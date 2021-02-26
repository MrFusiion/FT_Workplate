local core = require(script.Parent.Parent)
local line = require(script.Parent:WaitForChild("line"))

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
local random = modules.get("random").new()

local dot = {}
dot.__index = dot

--local viewportSize = workspace.CurrentCamera.ViewportSize
--local speed = math.floor(((viewportSize.X * viewportSize.Y)/(1920*1080))*8+.5)
local speed = 150
function dot.new(parent, size, theme, color)
    local newDot = setmetatable({}, dot)
    newDot.Parent = parent
    newDot.Vx = random:choice({-speed, speed})
    newDot.Vy = random:choice({-speed, speed})
    newDot.X = random:nextInt(0, parent.AbsoluteSize.X)
    newDot.Y = random:nextInt(0, parent.AbsoluteSize.Y)
    newDot.Size = size
    newDot.Frame = nil
    newDot.Lines = {}
    newDot.LinesCount = 0
    newDot.Theme = theme
    newDot.Color = color
    newDot:init()
    return newDot
end

function dot:init()

    if self.Frame then
        self.Frame:Destroy()
    end

    self.Frame = Instance.new("Frame")
    self.Frame.Name = "Dot"
    self.Frame.Position = UDim2.new(0, self.X, 0, self.Y)
    self.Frame.Size = UDim2.new(0, self.Size, 0, self.Size)
    self.Frame.BackgroundColor3 = core.color.getLuma(self.Theme.TextClr) < .5 and core.color.tint(self.Theme.TextClr, .25) or
                                    core.color.shade(self.Theme.TextClr, .1)
    self.Frame.BackgroundTransparency = .25
    self.Frame.ZIndex = self.Parent.ZIndex + 2
    self.Frame.Parent = self.Parent

    --UICorner
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(1, 0)
    Corner.Parent = self.Frame
end

function dot:update(t)
    self:applyVelocity(t)
    --self.Frame:TweenPosition(UDim2.new(0, self.X, 0, self.Y), "InOut", "Sine", .1, true)
    self.Frame.Position = UDim2.new(0, self.X, 0, self.Y)
end

function dot:applyVelocity(t)
    self.X = math.clamp(self.X + self.Vx * t, 0, self.Parent.AbsoluteSize.X - self.Size) 
    self.Y = math.clamp(self.Y + self.Vy * t, 0, self.Parent.AbsoluteSize.Y - self.Size)

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

    if self.Frame then
        self.Frame.BackgroundColor3 = core.color.getLuma(self.Theme.TextClr) < .5 and core.color.tint(self.Theme.TextClr, .25) or
            core.color.shade(self.Theme.TextClr, .1)
    end
end

function dot:setColor(color)
    if next(self.Lines) then
        for _, l in ipairs(self.Lines) do
            l:setColor(color)
        end
    end
end

function dot:addLine(l)
    table.insert(self.Lines, l)
    self.LinesCount += 1
end

function dot:initLines(start, dots, dotsCount)
    for i=start, dotsCount do
        local l = line.new(self.Parent, self, dots[i], 4, self.Color)
        self:addLine(l)
        dots[i]:addLine(l)
    end
end

function dot:updateLines(start)
    for i=start or 1, self.LinesCount do
        self.Lines[i]:update()
    end
end

return dot