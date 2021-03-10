local core = require(script.Parent)

local element = core.roact.Component:extend("__" .. script.Name .. "__")

function element:render()
    local children = self.props[core.roact.Children] or {}
    self.props[core.roact.Children] = nil
    children["Corner"] = core.roact.createElement(core.elements.UICorner)

    local contentColor = self.props.ContentColor3 or ColorSequence(Color3.fromRGB(0, 170, 0), Color3.fromRGB(85, 255, 0))
    contentColor = typeof(contentColor) == "Color3" and ColorSequence(self.props.contentColor) 

    return core.roact.createElement(core.elements.global:getConsumer(), {
        render = function(global)
            return core.roact.createElement("Frame", {
                AnchorPoint = self.props.AnchorPoint or Vector2.new(.5, .5),
                BackgroundColor3 = self.props.BackgroundColor3 or global.theme.BgClr,
                Position = self.props.Position,
                Size = self.props.Size or UDim2.new(0, core.scale:getOffset(200), 0, core.scale:getOffset(50))
            }, {
                ["Corner"] = core.roact.createElement(core.elements.UICorner),
                ['Content'] = core.roact.createElement("Frame", {
                    AnchorPoint = Vector2.new(0, .5),
                    Position = UDim2.new(0, core.scale:getOffset(-(self.BorderSize or 6) / 2), .5, 0),
                    Size = UDim2.new(self.props.Value, core.scale:getOffset(-(self.BorderSize or 6)), 1, core.scale:getOffset(-(self.BorderSize or 6)))
                }, {
                    ["Corner"] = core.roact.createElement(core.elements.UICorner),
                    ["Gradient"] = core.roact.createElement("Gradient", {
                        Color = contentColor
                    })
                })
            })
        end
    })
end

return element