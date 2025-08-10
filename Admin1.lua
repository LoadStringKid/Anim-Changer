-- Utility
local function setProperties(instance, properties)
	for prop, value in properties do
		instance[prop] = value
	end
end

-- Tool creation
local function createTool()
	local tool = Instance.new("Tool")
	tool.Name = "Candy Blossom Seed"
	tool.RequiresHandle = true

	local handle = Instance.new("Part")
	handle.Name = "Handle"
	handle.Size = Vector3.new(0.5, 1, 0.5)
	handle.BrickColor = BrickColor.Blue()
	handle.Anchored = false
	handle.CanCollide = false
	handle.Parent = tool

	-- Decals on all sides
	local sides = {"Front", "Back", "Left", "Right", "Top", "Bottom"}
	for _, side in ipairs(sides) do
		local decal = Instance.new("Decal")
		decal.Face = Enum.NormalId[side]
		decal.Texture = "rbxassetid://" .. (side == "Bottom" and "9452130037" or "9106098127")
		decal.Parent = handle
	end

	return tool
end

-- RemoteEvent creator
local function createRemoteEvent()
	local existing = workspace:FindFirstChild("GiveCandyBlossomSeed")
	if existing then return existing end

	local remote = Instance.new("RemoteEvent")
	remote.Name = "GiveCandyBlossomSeed"
	remote.Parent = workspace
	return remote
end

-- GUI creation
local function createScreenGui(player)
	local playerGui = player:FindFirstChild("PlayerGui")
	if not playerGui then return end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "ScreenGui"
	screenGui.ResetOnSpawn = true
	screenGui.Parent = playerGui

	local frame = Instance.new("Frame")
	setProperties(frame, {
		Name = "Frame",
		Size = UDim2.new(0, 400, 0, 300),
		Position = UDim2.new(0.5, -200, 0.5, -150),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Parent = screenGui,
	})

	local imageButton = Instance.new("ImageButton")
	setProperties(imageButton, {
		Name = "ImageButton",
		Size = UDim2.new(0, 100, 0, 100),
		Position = UDim2.new(0, 20, 0, 20),
		Image = "rbxassetid://0",
		Parent = frame,
	})

	local imageLabel = Instance.new("ImageLabel")
	setProperties(imageLabel, {
		Name = "ImageLabel",
		Size = UDim2.new(0, 50, 0, 50),
		Position = UDim2.new(0, 140, 0, 20),
		Image = "rbxassetid://0",
		Parent = frame,
	})

	local textLabel = Instance.new("TextLabel")
	setProperties(textLabel, {
		Name = "TextLabel",
		Size = UDim2.new(0, 200, 0, 50),
		Position = UDim2.new(0, 20, 0, 140),
		Text = "Sample Text",
		TextColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 1,
		Parent = frame,
	})

	local uiStroke = Instance.new("UIStroke")
	setProperties(uiStroke, {
		Name = "UIStroke",
		Thickness = 2,
		Color = Color3.fromRGB(255, 0, 0),
		Parent = textLabel,
	})

	local dragDetector = Instance.new("UIDragDetector")
	setProperties(dragDetector, {
		Name = "UIDragDetector",
		Parent = frame,
	})

	-- Client-side click handling (in a LocalScript)
	local localScript = Instance.new("LocalScript")
	localScript.Parent = imageButton
	localScript.Source = [[
		script.Parent.MouseButton1Click:Connect(function()
			local remote = workspace:FindFirstChild("GiveCandyBlossomSeed")
			if remote then
				remote:FireServer()
			end
		end)
	]]
end

-- Setup RemoteEvent handler
local remote = createRemoteEvent()
remote.OnServerEvent:Connect(function(player)
	local backpack = player:FindFirstChild("Backpack")
	if backpack then
		local tool = createTool()
		tool.Parent = backpack
	end
end)

-- Handle existing players
for _, player in ipairs(game.Players:GetPlayers()) do
	createScreenGui(player)
end

-- New players
game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		task.wait(1)
		createScreenGui(player)
	end)
end)
