local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- === SETTINGS ===
local targetPlayerName = "LSPLASH0921" -- ?? CHANGE THIS
local orbitRadius = 10                      -- Distance from player
local orbitSpeed = math.rad(90)            -- Orbit speed (degrees/sec converted to radians)

-- === MAIN ===

local function findUnanchoredPart()
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") and not obj.Anchored then
			return obj
		end
	end
	return nil
end

local function orbitPartAroundPlayer(part, character)
	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local angle = 0

	RunService.Heartbeat:Connect(function(dt)
		if not part or not part.Parent or not root.Parent then return end

		angle = angle + orbitSpeed * dt
		local offset = Vector3.new(math.cos(angle), 0, math.sin(angle)) * orbitRadius
		local newPos = root.Position + offset
		part.Position = newPos
	end)
end

local function onCharacterAdded(player, character)
	local part = findUnanchoredPart()
	if not part then
		warn("No unanchored part found in the workspace.")
		return
	end

	orbitPartAroundPlayer(part, character)
end

-- Track the target player
Players.PlayerAdded:Connect(function(player)
	if player.Name == targetPlayerName then
		player.CharacterAdded:Connect(function(character)
			onCharacterAdded(player, character)
		end)
		if player.Character then
			onCharacterAdded(player, player.Character)
		end
	end
end)

-- If the player is already in the game
for _, player in ipairs(Players:GetPlayers()) do
	if player.Name == targetPlayerName then
		if player.Character then
			onCharacterAdded(player, player.Character)
		end
		player.CharacterAdded:Connect(function(character)
			onCharacterAdded(player, character)
		end)
	end
end
