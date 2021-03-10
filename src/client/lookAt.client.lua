local shared = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"))
local lookAt = shared.get("lookAt")

local player = game.Players.LocalPlayer
local mouse = game:GetService("Players").LocalPlayer:GetMouse()

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
    local origin = head.Position
    local destination = mouse.Hit.Position
	thisLookAt:calcGoal(mouse.Hit.Position)
	thisLookAt:update(dt)
end)

while (true) do
    local origin = head.Position
    local destination = mouse.Hit.Position
    thisLookAt:updateFire()
	wait(0.2);
end