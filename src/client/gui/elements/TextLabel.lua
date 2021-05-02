local core = require(script.Parent)

local element = core.roact.PureComponent:extend("__" .. script.Name .. "__")

function element:render()
    return core.roact.createElement(core.elements.global:getConsumer(), {
        render = function(global)
            local props = core.shallowCopyTable(self.props)

            --apply dflt props
            props.BackgroundColor3 = props.BackgroundColor3 or global.theme.BgClr
            props.TextColor3 = props.TextColor3 or global.theme.TextClr
            props.Font = props.Font or global.theme.Font
            props.ZIndex = (props.ZIndex or 1) + 1

            --////[children]////--
            local children = props[core.roact.Children] or {}
            props[core.roact.Children] = nil

            children.Corner = core.roact.createElement(core.elements.UICorner)

            children.Shadow = core.roact.createElement("Frame", {
                BackgroundColor3 = core.color.shade(props.BackgroundColor3, .5),
                Position = UDim2.new(0, 0, 0, core.scale:getOffset(5)),
                Size = UDim2.new(1, 0, 1, 0),
                ZIndex = props.ZIndex - 1
            }, {
                Corner = core.roact.createElement(core.elements.UICorner)
            })

            return core.roact.createElement(script.Name, props, children)
        end
    })
end

return element