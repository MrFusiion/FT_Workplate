local TS = game:GetService('TweenService')
local PPS = game:GetService("ProximityPromptService")

local core = require(script.Parent.Parent)
local platform = core.client.get('platform')

local element = core.roact.Component:extend('Interact')

function element:init()
    self:setState({
        prompt = {},
        inputType = nil
    })
    self.TweenInfoFast = TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    self.TweenInfoQuick = TweenInfo.new(.06, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
end

function element:render()
    self.TweensPress = {}
    self.TweensRelease = {}
    self.TweensFadeIn = {}
    self.TweensFadeOut = {}
    return core.roact.createElement('BillboardGui', {
        Adornee = self.state.prompt.Parent,
        AlwaysOnTop = true,
        Active = true,
        Size = UDim2.fromOffset(core.scale:getOffset(100), core.scale:getOffset(100))
    }, {
        ['InputFrame'] = core.roact.createElement('Frame', {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            SizeConstraint = Enum.SizeConstraint.RelativeYY
        }, {
            ['ResizeFrame'] = core.roact.createElement('Frame', {
                AnchorPoint = Vector2.new(.5, .5),
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(.5, .5),
                Size = UDim2.fromScale(1, 1)
            }, {
                ['Scale'] = core.roact.createElement('UIScale', {
                    [core.roact.Ref] = function(rbx)
                        if not rbx then return end
                        table.insert(self.TweensPress, TS:Create(rbx, self.TweenInfoFast, { Scale = 1.3 }))
                        table.insert(self.TweensRelease, TS:Create(rbx, self.TweenInfoFast, { Scale = 1 }))
                    end
                }),
                ['CONSOLE'] = core.roact.createElement('ImageLabel', {
                    AnchorPoint = Vector2.new(.5, .5),
                    BackgroundTransparency = 1,
                    Position = UDim2.fromScale(.5, .5),
                    Size = UDim2.fromScale(1, 1),
                    Visible = self.state.inputType == Enum.ProximityPromptInputType.Gamepad,
                    Image = platform.getConsoleImage(self.state.prompt.GamepadKeyCode),
                    ImageTransparency = 1,
                    [core.roact.Ref] = function(rbx)
                        if not rbx then return end
                        table.insert(self.TweensFadeOut, TS:Create(rbx, self.TweenInfoQuick, { ImageTransparency = 1 }))
                        table.insert(self.TweensFadeIn, TS:Create(rbx, self.TweenInfoQuick, { ImageTransparency = 0 }))
                    end
                }),
                ['TOUCH'] = core.roact.createElement('ImageLabel', {
                    AnchorPoint = Vector2.new(.5, .5),
                    BackgroundTransparency = 1,
                    Position = UDim2.fromScale(.5, .5),
                    Size = UDim2.fromScale(1, 1),
                    Visible = self.state.inputType == Enum.ProximityPromptInputType.Touch,
                    Image = 'rbxassetid://4952527150',
                    ImageTransparency = 1,
                    [core.roact.Ref] = function(rbx)
                        if not rbx then return end
                        table.insert(self.TweensFadeOut, TS:Create(rbx, self.TweenInfoQuick, { ImageTransparency = 1 }))
                        table.insert(self.TweensFadeIn, TS:Create(rbx, self.TweenInfoQuick, { ImageTransparency = 0 }))
                    end
                }, {
                    ['Icon'] = core.roact.createElement('ImageLabel', {
                        AnchorPoint = Vector2.new(.5, .5),
                        BackgroundTransparency = 1,
                        Position = UDim2.fromScale(.5, .5),
                        Size = UDim2.fromScale(.5, .5),
                        ZIndex = 2,
                        ImageTransparency = 1,
                        Image = 'rbxasset://textures/ui/Controls/TouchTapIcon.png',
                        [core.roact.Ref] = function(rbx)
                            if not rbx then return end
                            table.insert(self.TweensFadeOut, TS:Create(rbx, self.TweenInfoQuick, { ImageTransparency = 1 }))
                            table.insert(self.TweensFadeIn, TS:Create(rbx, self.TweenInfoQuick, { ImageTransparency = 0 }))
                        end
                    })
                }),
                ['PC'] = core.roact.createElement('ImageLabel', {
                    AnchorPoint = Vector2.new(.5, .5),
                    BackgroundTransparency = 1,
                    Position = UDim2.fromScale(.5, .5),
                    Size = UDim2.fromScale(1, 1),
                    Visible = self.state.inputType == Enum.ProximityPromptInputType.Keyboard,
                    ImageTransparency = 1,
                    Image = 'rbxassetid://4952527150',
                    [core.roact.Ref] = function(rbx)
                        if not rbx then return end
                        table.insert(self.TweensFadeOut, TS:Create(rbx, self.TweenInfoQuick, { ImageTransparency = 1 }))
                        table.insert(self.TweensFadeIn, TS:Create(rbx, self.TweenInfoQuick, { ImageTransparency = 0 }))
                    end
                }, {
                    ['Key'] = core.roact.createElement('TextLabel', {
                        AnchorPoint = Vector2.new(.5, .5),
                        BackgroundTransparency = 1,
                        Position = UDim2.fromScale(.5, .5),
                        Size = UDim2.fromScale(1, 1),
                        ZIndex = 2,
                        Font = Enum.Font.GothamSemibold,
                        Text = platform.KeyCodeToText(self.state.prompt.KeyboardKeyCode),
                        TextSize = string.len(platform.KeyCodeToText(self.state.prompt.KeyboardKeyCode) or '') > 2 and 20 or 30,
                        TextTransparency = 1,
                        TextColor3 = Color3.new(.8, .8, .8),
                        TextXAlignment = Enum.TextXAlignment.Center,
                        [core.roact.Ref] = function(rbx)
                            if not rbx then return end
                            table.insert(self.TweensFadeOut, TS:Create(rbx, self.TweenInfoQuick, { TextTransparency = 1 }))
                            table.insert(self.TweensFadeIn, TS:Create(rbx, self.TweenInfoQuick, { TextTransparency = 0 }))
                        end
                    })
                })
            }),
            ['Button'] = core.roact.createElement('TextButton', {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                ZIndex = 3,
                Text = '',
                [core.roact.Ref] = function(rbx) self.Button = rbx end
            })
        })
    })
end

function element:show()
    for _, tween in ipairs(self.TweensFadeIn) do
        tween:Play()
    end
end

function element:hide()
    for _, tween in ipairs(self.TweensFadeOut) do
        tween:Play()
    end
end

function element:linkConnections()
    self.Connections = {}
    table.insert(self.Connections, self.state.prompt.Triggered:Connect(function()
        for _, tween in ipairs(self.TweensPress) do
            tween:Play()
        end
    end))

    table.insert(self.Connections, self.state.prompt.TriggerEnded:Connect(function()
        for _, tween in ipairs(self.TweensRelease) do
            tween:Play()
        end
    end))
end

function element:unlinkConnections()
    for _, conn in ipairs(self.Connections) do
        conn:Disconnect()
    end
    self.Connections = {}
end

function element:didMount()
    PPS.PromptShown:Connect(function(prompt, inputType)
        if prompt.Style ~= Enum.ProximityPromptStyle.Default then
            self:setState({
                prompt = prompt,
                inputType = inputType
            })
            self:linkConnections()
            self:show()

            prompt.PromptHidden:Wait()

            self:hide()
            wait(.2)

            self:unlinkConnections()
        end
    end)
    local buttonDown = false
    self.Button.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) and
            input.UserInputState ~= Enum.UserInputState.Change then
            self.state.prompt:InputHoldBegin()
            buttonDown = true
        end
    end)
    self.Button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            if buttonDown then
                buttonDown = false
                self.state.prompt:InputHoldEnd()
            end
        end
    end)
end

return element