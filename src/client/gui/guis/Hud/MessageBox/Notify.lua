local core = require(script.Parent.Parent.Parent)

local element = core.roact.Component:extend("MessageBox_Notify")

function element:init()
    self:setState{
        visible = false,
        title = "info",
        message = ""
    }
end

function element:render()
    self.Updating = true
    return core.roact.createElement(core.elements.global:getConsumer(), {
        render = function(global)
            return core.roact.createFragment{
                ['Window'] = core.roact.createElement(core.elements.Window, {
                    Size = core.scale.udim2.fromOffset(600, 400),
                    Title = self.state.title,
                    CloseEnabled = false,
                    Visible = self.state.visible
                }, {
                    ['Label'] = core.roact.createElement("TextBox", {
                        AnchorPoint = core.anchor.tc,
                        BackgroundTransparency = 1,
                        Position = UDim2.fromScale(.5, 0),
                        Size = core.scale.udim2.new(1, -10, 1, -70),
                        ZIndex = 5,
                        MultiLine = true,
                        TextEditable = true,
                        RichText = true,
                        Text = self.state.message,
                        TextColor3 = global.theme.TextClr,
                        TextSize = core.scale:getTextSize(30),
                        TextWrapped = true,
                    }),
                    ['Button'] = core.roact.createElement(core.elements.TextButton, {
                        AnchorPoint = core.anchor.bc,
                        BackgroundColor3 = global.theme.AcceptBgClr,
                        Position = core.scale.udim2.new(.5, 0, 1, -10),
                        Size = core.scale.udim2.fromOffset(140, 60),
                        ZIndex = 5,
                        Text = "OK",
                        TextSize = core.scale:getTextSize(40),
                        TextColor3 = global.theme.AcceptTextClr,
                        [core.roact.Ref] = function(rbx) self.Button  = rbx end
                    })
                }),
                ['Notify'] = core.roact.createElement("BindableEvent", {
                    [core.roact.Ref] = function(rbx)
                        self.Notify = rbx
                    end
                })
            }
        end
    })
end

function element:didUpdate()
    self.Updating = false
end

function element:didMount()
    self.Updating = false

    local re_Notify = game:GetService("ReplicatedStorage")
        :WaitForChild("remote")
        :WaitForChild("message")
        :WaitForChild("Notify")

    local function notify(title, message)
        while self.Updating do wait() end
        self:setState{
            visible = true,
            title = title,
            message = message
        }
    end

    self.Notify.Event:Connect(notify)
    re_Notify.OnClientEvent:Connect(notify)

    self.Button.Activated:Connect(function()
        while self.Updating do wait() end
        self:setState{
            visible = false
        }
    end)
end

return element