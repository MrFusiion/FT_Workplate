local core = require(script.Parent.Parent)

local mechanicHud = core.roact.Component:extend("mechanic_hud")

function mechanicHud:render()
    local subFrames = {}
    for _, module in ipairs(script:GetChildren()) do
        if module:IsA("ModuleScript") then
            subFrames[module.Name] = core.roact.createElement(require(module))
        end
    end
    return core.roact.createElement("Frame", {
        AnchorPoint = Vector2.new(.5, .5),
        BackgroundTransparency = 1,
        Position = UDim2.fromScale(.5, .5),
        Size = UDim2.fromScale(1, 1)
    }, subFrames)
end

return mechanicHud