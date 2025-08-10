-- Get a random part in the Workspace that isn't the player's character or anchored
local function getRandomPart(player)
	local character = player.Character
	local validParts = {}

	for _, part in ipairs(workspace:GetDescendants()) do
		if part:IsA("BasePart") and not part.Anchored and not part:IsDescendantOf(character) then
			table.insert(validParts, part)
		end
	end

	if #validParts > 0 then
		return validParts[math.random(1, #validParts)]
	end

	return nil
end

-- Orbiting logic
local function startOrbit(part, player)
	local runService = game:GetService("RunService")
	local orbitRadius = 10
	local orbitSpeed = 2
	local angle = 0

	local character = player.Character
	if not character then return end

	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	-- Make the part not collide and float
	part.CanCollide = false
	part.Anchored = false

	-- Weld the part to a fake part that orbits
	local attachmentPart = Instance.new("Part")
	attachmentPart.Size = Vector3.new(1,1,1)
	attachmentPart.Transparency = 1
	attachmentPart.Anchored = true
	attachmentPart.CanCollide = false
	attachmentPart.Parent = workspace

	-- Loop to update orbit
	task.spawn(function()
		while player and player.Parent and hrp and part and part.Parent do
			angle += orbitSpeed * 0.03
			local x = math.cos(angle) * orbitRadius
			local z = math.sin(angle) * orbitRadius
			local targetPos = hrp.Position + Vector3.new(x, 3, z)
			attachmentPart.Position = targetPos
			part.Velocity = (targetPos - part.Position) * 5
			task.wait(0.03)
		end
	end)
end

-- Listen for players joining
game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		task.wait(2) -- wait for character to load
		local part = getRandomPart(player)
		if part then
			startOrbit(part, player)
		end
	end)
end)
