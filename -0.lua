local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local targetName = "LSPLASH09211"  -- The player to follow
local yourUsername = "LSPLASH0921"  -- CHANGE THIS to your Roblox username

local targetPlayer = Players:FindFirstChild(targetName)
local yourPlayer = Players:FindFirstChild(yourUsername)

if not targetPlayer then
	warn("Target player ("..targetName..") not found!")
	return
end
if not yourPlayer then
	warn("Your player ("..yourUsername..") not found!")
	return
end

local function getHRP(player)
	if player.Character then
		return player.Character:FindFirstChild("HumanoidRootPart")
	end
end

-- Wait for both characters to load HRPs
while not (targetPlayer.Character and getHRP(targetPlayer)) do
	targetPlayer.CharacterAdded:Wait()
end
while not (yourPlayer.Character and getHRP(yourPlayer)) do
	yourPlayer.CharacterAdded:Wait()
end

local targetHRP = getHRP(targetPlayer)
local yourHRP = getHRP(yourPlayer)

-- Follow loop
RunService.Heartbeat:Connect(function()
	-- Update HRPs in case of respawn
	targetHRP = getHRP(targetPlayer)
	yourHRP = getHRP(yourPlayer)
	if not targetHRP or not yourHRP then
		return
	end

	-- Calculate position 5 studs to the right of target
	local rightVec = targetHRP.CFrame.RightVector
	local desiredPos = targetHRP.Position + rightVec * 5

	-- Keep your current Y position (height) so no weird vertical movement
	desiredPos = Vector3.new(desiredPos.X, yourHRP.Position.Y, desiredPos.Z)

	-- Smoothly move your HRP towards desired position
	local newPos = yourHRP.Position:Lerp(desiredPos, 0.1)

	-- Set CFrame so you face the target player
	yourHRP.CFrame = CFrame.new(newPos, targetHRP.Position)
end)
