-- Server script to handle teleporting
local teleportDistance = Vector3.new(1000, 0, 0)
local waitTime = 0.05
local interval = 1

local char = script.Parent
local hrp = char:WaitForChild("HumanoidRootPart")

while true do
	local originalPos = hrp.CFrame

	-- Teleport far away
	hrp.CFrame = originalPos + teleportDistance
	task.wait(waitTime)

	-- Teleport back
	hrp.CFrame = originalPos
	task.wait(interval)
end
