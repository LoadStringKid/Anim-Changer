local Players = game:GetService("Players")

local HAT_NAME = "International Fedora - Philippines" -- Replace this with the exact hat name
local ROTATION_SPEED = math.rad(90) -- radians per second (90 degrees per second)
local RADIUS = 2 -- studs offset from head

local function spinHat(player)
	local character = player.Character
	if not character then return end

	local head = character:FindFirstChild("Head")
	if not head then return end

	local hat = character:FindFirstChild(HAT_NAME)
	if not hat then return end

	local handle = hat:FindFirstChild("Handle")
	if not handle or not handle:IsA("BasePart") then return end

	-- Clean up old spin part if exists
	if hat:FindFirstChild("SpinPart") then
		hat.SpinPart:Destroy()
	end

	-- Create invisible spinning part
	local spinPart = Instance.new("Part")
	spinPart.Name = "SpinPart"
	spinPart.Size = Vector3.new(1,1,1)
	spinPart.Transparency = 1
	spinPart.Anchored = false
	spinPart.CanCollide = false
	spinPart.Parent = hat

	-- Weld spinPart to head so it moves with the player
	local weldToHead = Instance.new("WeldConstraint")
	weldToHead.Part0 = spinPart
	weldToHead.Part1 = head
	weldToHead.Parent = spinPart

	-- Weld hat handle to spinPart so it orbits the head
	local weldHat = Instance.new("WeldConstraint")
	weldHat.Part0 = handle
	weldHat.Part1 = spinPart
	weldHat.Parent = handle

	-- Spin loop coroutine
	coroutine.wrap(function()
		local angle = 0
		while player.Character == character and spinPart.Parent do
			angle = angle + ROTATION_SPEED * wait()
			local offset = Vector3.new(math.cos(angle)*RADIUS, 0, math.sin(angle)*RADIUS)
			spinPart.CFrame = head.CFrame * CFrame.new(offset)
		end
	end)()
end

-- Example: spin hat for a specific player
local targetPlayerName = "LSPLASH0921" -- change to the target player name

local player = Players:FindFirstChild(targetPlayerName)
if player and player.Character then
	spinHat(player)
else
	-- Wait for player to join and then spin
	Players.PlayerAdded:Connect(function(p)
		if p.Name == targetPlayerName then
			p.CharacterAdded:Connect(function()
				spinHat(p)
			end)
		end
	end)
end
