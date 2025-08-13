local Players = game:GetService("Players")
 
local function onCharacterAdded(character)
	local humanoid = character:WaitForChild("Humanoid")
 
	for _, playingTracks in pairs(humanoid:GetPlayingAnimationTracks()) do
		playingTracks:Stop(0)
	end
 
	local animateScript = character:WaitForChild("Animate")
 
	animateScript.idle.Animation1.AnimationId = "rbxassetid://100743505643669"
end
 
local function onPlayerAdded(player)
	if player.Character then
		onCharacterAdded(player.Character)
	end
	player.CharacterAdded:Connect(onCharacterAdded)
end
 
Players.PlayerAdded:Connect(onPlayerAdded)
