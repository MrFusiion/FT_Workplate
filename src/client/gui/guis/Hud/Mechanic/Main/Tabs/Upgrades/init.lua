local core = require(script.Parent.Parent.Parent.Parent.Parent)

local cameraUtils = core.client.get("cameraUtils")
local playerUtils = core.client.get("playerUtils")

local stringUtils = core.shared.get("stringUtils")

return function (menu)

    local element = core.roact.Component:extend("Mechanic_Upgrades")

    function element:init()
        self.Catogories = { "Acceleration", "Speed", "TireTraction", "TankCapacity" }
        self.Buttons = {}
        self:setState({
            ["Acceleration"] = {
                price = 0,
                value = 0
            },
            ["Speed"] = {
                price = 0,
                value = 0
            },
            ["TireTraction"] = {
                price = 0,
                value = 0
            },
            ["TankCapacity"] = {
                price = 0,
                value = 0
            }
        })
    end

    function element:render()
        self.Updating = true
        return core.roact.createElement(core.elements.global:getConsumer(), {
            render = function(global)
                local function createFrames(value)
                    local frames = {
                        ['Layout'] = core.roact.createElement("UIListLayout", {
                            Padding = UDim.new(0, core.scale:getOffset(5)),
                            FillDirection = Enum.FillDirection.Horizontal,
                            HorizontalAlignment = Enum.HorizontalAlignment.Center,
                            SortOrder = Enum.SortOrder.LayoutOrder,
                            VerticalAlignment = Enum.VerticalAlignment.Center
                        })
                    }
                    for i=1, 5 do
                        frames[i] = core.roact.createElement("Frame", {
                            BackgroundColor3 = i <= value and
                                global.theme.AcceptBgClr or
                                core.color.tint(global.theme.BgClr, .125),
                            LayoutOrder = i,
                            Size = UDim2.new(.2, -core.scale:getOffset(5), 1, 0),
                            ZIndex = 5,
                        }, {
                            ['Corner'] = core.roact.createElement(core.elements.UICorner),
                            ['Border'] = core.roact.createElement("Frame", {
                                AnchorPoint = Vector2.new(.5, .5),
                                BackgroundColor3 = i <= value and
                                core.color.shade(global.theme.AcceptBgClr, .25) or
                                    global.theme.BgClr,
                                Position = UDim2.new(.5, core.scale:getOffset(2), .5, core.scale:getOffset(2)),
                                Size = UDim2.new(1, core.scale:getOffset(2), 1, core.scale:getOffset(2)),
                                ZIndex = 4
                            }, {
                                ['Corner'] = core.roact.createElement(core.elements.UICorner)
                            })
                        })
                    end
                    return frames
                end

                local function createContent()
                    local contents = {
                        ['Layout'] = core.roact.createElement("UIListLayout", {
                            Padding = UDim.new(0, core.scale:getOffset(10)),
                            FillDirection = Enum.FillDirection.Vertical,
                            HorizontalAlignment = Enum.HorizontalAlignment.Center,
                            SortOrder = Enum.SortOrder.LayoutOrder,
                            VerticalAlignment = Enum.VerticalAlignment.Top
                        })
                    }
                    for i, catogory in ipairs(self.Catogories) do
                        contents[catogory] = core.roact.createElement("Frame", {
                            BackgroundColor3 = core.color.tint(global.theme.BgClr, .125),
                            LayoutOrder = i * 2 - 1,
                            Size = UDim2.new(1, -core.scale:getOffset(10), 0, core.scale:getOffset(90))
                        }, {
                            ['Header'] = core.roact.createElement("TextLabel", {
                                BackgroundTransparency = 1,
                                Size = UDim2.new(1, 0, 0, core.scale:getOffset(50)),
                                ZIndex = 3,
                                Font = Enum.Font.SourceSansBold,
                                Text = stringUtils.sepUppercase(catogory),
                                TextColor3 = global.theme.TextClr,
                                TextSize = core.scale:getTextSize(30)
                            }),
                            ['Frames'] = core.roact.createElement("Frame", {
                                AnchorPoint = Vector2.new(0, 1),
                                BackgroundTransparency = 1,
                                Position = UDim2.fromScale(0, 1),
                                Size = UDim2.new(.7, 0, 0, core.scale:getOffset(40))
                            }, createFrames(self.state[catogory].value)),
                            ['Button'] = core.roact.createElement(core.elements.TextButton, {
                                AnchorPoint = Vector2.new(1, 1),
                                --BackgroundColor3 = global.theme.AcceptBgClr,
                                Position = UDim2.fromScale(1, 1),
                                Size = UDim2.new(.3, -core.scale:getOffset(5), 0, core.scale:getOffset(40)),
                                ZIndex = 5,
                                Font = Enum.Font.SourceSansBold,
                                Text = self.state[catogory].value < 5 and tostring(self.state[catogory].price):upper() or "MAX",
                                TextColor3 = global.theme.AcceptTextClr,
                                TextSize = core.scale:getTextSize(25),
                                Active = self.state[catogory].value < 5,
                                [core.roact.Ref] = function(rbx) self.Buttons[catogory] = rbx end
                            })
                        })
                        if next(self.Catogories, i) then
                            contents[("sep_%d"):format(i)] = core.roact.createElement("Frame", {
                                AnchorPoint = Vector2.new(.5, 0),
                                BackgroundColor3 = core.color.shade(global.theme.BgClr, .125),
                                LayoutOrder = i * 2,
                                Size = UDim2.new(1, -core.scale:getOffset(10), 0, core.scale:getOffset(5)),
                                ZIndex = 4
                            }, {
                                ['UICorner'] = core.roact.createElement(core.elements.UICorner)
                            })
                        end
                    end
                    return contents
                end

                return core.roact.createElement("Frame", {
                    AnchorPoint = Vector2.new(1, 1),
                    BackgroundColor3 = core.color.tint(global.theme.BgClr, .5),
                    Position = core.scale.udim2.new(1, -50, 1, -50),
                    Size = UDim2.fromOffset(core.scale:getOffset(400), core.scale:getOffset(520)),
                    LayoutOrder = 1,
                    ZIndex = 2,
                    Visible = false,
                    [core.roact.Ref] = function(rbx) self.Frame = rbx end
                }, {
                    ['Corner'] = core.roact.createElement(core.elements.UICorner),
                    ['Border'] = core.roact.createElement("Frame", {
                        BackgroundColor3 = core.color.tint(global.theme.BgClr, .125),
                        Position = UDim2.fromOffset(0, core.scale:getOffset(5)),
                        Size = UDim2.fromScale(1, 1)
                    }, {
                        ['Corner'] = core.roact.createElement(core.elements.UICorner),
                    }),
                    ['Header'] = core.roact.createElement("TextLabel", {
                        AnchorPoint = Vector2.new(.5, 0),
                        BackgroundColor3 = global.theme.BgClr,
                        Position = UDim2.fromScale(.5, 0),
                        Size = UDim2.new(1, 0, 0, core.scale:getOffset(50)),
                        ZIndex = 4,
                        Font = Enum.Font.SourceSansBold,
                        Text = "UPGRADES",
                        TextColor3 = global.theme.TextClr,
                        TextSize = core.scale:getTextSize(40)
                    }, {
                        ['Corner'] = core.roact.createElement(core.elements.UICorner),
                        ['BottomCorner'] = core.roact.createElement("Frame", {
                            AnchorPoint = Vector2.new(.5, 1),
                            BackgroundColor3 = global.theme.BgClr,
                            BorderSizePixel = 0,
                            Position = UDim2.fromScale(.5, 1),
                            Size = UDim2.fromScale(1, .5),
                            ZIndex = 3
                        }),
                        ['Shadow'] = core.roact.createElement("Frame", {
                            AnchorPoint = Vector2.new(.5, 0),
                            BackgroundColor3 = global.theme.BgClr,
                            BackgroundTransparency = .5,
                            BorderSizePixel = 0,
                            Position = UDim2.fromScale(.5, 1),
                            Size = UDim2.new(1, 0, 0, core.scale:getOffset(5)),
                            ZIndex = 3
                        }),
                    }),
                    ['Content'] = core.roact.createElement("Frame", {
                        AnchorPoint = Vector2.new(.5, 1),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(.5, 0, 1, -core.scale:getOffset(10)),
                        Size = UDim2.new(1, -core.scale:getOffset(20), 1, -core.scale:getOffset(70))
                    }, createContent()),
                    ['Open'] = core.roact.createElement("BindableEvent", { [core.roact.Ref] = function(rbx) self.OpenEvent = rbx end }),
                    ['Close'] = core.roact.createElement("BindableEvent", { [core.roact.Ref] = function(rbx) self.CloseEvent = rbx end }),
                    ['Init'] = core.roact.createElement("BindableEvent", { [core.roact.Ref] = function(rbx) self.InitEvent = rbx end }),
                    ['Exit'] = core.roact.createElement("BindableEvent", { [core.roact.Ref] = function(rbx) self.ExitEvent = rbx end })
                })
            end
        })
    end

    function element:didUpdate()
        self.Updating = false
    end

    function element:didMount()
        local tab = menu.Tabs:new(1, "Upgrades")
        self.Updating = false

        function tab.init(data)
            self.Conns = {}
            local state = {}
            for _, catogory in ipairs(self.Catogories) do
                table.insert(self.Conns, data.car.Model:GetAttributeChangedSignal(("STAT_%s"):format(catogory)):Connect(function()
                    while self.Updating do wait() end
                    self:setState({
                        [catogory] = {
                            price = data.car.Model:GetAttribute(("PRICE_STAT_%s"):format(catogory)),
                            value = data.car.Model:GetAttribute(("STAT_%s"):format(catogory))
                        }
                    })
                end))
                state[catogory] = {
                    price = data.car.Model:GetAttribute(("PRICE_STAT_%s"):format(catogory)),
                    value = data.car.Model:GetAttribute(("STAT_%s"):format(catogory))
                }
            end

            state.upgrade = function(catogory)
                data.car.Model.UpgradeStat:FireServer(catogory)
            end

            self:setState(state)
        end

        function tab.open()
            self.Frame.Visible = true
        end

        function tab.close()
            self.Frame.Visible = false
        end

        function tab.exit()
            for _, conn in ipairs(self.Conns) do
                conn:Disconnect()
            end
            self.Conns = {}
        end

        for buttonName, button in pairs(self.Buttons) do
            button.Activated:Connect(function()
                self.state.upgrade(buttonName)
            end)
        end
    end

    return element
end