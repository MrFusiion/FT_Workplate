local remoteMechanic = game:GetService("ReplicatedStorage"):WaitForChild("remote"):WaitForChild("mechanic")
local re_Enter = remoteMechanic:WaitForChild("Enter")
local re_Entered = remoteMechanic:WaitForChild("Entered")
local re_Exit = remoteMechanic:WaitForChild("Exit")

local client = require(game.StarterPlayer.StarterPlayerScripts.Modules)
local playerUtils = client.get("playerUtils")
local cameraUtils = client.get("cameraUtils")
local backpackUtils = client.get("backpackUtils")

local mechanicHud = playerUtils.getPlayerGui():WaitForChild("Hud"):WaitForChild("Mechanic")
local mainFrame = mechanicHud:WaitForChild("Main")

re_Enter.OnClientEvent:Connect(function(cameras)
    local camera = cameras["Upgrades"]

    cameraUtils.scriptable(true)
    cameraUtils.getCamera().CFrame = camera.PrimaryPart.CFrame
end)

re_Entered.OnClientEvent:Connect(function(cameras, data)
    backpackUtils.hide()

    mainFrame.Open:Fire(cameras, data)

    local conn, exitConn
    conn = mainFrame.Exit.Event:Connect(function()
        re_Exit:FireServer()
        exitConn = re_Exit.OnClientEvent:Connect(function()
            cameraUtils.scriptable(false)

            backpackUtils.show()
            conn:Disconnect()
            exitConn:Disconnect()
        end)
    end)
end)