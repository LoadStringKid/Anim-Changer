local targetName = "LSPLASH09211"
local floatAmplitude = 2       -- height of floating
local floatSpeed = 2           -- floating speed
local followDistance = 3       -- distance behind target to follow

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- The player who will follow LSPLASH09211
-- You can set this to whoever you want. Here we pick the first player other than LSPLASH09211
local function getFollower()
	for _, player in ipairs(Players:GetPlayers()) do
		if player.Name ~= targetName then
			return player
		end
	end
	return nil
end

local follower = getFollower()

-- Get target player object
local function getTarget()
	return Players:FindFirstChild(targetName)
end

local startTime = tick()

RunService.Heartbeat:Connect(function()
	if not follower or not follower.Character or not follower.Character:FindFirstChild("HumanoidRootPart") then
		follower = getFollower()
		return
	end
	local target = getTarget()
	if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then
		return
	end

	local followerHRP = follower.Character.HumanoidRootPart
	local targetHRP = target.Character.HumanoidRootPart

	local targetPos = targetHRP.Position
	local offset = -targetHRP.CFrame.LookVector * followDistance
	local floatOffsetY = math.sin((tick() - startTime) * floatSpeed) * floatAmplitude

	local desiredPos = Vector3.new(targetPos.X + offset.X, targetPos.Y + floatOffsetY, targetPos.Z + offset.Z)

	-- Smoothly move follower towards desired position
	local currentPos = followerHRP.Position
	local moveVector = (desiredPos - currentPos) * 0.1

	followerHRP.CFrame = CFrame.new(currentPos + moveVector, targetPos)
end)

