local SurfaceLight = {}
SurfaceLight.__index = SurfaceLight

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

function SurfaceLight.new(parent)
    local newSurfaceLight = {}

    newSurfaceLight.Button = Instance.new("TextButton")
    newSurfaceLight.Button.AnchorPoint = Vector2.new(.5, .5)
    newSurfaceLight.Button.BackgroundTransparency = 1
    newSurfaceLight.Button.Size = UDim2.fromOffset(25, 25)
    newSurfaceLight.Button.Text = ""
    newSurfaceLight.Button.AutoButtonColor = false
    newSurfaceLight.Button.ZIndex = 3
    newSurfaceLight.Button.Parent = parent

    newSurfaceLight.Inner = Instance.new("Frame")
    newSurfaceLight.Inner.Size = UDim2.fromScale(1, 1)
    newSurfaceLight.Inner.ZIndex = 2
    corner(0, 8).Parent = newSurfaceLight.Inner
    newSurfaceLight.Inner.Parent = newSurfaceLight.Button

    return setmetatable(newSurfaceLight, SurfaceLight)
end

function SurfaceLight:color(color)
    color = self.Click and auto(color, .5) or color
    self.Inner.BackgroundColor3 = color
end

return SurfaceLight