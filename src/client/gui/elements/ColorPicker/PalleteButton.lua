local TS = game:GetService("TweenService")

local core = require(script.Parent.Parent)

local element = core.roact.Component:extend("ColorPalleteButton")

function element:render()
    return core.roact.createElement("ImageButton", {
        AnchorPoint = self.props.AnchorPoint or Vector2.new(.5, .5),
        BackgroundTransparency = 1,
        Position = self.props.Position or UDim2.new(),
        Size = core.scale.udim2.fromOffset(35, 40),
        LayoutOrder = self.props.LayoutOrder or 0,
        ZIndex = (self.props.ZIndex or 1),
        Image = "rbxassetid://6674511441",
        ImageColor3 = self.props.ImageColor3,
        [core.roact.Ref] = core.cloneRef(self.props[core.roact.Ref], function(rbx) self.Button = rbx end)
    }, {
        ['Highlight_Outer'] = core.roact.createElement("ImageLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            ZIndex = (self.props.ZIndex or 1) + 1,
            Image = "rbxassetid://6675134875",
            ImageColor3 = Color3.new(0, 0.5, 1),
            ImageTransparency = 1,
            [core.roact.Ref] = function(rbx) self.Outer = rbx end
        }),
        ['Highlight_Inner'] = core.roact.createElement("ImageLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            ZIndex = (self.props.ZIndex or 1) + 1,
            Image = "rbxassetid://6675135931",
            ImageColor3 = Color3.new(1, 1, 1),
            ImageTransparency = 1,
            [core.roact.Ref] = function(rbx) self.Inner = rbx end
        })
    })
end

function element:didMount()
    local tweenShowInfo = TweenInfo.new(.05, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
    local tweenHideInfo = TweenInfo.new(.05, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

    local tweensShow = {
        TS:Create(self.Outer, tweenShowInfo, { ImageTransparency = 0 }),
        TS:Create(self.Inner, tweenShowInfo, { ImageTransparency = 0 })
    }
    local tweensHide = {
        TS:Create(self.Outer, tweenShowInfo, { ImageTransparency = 1 }),
        TS:Create(self.Inner, tweenShowInfo, { ImageTransparency = 1 })
    }

    self.Button.MouseEnter:Connect(function()
        for _, tween in ipairs(tweensShow) do
            tween:Play()
        end
    end)

    self.Button.MouseLeave:Connect(function()
        for _, tween in ipairs(tweensHide) do
            tween:Play()
        end
    end)
end

return element