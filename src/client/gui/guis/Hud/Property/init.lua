local core = require(script.Parent.Parent)
local platform = core.client.get('platform')

local element = core.roact.Component:extend('Property')

function element:init()
    self:setState({
        mode = 'Claim',
        price = 5e5
    })
end

function element:render()
    return core.roact.createElement(core.elements.global:getConsumer(), {
        render = function(global)
            return core.roact.createElement('Frame', {
                AnchorPoint = Vector2.new(.5, .5),
                BackgroundTransparency = 1,
                Position = UDim2.new(.5, 0, .5, 0),
                Size = UDim2.new(0, core.scale:getOffset(1000), 0, core.scale:getOffset(800)),
                Visible = false,
                [core.roact.Ref] = function(rbx) self.Frame = rbx end
            }, {
                ['Buttons'] = core.roact.createElement('Frame', {
                    AnchorPoint = Vector2.new(.5, 1),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(.5, 0, 1, 0),
                    Size = UDim2.new(0, core.scale:getOffset(400), 0, core.scale:getOffset(140))
                }, {
                    ['Left'] = core.roact.createElement(core.elements.TextButton, {
                        Size = UDim2.fromOffset(core.scale:getOffset(60), core.scale:getOffset(80)),
                        Visible = self.state.mode == 'Buy' or self.state.mode == 'Claim' or global.platform == 'CONSOLE',
                        Text = '<',
                        TextSize = core.scale:getTextSize(50),
                        [core.roact.Ref] = function(rbx) self.LeftButton = rbx end
                    }, {
                        ['ConsoleButton'] = core.roact.createElement('ImageLabel', {
                            AnchorPoint = Vector2.new(1, .5),
                            BackgroundTransparency = 1,
                            Position = UDim2.fromScale(0, .5),
                            Size = UDim2.fromScale(.6, .6),
                            SizeConstraint = Enum.SizeConstraint.RelativeYY,
                            Visible = global.platform == 'CONSOLE',
                            ZIndex = 4,
                            Image = platform.getConsoleImage(Enum.KeyCode.DPadLeft),
                        })
                    }),
                    ['Confirm'] = core.roact.createElement(core.elements.TextButton, {
                        AnchorPoint = Vector2.new(.5, 0),
                        Position = UDim2.fromScale(.5, 0),
                        Size = UDim2.fromOffset(core.scale:getOffset(260), core.scale:getOffset(80)),
                        AutoButtonColor = self.state.mode == 'Claim' or self.state.mode == 'Buy' or global.platform == 'CONSOLE',
                        Active = self.state.mode == 'Claim' or self.state.mode == 'Buy' or global.platform == 'CONSOLE',
                        Text = self.state.mode == 'Claim' and 'Claim' or '',
                        --TextColor3 = (self.state.mode == 'Buy' or self.state.mode == 'Expand') and Color3.fromRGB(57, 147, 0) or nil,
                        TextSize = core.scale:getTextSize(50),
                        [core.roact.Ref] = function(rbx) self.ConfirmButton = rbx end,
                    }, {
                        ['Cash'] = core.roact.createElement(core.elements.TextWithIcon, {
                            BackgroundTransparency = 1,
                            Position = UDim2.new(.5, 0, .5, 0),
                            Size = UDim2.new(1, 0, 1, 0),
                            ZIndex = 2,
                            Visible = self.state.mode == 'Buy' or self.state.mode == 'Expand',
                            Text = core.subfix.addSubfix(self.state.price),
                            Font = Enum.Font.SourceSansBold,
                            TextColor3 = Color3.fromRGB(57, 147, 0),
                            TextSize = core.scale:getTextSize(50),
                            Image = 'rbxassetid://6276261087'
                        }),
                        ['ConsoleButton'] = core.roact.createElement('ImageLabel', {
                            AnchorPoint = Vector2.new(1, .5),
                            BackgroundTransparency = 1,
                            Position = UDim2.new(1, core.scale:getOffset(-5), .5, 0),
                            Size = UDim2.fromScale(.6, .6),
                            SizeConstraint = Enum.SizeConstraint.RelativeYY,
                            Visible = global.platform == 'CONSOLE',
                            ZIndex = 4,
                            Image = platform.getConsoleImage(Enum.KeyCode.ButtonA),
                        })
                    }),
                    ['Exit'] = core.roact.createElement(core.elements.TextButton, {
                        AnchorPoint = Vector2.new(.5, 1),
                        BackgroundColor3 = global.theme.ExitBgClr,
                        Position = UDim2.new(.5, 0, 1, core.scale:getOffset(10)),
                        Size = UDim2.fromOffset(core.scale:getOffset(200), core.scale:getOffset(55)),
                        Visible = self.state.mode == 'Buy' or self.state.mode == 'Expand',
                        Text = 'Exit',
                        TextColor3 = global.theme.ExitTextClr,
                        TextSize = core.scale:getTextSize(50),
                        [core.roact.Ref] = function(rbx) self.ExitButton = rbx end
                    }, {
                        ['ConsoleButton'] = core.roact.createElement('ImageLabel', {
                            AnchorPoint = Vector2.new(1, .5),
                            BackgroundTransparency = 1,
                            Position = UDim2.new(1, core.scale:getOffset(-5), .5, 0),
                            Size = UDim2.fromScale(.6, .6),
                            SizeConstraint = Enum.SizeConstraint.RelativeYY,
                            Visible = global.platform == 'CONSOLE',
                            ZIndex = 4,
                            Image = platform.getConsoleImage(Enum.KeyCode.ButtonB),
                        })
                    }),
                    ['Right'] = core.roact.createElement(core.elements.TextButton, {
                        AnchorPoint = Vector2.new(1, 0),
                        Position = UDim2.fromScale(1, 0),
                        Size = UDim2.fromOffset(core.scale:getOffset(60), core.scale:getOffset(80)),
                        Visible = self.state.mode == 'Buy' or self.state.mode == 'Claim' or global.platform == 'CONSOLE',
                        Text = '>',
                        TextSize = core.scale:getTextSize(50),
                        [core.roact.Ref] = function(rbx) self.RightButton = rbx end
                    }, {
                        ['ConsoleButton'] = core.roact.createElement('ImageLabel', {
                            AnchorPoint = Vector2.new(0, .5),
                            BackgroundTransparency = 1,
                            Position = UDim2.fromScale(1, .5),
                            Size = UDim2.fromScale(.6, .6),
                            SizeConstraint = Enum.SizeConstraint.RelativeYY,
                            Visible = global.platform == 'CONSOLE',
                            ZIndex = 4,
                            Image = platform.getConsoleImage(Enum.KeyCode.DPadRight),
                        })
                    })
                }),
                ['Mode'] = core.roact.createElement('StringValue', {
                    Value = self.state.mode,
                    [core.roact.Ref] = function(rbx) self.ModeV = rbx end
                }),
                ['Price'] = core.roact.createElement('NumberValue', {
                    Value = self.state.price,
                    [core.roact.Ref] = function(rbx) self.PriceV = rbx end
                })
            })
        end
    })
end

function element:didMount()
    self.ModeV:GetPropertyChangedSignal('Value'):Connect(function()
        self:setState({
            mode = self.ModeV.Value
        })
    end)
    self.PriceV:GetPropertyChangedSignal('Value'):Connect(function()
        self:setState({
            price = self.PriceV.Value
        })
    end)

    for _, button in ipairs{ self.LeftButton, self.ConfirmButton, self.ExitButton, self.RightButton } do
       local objV = Instance.new('ObjectValue')
       objV.Name = button.Name
       objV.Value = button
       objV.Parent = self.Frame
    end
end

return element