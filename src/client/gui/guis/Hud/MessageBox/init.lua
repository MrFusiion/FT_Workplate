local core = require(script.Parent.Parent)

local element = core.roact.Component:extend("MessageBox_Container")

function element:init()
    
end

function element:render()
    local frames = {}
    for _, module in ipairs(script:GetChildren()) do
        frames[module.Name] = core.roact.createElement(require(module))
    end

    return core.roact.createElement(core.elements.global:getConsumer(), {
        render = function(global)
            return core.roact.createElement("Frame", {
                AnchorPoint = core.anchor.c,
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(.5, .5),
                Size = UDim2.fromScale(1, 1)
            }, frames)
        end
    })
end

function element:didMount()
    
end

return element