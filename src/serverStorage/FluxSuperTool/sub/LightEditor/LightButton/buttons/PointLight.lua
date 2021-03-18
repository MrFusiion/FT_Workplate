local PointLight = {}
PointLight.__index = PointLight

local function corner(scale, offset)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(scale, offset)
    return c
end

function auto(clr, factor, tolerance)
    tolerance = tolerance or .5
    return math.clamp(.2126 * clr.R + .7152 * clr.G + .0722 * clr.B, 0, 1) < tolerance and
    Color3.new(
        clr.R + (1 - clr.R) * factor,
        clr.G + (1 - clr.G) * factor,
        clr.B + (1 - clr.B) * factor
    ) or Color3.new(
        clr.R * (1 - factor),
        clr.G * (1 - factor),
        clr.B * (1 - factor)
    )
end

function PointLight.new(parent)
    local newPointLight = {}

    newPointLight.Button = Instance.new("TextButton")
    newPointLight.Button.AnchorPoint = Vector2.new(.5, .5)
    newPointLight.Button.BackgroundTransparency = 1
    newPointLight.Button.Size = UDim2.fromOffset(25, 25)
    newPointLight.Button.Text = ""
    newPointLight.Button.AutoButtonColor = false
    newPointLight.Button.ZIndex = 3
    newPointLight.Button.Parent = parent

    newPointLight.Inner = Instance.new("Frame")
    newPointLight.Inner.Size = UDim2.fromScale(1, 1)
    newPointLight.Inner.ZIndex = 2
    corner(1, 0).Parent = newPointLight.Inner
    newPointLight.Inner.Parent = newPointLight.Button

    return setmetatable(newPointLight, PointLight)
end

function PointLight:color(color)
    color = self.Click and auto(color, .5) or color
    self.Inner.BackgroundColor3 = color
end

return PointLight