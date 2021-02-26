local properties = require(script:WaitForChild("properties"))

local shared = require(game:GetService('ReplicatedStorage'):WaitForChild('modules'))
local settings = shared.get('settings').new(script:WaitForChild('config'))
local mathUtils = shared.get('mathUtils')

local server = require(game:GetService('ServerScriptService'):WaitForChild('modules'))
local datastore = server.get('datastore')
local validate = server.get('validate')

--================/Init Start/================--
for _, property in ipairs(workspace:WaitForChild("Properties"):GetChildren()) do
    local prop = properties:add(property)
    prop.PlateEnable:Connect(function(p, enable)
        p.Transparency = not enable and 1 or 0
        p.CanCollide = enable
    end)
    prop:init()
end
--================/Init End/================--

--================/Remote Start/================--
local PROPERTY_COST = settings:get('PropertyCost')
local function getPlateCost(player)
    local prop = properties:get(player.UserId)
    local i = prop and prop:getPlateCount() or 0
    return mathUtils.roundStep(PROPERTY_COST * 1.45^i, 500) + 500 * i
end

local function setProperty(player, property)
    if property and property:isOwner(0) then
        local store = datastore.combined.player(player, 'Data', 'Property')
        property:setOwner(player.UserId)
        property:init(store:get('Property', datastore.deepCopy(properties.property.NEW_PROP_DATA)))
        store:connect('onRemove', 'Property', function()
            property:reset()
        end)
    end
end

local propertyRemote = game:GetService('ReplicatedStorage')
    :WaitForChild('remote')
    :WaitForChild('property')

local rf_GetProperty = propertyRemote:WaitForChild('GetProperty')
function rf_GetProperty.OnServerInvoke(player)
    return properties:get(player.UserId)
end

local rf_GetPropertyOwner = propertyRemote:WaitForChild('GetPropertyOwner')
function rf_GetPropertyOwner.OnServerInvoke(_, property)
    local owner
    validate.isInstanceOf(property, 'Model', function()
        local prop = properties:getFromModel(property)
        if prop then
            owner = prop:getOwner()
        end
    end)
    return owner
end

local rf_GetAvailiblePlates = propertyRemote:WaitForChild('GetAvailiblePlates')
function rf_GetAvailiblePlates.OnServerInvoke(player)
    local prop = properties:get(player.UserId)
    if prop then
        return prop:getExpandablePlates()
    end
end

local rf_GetPlatePrice = propertyRemote:WaitForChild('GetPlatePrice')
function rf_GetPlatePrice.OnServerInvoke(player)
    return getPlateCost(player)
end

local re_ClaimProperty = propertyRemote:WaitForChild('ClaimProperty')
re_ClaimProperty.OnServerEvent:Connect(function(player, property)
    validate.isInstanceOf(property, 'Model', function()
        if not properties:get(player.UserId) then
            local prop = properties:getFromModel(property)
            if prop then
                setProperty(player, prop)
            end
        end
    end)
end)

local re_BuyProperty = propertyRemote:WaitForChild('BuyProperty')
re_BuyProperty.OnServerEvent:Connect(function(player, property)
    validate.isInstanceOf(property, 'Model', function()
        local prop = properties:get(player.UserId)
        local store = datastore.combined.player(player, 'Data', 'Cash')
        local cost = getPlateCost(player)
        if not prop and cost <= store:get('Cash') then
            prop = properties:getFromModel(property)
            if prop and prop:isOwner(0) then
                store:increment('Cash', -cost)
                setProperty(player, prop)
            end
        end
    end)
end)

local re_ExpandProperty = propertyRemote:WaitForChild('ExpandProperty')
re_ExpandProperty.OnServerEvent:Connect(function(player, plate)
    validate.isInstanceOf(plate, 'Part', function()
        local prop = properties:get(player.UserId)
        local index = prop.getIndexFromPlate(plate)
        local store = datastore.combined.player(player, 'Data', 'Cash', 'Property')
        local cost = getPlateCost(player)
        if prop and index and cost <= store:get('Cash') then
            if not prop:isEnabled(index) and prop:canEnable(index) then
                store:increment('Cash', -cost)
                prop:enable(index, true)
                store:update('Property', function(data)
                    data[index] = 1
                    return data
                end)
            end
        end
    end)
end)
--================/Remote End/================--

--================/Data Start/================--

datastore.load:Connect(function(player)
    local store = datastore.combined.player(player, 'Data', 'Cash', 'Property')
    local data = store:get('Property')
    if data then
        re_ClaimProperty:FireClient(player, properties)
    end
end)

--================/Data End/================--