--@initApi
--@Class: 'Fluid'
local fluid = {}

fluid.__index = function(self, key)
    local value
    pcall(function()
        value = rawget(self, "Part")[key]
    end)
    if value then
        return value
    else
        return fluid[key]
    end
end

fluid.__newindex = function(self, key, value)
    if key == 'Transparency' then
        self:setTransparency(value)
    else
        local suc = pcall(function()
            self.Part[key] = value
        end)
        if not suc then
            rawset(self, key, value)
        end
    end
end

--[[@Function: {
    'class' : 'Fluid',
    'name' : 'new',
    'args' : { 'parent' : 'BasePart' },
    'return' : 'Fluid',
    'info' : 'Creates a new Fluid object.'
}
@Properties: {
    'class' : 'Fluid',
    'props' : [{
        'name' : 'FluidSpeed',
        'type' : 'number',
    }, {
        'name' : 'Textures',
        'type' : 'table',
    }, {
        'name' : 'Running',
        'type' : 'boolean',
    }, {
        'name' : 'Part',
        'type' : 'BasePart',
    }]
}]]
function fluid.new(parent)
    local newFluid = {}
    newFluid.FluidSpeed = 100
    newFluid.Textures = {}
    newFluid.Running = false

    newFluid.Part = Instance.new("Part")
    newFluid.Part.Material = 'SmoothPlastic'
    newFluid.Part.Transparency = .5
    newFluid.Part.Parent = parent

    setmetatable(newFluid, fluid)
    newFluid:__init()
    newFluid:start()
    return newFluid
end

--[[@Function: {
    'class' : 'Fluid',
    'name' : '__init',
    'args' : { 'self' : 'Fluid' },
    'info' : '[Private] Initializes all the textures sides.'
}]]
function fluid.__init(self)
    for _, v in pairs(Enum.NormalId:GetEnumItems()) do
        local texture = Instance.new("Texture")
        texture.Color3 = Color3.new()
        texture.Texture = self.getTexture()
        texture.StudsPerTileU = 5
        texture.StudsPerTileV = 5
        texture.Transparency = .5
        texture.Face = v
        texture.Parent = self.Part
        table.insert(self.Textures, texture)
    end
end

--[[@Function: {
    'class' : 'Fluid',
    'name' : 'setFluidType',
    'args' : { 'self' : 'Fluid', 'value' : 'string' },
    'info' : 'Sets the fluid type (water, lava).'
}]]
function fluid.setFluidType(self, value)
    if value == 'water' then
        self:setTransparency(.5)
        self.Material = 'SmoothPlastic'
    elseif value == 'lava' then
        self:setTransparency(0)
        self.Material = 'Neon'
    end
end

--[[@Function: {
    'class' : 'Fluid',
    'name' : 'setTransparency',
    'args' : { 'self' : 'Fluid', 'value' : 'number' },
    'info' : 'Sets the transaparency of the part and all of his textures sides.'
}]]
function  fluid.setTransparency(self, value)
    self.Part.Transparency = value
    for _, v in ipairs(self.Textures) do
        v.Transparency = value
    end
end

--[[@Function: {
    'class' : 'Fluid',
    'name' : 'start',
    'args' : { 'self' : 'Fluid', 'speed' : 'number' },
    'info' : 'Starts the fluid animation.'
}]]
function fluid.start(self, speed)
    self.FluidSpeed = speed or self.FluidSpeed
    if self.Running then return end
    self.Running = true
    spawn(function()
        while self.Running do
            for i = 1, 25 do
                for _, v in ipairs(self.Textures) do
                    v.Texture = self.getTexture(i)
                end
                wait(1 / self.FluidSpeed)
            end
        end
    end)
end

--[[@Function: {
    'class' : 'Fluid',
    'name' : 'stop',
    'args' : { 'self' : 'Fluid' },
    'info' : 'Stops the fluid animation.'
}]]
function fluid.stop(self)
    self.Running = false
end

--[[@Function: {
    'class' : 'Fluid',
    'name' : 'getTexture',
    'args' : { 'index' : 'number' },
    'info' : 'Gets the water texture from roblox (1 - 25)'
}]]
function fluid.getTexture(i)
    i = math.max(1, math.min(25, i or 1))
    return string.format("rbxasset://textures/water/normal_%02d.dds", i)
end

return fluid