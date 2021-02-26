--@initApi
--@Class: 'Properties'
local property = require(script:WaitForChild("property"))

local properties_mt = {}
properties_mt.__index = properties_mt
properties_mt.property = property

local properties = setmetatable({}, properties_mt)

--[[@Function: {
    'class' : 'Properties',
    'name' : 'add',
    'args' : { 'self' : 'Property', 'part' : 'BasePart'},
    'info' : 'adds a new Property to the list.'
}]]
function properties_mt.add(self, part)
    local id = #self + 1
    self[id] = property.new(id, part)
    return self[id]
end

--[[@Function: {
    'class' : 'Properties',
    'name' : 'get',
    'args' : { 'self' : 'Property', 'playerId' : 'number' },
    'return' : 'Property',
    'info' : 'Gets the Property of the player.'
}]]
function properties_mt.get(self, playerId)
    for _, prop in ipairs(self) do
        if prop:isOwner(playerId) then
            return prop
        end
    end
end

--[[@Function: {
   'class' : 'Properties',
   'name' : 'getFromModel',
   'args' : { 'self' : 'Property', 'model' : 'Model'},
   'return' : 'property',
   'info' : 'Gets property by model.'
}]]
function properties_mt.getFromModel(self, model)
    if string.match(model.Name, 'Property%[%d+%]') then
        local id =  tonumber(string.match(model.Name, '%d+'))
        return self[id]
    end
end

--[[@Function: {
    'class' : 'Properties',
    'name' : 'getEmpty',
    'args' : { 'self' : 'Property' },
    'return' : 'Property',
    'info' : 'Gets the first empty(not owned) Property in the list.'
}]]
function properties_mt.getEmpty(self)
    for _, prop in ipairs(self) do
        if prop:isOwner(0) then
            return prop
        end
    end
end

--[[@Function: {
   'class' : 'Properties',
   'name' : 'getAllEmpty',
   'args' : { 'self' : 'Property', 'part' : 'BasePart'},
   'return' : 'table',
   'info' : 'Gets all the empty(not owned) Properties in the list.'
}]]
function properties_mt.getAllEmpty(self)
    local t = {}
    for _, prop in ipairs(self) do
        if prop:isOwner(0) then
            table.insert(t, prop)
        end
    end
    return t
end

return properties