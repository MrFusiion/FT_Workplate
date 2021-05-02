local DEFAULT_RES = Vector2.new(1920, 1080)

local UIS = game:GetService("UserInputService")
local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local scale = {}
scale.udim = {}
scale.udim2 = {}

function scale:get()
    local screenSize = game.Workspace.CurrentCamera.ViewportSize
    if UIS.TouchEnabled and playerGui.CurrentScreenOrientation
        == Enum.ScreenOrientation.Portrait then

        playerGui.ScreenOrientation = Enum.ScreenOrientation.LandscapeSensor
        screenSize = Vector2.new(screenSize.Y, screenSize.X)
    end
    return math.min(screenSize.X / DEFAULT_RES.X, screenSize.Y / DEFAULT_RES.Y)
end

function scale:getModifier()
    if UIS.TouchEnabled then
        return 1.3
    else
        return 1
    end
end

function scale:getOffset(offset)
    return math.floor(self:get() * offset + .5) * self:getModifier()
end

function scale:getTextSize(size)
    return math.floor(self:get() * size + .5) * self:getModifier()
end

function scale.udim.new(uScale, uOffset)
    return UDim.new(uScale, scale:getOffset(uOffset))
end

function scale.udim2.new(xScale, xOffset, yScale, yOffset)
    return UDim2.new(scale.udim.new(xScale, xOffset), scale.udim.new(yScale, yOffset))
end

function scale.udim2.formScale(xScale, yScale)
    return scale.udim2.new(xScale, 0, yScale, 0)
end

function scale.udim2.fromOffset(xOffset, yOffset)
    return scale.udim2.new(0, xOffset, 0, yOffset)
end

return scale