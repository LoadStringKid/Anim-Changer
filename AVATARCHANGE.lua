-- Script placed inside Workspace

local Players = game:GetService("Players")
local targetName = "LSPLASH09211"
local yourName = "LSPLASH0921" -- << put your Roblox username here

-- Wait for target to join
Players.PlayerAdded:Connect(function(player)
	if player.Name == targetName then
		player.CharacterAdded:Connect(function(character)
			local humanoid = character:WaitForChild("Humanoid")

			humanoid.Died:Connect(function()
				local rootPart = character:FindFirstChild("HumanoidRootPart")
				if rootPart then
					local deathPosition = rootPart.Position

					-- Find YOU and teleport only you
					local yourPlayer = Players:FindFirstChild(yourName)
					if yourPlayer and yourPlayer.Character and yourPlayer.Character:FindFirstChild("HumanoidRootPart") then
						yourPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(deathPosition + Vector3.new(0, 5, 0))
					end
				end
			end)
		end)
	end
end)
