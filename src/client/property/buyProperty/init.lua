local propertyRemote = game:GetService("ReplicatedStorage")
    :WaitForChild("remote")
    :WaitForChild("property")

local re_BuyProperty = propertyRemote:WaitForChild("BuyProperty")
local rf_GetPropertyOwner = propertyRemote:WaitForChild("GetPropertyOwner")
local rf_GetPlatePrice = propertyRemote:WaitForChild("GetPlatePrice")

local client = require(game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts"):WaitForChild("Modules"))
local playerUtils = client.get("playerUtils")
local input = client.get("input")

local propertyFrame =   playerUtils.getPlayerGui():WaitForChild("Hud"):WaitForChild("Property")
local exitButton =      propertyFrame:WaitForChild("Exit").Value
local modeV =           propertyFrame:WaitForChild("Mode")
local priceV =          propertyFrame:WaitForChild("Price")

local proximityPrompts = playerUtils:getPlayerGui():WaitForChild("ProximityPrompts")
local prompt = proximityPrompts:WaitForChild("Interact")

local cycleProperty = require(script.Parent:WaitForChild("cycleProperty"))
local buyProperty = {}
buyProperty.Connections = {}

function buyProperty.start(properties)
    table.insert(buyProperty.Connections, exitButton.Activated:Connect(function()
        buyProperty.stop()
    end))

    table.insert(buyProperty.Connections, playerUtils.onDead(function()
        buyProperty.stop()
    end))

    input.bindPriority("PropertyExit", input.beginWrapper(function()
        exitButton.Activate:Fire()
        wait(.1)
        buyProperty.stop()
    end), false, 2001, Enum.KeyCode.ButtonB)

    buyProperty.Running = true
    propertyFrame.Visible = true
    priceV.Value = rf_GetPlatePrice:InvokeServer()
    modeV.Value = "Buy"
    prompt.Enabled = false

    local function claim(property)
        local cash = game:GetService("Players").LocalPlayer.leaderstats.Cash.Value
        local cost = rf_GetPlatePrice:InvokeServer()
        local owner = rf_GetPropertyOwner:InvokeServer(property.Model)
        if owner == 0 and cost <= cash then
            re_BuyProperty:FireServer(property.Model)
            buyProperty.stop()
        else
            -- TODO message player not enough cash
        end
    end

    cycleProperty.start(properties, claim)
end

function buyProperty.stop()
    cycleProperty.stop()
    propertyFrame.Visible = false
    buyProperty.Running = false
    prompt.Enabled = true

    for _, conn in ipairs(buyProperty.Connections) do
        conn:Disconnect()
    end
    buyProperty.Connections = {}
end

return buyProperty