local core = require(script.Parent.Parent)

local buttons = require(script:WaitForChild('Buttons'))
local SideButton = require(script:WaitForChild('SideButton'))

local element = core.roact.Component:extend('SideButtons')

function element:init()
    
end

function element:render()
    local padding = core.scale:getOffset(10)
    local sizeX = (core.scale:getOffset(80) + padding) * #buttons - padding + core.scale:getOffset(5)

    local children = {
        Layout = core.roact.createElement('UIListLayout', {
            Padding = UDim.new(0, padding),
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder
        })
    }
    
    for order, props in ipairs(buttons) do
        props.Order = order
        children[props.Name] = core.roact.createElement(SideButton, props)
    end

    return core.roact.createElement('Frame', {
        AnchorPoint = Vector2.new(0, .5),
        BackgroundTransparency = 1,
        Position = UDim2.new(0, core.scale:getOffset(5), .5, 0),
        Size = UDim2.new(0, core.scale:getOffset(80), 0, sizeX)
    }, children)
end

function element:didMount()
    
end

return element