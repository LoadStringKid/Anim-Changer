local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Wait for player and character
while not player do
	wait()
	player = Players.LocalPlayer
end

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Reanimate function: clones character, disables original Humanoid, moves camera
local function reanimate()
	-- Clone the character
	local clone = character:Clone()
	clone.Name = "ReanimateClone"
	clone.Parent = workspace

	-- Set clone's primary part to match character's PrimaryPart
	clone:SetPrimaryPartCFrame(character.PrimaryPart.CFrame)

	-- Make clone invisible or transparent if you want to hide original character
	for _, part in pairs(character:GetChildren()) do
		if part:IsA("BasePart") then
			part.Transparency = 1
			part.CanCollide = false
		elseif part:IsA("Decal") then
			part.Transparency = 1
		end
	end

	-- Disable the original humanoid to prevent animation conflicts
	humanoid:ChangeState(Enum.HumanoidStateType.Physics)
	humanoid.PlatformStand = true

	-- Set camera to the clone's humanoid root part
	local cam = workspace.CurrentCamera
	cam.CameraSubject = clone:WaitForChild("Humanoid")
	cam.CameraType = Enum.CameraType.Custom

	return clone
end

local clone = reanimate()
local cloneHumanoid = clone:WaitForChild("Humanoid")
local animator = cloneHumanoid:WaitForChild("Animator")

-- Animation asset IDs
local animations = {
	idle = "rbxassetid://111556936070783",
	walk = "rbxassetid://122168431241166",
	run = "rbxassetid://82875217463456"
}

-- Remove any playing animations on clone's animator
for _, track in pairs(animator:GetPlayingAnimationTracks()) do
	track:Stop()
	track:Destroy()
end

-- Create new animations
local idleAnim = Instance.new("Animation")
idleAnim.AnimationId = animations.idle

local walkAnim = Instance.new("Animation")
walkAnim.AnimationId = animations.walk

local runAnim = Instance.new("Animation")
runAnim.AnimationId = animations.run

-- Load animations
local idleTrack = animator:LoadAnimation(idleAnim)
local walkTrack = animator:LoadAnimation(walkAnim)
local runTrack = animator:LoadAnimation(runAnim)

-- Play idle initially
idleTrack:Play()

-- Switch animations based on speed on cloneHumanoid
cloneHumanoid.Running:Connect(function(speed)
	if speed > 0 and speed < 16 then
		if not walkTrack.IsPlaying then
			idleTrack:Stop()
			runTrack:Stop()
			walkTrack:Play()
		end
	elseif speed >= 16 then
		if not runTrack.IsPlaying then
			idleTrack:Stop()
			walkTrack:Stop()
			runTrack:Play()
		end
	else
		if not idleTrack.IsPlaying then
			walkTrack:Stop()
			runTrack:Stop()
			idleTrack:Play()
		end
	end
end)

-- Optional: Clean up the original character eventually if you want
-- You might want to listen for player character respawn to remove clones etc.
