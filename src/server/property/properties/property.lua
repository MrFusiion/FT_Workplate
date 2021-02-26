--@initApi
--@Class: 'Property'
local modules = require(game:GetService('ReplicatedStorage'):WaitForChild('modules'))
local mathUtils = modules.get('mathUtils')
local event = modules.get('event')

local property = {}
property.__index = property
property.SIZE = 5
property.MAX_PLATE_COUNT = property.SIZE*property.SIZE
property.NEW_PROP_DATA = {}
for i=1, property.MAX_PLATE_COUNT do
    table.insert(property.NEW_PROP_DATA,
        i == math.ceil(property.MAX_PLATE_COUNT/2) and 1 or 0)
end

--[[
@Function: {
    'class' : 'Property',
    'name' : 'new',
    'args' : { 'model' : 'Model' },
    'return' : 'Property',
    'info' : "Creates a new property."
}
@Properties: {
    'class' : 'Property',
    'props' : [{
        'name' : 'Data',
        'type' : 'table'
    }, {
        'name' : 'Parts',
        'type' : 'table'
    }, {
        'name' : 'Owner',
        'type' : 'number'
    }, {
        'name' : 'Enable',
        'type' : 'RBXScriptSignal'
    }]
}]]
--[[@Properties: {
    'class' : 'Property',
    'props' : [{
        'name' : '__PlateEnableSignal',
        'type' : 'BindableEvent'
    }]
}]]
function property.new(id, model)
    local newProperty = setmetatable({}, property)
    newProperty.Data = {}
    newProperty.Plates = {}
    newProperty.ExpandablePlates = {}
    newProperty.Owner = 0

    newProperty.Model = Instance.new('Model')
    newProperty.Model.Name = string.format('Property[%02d]', id)
    newProperty.Model.Parent = model.Parent

    newProperty.__PlateEnableSignal, newProperty.PlateEnable = event.new()

    local cf = model.PrimaryPart.CFrame - model.PrimaryPart.CFrame.RightVector * ((model.PrimaryPart.Size.X * (property.SIZE + 1)) / 2)
            + model.PrimaryPart.CFrame.LookVector * ((model.PrimaryPart.Size.Z * (property.SIZE + 1)) / 2)
    for z=1, property.SIZE do
        for x=1, property.SIZE do
            local index = property.getIndex(x, z)

            local part = model.PrimaryPart:Clone()
            part.Name = string.format("Land[%02d]", index)
            part.Anchored = true
            part.CFrame = cf + (model.PrimaryPart.CFrame.RightVector * model.PrimaryPart.Size.X * x)
                - (model.PrimaryPart.CFrame.LookVector * model.PrimaryPart.Size.Z * z)
            part.Parent = newProperty.Model

            if index == math.ceil(property.MAX_PLATE_COUNT/2) then
                newProperty.Model.PrimaryPart = part
                newProperty.Data[index] = 1
            else
                newProperty.Data[index] = 0
            end
            newProperty.Plates[index] = part
        end
    end
    model:Destroy()
    return newProperty
end

--[[@Function: {
    'class' : 'Property',
    'name' : 'init',
    'args' : { 'self' : 'Property', 'data' : 'table/nil' },
    'info' : "Enables or Disables plates according to data."
}]]
function property.init(self, data)
    assert(data == nil or typeof(data)=='table', "`data` must be type of table or nil!")
    assert(data == nil or #data == property.MAX_PLATE_COUNT, string.format("`data` size is needs to be %d!", property.MAX_PLATE_COUNT))
    self.Data = data or self.Data
    for id in pairs(self.Data) do
        self:enable(id, self.Data[id]==1)
    end
end

--[[@Function: {
    'class' : 'Property',
    'name' : 'reset',
    'args' : { 'self' : 'Property' },
    'info' : "Resets all data plates back to default."
}]]
function property.reset(self)
    self.Owner = 0
    self.ExpandablePlates = {}
    for k in pairs(self.Data) do
        self.Data[k] = k == math.ceil(property.MAX_PLATE_COUNT/2) and 1 or 0
        self:enable(k, self.Data[k]==1)
    end
end

--[[@Function: {
    'class' : 'Property',
    'name' : 'enable',
    'args' : { 'self' : 'Property', 'id' : 'number', 'enable' : 'boolean' },
    'info' : "Enables a specific plate of the property given by the id."
}]]
function property.enable(self, id, enable)
    assert(typeof(id)=='number', "`id` must be type of number!")
    assert(0 < id and id <= property.MAX_PLATE_COUNT, "`id` is out of range!")
    self.Data[id] = enable and 1 or 0
    self.__PlateEnableSignal:Fire(self.Plates[id], enable)
end

--[[@Function: {
    'class' : 'Property',
    'name' : 'canEnable',
    'args' : { 'self' : 'Property', 'id' : 'number' },
    'return' : 'boolean'
    'info' : "Checks if a specific plate of the property can be enabled."
}]]
function property.canEnable(self, id)
    assert(typeof(id)=='number', "`id` must be type of number!")
    assert(0 < id and id <= property.MAX_PLATE_COUNT, "`id` is out of range!")
    return (self.Data[id] ~= 1)
        and ((id % property.SIZE ~= 1 and self.Data[id - 1] == 1)--left
        or (id % property.SIZE ~= 0 and self.Data[id + 1] == 1)--right
        or (id - property.SIZE >= 1 and self.Data[id - property.SIZE] == 1)--up
        or (id + property.SIZE <= property.MAX_PLATE_COUNT and self.Data[id + property.SIZE] == 1))--down
end

--[[@Function: {
    'class' : 'Property',
    'name' : 'isEnabled',
    'args' : { 'self' : 'Property', 'id' : 'number', 'enable' : 'boolean' },
    'info' : "Checks if a specific plate of the property is enabled."
}]]
function property.isEnabled(self, id)
    assert(typeof(id)=='number', "`id` must be type of number!")
    assert(0 < id and id <= property.MAX_PLATE_COUNT, "`id` is out of range!")
    return self.Data[id] == 1
end

--[[@Function: {
    'class' : 'Property',
    'name' : 'setOwner',
    'args' : { 'self' : 'Property', 'playerId' : 'number' },
    'info' : "Set the player as the owner of the property."
}]]
function property.setOwner(self, playerId)
    assert(typeof(playerId)=='number', "`playerId` must be type of number!")
    self.Owner = playerId
end

--[[@Function: {
    'class' : 'Property',
    'name' : 'getOwner',
    'args' : { 'self' : 'Property' },
    'return' : 'number',
    'info' : 'Gets the Property's onwer.'
}]]
function property.getOwner(self)
    return self.Owner
end

--[[@Function: {
    'class' : 'Property',
    'name' : 'isOwner',
    'args' : { 'self' : 'Property', 'playerId' : 'number' },
    'return' : 'boolean',
    'info' : "Checks if player is the owner of the property."
}]]
function property.isOwner(self, playerId)
    assert(typeof(playerId)=='number', "`playerId` must be type of number!")
    return self.Owner == playerId
end

--[[@Function: {
    'class' : 'Property',
    'name' : 'getAvailiblePlates',
    'args' : { 'self' : 'Property' },
    'return' : 'table',
    'info' : "Gets all of the plates that are next to a bought plate."
}]]
function property.getExpandablePlates(self)
    local t = {}
    for id, plate in pairs(self.Plates) do
        if self:canEnable(id) then
            table.insert(t, plate)
        end
    end
    return t
end

--[[@Function: {
    'class' : 'Property',
    'name' : 'getPlateCount',
    'args' : { 'self' : 'Property' },
    'return' : 'number',
    'info' : "Counts the total of active plates."
}]]
function property.getPlateCount(self)
    local count = 0
    for _, data in ipairs(self.Data) do
        count += data
    end
    return count
end

--[[@Function: {
    'class' : 'Property',
    'name' : 'maxUpgraded',
    'args' : { 'self' : 'Property' },
    'return' : 'boolean',
    'info' : "Checks if all of the property plates are enabled."
}]]
function property.maxUpgraded(self)
    return self:getPlateCount() >= property.MAX_PLATE_COUNT
end

--===============/static/===============--
--[[@Function: {
    'class' : 'Property',
    'name' : 'getId',
    'args' : { 'part' : 'BasePart' },
    'return' : 'number',
    'info' : "Gets the Id the of the plate."
}]]
function property.getIndexFromPlate(part)
    if string.match(part.Name, 'Land%[%d+%]') then
        return tonumber(string.match(part.Name, '%d+'))
    end
end

--[[@Function: {
    'class' : 'Property',
    'name' : 'getIndex',
    'args' : { 'x' : 'number', 'z' : 'number' },
    'return' : 'number',
    'info' : "Returns a number converted from 2D to 1D space."
}]]
function property.getIndex(x, z)
    assert(typeof(x)=='number', "`x` must be type of number!")
    assert(typeof(z)=='number', "`z` must be type of number!")
    return (z - 1) * property.SIZE + x
end

--[[@Function: {
    'class' : 'Property',
    'name' : 'get2D',
    'args' : { 'index' : 'number' },
    'return' : 'number',
    'info' : "Returns a number converted from 1D to 2D space."
}]]
function property.get2D(index)
    assert(typeof(index)=='number', "`index` must be type of number!")
    return index - math.floor((index - 1) / property.SIZE) * property.SIZE,
        math.ceil(index / property.SIZE)
end

--===============/meta/===============--
function property.__tostring(self)
    return table.concat(self.Data)
end

return property