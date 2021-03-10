local propertyRemote = game:GetService("ReplicatedStorage")
    :WaitForChild("remote")
    :WaitForChild("property")

local rf_GetProperty = propertyRemote:WaitForChild("GetProperty")
local rf_GetAvailiblePlates = propertyRemote:WaitForChild("GetAvailiblePlates")
local rf_GetPlatePrice = propertyRemote:WaitForChild("GetPlatePrice")

local modules = require(game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts"):WaitForChild("Modules"))
local cameraUtils = modules.get("cameraUtils")
local playerUtils = modules.get("playerUtils")
local input = modules.get("input")
local platform = modules.get("platform")

local proximityPrompts = playerUtils:getPlayerGui():WaitForChild("ProximityPrompts")
local prompt = proximityPrompts:WaitForChild("Interact")

local propertyFrame =   playerUtils.getPlayerGui():WaitForChild("Hud"):WaitForChild("Property")
local exitButton =      propertyFrame:WaitForChild("Exit").Value
local leftButton =      propertyFrame:WaitForChild("Left").Value
local confirmButton =   propertyFrame:WaitForChild("Confirm").Value
local rightButton =     propertyFrame:WaitForChild("Right").Value
local modeV =           propertyFrame:WaitForChild("Mode")
local priceV =          propertyFrame:WaitForChild("Price")

local expandProperty = {}
expandProperty.Connections = {}

local FULL_DATA = {}
for _=1,25 do
    table.insert(FULL_DATA, 1)
end

local expandPlates = {}
local function clearPlates()
    for _, expandPlate in ipairs(expandPlates) do
        expandPlate:destroy()
    end
    expandPlates = {}
end
local function checkPlates()
    local checkedPlates = {}
    for _, expandPlate in ipairs(expandPlates) do
        if expandPlate.Part.Parent then
            expandPlate:unselect()
            table.insert(checkedPlates, expandPlate)
        end
    end
    table.sort(checkedPlates, function(a, b)
        return a.Plate.Name < b.Plate.Name
    end)
    expandPlates = checkedPlates
end

local function cameraSetup(property)
    playerUtils.lock(true)
    cameraUtils.scriptable(true)
    local modelCf = property.Model:GetPrimaryPartCFrame()
    local _, size = property.Model:GetBoundingBox()
    local fov = cameraUtils.get("FieldOfView")

    local borderOffset = 100
    local dist = (math.max(size.X, size.Z) / 2 + borderOffset) / math.tan(math.rad(fov/2))
    local cf = CFrame.new(modelCf.p + modelCf.UpVector * ((property.Model.PrimaryPart.Size.Y/2) + dist), modelCf.p)

    cameraUtils.tween(cf, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)):Play()
end

local expandPlate = require(script:WaitForChild("expandPlate"))
local function createPlates()
    local cost = rf_GetPlatePrice:InvokeServer()
    priceV.Value = cost
    local availiblePlates = rf_GetAvailiblePlates:InvokeServer()
    if #availiblePlates <= 0 then
        expandProperty.stop()
        return
    end
    for _, plate in ipairs(availiblePlates) do
        local newExpandPlate = expandPlate.new(plate)
        if newExpandPlate then
            newExpandPlate.ClickDetector.MouseClick:Connect(function()
                newExpandPlate:claim(cost)
                createPlates()
            end)
            table.insert(expandPlates, newExpandPlate)
        end
    end
end

local index = 1
local function gamepadSetup()
    local function plateSelect()
        if expandPlates[index] then
            expandPlates[index]:select()
        end
    end

    local function plateUnselect()
        if expandPlates[index] then
            expandPlates[index]:unselect()
        end
    end

    if platform.getPlatform() == "CONSOLE" then
        checkPlates()
        plateSelect()
    end
    
    input.bindPriority("ExpandCycleLeft", input.beginWrapper(function()
        leftButton.Activate:Fire()
        plateUnselect()
        index = (index - 2) % #expandPlates + 1
        plateSelect()
    end), false, 2001, Enum.KeyCode.DPadLeft)

    input.bindPriority("PropertyClaim", input.beginWrapper(function()
        confirmButton.Activate:Fire()
        if expandPlates[index] then
            plateUnselect()
            expandPlates[index]:claim()
            createPlates()
            checkPlates()
            plateUnselect()
            index = 1
            plateSelect()
        end
    end), false, 2001, Enum.KeyCode.ButtonA)

    input.bindPriority("PropertyExit", input.beginWrapper(function()
        exitButton.Activate:Fire()
        wait(.1)
        expandProperty.stop()
    end), false, 2001, Enum.KeyCode.ButtonB)

    input.bindPriority("ExpandCycleRight", input.beginWrapper(function()
        rightButton.Activate:Fire()
        plateUnselect()
        index = index % #expandPlates + 1
        plateSelect()
    end), false, 2001, Enum.KeyCode.DPadRight)

    table.insert(expandProperty.Connections, platform.PlafromChange:Connect(function(plat)
        if plat == "CONSOLE" then
            clearPlates()
            createPlates()
            checkPlates()
            index = 1
            plateSelect()
        end
    end))
end

function expandProperty.start()
    local prop = rf_GetProperty:InvokeServer()
    local availiblePlates = rf_GetAvailiblePlates:InvokeServer() or {}
    if prop and #availiblePlates > 0 then
        table.insert(expandProperty.Connections, exitButton.Activated:Connect(function()
            expandProperty.stop()
        end))

        table.insert(expandProperty.Connections, playerUtils.onDead(function()
            expandProperty.stop()
        end))

        expandProperty.Running = true
        propertyFrame.Visible = true
        modeV.Value = "Expand"
        prompt.Enabled = false

        cameraSetup(prop)
        createPlates()
        gamepadSetup()
    end
end

function expandProperty.stop()
    playerUtils.lock(false)
    cameraUtils.scriptable(false)
    clearPlates()

    for _, conn in ipairs(expandProperty.Connections) do
        conn:Disconnect()
    end
    expandProperty.Connections = {}

    input.safeUnbind("ExpandCycleLeft", "ExpandCycleRight", "PropertyClaim", "PropertyExit")

    propertyFrame.Visible = false
    expandProperty.Running = false
    prompt.Enabled = true
end

return expandProperty