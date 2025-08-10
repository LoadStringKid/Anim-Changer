local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Wait for character and HumanoidRootPart
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

-- Find all unanchored, non-character parts
local unanchoredParts = {}

for _, obj in pairs(workspace:GetDescendants()) do
	if obj:IsA("BasePart")
		and not obj.Anchored
		and not obj:IsDescendantOf(character)
		and obj.Name ~= "HumanoidRootPart" then
		table.insert(unanchoredParts, obj)
	end
end

-- Check if any unanchored parts exist
if #unanchoredParts == 0 then
	warn("No unanchored parts found.")
	return
end

-- Pick a random part
local selectedPart = unanchoredParts[math.random(1, #unanchoredParts)]

-- Anchor it to allow movement
selectedPart.Anchored = true
selectedPart.CanCollide = false

-- Orbit parameters
local radius = 10
local height = 3
local angle = 0
local speed = 2 -- radians per second

-- Orbit loop
RunService.RenderStepped:Connect(function(dt)
	if selectedPart and hrp then
		angle += dt * speed
		local offset = Vector3.new(math.cos(angle) * radius, height, math.sin(angle) * radius)
		selectedPart.Position = hrp.Position + offset
	end
end)
