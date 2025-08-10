local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

-- Pick the first unanchored BasePart in workspace that isn't part of your character
local target
for _, obj in ipairs(workspace:GetDescendants()) do
	if obj:IsA("BasePart") and not obj.Anchored and obj.Parent ~= character then
		target = obj
		break
	end
end

if not target then
	warn("No unanchored part found!")
	return
end

-- Make sure we have network ownership
target:SetNetworkOwner(player)

-- Orbit settings
local radius = 5
local speed = math.pi -- radians/sec
local angle = 0
local height = 2

-- Use physics replication to move it
game:GetService("RunService").Heartbeat:Connect(function(dt)
	angle += speed * dt
	local x = math.cos(angle) * radius
	local z = math.sin(angle) * radius
	target.Position = root.Position + Vector3.new(x, height, z)
	target.Velocity = Vector3.new(0, 0, 0) -- prevent it from drifting
end)
