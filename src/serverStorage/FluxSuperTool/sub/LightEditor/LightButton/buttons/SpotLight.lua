local SpotLight = {}
SpotLight.__index = SpotLight

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

function SpotLight.new(parent)
    local newSpotLight = {}

    newSpotLight.Button = Instance.new("TextButton")
    newSpotLight.Button.AnchorPoint = Vector2.new(.5, .5)
    newSpotLight.Button.BackgroundTransparency = 1
    newSpotLight.Button.Size = UDim2.fromOffset(25, 25)
    newSpotLight.Button.Text = ""
    newSpotLight.Button.AutoButtonColor = false
    newSpotLight.Button.ZIndex = 3
    newSpotLight.Button.Parent = parent

    newSpotLight.Inner = Instance.new("Frame")
    newSpotLight.Inner.Size = UDim2.fromScale(1, 1)
    newSpotLight.Inner.ZIndex = 2
    corner(1, 0).Parent = newSpotLight.Inner
    newSpotLight.Inner.Parent = newSpotLight.Button

    newSpotLight.InnerBottom = Instance.new("Frame")
    newSpotLight.InnerBottom.AnchorPoint = Vector2.new(.5, 1)
    newSpotLight.InnerBottom.Position = UDim2.fromScale(.5, 1)
    newSpotLight.InnerBottom.Size = UDim2.fromScale(1, .6)
    newSpotLight.InnerBottom.ZIndex = 2
    corner(0, 10).Parent = newSpotLight.InnerBottom
    newSpotLight.InnerBottom.Parent = newSpotLight.Button

    return setmetatable(newSpotLight, SpotLight)
end

function SpotLight:color(color)
    color = self.Click and auto(color, .5) or color
    self.Inner.BackgroundColor3 = color
    self.InnerBottom.BackgroundColor3 = color
end

return SpotLight