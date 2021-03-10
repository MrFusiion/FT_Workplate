local core = require(script.Parent)

local DFLT_BG_IMAGE = "rbxassetid://6093172294"

local element = core.roact.PureComponent:extend("__" .. script.Name .. "__")

function element:render()
    local close = self.props.CloseEnabled == nil or self.props.CloseEnabled

    local children = self.props[core.roact.Children] or {}
    self.props[core.roact.Children] = nil
    children["Corner"] = core.roact.createElement(core.elements.UICorner)

    return core.roact.createElement(core.elements.global:getConsumer(), {
        render = function(global)
            return core.roact.createElement("Frame", {
                AnchorPoint = self.props.AnchorPoint or Vector2.new(.5, .5),
                BackgroundTransparency = 1,
                Position = self.props.Position or UDim2.fromScale(.5, .5),
                Size = self.props.Size,
                Visible = self.props.Visible,
                ZIndex = self.props.ZIndex,
                [core.roact.Ref] = function(rbx) self.Frame = rbx end
            }, {
                ["Topbar"] = core.roact.createElement("Frame", {
                    BackgroundColor3 = self.props.BorderColor or global.theme.BgClr,
                    Size = UDim2.new(close and .333 or 1, 0, 0, self.BarSize or core.scale:getOffset(60)),
                    ZIndex = self.props.ZIndex
                }, {
                    ["Corner"] = core.roact.createElement(core.elements.UICorner),
                    ["Merge"] = core.roact.createElement("Frame", {
                        AnchorPoint = Vector2.new(.5, .5),
                        BackgroundColor3 = self.props.BorderColor or global.theme.BgClr,
                        BorderSizePixel = 0,
                        Position = UDim2.fromScale(.5, 1),
                        Size = UDim2.fromScale(1, 1),
                        ZIndex = self.props.ZIndex
                    }),
                    ["Title"] = core.roact.createElement("TextLabel", {
                        BackgroundTransparency = 1,
                        Size = close and
                        UDim2.new(1, -(self.BarSize or core.scale:getOffset(60)), 1, 0) or
                        UDim2.fromScale(1, 1),
                        ZIndex = (self.props.ZIndex or 1) + 1,
                        Font = self.props.Font or global.theme.Font,
                        Text = self.props.Title or "",
                        TextColor3 = self.props.TextColor3 or global.theme.TextClr,
                        TextSize = self.props.TextSize or core.scale:getTextSize(50)
                    }),
                    ["Close"] = close and
                    core.roact.createElement("ImageButton", {
                        AnchorPoint = Vector2.new(1, 0),
                        BackgroundColor3 = global.theme.ExitBgClr,
                        Position = UDim2.fromScale(1, 0),
                        Size = UDim2.fromScale(1, 1),
                        SizeConstraint = Enum.SizeConstraint.RelativeYY,
                        ZIndex = (self.props.ZIndex or 1) + 1,
                        Image = "rbxassetid://6299709738",
                        ImageColor3 = global.theme.ExitTextClr,
                        [core.roact.Ref] = function(rbx) self.ExitButton = rbx end
                    }, {
                        ["Corner"] = core.roact.createElement(core.elements.UICorner)
                    }) or nil
                }),
                ["Body"] = core.roact.createElement(core.elements.Frame, {
                    AnchorPoint = Vector2.new(0, 1),
                    BackgroundColor3 = self.props.BorderColor or global.theme.BgClr,
                    Position = UDim2.fromScale(0, 1),
                    Size = UDim2.new(1, 0, 1, -(self.BarSize or core.scale:getOffset(60))),
                    ZIndex = self.props.ZIndex
                }, {
                    ["Inner"] = core.roact.createElement("Frame", {
                        AnchorPoint = Vector2.new(.5, .5),
                        BackgroundColor3 = self.props.BackgroundColor3 or core.color.tint(global.theme.BgClr, .1),
                        Size = UDim2.new(1, -(self.props.BorderWidth or core.scale:getOffset(25)), 1, -(self.props.BorderWidth or core.scale:getOffset(25))),
                        Position = UDim2.fromScale(.5, .5),
                        ZIndex = (self.props.ZIndex or 1) + 2
                    }, children)
                })
            })
        end
    })
end

function element:didMount()
    if self.ExitButton then
        self.ExitButton.Activated:Connect(function()
            self.Frame.Visible = false
        end)
    end
end

return element