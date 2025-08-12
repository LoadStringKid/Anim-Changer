-- SERVER SCRIPT for Workspace

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local YOUR_USERNAME = "LSPLASH0921" -- <<<<<< CHANGE THIS TO YOUR EXACT USERNAME
local yourPlayer = Players:FindFirstChild(YOUR_USERNAME)

if not yourPlayer then
	warn("Your player was not found. Make sure you are in the game.")
	return
end

local yourCharacter = nil
local following = false
local targetPlayer = nil
local orbiting = false
local orbitRadius = 5
local orbitSpeed = 2
local floatAmplitude = 1.5
local floatSpeed = 2
local baseOffset = Vector3.new(0, 0, 0)
local floatTime = 0

-- Utility: Get HumanoidRootPart safely
local function getRootPart(character)
	return character and character:FindFirstChild("HumanoidRootPart")
end

-- Chat Command Listener
Players.PlayerAdded:Connect(function(player)
	player.Chatted:Connect(function(message)
		if message == "LQ11" then
			if not yourPlayer.Character then return end
			yourCharacter = yourPlayer.Character
			targetPlayer = player
			following = true
			orbiting = false
			floatTime = 0

			local targetRoot = getRootPart(targetPlayer.Character)
			local yourRoot = getRootPart(yourCharacter)

			if targetRoot and yourRoot then
				local offset = targetRoot.CFrame:ToWorldSpace(CFrame.new(-3, 0, 2))
				yourRoot.CFrame = CFrame.new(offset.Position)
			end

		elseif message == "RQ22" and player == targetPlayer then
			following = false
			orbiting = true
			floatTime = 0
		end
	end)
end)

-- Smooth Follow + Orbit + Float Update
RunService.Heartbeat:Connect(function(dt)
	if not yourPlayer.Character then return end
	yourCharacter = yourPlayer.Character
	local yourRoot = getRootPart(yourCharacter)

	if not yourRoot then return end

	floatTime += dt
	local floatY = math.sin(floatTime * floatSpeed) * floatAmplitude

	if following and targetPlayer and targetPlayer.Character then
		local targetRoot = getRootPart(targetPlayer.Character)
		if targetRoot then
			local targetPos = targetRoot.Position + Vector3.new(-3, floatY, 2)
			yourRoot.CFrame = CFrame.new(targetPos)
		end

	elseif orbiting and targetPlayer and targetPlayer.Character then
		local targetRoot = getRootPart(targetPlayer.Character)
		if targetRoot then
			local angle = tick() * orbitSpeed
			local offset = Vector3.new(math.cos(angle) * orbitRadius, floatY, math.sin(angle) * orbitRadius)
			local orbitPos = targetRoot.Position + offset
			yourRoot.CFrame = CFrame.new(orbitPos, targetRoot.Position)
		end
	end
end)
