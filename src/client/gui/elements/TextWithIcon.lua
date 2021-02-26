local TextS = game:GetService('TextService')

local core = require(script.Parent)

local element = core.roact.Component:extend('TextWithIcon')

function element:render()
    return core.roact.createElement(core.elements.global:getConsumer(), {
        render = function(global)
            return core.roact.createElement(core.elements.Frame, {
                AnchorPoint = self.props.AnchorPoint or Vector2.new(.5, .5),
                BackgroundColor3 = self.props.BackgroundColor3 or global.theme.BgClr,
                BackgroundTransparency = self.props.BackgroundTransparency or 0,
                Position = self.props.Position or UDim2.new(.5, 0, .5, 0),
                Size = self.props.Size or UDim2.fromOffset(core.scale:getOffset(200), core.scale:getOffset(60)),
                ZIndex = (self.props.ZIndex or 1),
                Visible = self.props.Visible
            }, {
                ['Value'] = core.roact.createElement('Frame', {
                    AnchorPoint = self.props.Anchor or Vector2.new(.5, .5),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(.5, 0, .5, 0),
                    Size = UDim2.fromScale(1, 1),
                    ZIndex = (self.props.ZIndex or 1),
                    [core.roact.Ref] = function(rbx) self.Frame = rbx end
                }, {
                    ['Text'] = core.roact.createElement('TextLabel', {
                        AnchorPoint = Vector2.new(1, 1),
                        BackgroundTransparency = 1,
                        ZIndex = (self.props.ZIndex or 1) + 1,
                        Position = UDim2.new(1, 0, 1, 0),
                        Text = self.props.Text or '',
                        Font = self.props.Font or global.theme.Font,
                        TextColor3 = self.props.TextColor3 or global.theme.TextClr,
                        TextSize = self.props.TextSize,
                        [core.roact.Ref] = function(rbx) self.Text = rbx end
                    }),
                    ['Icon'] = core.roact.createElement('ImageLabel', {
                        AnchorPoint = Vector2.new(0, 1),
                        BackgroundTransparency = 1,
                        ZIndex = (self.props.ZIndex or 1) + 1,
                        Position = UDim2.new(0, 0, 1, 0),
                        Size = self.props.IconSize or UDim2.fromScale(1, 1),
                        SizeConstraint = Enum.SizeConstraint.RelativeYY,
                        Image = self.props.Image,
                        [core.roact.Ref] = function(rbx) self.Icon = rbx end
                    })
                })
            })
        end
    })
end

function element:didUpdate()
    local icon = self.Frame:FindFirstChildWhichIsA('ImageLabel')
    local text = self.Frame:FindFirstChildWhichIsA('TextLabel')
    self.Frame.Size = UDim2.new(0, icon.AbsoluteSize.X + text.TextBounds.X, 1, 0)
end

function element:didMount()
    self.Text.Size = UDim2.new(1, -self.Icon.AbsoluteSize.X, 1, 0)

    local icon = self.Frame:FindFirstChildWhichIsA('ImageLabel')
    local text = self.Frame:FindFirstChildWhichIsA('TextLabel')
    local textSizeX = TextS:GetTextSize(text.Text, text.TextSize, text.Font, text.AbsoluteSize).X
    self.Frame.Size = UDim2.new(0, icon.AbsoluteSize.X + textSizeX, 1, 0)
end

return element