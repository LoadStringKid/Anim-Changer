--// Reanimated Spin Hat Script - Spins hat around character (5 studs/sec)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Reanimation: Clone character locally to prevent respawn
local clonedChar = character:Clone()
clonedChar.Parent = workspace
clonedChar:SetPrimaryPartCFrame(character:GetPrimaryPartCFrame())

-- Disable original character's humanoid to "reset" it without triggering respawn
character:FindFirstChildOfClass("Humanoid").BreakJointsOnDeath = false
character:BreakJoints()

-- Set camera and character to clone (local-only)
workspace.CurrentCamera.CameraSubject = clonedChar:FindFirstChild("Humanoid")
player.Character = clonedChar

-- Find first hat accessory in cloned character
local hat = nil
for _, accessory in ipairs(clonedChar:GetChildren()) do
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

-- Remove welds so the hat can move freely
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

-- Spin the hat around the HumanoidRootPart
RunService.Heartbeat:Connect(function(deltaTime)
	angle = angle + angularSpeed * deltaTime
	local offset = Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
	local hrp = clonedChar:FindFirstChild("HumanoidRootPart")
	if hrp then
		handle.CFrame = hrp.CFrame * CFrame.new(offset + Vector3.new(0, 2, 0))
	end
end)
