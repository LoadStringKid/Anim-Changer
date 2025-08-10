local character = script.Parent
local humanoid = character:FindFirstChildOfClass("Humanoid")
if not humanoid then return end

local animator = humanoid:FindFirstChildOfClass("Animator")
if not animator then
    animator = Instance.new("Animator")
    animator.Parent = humanoid
end

-- Remove default Animate script if present
local animateScript = character:FindFirstChild("Animate")
if animateScript then
    animateScript.Disabled = true
end

-- Animation asset IDs
local idleAnimId = "rbxassetid://111556936070783"
local walkStartAnimId = "rbxassetid://82875217463456"
local walkAnimId = "rbxassetid://122168431241166"

-- Create Animation objects
local idleAnim = Instance.new("Animation")
idleAnim.Name = "CustomIdle"
idleAnim.AnimationId = idleAnimId

local walkStartAnim = Instance.new("Animation")
walkStartAnim.Name = "CustomWalkStart"
walkStartAnim.AnimationId = walkStartAnimId

local walkAnim = Instance.new("Animation")
walkAnim.Name = "CustomWalk"
walkAnim.AnimationId = walkAnimId

-- Load AnimationTracks
local idleTrack = animator:LoadAnimation(idleAnim)
local walkStartTrack = animator:LoadAnimation(walkStartAnim)
local walkTrack = animator:LoadAnimation(walkAnim)

idleTrack.Looped = true
walkStartTrack.Looped = false
walkTrack.Looped = true

-- Play idle by default
idleTrack:Play()

local isWalking = false
local walkStartPlayed = false

local function stopAllExcept(track)
    if idleTrack ~= track then idleTrack:Stop() end
    if walkStartTrack ~= track then walkStartTrack:Stop() end
    if walkTrack ~= track then walkTrack:Stop() end
end

humanoid.Running:Connect(function(speed)
    if speed > 0.1 then
        if not isWalking then
            -- Just started walking
            isWalking = true
            walkStartPlayed = false
            stopAllExcept(walkStartTrack)
            walkStartTrack:Play()
            -- After walkStart finishes, play walk loop
            walkStartTrack.Stopped:Wait()
            if isWalking then
                walkStartPlayed = true
                stopAllExcept(walkTrack)
                walkTrack:Play()
            end
        elseif walkStartPlayed == false and not walkStartTrack.IsPlaying then
            -- If walkStart was interrupted, go to walk
            walkStartPlayed = true
            stopAllExcept(walkTrack)
            walkTrack:Play()
        end
    else
        -- Stopped walking
        isWalking = false
        walkStartPlayed = false
        stopAllExcept(idleTrack)
        idleTrack:Play()
    end
end)

-- Safety: If character dies, stop all animations
humanoid.Died:Connect(function()
    idleTrack:Stop()
    walkStartTrack:Stop()
    walkTrack:Stop()
end)

