local core = require(script.Parent.Parent.Parent.Parent.Parent)

local cameraUtils = core.client.get("cameraUtils")
--local car = require(script.car)

return function (menu)
    local element = core.roact.Component:extend("Mechanic_Paint")

    function element:init()
        self.Buttons = {}

        self.Menu = {
            ["Body"] = {
                ["Icon"] = "rbxassetid://6673814417",
                ["Picker"] = "ColorPicker",
                ['Selected'] = function(data, boolean)
                    
                end,
            },
            ["Wheelcap"] = {
                ["Icon"] = "rbxassetid://6673848521",
                ["Picker"] = "ColorPicker",
                ['Selected'] = function(data, boolean)
                    
                end,
            },
            ["Icon"] = {
                ["Icon"] = "rbxassetid://6673814333",
                ["Picker"] = "ColorPicker",
                ['Selected'] = function(data, boolean)
                    
                end,
            },
            ["Seat"] = {
                ["Icon"] = "rbxassetid://6673814170",
                ["Picker"] = "ColorPicker",
                ['Selected'] = function(data, boolean)
                    
                end,
            },
            ["Light"] = {
                ["Icon"] = "rbxassetid://6673814251",
                ["Picker"] = "ColorPicker",
                ['Selected'] = function(data, boolean)
                    for _, light in ipairs(data.lights) do
                        if not boolean then
                            light:on()
                        else
                            light:off()
                        end
                        data.car.Model.EnableLight:FireServer(boolean)
                    end
                end,
            }
        }
    end
    
    function element:render()
        return core.roact.createElement(core.elements.global:getConsumer(), {
            render = function(global)
                local buttons = {
                    ['Layout'] = core.roact.createElement("UIListLayout", {
                        Padding = core.scale.udim.new(0, 5),
                        FillDirection = Enum.FillDirection.Horizontal,
                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        SortOrder = Enum.SortOrder.LayoutOrder
                    })
                }
                for catogoryName, catogoryData in pairs(self.Menu) do
                    buttons[catogoryName] = core.roact.createElement(core.elements.ImageButton, {
                        Size = UDim2.fromScale(1, 1),
                        SizeConstraint = Enum.SizeConstraint.RelativeYY,
                        Image = catogoryData.Icon,
                        [core.roact.Ref] = function(rbx) self.Buttons[catogoryName] = rbx end
                    })
                end
    
                return core.roact.createElement("Frame", {
                    AnchorPoint = Vector2.new(.5, .5),
                    BackgroundTransparency = 1,
                    LayoutOrder = 3,
                    Position = UDim2.fromScale(.5, .5),
                    Size = UDim2.fromScale(1, 1),
                    Visible = false,
                    [core.roact.Ref] = function(rbx) self.Frame = rbx end
                }, {
                    ['Buttons'] = core.roact.createElement("Frame", {
                        AnchorPoint = Vector2.new(.5, 0),
                        BackgroundTransparency = 1,
                        Position = core.scale.udim2.new(.5, 0, 0, 220),
                        Size = core.scale.udim2.fromOffset(330, 80),
                    }, buttons),
                    ['ColorPickerFrame'] = core.roact.createElement("Frame", {
                        AnchorPoint = Vector2.new(0, .5),
                        BackgroundColor3 = global.theme.BgClr,
                        Position = core.scale.udim2.new(0, 100, .5, 0),
                        Size = core.scale.udim2.fromOffset(500, 500),
                        Visible = false,
                        [core.roact.Ref] = function(rbx) self.ColorPickerFrame = rbx end,
                    }, {
                        ['Corner'] = core.roact.createElement(core.elements.UICorner),
                        ['ColorPicker'] = core.roact.createElement(core.elements.ColorPicker, {
                            Position = UDim2.fromScale(.5, .5),
                            ZIndex = 2,
                            [core.roact.Ref] = function(rbx) self.ColorPicker = rbx end,
                        })
                    })
                })
            end
        })
    end

    function element:openPicker(name, boolean)
        self[("%sFrame"):format(name)].Visible = boolean
    end

    function element:didMount()
        local tab = menu.Tabs:new(3, "Paint")
        local data, car

        function tab.init(d)
            data = d
            car = d.car
            car.Model.EnableLight:FireServer(false)
        end

        function tab.open(d)
            cameraUtils.scriptable(false)
            self.OldCameraZoomDistance = { cameraUtils.getZoomDistance() }
            cameraUtils.setZoomDistance(10, 20)
            self.Frame.Visible = true
        end

        function tab.close(d)
            if self.OldCameraZoomDistance then
                cameraUtils.scriptable(true)
                cameraUtils.setZoomDistance(table.unpack(self.OldCameraZoomDistance))
                self.OldCameraZoomDistance = nil
                self.Frame.Visible = false

                if self.Selected then
                    self:openPicker(self.Menu[self.Selected].Picker, false)
                    self.Menu[self.Selected].Selected(data, false)
                    self.Buttons[self.Selected].Selected = false
                    self.Selected = nil
                end
            end
        end

        function tab.exit(d)
            data = nil
            car = nil
        end

        for name, button in pairs(self.Buttons) do
            button.Activated:Connect(function()
                if self.Selected == name then
                    self:openPicker(self.Menu[name].Picker, false)
                    self.Menu[name].Selected(data, false)
                    self.Selected = nil
                    button.Selected = false
                else
                    if self.Selected then
                        self:openPicker(self.Menu[self.Selected].Picker, false)
                        self.Menu[self.Selected].Selected(data, false)
                        self.Buttons[self.Selected].Selected = false
                        self.Selected = nil
                    end
                    self:openPicker(self.Menu[name].Picker, true)
                    self.Menu[name].Selected(data, true)
                    self.Selected = name
                    button.Selected = true
                end
            end)
        end

        self.ColorPicker.Chosen.Event:Connect(function(color)
            local catogory = self.Selected
            if catogory and car then
                car.Paint:color(catogory, color)
                data.invoice.Add:Invoke(("%sColor"):format(catogory), car.Model.GetRepaintPrice:InvokeServer(), color.Color, self.Menu[catogory].Icon):Connect(function()
                    car.Paint:reset(catogory)
                end)
            end
        end)
    end
    
    return element
end