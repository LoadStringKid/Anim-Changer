local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Wait for character
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

-- Get all parts in the workspace
local allParts = {}

for _, obj in pairs(workspace:GetDescendants()) do
	if obj:IsA("BasePart") and obj ~= hrp and not obj:IsDescendantOf(character) then
		table.insert(allParts, obj)
	end
end

if #allParts == 0 then
	warn("No parts found in the game.")
	return
end

-- Pick a random part
local targetPart = allParts[math.random(1, #allParts)]

-- Anchor and disable collision to prevent weird behavior
targetPart.Anchored = true
targetPart.CanCollide = false

-- Orbit parameters
local radius = 8
local speed = 2 -- radians per second
local height = 3
local angle = 0

-- Spin it!
RunService.RenderStepped:Connect(function(dt)
	if hrp and targetPart then
		angle += dt * speed
		local offset = Vector3.new(math.cos(angle) * radius, height, math.sin(angle) * radius)
		targetPart.Position = hrp.Position + offset
	end
end)
