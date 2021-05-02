local core = require(script.Parent.Parent.Parent)

local element = core.roact.Component:extend("MessageBox_Confirm")

function element:init()
    self:setState{
        visible = false,
        title = "confirm"
    }
end

function element:render()
    return core.roact.createElement(core.elements.global:getConsumer(), {
        render = function(global)
            return core.roact.createElement(core.elements.Window, {
                Size = core.scale.udim2.fromOffset(600, 400),
                Title = self.state.title,
                CloseEnabled = false,
                Visible = self.state.visible
            })
        end
    })
end

function element:didMount()
    
end

return element