--@initApi
--@Class: 'Solid'
local solid = {}

solid.__index = function(self, key)
    local value
    pcall(function()
        value = rawget(self, "Part")[key]
    end)
    if value then
        return value
    else
        return solid[key]
    end
end

solid.__newindex = function(self, key, value)
    local suc = pcall(function()
        self.Part[key] = value
    end)
    if not suc then
        rawset(self, key, value)
    end
end

--[[
@Function: {
    'class' : 'Solid',
    'name' : 'new',
    'args' : { 'parent' : 'BasePart' },
    'return' : 'Solid',
    'info' : "Creates a new Solid."
}
@Properties: {
    'class' : 'Solid',
    'props' : [{
        'name' : 'parent',
        'type' : 'BasePart'
    }]
}]]
function solid.new(parent)
    local newSolid = {}
    newSolid.Part = Instance.new("Part")
    newSolid.Part.Parent = parent
    setmetatable(newSolid, solid)
    return newSolid
end

return solid