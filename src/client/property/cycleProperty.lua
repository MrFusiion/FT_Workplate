local propertyRemote = game:GetService("ReplicatedStorage")
    :WaitForChild("remote")
    :WaitForChild("property")

local rf_GetPropertyOwner = propertyRemote:WaitForChild("GetPropertyOwner")

local client = require(game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts"):WaitForChild("Modules"))
local cameraUtils = client.get("cameraUtils")
local playerUtils = client.get("playerUtils")
local input =       client.get("input")
local platform =    client.get("platform")

local propertyFrame =   playerUtils.getPlayerGui():WaitForChild("Hud"):WaitForChild("Property")
local leftButton =      propertyFrame:WaitForChild("Left").Value
local confirmButton =   propertyFrame:WaitForChild("Confirm").Value
local rightButton =     propertyFrame:WaitForChild("Right").Value
--local modeV =           propertyFrame:WaitForChild("Mode").Value
--local priceV =          propertyFrame:WaitForChild("Price").Value

local cycleProperty = {}
cycleProperty.Connections = {}

local function setCameraCFrame(property)
    if property then
        local _, size = property.Model:GetBoundingBox()
        local offset = CFrame.new(0, size.X / 2, size.X / 2)
        local modelCF = property.Model:GetPrimaryPartCFrame()
        local cf = CFrame.new((modelCF * offset).p, modelCF.p)
        cameraUtils.tween(cf, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)):Play()
    end
end

function cycleProperty.start(properties, claimCallback)
    playerUtils.lock(true)
    cameraUtils.scriptable(true)
    local index = 1
    setCameraCFrame(properties[index])
    local function cycleLeft()
        local owner
        repeat
            index = (index - 2) % #properties + 1
            owner = rf_GetPropertyOwner:InvokeServer(properties[index].Model)
        until owner == 0
        setCameraCFrame(properties[index])
    end
    local function cycleRight()
        local owner
        repeat
            index = index % #properties + 1
            owner = rf_GetPropertyOwner:InvokeServer(properties[index].Model)
        until owner == 0
        setCameraCFrame(properties[index])
    end
    local function claim()
        claimCallback(properties[index])
    end

    --Controls
    table.insert(cycleProperty.Connections, leftButton.Activated:Connect(cycleLeft))
    table.insert(cycleProperty.Connections, confirmButton.Activated:Connect(claim))
    table.insert(cycleProperty.Connections, rightButton.Activated:Connect(cycleRight))

    input.bindPriority("cycleLeft", input.beginWrapper(function()
        leftButton.Activate:Fire()
        cycleLeft()
    end), false, 2001, Enum.KeyCode.Left, Enum.KeyCode.A, Enum.KeyCode.DPadLeft)
    input.bindPriority("claim", input.beginWrapper(function()
        confirmButton.Activate:Fire()
        claim()
    end), false, 2001, Enum.KeyCode.Return, Enum.KeyCode.KeypadEnter, Enum.KeyCode.ButtonA)
    input.bindPriority("cycleRight", input.beginWrapper(function()
        rightButton.Activate:Fire()
        cycleRight()
    end), false, 2001, Enum.KeyCode.Right, Enum.KeyCode.D, Enum.KeyCode.DPadRight)
end

function cycleProperty.stop()
    playerUtils.lock(false)
    cameraUtils.scriptable(false)
    input.safeUnbind("cycleLeft", "cycleRight", "claim")
    for _, conn in ipairs (cycleProperty.Connections) do
        conn:Disconnect()
    end
    cycleProperty.Connections = {}
end

return cycleProperty