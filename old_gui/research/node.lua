local core = require(script.Parent.Parent)

local node = core.roact.Component:extend("Node")

function node:init()
    self:setState({
        Bought = false,
        Unlocked = false
    })
end

function node:render()
    return core.roact.createElement(core.theme:getConsumer(), {
        render = function(theme)
            return core.roact.createElement("Frame", {
                AnchorPoint = Vector2.new(.5, .5),
                BackgroundColor3 = self.props.BackgroundColor3,
                BorderSizePixel = 0,
                Position = self.props.Position,
                Size = UDim2.new(0, core.scale:getOffset(150), 0, core.scale:getOffset(150)),
                ZIndex = self.props.ZIndex or 1
            }, {
                ImageItem = core.roact.createElement("ImageLabel", {
                    AnchorPoint = Vector2.new(.5, .5),
                    BackgroundColor3 = core.color.shade(self.props.BackgroundColor3, .25),
                    BorderSizePixel = 0,
                    Position = UDim2.new(.5, 0, .5, 0),
                    Size = UDim2.new(1, core.scale:getOffset(-10), 1, core.scale:getOffset(-10)),
                    ZIndex = (self.props.ZIndex or 1) + 1,
                    Image = "rbxassetid://6111596826"
                }, {
                    Corner = core.roact.createElement(core.elements.UICorner)
                }),
                Shade = core.roact.createElement("Frame", {
                    AnchorPoint = Vector2.new(.5, .5),
                    BackgroundColor3 = Color3.new(),
                    BackgroundTransparency = self.props.Bought and 1 or .75,
                    BorderSizePixel = 0,
                    Position = UDim2.new(.5, 0, .5, 0),
                    Size = UDim2.new(1, 0, 1, 0),
                    ZIndex = (self.props.ZIndex or 1) + 2,
                }, {
                    Corner = core.roact.createElement(core.elements.UICorner)
                }),
                Slot = core.roact.createElement("ImageLabel", {
                    AnchorPoint = Vector2.new(.5, .5),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Position = UDim2.new(.5, 0, .5, 0),
                    Size = UDim2.new(1, core.scale:getOffset(-30), 1, core.scale:getOffset(-30)),
                    ZIndex = (self.props.ZIndex or 1) + 3,
                    Image = "rbxassetid://6111611576",
                    ImageTransparency = (self.props.Locked==nil or self.props.Locked) and 0 or 1,
                    ImageColor3 = Color3.new(.15, .15, .15)
                }),
                Corner = core.roact.createElement(core.elements.UICorner)
            })
        end
    })
end

function node:didMount()
    
end

return node