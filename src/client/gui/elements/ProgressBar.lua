local core = require(script.Parent)

local element = core.roact.Component:extend("__" .. script.Name .. "__")

local COLORS = {
    { range = { min =  0, max = .2 },  color = ColorSequence.new(Color3.fromRGB(170,  0,   0), Color3.fromRGB(255,   0, 0)) },
    { range = { min = .2, max = .3 },  color = ColorSequence.new(Color3.fromRGB(200,  90, 40), Color3.fromRGB(255,  80, 0)) },
    { range = { min = .3, max = .4 },  color = ColorSequence.new(Color3.fromRGB(170, 170,  0), Color3.fromRGB(255, 255, 0)) },
    { range = { min = .4, max =  1 },  color = ColorSequence.new(Color3.fromRGB(  0, 170,  0), Color3.fromRGB( 85, 255, 0)) },
}

local function getColor(value)
    value = math.clamp(value, 0, 1)
    for _, v in pairs(COLORS) do
        if v.range.min <= value and v.range.max >= value then
            return v.color
        end
    end
end

function element:render()
    local children = self.props[core.roact.Children] or {}
    self.props[core.roact.Children] = nil
    children["Corner"] = core.roact.createElement(core.elements.UICorner)

    local contentColor = self.props.ContentColor3 or getColor(self.props.Value)
    contentColor = typeof(contentColor) == "Color3" and ColorSequence.new(contentColor) or contentColor

    local value = math.clamp(self.props.Value, 0, 1)

    return core.roact.createElement(core.elements.global:getConsumer(), {
        render = function(global)
            return core.roact.createElement("Frame", {
                AnchorPoint = self.props.AnchorPoint or Vector2.new(.5, .5),
                BackgroundColor3 = self.props.BackgroundColor3 or global.theme.BgClr,
                Position = self.props.Position,
                Size = self.props.Size or UDim2.new(0, core.scale:getOffset(200), 0, core.scale:getOffset(50))
            }, {
                ["Corner"] = core.roact.createElement(core.elements.UICorner),
                ['Mask'] = core.roact.createElement("Frame", {
                    AnchorPoint = Vector2.new(0, .5),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, core.scale:getOffset((self.BorderSize or 6) / 2), .5, 0),
                    Size = UDim2.new(value, -core.scale:getOffset((self.BorderSize or 6)), 1, -core.scale:getOffset((self.BorderSize or 6))),
                    ClipsDescendants = true
                }, {
                    ['Content'] = core.roact.createElement("Frame", {
                        AnchorPoint = Vector2.new(0, .5),
                        Position = UDim2.fromScale(0, .5),
                        Size = UDim2.new(1 / value, 0, 1, 0)
                    }, {
                        ["Corner"] = core.roact.createElement(core.elements.UICorner),
                        ["Gradient"] = core.roact.createElement("UIGradient", {
                            Color = contentColor
                        })
                    })
                }),
                ['Label'] = core.roact.createElement("TextLabel", {
                    AnchorPoint = Vector2.new(.5, .5),
                    BackgroundTransparency = 1,
                    Position = UDim2.fromScale(.5, .5),
                    Size = UDim2.fromScale(1, 1),
                    Font = self.props.Font or Enum.Font.SourceSans,
                    Text = self.props.Text or string.format("%.2f%%", self.props.Value * 100),
                    TextSize = self.props.TextSize,
                    TextColor3 = self.props.TextColor3 or global.theme.TextClr
                })
            })
        end
    })
end

return element