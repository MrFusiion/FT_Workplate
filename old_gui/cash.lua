local core = require(script.Parent.Parent)

local element = core.roact.Component:extend("Cash")

function element:init()
    self.cashV = game:GetService("Players").LocalPlayer
        :WaitForChild("leaderstats"):WaitForChild("Cash")
    self:setState({
        cash = self.cashV.Value
    })
end

function element:render()
    return core.roact.createElement(core.elements.Frame, {
        AnchorPoint = Vector2.new(.5, 0),
        Position = UDim2.new(.5, 0, 0, core.scale:getOffset(5)),
        Size = UDim2.new(0, core.scale:getOffset(300), 0, core.scale:getOffset(60)),
    }, {
        text = core.roact.createElement("TextLabel", {
            AnchorPoint = Vector2.new(.5, .5),
            BackgroundTransparency = 1,
            ZIndex = 3,
            Position = UDim2.new(.5, 0, .5, 0),
            Size = UDim2.new(1, 0, 1, 0),
            Text = '$ '..core.subfix.addSubfix(self.state.cash),
            Font = Enum.Font.SourceSansSemibold,
            TextColor3 = Color3.fromRGB(3, 153, 15),
            TextSize = core.scale:getTextSize(50)
        }, {
            
        })
    })
end

function element:shouldUpdate(_, state)
    return self.state.cash ~= state.cash
end

function element:didMount()
    self.cashV:GetPropertyChangedSignal("Value"):Connect(function(value)
        self:setState({
            cash = self.cashV.Value
        })
    end)
end

return element
