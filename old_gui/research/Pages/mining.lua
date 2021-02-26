local core = require(script.Parent.Parent.Parent)
local node = require(script.Parent.Parent:WaitForChild("node"))

return core.roact.createElement(core.theme:getConsumer(), {
    render = function(theme)
        return core.roact.createElement("Frame", {
            AnchorPoint = Vector2.new(.5, .5),
            BackgroundTransparency = 1,
            Position = UDim2.new(.5, 0, .5, 0),
            Size = UDim2.new(1, 0, 1, 0)
        }, {
            Node = core.roact.createElement(node, {
                Position = UDim2.new(0, core.scale:getOffset(200), 0, core.scale:getOffset(200)),
                BackgroundColor3 = theme.ClrRed,
                ZIndex = 4,
                Locked = false,
                Bought = true,
            }),
            Node_Unlocked = core.roact.createElement(node, {
                Position = UDim2.new(0, core.scale:getOffset(400), 0, core.scale:getOffset(200)),
                BackgroundColor3 = theme.ClrRed,
                ZIndex = 4,
                Locked = false,
            }),
            Node_Locked = core.roact.createElement(node, {
                Position = UDim2.new(0, core.scale:getOffset(600), 0, core.scale:getOffset(200)),
                BackgroundColor3 = theme.ClrRed,
                ZIndex = 4
            })
        })
    end
})