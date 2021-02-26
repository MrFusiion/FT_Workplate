local core = require(script.Parent)
local dot = require(script:WaitForChild("dot"))

local lines = core.roact.Component:extend("Lines")

function lines:init()
    self.Running = true
    self.FrameRef = function(rbx) self.Frame = rbx end
end

function lines:render()
    return core.roact.createElement(core.theme:getConsumer(), {
        render = function(theme)
            return core.roact.createElement("ScreenGui", {
                Name = "Hud",
                IgnoreGuiInset = true,
                ResetOnSpawn = false,
                ZIndexBehavior = 'Global',
                Enabled = false
            }, {
                Frame = core.roact.createElement("Frame", {
                    AnchorPoint = Vector2.new(.5, .5),
                    BackgroundColor3 = theme.BgClr,
                    BorderSizePixel = 0,
                    Position = UDim2.new(.5, 0, .5, 0),
                    Size = UDim2.new(.8, 0, .8, 0),
                    [core.roact.Ref] = self.FrameRef
                })
            })
        end
    })
end

local dotAmount = 20
function lines:didMount()
    --[[
    local dots = {}
    for i=1,dotAmount,1 do
        dots[i] = dot.new(self.Frame, core.scale:getOffset(10))
    end

    spawn(function()
        while self.Running do
            wait()
            --render
            for _, d in pairs(dots) do
                d:render()
            end

            --draw lines
            for i=1,#dots,1 do
                for j=i,#dots,1 do
                    dots[i]:drawLine(dots[j])
                end
            end
        end
    end)]]
end

function lines:willUnmount()
    self.Running = false
end

return lines