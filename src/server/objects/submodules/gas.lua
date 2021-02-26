--@initApi
--@Class: 'Gas'
local gas = {}

local MAX_RATE = 10

gas.__index = function(self, key)
    local value
    pcall(function()
        value = rawget(self, "Outer")[key]
    end)
    if value then
        return value
    else
        return gas[key]
    end
end

gas.__newindex = function(self, key, value)
    if key == 'Transparency' or key == 'Size'
            or key == 'Position' or key == 'CFrame'
            or key == 'BrickColor' or key == 'Color3' then
        self[string.format("set%s", key)](self, value)
    else
        local suc = pcall(function()
            self.Outer[key] = value
        end)
        if not suc then
            error(string.format("%s is not a valid member of object type gas"))
        end
    end
end

--[[@Function: {
    'class' : 'Gas',
    'name' : 'new',
    'args' : { },
    'return' : 'Gas',
    'info' : 'Creates a new Gas object.'
}
@Properties: {
    'class' : 'Gas',
    'props' : [{
        'name' : 'Outer',
        'type' : 'BasePart',
    }, {
        'name' : 'Inner',
        'type' : 'BasePart',
    }, {
        'name' : 'Particle',
        'type' : 'ParticleEmitter',
    }]
}]]
function gas.new()
    local newGas = {}

    newGas.Outer = Instance.new("Part")
    newGas.Outer.Anchored = true
    newGas.Outer.CanCollide = false
    newGas.Outer.Transparency = 1

    newGas.Inner = newGas.Outer:Clone()
    newGas.Inner.Size = newGas.Outer.Size / 2
    newGas.Inner.Parent = newGas.Outer

    newGas.Particle = Instance.new("ParticleEmitter")
    newGas.Particle.Texture = 'rbxasset://textures/particles/smoke_main.dds'
    newGas.Particle.Rate = 1
    newGas.Particle.Size = NumberSequence.new(math.min(
            newGas.Inner.Size.X / 2, 
            newGas.Inner.Size.Y / 2, 
            newGas.Inner.Size.Z / 2 ))
    newGas.Particle.Transparency = NumberSequence.new(.5)
    newGas.Particle.Lifetime = NumberRange.new(10, 10)
    newGas.Particle.Drag = 100
    newGas.Particle.Rotation = NumberRange.new(0, 6)
    newGas.Particle.RotSpeed = NumberRange.new(1, 1)
    newGas.Particle.Speed = NumberRange.new(1, 1)
    newGas.Particle.SpreadAngle = Vector2.new()
    newGas.Particle.Parent = newGas.Inner

    setmetatable(newGas, gas)
    return newGas
end

--============//Setters//============--
--[[@Function: {
    'class' : 'Gas',
    'name' : 'setVolume',
    'args' : { 'self' : 'Gas', 'value' : 'number'},
    'info' : 'Sets the volume of the gas.'
}]]
function gas.setVolume(self, value)
    self.Particle.Rate = math.max(.5, math.floor(MAX_RATE * value))
end

--[[@Function: {
    'class' : 'Gas',
    'name' : 'setTransparency',
    'args' : { 'self' : 'Gas', 'value' : 'number'},
    'info' : 'Sets the transparency of the gas.'
}]]
function gas.setTransparency(self, value)
    self.Particle.Transparency = NumberSequence.new(value)
end

--[[@Function: {
    'class' : 'Gas',
    'name' : 'setSize',
    'args' : { 'self' : 'Gas', 'value' : 'Vector3'},
    'info' : 'Sets the size of the Gas.'
}]]
function gas.setSize(self, value)
    self.Outer.Size = value
    self.Inner.Size = value / 2
    self.Particle.Size = NumberSequence.new(math.min(value.X / 2, value.Y / 2, value.Z / 2))
end

--[[@Function: {
    'class' : 'Gas',
    'name' : 'setPosition',
    'args' : { 'self' : 'Gas', 'value' : 'Vector3'},
    'info' : 'Sets the position of the Gas.'
}]]
function gas.setPosition(self, value)
    self.Outer.Position = value
    self.Inner.Position = value
end

--[[@Function: {
    'class' : 'Gas',
    'name' : 'setCFrame',
    'args' : { 'self' : 'Gas', 'value' : 'CFrame'},
    'info' : 'Sets the CFrame of the Gas.'
}]]
function gas.setCFrame(self, value)
    self.Outer.CFrame = value
    self.Inner.CFrame = value
end

--[[@Function: {
    'class' : 'Gas',
    'name' : 'setBrickColor',
    'args' : { 'self' : 'Gas', 'value' : 'BrickColor'},
    'info' : 'Sets the color of the Gas.'
}]]
function gas.setBrickColor(self, value)
    self:setColor3(value.Color)
end

--[[@Function: {
    'class' : 'Gas',
    'name' : 'setColor3',
    'args' : { 'self' : 'Gas', 'value' : 'Color3'},
    'info' : 'Sets the color of the Gas.'
}]]
function gas.setColor3(self, value)
    self.Particle.Color = ColorSequence.new(value)
end

return gas