local core = require(script.Parent)

local element = core.roact.Component:extend("__" .. script.Name .. "__")

function element:render()
    return core.roact.createElement('UICorner', {
        CornerRadius = UDim.new(0, core.scale:getOffset(10))
    }, self.props[core.roact.Children])
end

return element