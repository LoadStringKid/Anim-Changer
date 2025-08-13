local targetPlayerName = "LSPLASH0921"
local followDistance = 5
local followSpeed = 0.1 -- lower is faster
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local function getCharacter(player)
	if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		return player.Character
	end
	return nil
end

local function teleportBehindTarget(followerChar, targetChar)
	local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
	local followerHRP = followerChar:FindFirstChild("HumanoidRootPart")

	if targetHRP and followerHRP then
		local backPosition = targetHRP.CFrame * CFrame.new(0, 0, followDistance)
		followerHRP.CFrame = backPosition
	end
end

local function followTarget(followerChar, targetChar)
	local followerHRP = followerChar:FindFirstChild("HumanoidRootPart")
	local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
	if not (followerHRP and targetHRP) then return end

	RunService.Heartbeat:Connect(function()
		if followerHRP and targetHRP then
			local desiredPosition = targetHRP.CFrame * CFrame.new(0, 0, followDistance)
			local newPosition = followerHRP.Position:Lerp(desiredPosition.Position, followSpeed)
			followerHRP.CFrame = CFrame.new(newPosition, targetHRP.Position)
		end
	end)
end

-- Wait for both players
task.wait(2) -- short delay for loading
local targetPlayer = Players:FindFirstChild(targetPlayerName)
local followerPlayer = Players:GetPlayers()[1] -- Assumes you are the first player

if targetPlayer and followerPlayer then
	local targetChar = getCharacter(targetPlayer)
	local followerChar = getCharacter(followerPlayer)

	-- Wait for characters to load if needed
	while not (targetChar and followerChar) do
		task.wait(0.5)
		targetChar = getCharacter(targetPlayer)
		followerChar = getCharacter(followerPlayer)
	end

	-- Teleport behind and start following
	teleportBehindTarget(followerChar, targetChar)
	followTarget(followerChar, targetChar)
else
	warn("Target player or follower player not found.")
end
