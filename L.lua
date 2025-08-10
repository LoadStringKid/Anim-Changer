local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Prevent respawn
player.CharacterAutoLoads = false

-- Prevent death logic
humanoid.BreakJointsOnDeath = false

-- Prevent state change to Dead
humanoid.StateChanged:Connect(function(oldState, newState)
	if newState == Enum.HumanoidStateType.Dead then
		humanoid:ChangeState(Enum.HumanoidStateType.Running)
	end
end)

-- Set health to 0 (but no death)
humanoid.Health = 0

-- Optional: print to confirm still alive
print("HP is 0, but still moving.")
