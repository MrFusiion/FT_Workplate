return function()
    local surface = Instance.new('SurfaceGui')
    surface.Face = Enum.NormalId.Top
    surface.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud

    local parent = Instance.new('Frame')
    parent.BackgroundTransparency = 1
    parent.AnchorPoint = Vector2.new(.5, .5)
    parent.Position = UDim2.new(.5, 0, .5, 0)
    parent.Size = UDim2.new(.9, 0, .9, 0)
    parent.Parent = surface

    for i, anchor in ipairs({ Vector2.new(0, 0), Vector2.new(1, 0),
            Vector2.new(1, 1), Vector2.new(0, 1) }) do
        local frame = Instance.new('Frame')
        frame.BackgroundTransparency = 1
        frame.Size = UDim2.new(.3, 0, .3, 0)
        frame.Position = UDim2.new(anchor.x, 0, anchor.y, 0)
        frame.AnchorPoint = anchor
        frame.Rotation = (i - 1) * 90
        frame.Parent = parent

        local f1 = Instance.new('Frame')
        f1.BorderSizePixel = 0
        f1.BackgroundColor3 = Color3.new(1, 1, 1)
        f1.Size = UDim2.new(1, 0, 0, 100)
        f1.Parent = frame

        local f2 = Instance.new('Frame')
        f2.BorderSizePixel = 0
        f2.BackgroundColor3 = Color3.new(1, 1, 1)
        f2.Size = UDim2.new(0, 100, 1, 0)
        f2.Parent = frame
    end

    local f1 = Instance.new('Frame')
    f1.BorderSizePixel = 0
    f1.BackgroundColor3 = Color3.new(1, 1, 1)
    f1.AnchorPoint = Vector2.new(.5, .5)
    f1.Position = UDim2.new(.5, 0, .5, 0)
    f1.Size = UDim2.new(0, 100, .4, 0)
    f1.Parent = parent

    local f2 = Instance.new('Frame')
    f2.BorderSizePixel = 0
    f2.BackgroundColor3 = Color3.new(1, 1, 1)
    f2.AnchorPoint = Vector2.new(.5, .5)
    f2.Position = UDim2.new(.5, 0, .5, 0)
    f2.Size = UDim2.new(.4, 0, 0, 100)
    f2.Parent = parent

    return surface
end