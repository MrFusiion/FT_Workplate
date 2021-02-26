local core = require(script.Parent)

local element = core.roact.PureComponent:extend("__" .. script.Name .. "__")

function element:init()

end

function element:render()
    return core.roact.createElement(core.elements.global:getConsumer(), {
        render = function(global)
            local props = core.deepCopyTable(self.props)
            --////[props]////--
            --default values check
            props.ZIndex = props.ZIndex or 1

            --assigning
            props.AnchorPoint = props.AnchorPoint or Vector2.new(.5, .5)
            props.BackgroundColor3 = props.BackgroundColor3 or global.theme.BgClr
            props.BackgroundTransparency = props.BackgroundTransparency or 0
            props.BorderSizePixel = 0
            props.Size = props.Size or UDim2.new(0, core.scale:getOffset(200), 0, core.scale:getOffset(50))
            props.ZIndex = props.ZIndex + 1

            --////[children]////--
            local children = props[core.roact.Children]
            props[core.roact.Children] = nil

            children.Corner = core.roact.createElement(core.elements.UICorner)

            children.Shadow = core.roact.createElement("Frame", {
                BackgroundColor3 = core.color.shade(props.BackgroundColor3, .5),
                BackgroundTransparency = props.BackgroundTransparency,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0, core.scale:getOffset(5)),
                Size = UDim2.new(1, 0, 1, 0),
                ZIndex = props.ZIndex - 1
            }, {
                Corner = core.roact.createElement(core.elements.UICorner)
            })

            return core.roact.createElement("Frame", props, children)
        end
    })
end

return element