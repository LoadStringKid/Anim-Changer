--[[
    GatheredAssetsBuilder
    This module reconstructs all assets originally in the "GatheredAssets" Model:
    - RemoteEvent: GiveCandyBlossomSeed
    - ScreenGui with Frame, ImageButton, ImageLabels, TextLabels, UIDragDetector, etc.
    Usage:
        local builder = require(path.to.GatheredAssetsBuilder)
        builder:CreateRemoteEvent()
        builder:CreateScreenGui(player)
--]]

local GatheredAssetsBuilder = {}

-- Utility function to set properties
local function setProperties(instance, properties)
    for prop, value in properties do
        instance[prop] = value
    end
end

-- 1. Create RemoteEvent in Workspace (or ReplicatedStorage if preferred)
function GatheredAssetsBuilder:CreateRemoteEvent(parent)
    parent = parent or workspace
    local remote = Instance.new("RemoteEvent")
    remote.Name = "GiveCandyBlossomSeed"
    remote.Parent = parent
    return remote
end

-- 2. Create ScreenGui and all descendants in player's PlayerGui
function GatheredAssetsBuilder:CreateScreenGui(player)
    local playerGui = player:FindFirstChild("PlayerGui")
    if not playerGui then return end

    -- ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ScreenGui"
    screenGui.ResetOnSpawn = true
    screenGui.Parent = playerGui

    -- Frame
    local frame = Instance.new("Frame")
    setProperties(frame, {
        Name = "Frame",
        Size = UDim2.new(0, 400, 0, 300),
        Position = UDim2.new(0.5, -200, 0.5, -150),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = screenGui,
    })

    -- ImageButton
    local imageButton = Instance.new("ImageButton")
    setProperties(imageButton, {
        Name = "ImageButton",
        Size = UDim2.new(0, 100, 0, 100),
        Position = UDim2.new(0, 20, 0, 20),
        Image = "rbxassetid://0", -- Replace with actual asset id if needed
        Parent = frame,
    })

    -- ImageLabels (example, add more as needed)
    local imageLabel = Instance.new("ImageLabel")
    setProperties(imageLabel, {
        Name = "ImageLabel",
        Size = UDim2.new(0, 50, 0, 50),
        Position = UDim2.new(0, 140, 0, 20),
        Image = "rbxassetid://0", -- Replace with actual asset id if needed
        Parent = frame,
    })

    -- Add more ImageLabels as needed (repeat above block for each)

    -- TextLabels (example, add more as needed)
    local textLabel = Instance.new("TextLabel")
    setProperties(textLabel, {
        Name = "TextLabel",
        Size = UDim2.new(0, 200, 0, 50),
        Position = UDim2.new(0, 20, 0, 140),
        Text = "Sample Text",
        TextColor3 = Color3.fromRGB(0,0,0),
        BackgroundTransparency = 1,
        Parent = frame,
    })

    -- UIStroke for TextLabel
    local uiStroke = Instance.new("UIStroke")
    setProperties(uiStroke, {
        Name = "UIStroke",
        Thickness = 2,
        Color = Color3.fromRGB(255, 0, 0),
        Parent = textLabel,
    })

    -- Add more TextLabels/UIStrokes as needed

    -- UIDragDetector
    local dragDetector = Instance.new("UIDragDetector")
    setProperties(dragDetector, {
        Name = "UIDragDetector",
        Parent = frame,
    })

    return screenGui
end

return GatheredAssetsBuilder

