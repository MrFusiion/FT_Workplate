local core = require(script.Parent.Parent)

local line = {}
line.__index = line

function line.new(parent, dotStart, dotEnd, stroke, color)
    local newLine = setmetatable({}, line)
    newLine.Parent = parent
    newLine.Start = dotStart
    newLine.End = dotEnd
    newLine.Stroke = stroke
    newLine.Frame = nil
    newLine.Color = color
    newLine:init()
    return newLine
end

function line:init()

    if self.Frame then
        self.Frame:Destroy()
    end

    self.Frame = Instance.new("Frame")
    self.Frame.Name = "Line"
    self.Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.Frame.BackgroundColor3 = self.Color
    self.Frame.BorderSizePixel = 0
    self.Frame.ZIndex = self.Parent.ZIndex + 2
    self.Frame.Parent = self.Parent

    self:update()
end

--local viewportSize = workspace.CurrentCamera.ViewportSize
--local maxDist = math.floor((viewportSize.X/1920)+.5) * 700
local maxDist = core.scale:getOffset(900)
function line:update()
    local startX, startY = self.Start.X + self.Start.Size / 2, self.Start.Y + self.Start.Size / 2
    local endX, endY = self.End.X + self.End.Size / 2, self.End.Y + self.End.Size / 2
    local dist = (Vector2.new(startX, startY) - Vector2.new(endX, endY)).Magnitude
    self.Frame.BackgroundTransparency = (dist/maxDist)+.5

    if dist <= maxDist then
        self.Frame.Size = UDim2.new(0, dist, 0, core.scale:getOffset(self.Stroke))
        self.Frame.Position = UDim2.new(0, (startX + endX) / 2, 0, (startY + endY) / 2)
        self.Frame.Rotation = math.deg(math.atan2(endY - startY, endX - startX))
    end
end

function line:setColor(color)
    self.Frame.BackgroundColor3 = color
end

return line