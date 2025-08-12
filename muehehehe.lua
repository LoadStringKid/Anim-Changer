local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local rotationSpeed = math.rad(90) -- limb spin speed (radians/sec)
local floatAmplitude = 2           -- float up/down height (studs)
local floatSpeed = 1               -- float cycles per second
local glideInterval = 5            -- seconds between glide movements
local glideDistance = 20           -- max distance to glide away from origin (studs)

local function createMotor6D(character, limbName)
	local torso = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
	local limb = character:FindFirstChild(limbName)
	if not torso or not limb then return nil end

	local motor = limb:FindFirstChild("SpinMotor")
	if motor then return motor end

	motor = Instance.new("Motor6D")
	motor.Name = "SpinMotor"
	motor.Part0 = torso
	motor.Part1 = limb
	motor.C0 = limb.CFrame:ToObjectSpace(torso.CFrame)
	motor.C1 = CFrame.new()
	motor.Parent = limb
	return motor
end

local function onCharacterAdded(character)
	local limbs = {"LeftUpperArm", "RightUpperArm", "LeftUpperLeg", "RightUpperLeg"}
	if not character:FindFirstChild("LeftUpperArm") then
		limbs = {"Left Arm", "Right Arm", "Left Leg", "Right Leg"}
	end

	local motors = {}
	for _, limbName in ipairs(limbs) do
		local motor = createMotor6D(character, limbName)
		if motor then
			table.insert(motors, motor)
		end
	end

	local torso = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
	if not torso then return end

	local originPosition = torso.Position

	coroutine.wrap(function()
		local angle = 0
		local time = 0

		local currentCFrame = torso.CFrame
		local targetCFrame = torso.CFrame
		local glideTimer = 0

		while character.Parent do
			local dt = RunService.Heartbeat:Wait()
			angle = angle + rotationSpeed * dt
			time = time + dt
			glideTimer = glideTimer + dt

			-- Spin limbs
			for i, motor in ipairs(motors) do
				local offset = (i - 1) * (math.pi/2)
				motor.C0 = CFrame.Angles(0, angle + offset, 0) * motor.C0
			end

			-- Every glideInterval seconds, pick a new random target position to glide to
			if glideTimer >= glideInterval then
				glideTimer = 0
				-- Random horizontal offset around origin within glideDistance studs
				local randomOffset = Vector3.new(
					math.random(-glideDistance * 100, glideDistance * 100) / 100,
					0,
					math.random(-glideDistance * 100, glideDistance * 100) / 100
				)
				local newPos = originPosition + randomOffset
				targetCFrame = CFrame.new(newPos.X, torso.Position.Y, newPos.Z) * (torso.CFrame - torso.CFrame.p)
			end

			-- Smoothly move currentCFrame towards targetCFrame (lerp over time)
			local lerpSpeed = 1 / glideInterval -- so it takes roughly glideInterval seconds to reach target
			currentCFrame = currentCFrame:Lerp(targetCFrame, lerpSpeed * dt)

			-- Add floating offset on Y axis
			local floatOffset = math.sin(time * floatSpeed * math.pi * 2) * floatAmplitude

			-- Update torso CFrame with floating on top of current glide position
			torso.CFrame = CFrame.new(
				currentCFrame.Position.X,
				currentCFrame.Position.Y + floatOffset,
				currentCFrame.Position.Z
			) * (currentCFrame - currentCFrame.p)
		end
	end)()
end

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(onCharacterAdded)

	if player.Character then
		onCharacterAdded(player.Character)
	end
end)

for _, player in ipairs(Players:GetPlayers()) do
	if player.Character then
		onCharacterAdded(player.Character)
	end
	player.CharacterAdded:Connect(onCharacterAdded)
end
