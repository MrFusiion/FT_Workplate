local DEFAULT_RES = Vector2.new(1920, 1080)

local UIS = game:GetService("UserInputService")
local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local scale = {}

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

return scale