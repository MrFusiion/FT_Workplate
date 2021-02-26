local core = require(script.Parent)
local dot = require(script:WaitForChild("dot"))
local research = core.roact.Component:extend("Research")

function research:init()
    self:setState({
        selected = 'mining',
        enabled = false
    })
    self.Running = true
    self.FrameRef = function(rbx) self.Frame = rbx end
    self.GradientRef = function(rbx) self.Gradient = rbx end
    self.ButtonsRefs = {}
    self.Buttons = {}
    for i=1,3,1 do
        self.ButtonsRefs[i] = function(rbx) self.Buttons[i] = rbx end
    end
end

function research:render()
    return core.roact.createElement(core.theme, {}, {
        [script.Name] = core.roact.createElement(core.theme:getConsumer(), {
            render = function(theme)
                self.Theme = theme
                if self.Dots then self:didUpdate() end
                return core.roact.createElement("ScreenGui", {
                    Name = "Hud",
                    IgnoreGuiInset = true,
                    ResetOnSpawn = false,
                    ZIndexBehavior = 'Global',
                    Enabled = false
                }, {
                    Content = core.roact.createElement("Frame", {
                        AnchorPoint = Vector2.new(.5, 1),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(.5, 0, 1, 0),
                        Size = UDim2.new(1, 0, 1, core.scale:getOffset(-160)),
                    }, {
                        
                        Image = core.roact.createElement("ImageLabel", {
                            AnchorPoint = Vector2.new(.5, .5),
                            BorderSizePixel = 0,
                            BackgroundTransparency = 1,
                            Position = UDim2.new(.5, 0, .5, 0),
                            Size = UDim2.new(1, core.scale:getOffset(-40), 1, core.scale:getOffset(-20)),
                            ZIndex = 2,
                            Image = "rbxassetid://6115127476",
                            ImageColor3 =  core.color.getLuma(theme.BgClr) < .5 and core.color.tint(theme.BgClr, .25) or Color3.new(1, 1, 1),
                            ImageTransparency = 1,
                            ScaleType = Enum.ScaleType.Tile,
                            TileSize = UDim2.new(0, core.scale:getOffset(600), 0, core.scale:getOffset(600)),
                        }, {
                            Page = require(script:WaitForChild("Pages"):FindFirstChild(self.state.selected))
                        })
                        --[[Frame = core.roact.createElement("Frame", {
                            AnchorPoint = Vector2.new(.5, .5),
                            BorderSizePixel = 0,
                            Position = UDim2.new(.5, 0, .5, 0),
                            Size = UDim2.new(1, core.scale:getOffset(-40), 1, core.scale:getOffset(-20)),
                            ZIndex = 2,
                            [core.roact.Ref] = self.FrameRef
                        }, {
                            Page = require(script:WaitForChild("Pages"):FindFirstChild(self.state.selected))
                        })]]
                    }),
                    Topbar = core.roact.createElement("Frame", {
                        AnchorPoint = Vector2.new(.5, 0),
                        BackgroundColor3 = Color3.new(),
                        BackgroundTransparency = .75,
                        BorderSizePixel = 0,
                        Position = UDim2.new(.5, 0, 0, core.scale:getOffset(80)),
                        Size = UDim2.new(1, 0, 0, core.scale:getOffset(80)),
                        ZIndex = 4
                    }, {
                        Buttons = core.roact.createElement("Frame", {
                            AnchorPoint = Vector2.new(.5, .5),
                            BackgroundTransparency = 1,
                            Position = UDim2.new(.5, 0, .5, 0),
                            Size = UDim2.new(.5, 0, 1, 0)
                        }, {
                            ListLayout = core.roact.createElement("UIListLayout", {
                                Padding = UDim.new(0, core.scale:getOffset(10)),
                                FillDirection = Enum.FillDirection.Horizontal,
                                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                                SortOrder = Enum.SortOrder.LayoutOrder,
                                VerticalAlignment = Enum.VerticalAlignment.Center
                            }),
                            LeftFrame = core.roact.createElement("Frame", {
                                BackgroundColor3 = core.color.auto(theme.BgClr, .25),
                                BorderSizePixel = 0,
                                LayoutOrder = 0,
                                Size = UDim2.new(0, core.scale:getOffset(10), 1, 0),
                                ZIndex = 5
                            }),
                            MiningBtn = core.roact.createElement(core.elements.TextButtonBox, {
                                AutoButtonColor = false,
                                BackgroundColor3 = theme.ClrRed,
                                LayoutOrder = 1,
                                Size = UDim2.new(0, core.scale:getOffset(200), 1, core.scale:getOffset(-10)),
                                ZIndex = 6,
                                Font = Enum.Font.SourceSansSemibold,
                                TextColor3 = theme.TextClr,
                                Text = "Mining",
                                TextSize = core.scale:getTextSize(50),
                                BorderSize = core.scale:getOffset(7),
                                [core.roact.Ref] = self.ButtonsRefs[1]
                            }),
                            MachinesBtn = core.roact.createElement(core.elements.TextButtonBox, {
                                AutoButtonColor = false,
                                BackgroundColor3 = theme.ClrBlue,
                                LayoutOrder = 2,
                                Size = UDim2.new(0, core.scale:getOffset(200), 1, core.scale:getOffset(-10)),
                                ZIndex = 6,
                                Font = Enum.Font.SourceSansSemibold,
                                TextColor3 = theme.TextClr,
                                Text = "Machines",
                                TextSize = core.scale:getTextSize(50),
                                BorderSize = core.scale:getOffset(7),
                                [core.roact.Ref] = self.ButtonsRefs[2]
                            }),
                            CarsBtn = core.roact.createElement(core.elements.TextButtonBox, {
                                AutoButtonColor = false,
                                BackgroundColor3 = theme.ClrGreen,
                                LayoutOrder = 3,
                                Size = UDim2.new(0, core.scale:getOffset(200), 1, core.scale:getOffset(-10)),
                                ZIndex = 6,
                                Font = Enum.Font.SourceSansSemibold,
                                TextColor3 = theme.TextClr,
                                Text = "Cars",
                                TextSize = core.scale:getTextSize(50),
                                BorderSize = core.scale:getOffset(7),
                                [core.roact.Ref] = self.ButtonsRefs[3]
                            }),
                            RightFrame = core.roact.createElement("Frame", {
                                BackgroundColor3 = core.color.auto(theme.BgClr, .25),
                                BorderSizePixel = 0,
                                LayoutOrder = 4,
                                Size = UDim2.new(0, core.scale:getOffset(10), 1, 0),
                                ZIndex = 4
                            })
                        }),
                        ExitBtn = core.roact.createElement(core.elements.TextButtonBox, {
                            AnchorPoint = Vector2.new(1, .5),
                            AutoButtonColor = false,
                            BackgroundColor3 = theme.ExitBgClr,
                            Position = UDim2.new(1, core.scale:getOffset(-20), .5, 0),
                            Size = UDim2.new(1, core.scale:getOffset(-10), 1, core.scale:getOffset(-10)),
                            SizeConstraint = Enum.SizeConstraint.RelativeYY,
                            ZIndex = 6,
                            Font = Enum.Font.SourceSansSemibold,
                            TextColor3 = theme.ExitTextClr,
                            Text = "X",
                            TextSize = core.scale:getTextSize(70),
                            BorderSize = core.scale:getOffset(7),
                        })
                    }),
                    Bg = core.roact.createElement("Frame", {
                        AnchorPoint = Vector2.new(.5, .5),
                        BackgroundColor3 = Color3.new(),
                        Transparency = .5,
                        BorderSizePixel = 0,
                        Position = UDim2.new(.5, 0, .5, 0),
                        Size = UDim2.new(1, 0, 1, 0),
                        [core.roact.Ref] = self.FrameRef
                    }, {
                        Frame = core.roact.createElement("Frame", {
                            BackgroundTransparency = 0.5,
                            BorderSizePixel = 0,
                            Size = UDim2.new(1, 0, 1, 0)
                        }, {
                            Gradient = core.roact.createElement("UIGradient", {
                                Rotation = 90,
                                Transparency = NumberSequence.new({
                                    NumberSequenceKeypoint.new(0, 0),
                                    NumberSequenceKeypoint.new(.45, 0),
                                    NumberSequenceKeypoint.new(1, .25),
                                }),
                                [core.roact.Ref] = self.GradientRef
                            })
                        })
                    }),
                    Title = core.roact.createElement("TextLabel", {
                        AnchorPoint = Vector2.new(.5, 0),
                        BackgroundColor3 = Color3.new(),
                        BackgroundTransparency = .75,
                        BorderSizePixel = 0,
                        Position = UDim2.new(.5, 0, 0, 0),
                        Size = UDim2.new(1, 0, 0, core.scale:getOffset(80)),
                        ZIndex = 4,
                        Font = Enum.Font.SourceSansSemibold,
                        TextColor3 = theme.TextClr,
                        Text = "Research",
                        TextSize = core.scale:getTextSize(60)
                    })
                })
            end
        })
    }) 
end

function research:didUpdate()
    for _, d in ipairs(self.Dots) do
        d:setTheme(self.Theme)
    end
end

function research:setGradient(button)
    local color = button.BackgroundColor3

    self.Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new()),
        ColorSequenceKeypoint.new(.45, Color3.new()),
        ColorSequenceKeypoint.new(1, color)
    })
end

--local viewportSize = workspace.CurrentCamera.ViewportSize
--local dotAmount=math.floor(((viewportSize.X * viewportSize.Y)/(1920*1080))*40+.5)
local dotAmount = math.min(core.scale:getOffset(40), 40)
dotAmount = math.max(10, dotAmount)
function research:didMount()
    self:setGradient(self.Buttons[1])

    for _, button in pairs(self.Buttons) do
        button.Activated:Connect(function()
            for _, d in ipairs(self.Dots) do
                d:setColor(button.BackgroundColor3)
            end
            self:setGradient(button)

            self:setState({
                selected = string.lower(button.Name:gsub("Btn", ""))
            })
        end)
    end

    self.Dots = {}
    for i=1,dotAmount,1 do
        self.Dots[i] = dot.new(self.Frame, core.scale:getOffset(10), self.Theme, self.Buttons[1].BackgroundColor3)
    end
    for i, d in ipairs(self.Dots) do
        d:initLines(i, self.Dots, dotAmount)
    end

    spawn(function()
        self.RSConnection = game:GetService("RunService").Heartbeat:Connect(function(t)
            if self.Running then
                local start = tick()
                for _, d in ipairs(self.Dots) do
                    d:update(t)
                    d:updateLines()
                end
                --[[for i, d in ipairs(self.Dots) do
                    d:updateLines(i)
                end]]
            end
        end)
    end)

    self.Blur = Instance.new("BlurEffect")
    self.Blur.Size = 1000
    self.Blur.Enabled = self.state.enabled
    self.Blur.Parent = game:GetService("Lighting")
end

function research:willUnmount()
    self.Running = false
    self.RSConnection:Disconnect()
end

return research