local propertyRemote = game:GetService("ReplicatedStorage")
    :WaitForChild("remote")
    :WaitForChild("property")

local re_ClaimProperty =    propertyRemote:WaitForChild("ClaimProperty")
local rf_GetPropertyOwner = propertyRemote:WaitForChild("GetPropertyOwner")

local client = require(game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts"):WaitForChild("Modules"))
local playerUtils = client.get("playerUtils")

local propertyFrame =   playerUtils.getPlayerGui():WaitForChild("Hud"):WaitForChild("Property")
local modeV =           propertyFrame:WaitForChild("Mode")

local proximityPrompts = playerUtils:getPlayerGui():WaitForChild("ProximityPrompts")
local prompt = proximityPrompts:WaitForChild("Interact")

local cycleProperty = require(script.Parent:WaitForChild("cycleProperty"))
local claimProperty = {}

function claimProperty.start(properties)
    prompt.Enabled = false
    claimProperty.Running = true
    propertyFrame.Visible = true
    modeV.Value = "Claim"

    claimProperty.diedConnection = playerUtils.onDead(function()
        claimProperty.stop()
    end)

    claimProperty.charConnection = playerUtils.getPlayer().CharacterAdded:Connect(function()
        wait(1)
        claimProperty.start(properties)
    end)

    local function claim(property)
        local owner = rf_GetPropertyOwner:InvokeServer(property.Model)
        if owner == 0 then
            re_ClaimProperty:FireServer(property.Model)
            claimProperty.stop()
        else
            -- TODO message player land allready claimed
        end
    end
    cycleProperty.start(properties, claim)
end

function claimProperty.stop()
    cycleProperty.stop()
    if claimProperty.diedConnection then
        claimProperty.diedConnection:Disconnect()
    end
    if claimProperty.charConnection then
        claimProperty.charConnection:Disconnect()
    end
    propertyFrame.Visible = false
    claimProperty.Running = false
    prompt.Enabled = true
end

return claimProperty