local core = require(script.Parent)

local element = core.roact.PureComponent:extend("__" .. script.Name .. "__")

function element:init()
    self.sounds = core.soundlist.new()
    self.sounds:add("click", 452267918)
    self.sounds:add("hover", 421058925)
    self.AnimFrameRef = function(rbx) self.AnimFrame = rbx end
    self.ButtonRef = function(rbx) self.Button = rbx end
    self.InnderRef = function(rbx) self.Inner = rbx end
end

function element:render() 
    return core.roact.createElement(core.theme:getConsumer(), {
        render = function(theme)
            local props = core.deepCopyTable(self.props)

            local ref = props[core.roact.Ref]
            props[core.roact.Ref] = core.cloneRef(ref, self.ButtonRef)

            --transfer custom props
            self.Animate = (props.Animate == nil) or props.Animate
            props.Animate = nil
            self.Sound = (props.Sound == nil) or props.Sound
            props.Sound = nil
            self.BorderSize = props.BorderSize or core.scale:getOffset(5)
            props.BorderSize = nil

            --apply dflt props
            props.BackgroundColor3 = props.BackgroundColor3 or theme.BgClr
            props.TextColor3 = props.TextColor3 or theme.TextClr
            props.Font = props.Font or theme.Font
            props.BackgroundTransparency = 1
            props.BorderSizePixel = 0
            --////[children]////--
            local children = props[core.roact.Children] or {}
            props[core.roact.Children] = nil

            children.Top = core.roact.createElement("Frame", {
                AnchorPoint = Vector2.new(.5, 0),
                BackgroundColor3 = props.BackgroundColor3,
                BorderSizePixel = 0,
                Position = UDim2.new(.5, 0, 0, 0),
                Size = UDim2.new(1, 0, 0, self.BorderSize),
                ZIndex = props.ZIndex or 1,
            })

            children.Bottom = core.roact.createElement("Frame", {
                AnchorPoint = Vector2.new(.5, 1),
                BackgroundColor3 = props.BackgroundColor3,
                BorderSizePixel = 0,
                Position = UDim2.new(.5, 0, 1, 0),
                Size = UDim2.new(1, 0, 0, self.BorderSize),
                ZIndex = props.ZIndex or 1,
            })

            children.Left = core.roact.createElement("Frame", {
                AnchorPoint = Vector2.new(0, .5),
                BackgroundColor3 = props.BackgroundColor3,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, .5, 0),
                Size = UDim2.new(0, self.BorderSize, 1, 0),
                ZIndex = props.ZIndex or 1,
            })

            children.Right = core.roact.createElement("Frame", {
                AnchorPoint = Vector2.new(1, .5),
                BackgroundColor3 = props.BackgroundColor3,
                BorderSizePixel = 0,
                Position = UDim2.new(1, 0, .5, 0),
                Size = UDim2.new(0, self.BorderSize, 1, 0),
                ZIndex = props.ZIndex or 1,
            })

            children.AnimFrame = core.roact.createElement("Frame", {
                AnchorPoint = Vector2.new(.5, .5),
                BackgroundColor3 = props.BackgroundColor3,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Position = UDim2.new(.5, 0, .5, 0),
                Size = UDim2.new(1, 0, 1, 0),
                ZIndex = (props.ZIndex or 2) - 2,
                [core.roact.Ref] = self.AnimFrameRef
            }, {
                Corner = core.roact.createElement(core.elements.UICorner)
            })

            props.ZIndex = (props.ZIndex or 2) - 1
            props.BackgroundColor3 = core.color.tint(props.BackgroundColor3, .25)
            return core.roact.createElement("TextButton", props, children)
        end
    })
end

function element:didMount()
    if self.Animate then
        local pressAnim = core.TS:Create(self.AnimFrame, TweenInfo.new(.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            Size = UDim2.new(2, 0, 2, 0),
            BackgroundTransparency = 1,
        })

        self.Button.Activated:Connect(function()
            --Clean up
            pressAnim:Cancel()
            self.AnimFrame.Size = UDim2.new(1, 0, 1, 0)
            self.AnimFrame.BackgroundTransparency = 0
        
            pressAnim:Play()
        end)

        self.Button.MouseEnter:Connect(function()
            self.Button.BackgroundTransparency = 0
        end)

        self.Button.MouseLeave:Connect(function()
            self.Button.BackgroundTransparency = 1
        end)
    end

    if self.Sound then
        self.Button.Activated:Connect(function()
            self.sounds:play("click")
        end)

        self.Button.MouseEnter:Connect(function()
            self.sounds:play("hover")
        end)
    end
end

return element