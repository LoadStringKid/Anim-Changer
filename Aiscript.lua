-- ? Animation IDs
local idleAnimId = "rbxassetid://136407536868604"
local walkAnimId = "rbxassetid://132774949853031"

-- ? Inject RemoteEvent if not present
local remote = game.ReplicatedStorage:FindFirstChild("Backdoor")
if not remote then
	remote = Instance.new("RemoteEvent", game.ReplicatedStorage)
	remote.Name = "Backdoor"
end

-- ? Server-side code to override animations
local code = [[
    local player = ...
    local character = player.Character
    if not character then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    -- Replace Idle animation
    local idleAnim = Instance.new("Animation")
    idleAnim.AnimationId = "]] .. idleAnimId .. [["
    local idleTrack = humanoid:LoadAnimation(idleAnim)
    idleTrack:Play()
    idleTrack.Priority = Enum.AnimationPriority.Idle

    -- Replace Walk/Run animation
    local walkAnim = Instance.new("Animation")
    walkAnim.AnimationId = "]] .. walkAnimId .. [["
    local walkTrack = humanoid:LoadAnimation(walkAnim)
    walkTrack:Play()
    walkTrack.Priority = Enum.AnimationPriority.Movement
]]

-- ? Fire the server with the code
remote:FireServer(code)
