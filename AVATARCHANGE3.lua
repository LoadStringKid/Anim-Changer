-- Script placed inside Workspace

local Players = game:GetService("Players")
local targetName = "LSPLASH09211"
local yourName = "LSPLASH0921" -- your username

-- Default follow offset (to the right side)
local followOffset = Vector3.new(2, 0, 0)
local following = true -- follow enabled by default

-- Simple noclip function for your character
local function noclip(character)
	task.spawn(function()
		while character.Parent do
			for _, part in ipairs(character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
			task.wait()
		end
	end)
end

-- Main follow loop
local function followTarget(targetPlayer, yourPlayer)
	task.spawn(function()
		while targetPlayer.Parent and yourPlayer.Parent do
			if following 
				and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") 
				and yourPlayer.Character and yourPlayer.Character:FindFirstChild("HumanoidRootPart") then
				
				-- Stick to target with offset
				local targetPos = targetPlayer.Character.HumanoidRootPart.Position
				yourPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos + followOffset)
			end
			task.wait(0.1) -- adjust speed/smoothness
		end
	end)
end

-- Setup
local function setup()
	local targetPlayer = Players:FindFirstChild(targetName)
	local yourPlayer = Players:FindFirstChild(yourName)

	if targetPlayer and yourPlayer then
		if yourPlayer.Character then
			noclip(yourPlayer.Character)
		end

		yourPlayer.CharacterAdded:Connect(function(char)
			noclip(char)
		end)

		followTarget(targetPlayer, yourPlayer)

		-- Chat commands
		yourPlayer.Chatted:Connect(function(msg)
			local lowerMsg = msg:lower()
			if lowerMsg == "!left" then
				followOffset = Vector3.new(-2, 0, 0) -- left side
			elseif lowerMsg == "!right" then
				followOffset = Vector3.new(2, 0, 0) -- right side
			elseif lowerMsg == "!behind" then
				followOffset = Vector3.new(0, 0, -3) -- behind target
			elseif lowerMsg == "!front" then
				followOffset = Vector3.new(0, 0, 3) -- in front
			elseif lowerMsg == "!stop" then
				following = false -- stop following
			elseif lowerMsg == "!follow" then
				following = true -- resume following
			end
		end)
	end
end

-- Run immediately and when players join
setup()
Players.PlayerAdded:Connect(function(plr)
	if plr.Name == targetName or plr.Name == yourName then
		task.wait(1)
		setup()
	end
end)
