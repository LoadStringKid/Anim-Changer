-- SpinAroundPlayer.lua
-- Place this Script in Workspace

local targetName = "LSPLASH0921" -- The player you want to orbit around
local spinSpeed = 2 -- Radians per second
local radius = 10 -- Distance from target
local heightOffset = 3 -- Height above target

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Wait for both you and the target to exist
local localPlayer = nil
repeat
	for _, player in ipairs(Players:GetPlayers()) do
		if player.Name ~= targetName then
			localPlayer = player
		end
	end
	task.wait()
until localPlayer and Players:FindFirstChild(targetName)

local targetPlayer = Players:FindFirstChild(targetName)
local angle = 0

RunService.Heartbeat:Connect(function(dt)
	if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and
		localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then

		local targetRoot = targetPlayer.Character.HumanoidRootPart
		local myRoot = localPlayer.Character.HumanoidRootPart

		-- Increment angle for smooth rotation
		angle = angle + spinSpeed * dt

		-- Calculate orbit position
		local offsetX = math.cos(angle) * radius
		local offsetZ = math.sin(angle) * radius
		local orbitPos = targetRoot.Position + Vector3.new(offsetX, heightOffset, offsetZ)

		-- Move smoothly
		myRoot.CFrame = CFrame.new(orbitPos, targetRoot.Position)
	end
end)
