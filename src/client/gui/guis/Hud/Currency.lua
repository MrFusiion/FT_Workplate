local TextS = game:GetService("TextService")

local core = require(script.Parent.Parent)
local playerUtils = core.client.get("playerUtils")

local element = core.roact.Component:extend("Currency")

function element:init()
    self:setState({
        cash = 0,
        cores = 0,
    })
end

function element:render()
    return core.roact.createElement("Frame", {
        AnchorPoint = Vector2.new(.5, 0),
        BackgroundTransparency = 1,
        Position = UDim2.new(.5, 0, 0, core.scale:getOffset(5)),
        Size = UDim2.new(0, core.scale:getOffset(300), 0, core.scale:getOffset(60))
    }, {
        --==========================/Cash/==========================--
        ["Cash"] = core.roact.createElement(core.elements.TextWithIcon, {
            Position = UDim2.new(.5, 0, .5, 0),
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 3,
            Text = core.subfix.addSubfix(self.state.cash),
            Font = Enum.Font.SourceSansBold,
            TextColor3 = Color3.fromRGB(57, 147, 0),
            TextSize = core.scale:getTextSize(50),
            Image = "rbxassetid://6276261087"
        }),
        --==========================/Cores/==========================--
        ["Merge"] = core.roact.createElement("Frame", {
            AnchorPoint = Vector2.new(.5, .5),
            BackgroundColor3 = Color3.fromRGB(139, 149, 255),
            BorderSizePixel = 0,
            Position = UDim2.fromScale(.5, 1),
            Size = UDim2.new(1, core.scale:getOffset(-50), 1, 0)
        }),
        ["Cores"] = core.roact.createElement(core.elements.TextWithIcon, {
            AnchorPoint = Vector2.new(.5, 0),
            BackgroundColor3 = Color3.fromRGB(139, 149, 255),
            Position = UDim2.new(.5, 0, 1, core.scale:getOffset(5)),
            Size = UDim2.new(1, core.scale:getOffset(-50), 1, core.scale:getOffset(-15)),
            Text = core.subfix.addSubfix(self.state.cores),
            Font = Enum.Font.SourceSansBold,
            TextColor3 = Color3.fromRGB(58, 62, 107),
            TextSize = core.scale:getTextSize(40),
            Image = "rbxassetid://5793838993"
            --IconSize = UDim2.new(1, core.scale:getOffset(-15), 1, core.scale:getOffset(-15))
        })
    })
end

function element:didMount()
    spawn(function()
        while not self.cashV do self.cashV = playerUtils.getStat("Cash") wait() end
        self.cashV:GetPropertyChangedSignal("Value"):Connect(function()
            pcall(function()
                self:setState({
                    cash = self.cashV.Value
                })
                self:updateValueFrameSize(self.CashValueFrame)
            end)
        end)

        while not self.coresV do self.coresV = playerUtils.getStat("Cores") wait() end
        self.coresV:GetPropertyChangedSignal("Value"):Connect(function()
            pcall(function()
                self:setState({
                    cores = self.coresV.Value
                })
                self:updateValueFrameSize(self.CoresValueFrame)
            end)
        end)

        self:setState({
            cash = self.cashV.Value,
            cores = self.coresV.Value
        })
    end)
end

return element