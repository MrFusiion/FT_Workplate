local holder = require(script.holder)

local children = game:GetService("ReplicatedStorage"):WaitForChild("WheelIcons"):GetChildren()
table.sort(children, function(a, b)
    return a.Name < b.Name
end)

local icons = {}
for i, icon in ipairs(children) do
    icons[icon.Name] = icon
    icons[i] = icon
end

local wheelrack = {}
wheelrack.__index = wheelrack

function wheelrack.new(model, wheelSize, data)
    local self = setmetatable({}, wheelrack)
    self.Rack = model:FindFirstChild(wheelSize)

    self.Holders = {}
    for _, child in ipairs(self.Rack:GetChildren()) do
        local i = tonumber(child.Name:match("%d+"))
        local hldr = holder.new(child, wheelSize, data)
        self.Holders[i] = hldr
    end

    self:updateColor(
        BrickColor.new(data.car.Model:GetAttribute("WheelcapColor")),
        BrickColor.new(data.car.Model:GetAttribute("IconColor"))
    )

    self.Conns = {}
    table.insert(self.Conns, data.car.Model:GetAttributeChangedSignal("WheelcapColor"):Connect(function()
        self:updateColor(
            BrickColor.new(data.car.Model:GetAttribute("WheelcapColor"))
        )
    end))

    table.insert(self.Conns, data.car.Model:GetAttributeChangedSignal("IconColor"):Connect(function()
        self:updateColor(
            nil,
            BrickColor.new(data.car.Model:GetAttribute("IconColor"))
        )
    end))

    table.insert(self.Conns, data.car.Model:GetAttributeChangedSignal("WheelIcon"):Connect(function()
        for _, hldr in ipairs(self.Holders) do
            hldr:updateState()
        end
    end))

    self.PagesCount = math.ceil(#icons / #self.Holders)
    self.CurrentPage = 1

    return self
end

function wheelrack:setActive(boolean)
    for _, hldr in ipairs(self.Holders) do
        hldr:setActive(boolean)
        if boolean then
            hldr:showState()
        else
            hldr:hideState()
        end
    end
end

function wheelrack:update()
    for i, hldr in ipairs(self.Holders) do
        local icon = icons[(self.CurrentPage - 1) * #self.Holders + i]
        hldr:set(icon and icon:Clone())
    end
end

function wheelrack:left()
    self.CurrentPage = (self.CurrentPage - 2) % self.PagesCount + 1
    self:update()
end

function wheelrack:right()
    self.CurrentPage = self.CurrentPage % self.PagesCount + 1
    self:update()
end

function wheelrack:destroy()
    for _, conn in ipairs(self.Conns) do
        conn:Disconnect()
    end

    for _, hldr in ipairs(self.Holders) do
        hldr:destroy()
    end
    self.Holders = {}
end

function wheelrack:updateColor(wheelcapColor, iconColor)
    for _, hldr in ipairs(self.Holders) do
        hldr:updateColor(wheelcapColor, iconColor)
    end
end

return wheelrack