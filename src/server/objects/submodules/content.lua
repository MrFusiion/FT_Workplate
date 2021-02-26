--@initApi
--@Class: 'Content'
local submodule = require(script.Parent)
local solidClass = submodule.get("solid")
local fluidClass = submodule.get("fluid")
local gasClass = submodule.get("gas")

local content = {}

content.__index = function(self, key)
    local value
    pcall(function()
        value = rawget(self, "Content")[key]
    end)
    if value then
        return value
    else
        return content[key]
    end
end

content.__newindex = function(self, key, value)
    local suc = pcall(function()
        self.Content[key] = value
    end)
    if not suc then
        rawset(self, key, value)
    end
end

--[[@Function: {
    'class' : 'Content',
    'name' : 'new',
    'args' : { 'part' : 'BasePart', 'type' : 'string', 'maxVolume' : 'number' },
    'return' : 'Content',
    'info' : 'Creates a new Content object.'
}
@Properties: {
    'class' : 'Content',
    'props' : [{
        'name' : 'Container',
        'type' : 'BasePart',
    }, {
        'name' : 'Type',
        'type' : 'string',
    }, {
        'name' : 'Volume',
        'type' : 'number',
    }, {
        'name' : 'MaxVolume',
        'type' : 'number',
    }]
}]]
function content.new(part, type, maxVolume)
    local newContent = {}
    newContent.Container = part
    newContent.Type = type
    newContent.Volume = 0
    newContent.MaxVolume = maxVolume

    setmetatable(newContent, content)
    newContent:__initVisual()

    return newContent
end

--[[@Function: {
    'class' : 'Content',
    'name' : 'add',
    'args' : { 'self' : 'Content', 'value' : 'number' },
    'info' : 'Adds the value to the content.'
}]]
function content.add(self, value)
    self:set(math.min(self.MaxVolume, self.Volume + value))
end

--[[@Function: {
    'class' : 'Content',
    'name' : 'remove',
    'args' : { 'self' : 'Content', 'value' : 'number' },
    'info' : 'Adds the value to the content.'
}]]
function content.remove(self, value)
    self:set(math.max(0, self.Volume - value))
end

--[[@Function: {
    'class' : 'Content',
    'name' : 'clear',
    'args' : { 'self' : 'Content' },
    'info' : 'Clears the volume of tank.'
}]]
function content.clear(self)
    self:set(0)
end

--[[@Function: {
    'class' : 'Content',
    'name' : 'set',
    'args' : { 'self' : 'Content', 'value' : 'number' },
    'info' : 'Sets the value of the content.'
}]]
function content.set(self, value)
    self.Volume = math.max(0, math.min(self.MaxVolume, value))
    self:__updateVisual()
end

--[[@Function: {
    'class' : 'Content',
    'name' : 'get',
    'args' : { 'self' : 'Content' },
    'return' : 'number',
    'info' : 'Gets the value of the content.'
}]]
function content.get(self)
    return self.Volume
end

--[[@Function: {
    'class' : 'Content',
    'name' : 'getFullness',
    'args' : { 'self' : 'Content' },
    'return' : 'number',
    'info' : 'Returns a value between 0 and 1 that describes the current used volume.'
}]]
function content.getFullness(self)
    return self.Volume / self.MaxVolume
end

--[[@Function: {
    'class' : 'Content',
    'name' : '__initVisual',
    'args' : { 'self' : 'Content' },
    'info' : '[Private] Initialize all visuals(tank contents).'
}]]
function content.__initVisual(self)
    if self.Type == 'solid' then
        rawset(self, 'Content', solidClass.new())
    elseif self.Type == 'fluid' then
        rawset(self, 'Content', fluidClass.new())
    elseif self.Type == 'gas' then
        rawset(self, 'Content', gasClass.new())
    else
        error("Type does not exits!")
    end

    if self.Type ~= 'gas' then
        self.Content.Size = self.Container.Size * Vector3.new(1, 0, 1)
        self.Content.CFrame = self.Container.CFrame
                - (self.Container.CFrame.UpVector * self.Container.Size.Y / 2) 
                + (self.Container.CFrame.UpVector * self.Content.Size.Y / 2)
    else
        self.Content.Size = self.Container.Size
        self.Content.CFrame = self.Container.CFrame
    end

    self.Content.Anchored = true
    self.Content.Transparency = 1
    self.Content.Parent = self.Container
end

--[[@Function: {
    'class' : 'Content',
    'name' : '__updateVisual',
    'args' : { 'self' : 'Content' },
    'info' : '[Private] Updates all visuals(tank contents).'
}]]
function content.__updateVisual(self)
    if self.Volume > 0 then
        if self.Type == 'solid' then
            self.Content.Transparency = 0 --[[
                TODO: make this more changable 
                ]]
        --elseif self.Type == 'fluid' then
            --self.Content.Transparency = 0.5 
        elseif self.Type == 'gas' then
            self.Content.Transparency = 0.5 --[[
                TODO: make this more changable
                ]]
        end
    else
        self.Content.Transparency = 1
    end

    if self.Type ~= 'gas' then
        self.Content.Size = self.Container.Size * Vector3.new(1, self:getFullness(), 1)
        self.Content.CFrame = self.Container.CFrame
                - (self.Container.CFrame.UpVector * self.Container.Size.Y / 2) 
                + (self.Container.CFrame.UpVector * self.Content.Size.Y / 2)
    else
        self.Content:setVolume(self:getFullness())
    end
end

return content