local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumaoidRP = Character:WaitForChild("HumanoidRootPart")
local CAS = game:GetService('ContextActionService')

for _, actionName in ipairs{ 'FlyForward', 'FlyBack', 'FlyRight', 'FlyLeft' } do
    CAS:UnbindAction(actionName)
end

HumaoidRP.Anchored = false
local Children = HumaoidRP:GetChildren()
for _, child in pairs(Children) do
    if child:IsA("BodyVelocity") then
        child:Destroy()
    end
    if child:IsA("BodyGyro") then
        child:Destroy()
    end
end

wait(.2)
script:Destroy()