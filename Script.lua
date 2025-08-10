--// Spin Hat Script - 5 studs/second
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Find first hat accessory
local hat = nil
for _, accessory in ipairs(character:GetChildren()) do
	if accessory:IsA("Accessory") then
		hat = accessory
		break
	end
end

if not hat then
	warn("No hat found!")
	return
end

-- Get the hat's handle
local handle = hat:FindFirstChild("Handle")
if not handle then
	warn("Hat has no handle!")
	return
end

-- Remove default attachment welds so we can move it freely
for _, obj in ipairs(handle:GetChildren()) do
	if obj:IsA("Weld") or obj:IsA("Motor6D") then
		obj:Destroy()
	end
end

-- Spin settings
local radius = 5
local speedStudsPerSecond = 5
local angularSpeed = speedStudsPerSecond / radius -- radians/sec
local angle = 0

-- Move the hat in a loop
RunService.Heartbeat:Connect(function(deltaTime)
	angle = angle + angularSpeed * deltaTime
	local offset = Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
	handle.CFrame = character.HumanoidRootPart.CFrame * CFrame.new(offset + Vector3.new(0, 2, 0))
end)
