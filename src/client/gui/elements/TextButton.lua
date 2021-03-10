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
    return core.roact.createElement(core.elements.global:getConsumer(), {
        render = function(global)
            local props = core.deepCopyTable(self.props)

            local ref = props[core.roact.Ref]
            props[core.roact.Ref] = core.cloneRef(ref, self.ButtonRef)

            --transfer custom props
            self.Animate = (props.Animate == nil) or props.Animate
            props.Animate = nil
            self.Sound = (props.Sound == nil) or props.Sound
            props.Sound = nil

            --apply dflt props
            props.BackgroundColor3 = props.BackgroundColor3 or global.theme.BgClr
            props.TextColor3 = props.TextColor3 or global.theme.TextClr
            props.Font = props.Font or global.theme.Font
            props.ZIndex = (props.ZIndex or 1) + 1
            props.AnimateBgColor = nil

            --////[children]////--
            local children = props[core.roact.Children] or {}
            props[core.roact.Children] = nil

            children.Corner = core.roact.createElement(core.elements.UICorner)

            children.Shadow = core.roact.createElement("Frame", {
                BackgroundColor3 = core.color.shade(props.BackgroundColor3, .5),
                Position = UDim2.new(0, 0, 0, core.scale:getOffset(5)),
                Size = UDim2.new(1, 0, 1, 0),
                ZIndex = props.ZIndex - 1
            }, {
                Corner = core.roact.createElement(core.elements.UICorner)
            })

            children.Activate = core.roact.createElement("BindableEvent", {
                [core.roact.Ref] = function (rbx)
                    if not rbx then return end
                    self.Activate = rbx.Event
                end
            })

            children.AnimFrame = core.roact.createElement("Frame", {
                AnchorPoint = Vector2.new(.5, .5),
                BackgroundColor3 = self.props.AnimateBgColor or props.BackgroundColor3,
                BackgroundTransparency = 1,
                Position = UDim2.new(.5, 0, .5, 0),
                Size = UDim2.new(1, 0, 1, 0),
                ZIndex = (props.ZIndex or 1) - 1,
                [core.roact.Ref] = self.AnimFrameRef
            }, {
                Corner = core.roact.createElement(core.elements.UICorner)
            })
            return core.roact.createElement(script.Name, props, children)
        end
    })
end

function element:didMount()
    if self.Animate then
        local pressAnim = core.TS:Create(self.AnimFrame, TweenInfo.new(.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            Size = UDim2.new(2, 0, 2, 0),
            BackgroundTransparency = 1,
        })

        local function onActivate()
            --Clean up
            pressAnim:Cancel()
            self.AnimFrame.Size = UDim2.new(1, 0, 1, 0)
            self.AnimFrame.BackgroundTransparency = 0
        
            pressAnim:Play()
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
end

return element