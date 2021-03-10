local core = require(script.Parent.Parent)

local element = core.roact.Component:extend("VacuumProgress")

function element:init()
    self:setState({
        value = 0,
        name = "",
        color = Color3.new(),
        visible = false
    })
end

function element:render()
    return core.roact.createElement("Frame", {
        AnchorPoint = Vector2.new(.5, .8),
        BackgroundTransparency = 1,
        Position = UDim2.fromScale(.5, .8),
        Size = UDim2.fromOffset(core.scale:getOffset(400), core.scale:getOffset(100)),
        Visible = false
    }, {
        ["Progress"] = core.roact.createElement(core.elements.ProgressBar, {
            AnchorPoint = Vector2.new(.5, 1),
            Position = UDim2.fromScale(.5, 1),
            Size = UDim2.new(1, 0, 0, core.scale:getOffset(40)),
            Value = self.state.value
        }),
        ["ResourceName"] = core.roact.createElement("TextLabel", {
            AnchorPoint = Vector2.new(.5, 0),
            BackgroundTransparency = 1,
            Position = UDim2.fromScale(.5, 0),
            Size = UDim2.new(1, 0, 0, core.scale:getOffset(50)),
            Font = Enum.Font.SourceSansSemibold,
            TextSize = core.scale:getTextSize(50),
            TextStrokeTransparency = 0,
            TextStrokeColor3 = Color3.new(.28, .28, .28)
        })
    })
end

function element:didMount()
    local remoteVacuum = game:GetService("ReplicatedStorage"):WaitForChild("remote"):WaitForChild("vacuum")
    local re_TargetDetails = remoteVacuum:WaitForChild("TargetDetails")

    re_TargetDetails.OnClientEvent:Connect(function(name, color, health, maxHealth)
        if not name then
            self:setState({
                visible = false
            })
        else
            self:setState({
                value = health / maxHealth,
                name = name,
                color = color,
                visible = true
            })
        end
    end)
end

return element