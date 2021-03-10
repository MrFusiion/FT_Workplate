local TS = game:GetService("TweenService")
local core = require(script.Parent.Parent.Parent)
local element = core.roact.Component:extend("BlueprintButton")

function element:init()
    self.Idle = Color3.fromRGB(2, 66, 135)
    self.Hover = Color3.fromRGB(164, 211, 255)
    self.Click = Color3.fromRGB(0, 45, 94)
end

function element:render()
    return core.roact.createElement("ImageButton", {
        BackgroundColor3 = self.Idle,
        AutoButtonColor = false,
        ZIndex = 5,
        Image = "",
        [core.roact.Ref] = core.cloneRef(self.props[core.roact.Ref], function(rbx)
            self.Button = rbx
        end)
    }, {
        ["Corner"] = core.roact.createElement(core.elements.UICorner),
        ["Frame"] = core.roact.createElement("Frame", {
            AnchorPoint = Vector2.new(.5, .5),
            BackgroundColor3 = Color3.fromRGB(12, 99, 199),
            ZIndex = 6,
            Position = UDim2.fromScale(.5, .5),
            Size = UDim2.new(1, core.scale:getOffset(-5), 1, core.scale:getOffset(-5))
        }, {
            ["Corner"] = core.roact.createElement(core.elements.UICorner),
            ["Name"] = core.roact.createElement("TextLabel", {
                AnchorPoint = Vector2.new(.5, 1),
                BackgroundColor3 = Color3.fromRGB(2, 66, 135),
                Position = UDim2.fromScale(.5, 1),
                Size = UDim2.new(1, 0, 0, core.scale:getOffset(70)),
                ZIndex = 7,
                Font = Enum.Font.SourceSansSemibold,
                Text = self.props.Name,
                TextColor3 = Color3.new(1, 1, 1),
                TextSize = core.scale:getTextSize(20),
                TextWrapped = true
            }, {
                ["Corner"] = core.roact.createElement(core.elements.UICorner)
            }),
            ["Background"] = core.roact.createElement("ImageLabel", {
                Size = UDim2.fromScale(1, 1),
                SizeConstraint = Enum.SizeConstraint.RelativeXX,
                ZIndex = 7,
                Image = "rbxassetid://6276549643",
                ScaleType = Enum.ScaleType.Fit
            }, {
                ["Corner"] = core.roact.createElement(core.elements.UICorner)
            }),
            ["Icon"] = core.roact.createElement("ImageLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                SizeConstraint = Enum.SizeConstraint.RelativeXX,
                ZIndex = 8,
                Image = self.props.Image or "rbxassetid://5456796819",
                [core.roact.Ref] = function(rbx) self.IconParent = rbx end
            })
        })
    })
end

function element:didMount()
    local hover = false
    self.Button.MouseEnter:Connect(function()
        TS:Create(self.Button, TweenInfo.new(.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            BackgroundColor3 = self.Hover
        }):Play()
        hover = true
    end)

    self.Button.MouseLeave:Connect(function()
        TS:Create(self.Button, TweenInfo.new(.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            BackgroundColor3 = self.Idle
        }):Play()
        hover = false
    end)

    self.Button.MouseButton1Down:Connect(function()
        TS:Create(self.Button, TweenInfo.new(.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            BackgroundColor3 = self.Click
        }):Play()
    end)

    self.Button.MouseButton1Up:Connect(function()
        if hover then
            TS:Create(self.Button, TweenInfo.new(.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                BackgroundColor3 = self.Hover
            }):Play()
        else
            TS:Create(self.Button, TweenInfo.new(.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                BackgroundColor3 = self.Idle
            }):Play()
        end
    end)
end

return element