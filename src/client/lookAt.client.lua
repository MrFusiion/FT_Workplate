local shared = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"))
local lookAt = shared.get("lookAt")

local remoteVacuum = game:GetService("ReplicatedStorage"):WaitForChild("remote"):WaitForChild("vacuum")
local re_TargetDetails = remoteVacuum:WaitForChild("TargetDetails")

local player = game.Players.LocalPlayer
local mouse = game:GetService("Players").LocalPlayer:GetMouse()

local vacuumLockedPos
local function getDestination()
    if vacuumLockedPos then
        return vacuumLockedPos
    else
        local unit = mouse.UnitRay
        return unit.Origin + unit.Direction * 1000
    end
end

local character = player.Character or player.CharacterAdded:Wait()
local head = character:WaitForChild("Head")
local thisLookAt = lookAt.new(character, math.rad(160), math.rad(120), math.rad(80), math.rad(105))
thisLookAt:initFire()

game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(char)
	character = char
    head = character:WaitForChild("Head")
    thisLookAt = lookAt.new(character, math.rad(160), math.rad(120), math.rad(80), math.rad(105))
    thisLookAt:initFire()
end)

game:GetService("RunService").RenderStepped:Connect(function(dt)
	thisLookAt:calcGoal(getDestination())
	thisLookAt:update(dt)
end)

re_TargetDetails.OnClientEvent:Connect(function(pos)
    if pos then
        vacuumLockedPos = pos
    else
        vacuumLockedPos = nil
    end
end)

while (true) do
    thisLookAt:updateFire(getDestination())
	wait(0.2);
end