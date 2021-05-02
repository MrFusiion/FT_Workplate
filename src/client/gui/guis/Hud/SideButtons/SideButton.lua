local core = require(script.Parent.Parent.Parent)
local platform = core.client.get("platform")
local input = core.client.get("input")

local element = core.roact.Component:extend("SideButton")

function element:init()
    
end

function element:render()
    return core.roact.createElement(core.elements.global:getConsumer(), {
        render = function(global)
            self.props.Color = typeof(self.props.Color) == "string" and global.theme[self.props.Color] or self.props.Color
            local padding = self.props.Padding or { x = 0, y = 0 }
            return core.roact.createElement("Frame", {
                BackgroundTransparency = 1,
                LayoutOrder = self.props.Order or 1,
                Size = UDim2.new(1, 0, 1, 0),
                SizeConstraint = Enum.SizeConstraint.RelativeXX,
            }, {
                ["Button"] = core.roact.createElement(core.elements.TextButton, {
                    BackgroundColor3 = global.theme.BgClr,
                    --AutoButtonColor = false,
                    Size = UDim2.new(1, 0, 1, 0),
                    ZIndex = 2,
                    Text = "",
                    AnimateBgColor = self.props.Color,
                    [core.roact.Event.Activated] = self.props.Callback,
                    [core.roact.Ref] = function(rbx) self.Button = rbx end
                }, {
                    ["ConsoleButton"] = core.roact.createElement("ImageLabel", {
                        AnchorPoint = Vector2.new(0, .5),
                        BackgroundTransparency = 1,
                        Position = UDim2.fromScale(1, .5),
                        Size = UDim2.fromScale(.6, .6),
                        Visible = global.platform == "CONSOLE",
                        ZIndex = 6,
                        Image = platform.getConsoleImage(self.props.ConsoleButton),
                    }),
                    ["Icon"] = core.roact.createElement("ImageLabel", {
                        AnchorPoint = Vector2.new(.5, .5),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(.5, 0, .5, 0),
                        Size = UDim2.new(1, core.scale:getOffset(padding.x), 1, core.scale:getOffset(padding.y)),
                        ZIndex = 5,
                        Image = self.props.Icon,
                        ImageColor3 = self.props.Color
                    }),
                    ["Clip"] = core.roact.createElement("Frame", {
                        BackgroundTransparency = 1,
                        Position = UDim2.new(1, core.scale:getOffset(5), 0, 0),
                        Size = UDim2.new(0, core.scale:getOffset(220), 1, 0),
                        ClipsDescendants = true
                    }, {
                        ["Info"] = core.roact.createElement("Frame", {
                            AnchorPoint = Vector2.new(1, 0),
                            BackgroundTransparency = 1,
                            Size = UDim2.new(1, 0, 1, 0),
                            [core.roact.Ref] = function(rbx) self.InfoFrame = rbx end
                        }, {
                            ["Name"] = core.roact.createElement("TextLabel", {
                                BackgroundTransparency = 1,
                                Size = UDim2.new(1, 0, .667, 0),
                                Font = Enum.Font.SourceSansSemibold,
                                Text = self.props.Name,
                                TextColor3 = self.props.Color,
                                TextSize = core.scale:getTextSize(50),
                                TextStrokeColor3 = core.color.shade(global.theme.BgClr, .5),
                                TextStrokeTransparency = .5,
                                TextXAlignment = Enum.TextXAlignment.Left
                            }),
                            ["Keybind"] = core.roact.createElement("TextLabel", {
                                AnchorPoint = Vector2.new(0, 1),
                                BackgroundTransparency = 1,
                                Position = UDim2.new(0, 0, 1, 0),
                                Size = UDim2.new(1, 0, .333, 0),
                                Font = Enum.Font.SourceSans,
                                RichText = true,
                                Text = string.format("Keybind[<font color=\"rgb(%d, %d, %d)\"><b>%s</b></font>]",
                                        math.floor(self.props.Color.R * 255), math.floor(self.props.Color.G * 255),
                                        math.floor(self.props.Color.B * 255), self.Keybind or "None"),
                                TextColor3 = core.color.tint(global.theme.BgClr, .25),
                                TextSize = core.scale:getTextSize(28),
                                TextStrokeColor3 = core.color.shade(global.theme.BgClr, .5),
                                TextStrokeTransparency = .5,
                                TextXAlignment = Enum.TextXAlignment.Left
                            })
                        })
                    })
                })
            })
        end
    })
end

function element:didMount()
    local dfltButtonPos = self.Button.Position
    local hoverButtonPos = self.Button.Position + UDim2.new(0, core.scale:getOffset(10), 0, 0)

    local dfltInfoFramePos = self.InfoFrame.Position
    local hoverInfoFramePos = UDim2.new(1, 0, 0, 0)

    self.Button.MouseEnter:Connect(function()
        if platform.getPlatform() == "PC" then
            self.Button:TweenPosition(hoverButtonPos, "InOut", "Sine", .1, true)
            self.InfoFrame:TweenPosition(hoverInfoFramePos, "InOut", "Sine", .5, true)
        end
    end)
    self.Button.MouseLeave:Connect(function()
        if platform.getPlatform() == "PC" then
            self.Button:TweenPosition(dfltButtonPos, "InOut", "Sine", .1, true)
            self.InfoFrame:TweenPosition(dfltInfoFramePos, "InOut", "Sine", .5, true)
        end
    end)

    input.bindPriority("BTN["..self.props.Name.."]", input.beginWrapper(function()
        self.Button.Activate:Fire()
        self.props.Callback()
    end), false, 2000, self.props.ConsoleButton)
end

return element