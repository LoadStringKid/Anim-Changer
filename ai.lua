local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local orbitRadius = 6
local orbitSpeed = 2
local hatTakeInterval = 5

local orbitingBricks = {}

-- Checks if the accessory is a head accessory (hat)
local function isHeadAccessory(accessory)
	if not accessory:IsA("Accessory") then return false end

	-- Usually head accessories attach to Head via Attachment named "HatAttachment" or similar
	local handle = accessory:FindFirstChild("Handle")
	if not handle then return false end

	-- Check if the handle has a Weld or Motor6D connected to the character's Head
	for _, constraint in ipairs(handle:GetChildren()) do
		if (constraint:IsA("Weld") or constraint:IsA("Motor6D")) and constraint.Part1 and constraint.Part1.Name == "Head" then
			return true
		end
	end

	return false
end

local function detachHat(accessory)
	local handle = accessory:FindFirstChild("Handle")
	if not handle or not handle:IsA("BasePart") then return end

	-- Remove Weld or Motor6D attaching hat to the Head
	for _, constraint in ipairs(handle:GetChildren()) do
		if constraint:IsA("Weld") or constraint:IsA("Motor6D") then
			constraint:Destroy()
		end
	end

	handle.Parent = workspace
	handle.Anchored = false
	handle.CanCollide = false
end

local function stripMeshesRecursively(object)
	for _, child in ipairs(object:GetChildren()) do
		if child:IsA("Mesh") or child:IsA("SpecialMesh") or child:IsA("BlockMesh") or child:IsA("MeshPart") then
			child:Destroy()
		else
			stripMeshesRecursively(child)
		end
	end
	if object:IsA("BasePart") then
		object.Material = Enum.Material.SmoothPlastic
		object.Color = Color3.new(1, 1, 1)
		object.Size = Vector3.new(1, 1, 1)
	end
end

local function convertHatToOrbitingBrick(accessory, character)
	local handle = accessory:FindFirstChild("Handle")
	if not handle or not handle:IsA("BasePart") then return end

	detachHat(accessory)
	stripMeshesRecursively(handle)

	-- Add to orbit list
	if not orbitingBricks[character] then
		orbitingBricks[character] = {}
	end

	table.insert(orbitingBricks[character], {
		Part = handle,
		Angle = math.random() * math.pi * 2,
		HeightOffset = math.random(2, 5)
	})
end

local function hatRemovalLoop()
	while true do
		wait(hatTakeInterval)
		for _, player in pairs(Players:GetPlayers()) do
			local character = player.Character
			if character then
				-- Find one head accessory only
				for _, item in pairs(character:GetChildren()) do
					if isHeadAccessory(item) then
						convertHatToOrbitingBrick(item, character)
						break -- only one per interval
					end
				end
			end
		end
	end
end

RunService.Heartbeat:Connect(function(dt)
	for character, bricks in pairs(orbitingBricks) do
		if character and character.Parent and character:FindFirstChild("HumanoidRootPart") then
			local root = character.HumanoidRootPart
			for _, data in pairs(bricks) do
				if data.Part and data.Part.Parent then
					data.Angle = data.Angle + orbitSpeed * dt
					local angle = data.Angle
					local x = math.cos(angle) * orbitRadius
					local z = math.sin(angle) * orbitRadius
					local y = data.HeightOffset

					data.Part.CFrame = CFrame.new(root.Position + Vector3.new(x, y, z)) * CFrame.Angles(0, angle * 3, 0)
					data.Part.Velocity = Vector3.new(0, 0, 0)
				end
			end
		end
	end
end)

spawn(hatRemovalLoop)
