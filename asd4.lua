--// SETTINGS
local yourName = "LSPLASH0921"
local targetName = "LSPLASH09211"
local radius = 10
local spinSpeed = 2

--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ChatService = game:GetService("Chat")

--// VARIABLES
local you = Players:WaitForChild(yourName)
local target = Players:WaitForChild(targetName)

local originalPos = nil
local currentMode = "follow" -- follow, spin, disappear
local spinning = false

-- Wait for characters
you.CharacterAdded:Wait()
target.CharacterAdded:Wait()
task.wait(1)

local yourRoot = you.Character:WaitForChild("HumanoidRootPart")
local targetRoot = target.Character:WaitForChild("HumanoidRootPart")

-- Save starting position
originalPos = yourRoot.Position

--// FUNCTIONS
local function teleportBehind()
	if targetRoot and yourRoot then
		local behindOffset = -targetRoot.CFrame.LookVector * 5
		yourRoot.CFrame = targetRoot.CFrame + behindOffset
	end
end

local function disappear()
	if yourRoot then
		yourRoot.CFrame = CFrame.new(100000, 100000, 100000) -- far away
	end
end

local function appear()
	if yourRoot and originalPos then
		yourRoot.CFrame = CFrame.new(originalPos)
	end
end

local function startSpin()
	spinning = true
	local startTime = tick()
	RunService.Heartbeat:Connect(function()
		if spinning and target.Character and your.Character then
			targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
			yourRoot = you.Character:FindFirstChild("HumanoidRootPart")
			if targetRoot and yourRoot then
				local angle = (tick() - startTime) * spinSpeed
				local x = math.cos(angle) * radius
				local z = math.sin(angle) * radius
				yourRoot.CFrame = CFrame.new(targetRoot.Position + Vector3.new(x, 0, z), targetRoot.Position)
			end
		end
	end)
end

local function stopSpin()
	spinning = false
end

local function follow()
	RunService.Heartbeat:Connect(function()
		if currentMode == "follow" and target.Character and you.Character then
			targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
			yourRoot = you.Character:FindFirstChild("HumanoidRootPart")
			if targetRoot and yourRoot then
				local direction = (targetRoot.Position - yourRoot.Position).Unit
				yourRoot.CFrame = CFrame.new(targetRoot.Position - direction * 5, targetRoot.Position)
			end
		end
	end)
end

-- Start following by default
follow()
teleportBehind()

--// CHAT COMMAND LISTENER
target.Chatted:Connect(function(msg)
	msg = msg:lower()
	if msg == "disappear" then
		currentMode = "disappear"
		stopSpin()
		disappear()
	elseif msg == "appear" then
		currentMode = "follow"
		stopSpin()
		appear()
		teleportBehind()
	elseif msg == "spin" then
		currentMode = "spin"
		startSpin()
	end
end)
