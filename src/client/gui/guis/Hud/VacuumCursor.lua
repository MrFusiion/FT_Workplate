local UIS = game:GetService("UserInputService")
local GS = game:GetService("GuiService")

local core = require(script.Parent.Parent)
local playerUtils = core.client.get("playerUtils")

local IDLE = "rbxassetid://6503743305"
local LOCKED = "rbxassetid://6503743248"
local LOOSE = "rbxassetid://6503786387"
local SPEED = 90

local element = core.roact.Component:extend("VacuumCursor")

function element:init()
    self:setState({
        visible = false,
        locked = false
    })
    self.Rotation = 0
    self.Tool = nil
end

function element:render()
    self.LifeCycleState = "Render"
    self.Gradients = {}
    UIS.MouseIconEnabled = not self.state.visible

    local handle = self.Tool and self.Tool:FindFirstChild("Handle")
    local beam = handle and handle:FindFirstChild("Beam")

    return core.roact.createElement("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }, {
        ["Icon"] = core.roact.createElement("ImageLabel", {
            AnchorPoint = Vector2.new(.5, .5),
            BackgroundTransparency = 1,
            Size = self.state.locked and
                    UDim2.fromOffset(core.scale:getOffset(128), core.scale:getOffset(128)) or
                    UDim2.fromOffset(core.scale:getOffset(64), core.scale:getOffset(64)),
            Image = self.state.locked and LOOSE or IDLE,
            Visible = self.state.visible,
            ZIndex = 999,
            [core.roact.Ref] = function(rbx) self.Icon = rbx end
        }, {
            ["Gradient"] = core.roact.createElement("UIGradient", {
                Color = self.Tool and (beam and beam.Color) or ColorSequence.new(Color3.new(1, 1, 1)),
                [core.roact.Ref] = function(rbx) table.insert(self.Gradients, rbx) end
            })
        }),
        ["Lock"] = core.roact.createElement("ImageLabel", {
            AnchorPoint = Vector2.new(.5, .5),
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(core.scale:getOffset(64), core.scale:getOffset(64)),
            Image = LOCKED,
            Visible = self.state.locked,
            ZIndex = 998,
            [core.roact.Ref] = function(rbx) self.Lock = rbx end
        }, {
            ["Gradient"] = core.roact.createElement("UIGradient", {
                Color = self.Tool and (beam and beam.Color) or ColorSequence.new(Color3.new(1, 1, 1)),
                [core.roact.Ref] = function(rbx) table.insert(self.Gradients, rbx) end
            })
        })
    })
end

function element:didUpdate()
    self.LifeCycleState = "Updated"
end

function element:didMount()
    self.LifeCycleState = "Mounted"
    local remoteVacuum = game:GetService("ReplicatedStorage"):WaitForChild("remote"):WaitForChild("vacuum")
    local re_TargetDetails = remoteVacuum:WaitForChild("TargetDetails")

    local mouse = playerUtils:getMouse()
    local player = playerUtils:getPlayer()
    local character = player.Character or player.CharacterAdded:Wait()
    local camera = workspace.CurrentCamera

    re_TargetDetails.OnClientEvent:Connect(function(pos)
        if self.LifeCycleState ~= "Render" then
            if pos then
                self:setState({
                    locked = true
                })
            else
                self:setState({
                    locked = false
                })
            end
        end
    end)

    game:GetService("RunService").RenderStepped:Connect(function(dt)
        if self.state.visible then
            self.Rotation = (self.Rotation + SPEED * dt) % 360
            for _, gradient in ipairs(self.Gradients) do
                gradient.Rotation = self.Rotation
            end
            self.Icon.Position = UDim2.fromOffset(mouse.X, mouse.Y + GS:GetGuiInset().Y)
            if self.state.locked and self.Tool then
                local attachment = self.Tool.Handle.Beam.Attachment1
                if attachment then
                    local vector = attachment and camera:WorldToScreenPoint(attachment.WorldPosition)
                    self.Lock.Position = UDim2.fromOffset(vector.X, vector.Y + GS:GetGuiInset().Y)
                end
            end
        end
    end)

    local childConnection, toolConnection
    local function childAdded(child)
        if not self.state.visible and child:IsA("Tool") and child:GetAttribute("Vacuum") then
            if self.LifeCycleState ~= "Render" then
                self.Tool = child
                self:setState({
                    visible = true
                })
                toolConnection = child.Unequipped:Connect(function()
                    self:setState({
                        visible = false
                    })
                    toolConnection:Disconnect()
                end)
            end
        end
    end
    player.CharacterAdded:Connect(function(char)
        character = char
        if childConnection then
            childConnection:Disconnect()
        end
        character.ChildAdded:Connect(childAdded)
    end)
    character.ChildAdded:Connect(childAdded)
end

return element