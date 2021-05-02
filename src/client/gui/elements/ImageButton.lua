local core = require(script.Parent)

local element = core.roact.PureComponent:extend("__" .. script.Name .. "__")

function element:init()
    self.sounds = core.soundlist.new()
    self.sounds:add("click", 452267918)
    self.sounds:add("hover", 421058925)
    self.IsSelected = false
end

function element:render()
    return core.roact.createElement(core.elements.global:getConsumer(), {
        render = function(global)
            local props = core.shallowCopyTable(self.props)
            local imageProps = {}

            local ref = props[core.roact.Ref]
            props[core.roact.Ref] = core.cloneRef(ref, function(rbx) self.Button = rbx end)

            --transfer custom props
            self.Animate = (props.Animate == nil) or props.Animate
            props.Animate = nil
            self.Sound = (props.Sound == nil) or props.Sound
            props.Sound = nil

            self.SelectedColor = props.SelectColor or global.theme.BlueClr
            props.SelectColor = nil

            --this is a ref color for the hover and click animation
            self.BackgroundColor = props.BackgroundColor3 or global.theme.BgClr

            --apply dflt props
            props.Text = ""
            --props.AutoButtonColor = false
            props.BackgroundColor3 = self.BackgroundColor
            props.ZIndex = (props.ZIndex or 1)
            props.AnimateBgColor = nil

            --getting all image props and removing it form the button's props
            imageProps.Image = props.Image
            props.Image = nil
            imageProps.ImageColor3 = props.ImageColor3 or global.theme.TextClr
            props.ImageColor3 = nil

            --////[children]////--
            local children = props[core.roact.Children] or {}
            props[core.roact.Children] = nil

            children.Corner = core.roact.createElement(core.elements.UICorner)

            children.Activate = core.roact.createElement("BindableEvent", {
                [core.roact.Ref] = function (rbx)
                    if not rbx then return end
                    self.Activate = rbx.Event
                end
            })

            children.Shadow = core.roact.createElement("Frame", {
                BackgroundColor3 = core.color.shade(props.BackgroundColor3, .5),
                Position = UDim2.new(0, 0, 0, core.scale:getOffset(5)),
                Size = UDim2.new(1, 0, 1, 0),
                ZIndex = props.ZIndex + 1,
                [core.roact.Ref] = function(rbx) self.Shadow = rbx end
            }, {
                Corner = core.roact.createElement(core.elements.UICorner)
            })

            children.Inner = core.roact.createElement("Frame", {
                AnchorPoint = Vector2.new(.5, .5),
                BackgroundColor3 = props.BackgroundColor3,
                Position = UDim2.new(.5, 0, .5, 0),
                Size = core.scale.udim2.new(1, -5, 1, -5),
                ZIndex = props.ZIndex + 3,
                [core.roact.Ref] = function(rbx) self.Inner = rbx end
            }, {
                Corner = core.roact.createElement(core.elements.UICorner)
            })

            children.Image = core.roact.createElement("ImageLabel", {
                AnchorPoint = Vector2.new(.5, .5),
                BackgroundTransparency = 1,
                Position = UDim2.new(.5, 0, .5, 0),
                Size = UDim2.new(1, 0, 1, 0),
                ZIndex = props.ZIndex + 4,
                Image = imageProps.Image,
                ImageColor3 = imageProps.ImageColor3
            }, {
                Corner = core.roact.createElement(core.elements.UICorner)
            })

            children.AnimFrame = core.roact.createElement("Frame", {
                AnchorPoint = Vector2.new(.5, .5),
                BackgroundColor3 = self.props.AnimateBgColor or props.BackgroundColor3,
                BackgroundTransparency = 1,
                Position = UDim2.new(.5, 0, .5, 0),
                Size = UDim2.new(1, 0, 1, 0),
                ZIndex = props.ZIndex,
                [core.roact.Ref] = function(rbx) self.AnimFrame = rbx end
            }, {
                Corner = core.roact.createElement(core.elements.UICorner)
            })

            props.ZIndex += 2
            return core.roact.createElement("TextButton", props, children)
        end
    })
end

function element:didMount()
    local hover, pressed

    if self.Animate then
        local pressAnim = core.TS:Create(self.AnimFrame, TweenInfo.new(.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            Size = UDim2.new(2, 0, 2, 0),
            BackgroundTransparency = 1,
        })

        local function onActivate()
            if self.Button.Active then
                --Clean up
                pressAnim:Cancel()
                self.AnimFrame.Size = UDim2.new(1, 0, 1, 0)
                self.AnimFrame.BackgroundTransparency = 0

                pressAnim:Play()
            end
        end

        self.Button.Activated:Connect(onActivate)
        self.Activate:Connect(onActivate)
    end

    if self.Sound then
        local function onActivate()
            if self.Button.Active then
                self.sounds:play("click")
            end
        end

        self.Button.Activated:Connect(onActivate)
        self.Activate:Connect(onActivate)

        self.Button.MouseEnter:Connect(function()
            if self.Button.Active then
                self.sounds:play("hover")
            end
        end)
    end

    if self.props.AutoButtonColor == true or self.props.AutoButtonColor == nil then

        self.Button.MouseEnter:Connect(function()
            hover = true
            if not self.IsSelected then
                self.Button.BackgroundColor3 = core.color.shade(self.BackgroundColor, .25)
            end
            self.Inner.BackgroundColor3 = core.color.shade(self.BackgroundColor, .25)
        end)
        self.Button.MouseLeave:Connect(function()
            hover = false
            if not self.IsSelected then
                self.Button.BackgroundColor3 = self.BackgroundColor
            end
            self.Inner.BackgroundColor3 = self.BackgroundColor
        end)

        self.Button.MouseButton1Down:Connect(function()
            pressed = true
            if not self.IsSelected then
                self.Button.BackgroundColor3 = core.color.tint(self.BackgroundColor, .25)
            end
            self.Inner.BackgroundColor3 = core.color.tint(self.BackgroundColor, .25)
        end)
        self.Button.MouseButton1Up:Connect(function()
            pressed = false
            if hover then
                if not self.IsSelected then
                    self.Button.BackgroundColor3 = core.color.shade(self.BackgroundColor, .25)
                end
                self.Inner.BackgroundColor3 = core.color.shade(self.BackgroundColor, .25)
            else
                if not self.IsSelected then
                    self.Button.BackgroundColor3 = self.BackgroundColor
                end
                self.Inner.BackgroundColor3 = self.BackgroundColor
            end
        end)
    end

    self.Button:GetPropertyChangedSignal("Selected"):Connect(function()
        print("selected")
        self.IsSelected = self.Button.Selected
        if self.Button.Selected then
            self.Button.BackgroundColor3 = self.SelectedColor
            self.Shadow.BackgroundColor3 = core.color.shade(self.SelectedColor, .5)
        else
            if pressed then
                self.Button.BackgroundColor3 = core.color.tint(self.BackgroundColor, .25)
            elseif hover then
                self.Button.BackgroundColor3 = core.color.shade(self.BackgroundColor, .25)
            else
                self.Button.BackgroundColor3 = self.BackgroundColor
            end
            self.Shadow.BackgroundColor3 = core.color.shade(self.BackgroundColor, .5)
        end
    end)
end

return element