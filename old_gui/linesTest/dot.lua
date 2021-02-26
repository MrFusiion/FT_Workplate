local core = require(script.Parent.Parent)

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
local random = modules.get("random").new()

local dot = {}
dot.__index = dot

local speed = 1
function dot.new(parent, size)
    local newDot = setmetatable({}, dot)
    newDot.Parent = parent
    newDot.Vx = random:nextNumber(-speed, speed)
    newDot.Vy = random:nextNumber(-speed, speed)
    newDot.X = random:nextInt(0, parent.AbsoluteSize.X)
    newDot.Y = random:nextInt(0, parent.AbsoluteSize.Y)
    newDot.Size = size
    newDot.Frame = nil
    newDot.Line = nil
    return newDot
end

function dot:render()
    self:applyVelocity()

    if self.Frame then
        self.Frame:Destroy()
    end

    --Frame
    self.Frame = Instance.new("Frame")
    self.Frame.Name = "Dot"
    self.Frame.Position = UDim2.new(0, self.X, 0, self.Y)
    self.Frame.Size = UDim2.new(0, self.Size, 0, self.Size)
    self.Frame.BackgroundColor3 = Color3.new(1, 0, 1)
    self.Frame.ZIndex = self.Parent.ZIndex
    self.Frame.Parent = self.Parent

    --UICorner
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(1, 0)
    Corner.Parent = self.Frame
end

function dot:applyVelocity()
    self.X = math.clamp(self.X + self.Vx, 0, self.Parent.AbsoluteSize.X - self.Size) 
    self.Y = math.clamp(self.Y + self.Vy, 0, self.Parent.AbsoluteSize.Y - self.Size)

    if self.X == 0 then
        self.Vx = -self.Vx
    elseif self.X == self.Parent.AbsoluteSize.X - self.Size then
        self.Vx = -self.Vx
    end

    if self.Y == 0 then
        self.Vy = -self.Vy
    elseif self.Y == self.Parent.AbsoluteSize.Y - self.Size then
        self.Vy = -self.Vy
    end
end

function dot:setTheme(theme)
    self.Theme = theme
    self:render()
end

function dot:drawLine(other)

    if self.Line then
        self.Line:Destroy()
    end

    self.Line = Instance.new("Frame")
    self.Line.BackgroundColor3 = Color3.new(0, 1, 0)
    self.Line.BorderSizePixel = 0
    self.Line.ZIndex = self.Frame.ZIndex

	local startX, startY = self.X + self.Size / 2, self.Y + self.Size / 2
	local endX, endY = other.X + other.Size / 2, other.Y + self.Size / 2
	local startVector = Vector2.new(startX, startY)
	local endVector = Vector2.new(endX, endY)
	local dist = (startVector - endVector).Magnitude
	self.Line.AnchorPoint = Vector2.new(0.5, 0.5)
	self.Line.Size = UDim2.new(0, dist, 0, core.scale:getOffset(2))
	self.Line.Position = UDim2.new(0, (startX + endX) / 2, 0, (startY + endY) / 2)
    self.Line.Rotation = math.deg(math.atan2(endY - startY, endX - startX))
    self.Line.Parent = self.Parent
end

return dot