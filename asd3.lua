--// Settings
local yourName = "LSPLASH0921"       -- Your username
local targetName = "LSPLASH09211"    -- Player you want to orbit
local radius = 10                    -- Distance from target
local speed = 2                      -- Speed multiplier

--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

--// Function to wait for a specific player
local function waitForPlayer(name)
	local player = Players:FindFirstChild(name)
	while not player do
		player = Players.PlayerAdded:Wait()
	end
	return player
end

-- Get both players
local you = waitForPlayer(yourName)
local target = waitForPlayer(targetName)

-- Wait for both characters to load
you.CharacterAdded:Wait()
target.CharacterAdded:Wait()
task.wait(1)

local yourRoot = you.Character:WaitForChild("HumanoidRootPart")
local targetRoot = target.Character:WaitForChild("HumanoidRootPart")
local startTime = tick()

-- Orbit loop
RunService.Heartbeat:Connect(function()
	if target.Character and target.Character:FindFirstChild("HumanoidRootPart")
	and you.Character and you.Character:FindFirstChild("HumanoidRootPart") then
		local angle = (tick() - startTime) * speed
		local x = math.cos(angle) * radius
		local z = math.sin(angle) * radius

		yourRoot.CFrame = CFrame.new(targetRoot.Position + Vector3.new(x, 0, z), targetRoot.Position)
	end
end)
