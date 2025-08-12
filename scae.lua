local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local targetUsername = "LSPLASH0921"

local glideDistance = 50
local glideTime = 2
local farAwayPosition = Vector3.new(10000, 500, 10000)
local waitAtFarLocation = 2
local loopDelay = 1

local function glideToRandomSpot(humanoidRootPart)
	local currentPosition = humanoidRootPart.Position
	local randomOffset = Vector3.new(
		math.random(-glideDistance, glideDistance),
		0,
		math.random(-glideDistance, glideDistance)
	)

	local targetPosition = currentPosition + randomOffset
	local goal = {CFrame = CFrame.new(targetPosition)}

	local tweenInfo = TweenInfo.new(glideTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local glideTween = TweenService:Create(humanoidRootPart, tweenInfo, goal)

	glideTween:Play()
	glideTween.Completed:Wait()
end

local function startLoopForPlayer(player)
	if player.Name ~= targetUsername then return end

	player.CharacterAdded:Connect(function(character)
		local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

		while true do
			local originalCFrame = humanoidRootPart.CFrame

			-- Glide to random spot
			glideToRandomSpot(humanoidRootPart)

			-- Teleport far away
			humanoidRootPart.CFrame = CFrame.new(farAwayPosition)
			wait(waitAtFarLocation)

			-- Teleport back
			humanoidRootPart.CFrame = originalCFrame

			wait(loopDelay)
		end
	end)

	-- If character is already loaded
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		local humanoidRootPart = player.Character.HumanoidRootPart

		while true do
			local originalCFrame = humanoidRootPart.CFrame

			glideToRandomSpot(humanoidRootPart)

			humanoidRootPart.CFrame = CFrame.new(farAwayPosition)
			wait(waitAtFarLocation)

			humanoidRootPart.CFrame = originalCFrame

			wait(loopDelay)
		end
	end
end

-- Start for player if they join after script runs
Players.PlayerAdded:Connect(startLoopForPlayer)

-- Start immediately if player is already in game
local player = Players:FindFirstChild(targetUsername)
if player then
	coroutine.wrap(startLoopForPlayer)(player)
end
