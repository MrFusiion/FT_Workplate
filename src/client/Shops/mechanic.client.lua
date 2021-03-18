local remoteMechanic = game:GetService("ReplicatedStorage"):WaitForChild("remote"):WaitForChild("mechanic")
local re_Entering = remoteMechanic:WaitForChild("Entering")

local client = require(game.StarterPlayer.StarterPlayerScripts.Modules)
local cameraUtils = client.get("cameraUtils")

re_Entering.OnClientEvent:Connect(function(camera)
    cameraUtils.scriptable(true)
    cameraUtils.getCamera().CFrame = camera.PrimaryPart.CFrame
end)