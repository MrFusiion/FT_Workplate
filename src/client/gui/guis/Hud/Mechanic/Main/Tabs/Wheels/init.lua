local core = require(script.Parent.Parent.Parent.Parent.Parent)

local wheelrack = require(script.wheelrack)

--+++++++[DEBUG]+++++++--
local function createPart(name, pos)
    local part = Instance.new("Part")
    part.Size = Vector3.new(1, 1, 1)
    part.Material = "SmoothPlastic"
    part.BrickColor = BrickColor.Red()
    part.Anchored = true
    part.CanCollide = false
    part.Name = name
    part.CFrame = CFrame.new(pos)
    part.Parent = workspace
end
--+++++++[DEBUG]+++++++--

return function (menu)
    local element = core.roact.Component:extend("Mechanic_Wheels")

    function element:render()
        return core.roact.createElement(core.elements.global:getConsumer(), {
            render = function(global)
                return core.roact.createElement("Frame", {
                    AnchorPoint = Vector2.new(0, 1),
                    BackgroundTransparency = 1,
                    LayoutOrder = 2,
                    Visible = false,
                    [core.roact.Ref] = function(rbx) self.Frame = rbx end
                }, {
                    ["LeftButton"] = core.roact.createElement(core.elements.TextButton, {
                        AnchorPoint = Vector2.new(1, .5),
                        Position = UDim2.new(0, -5, .5, 0),
                        Size = UDim2.new(0, core.scale:getOffset(70), 0, core.scale:getOffset(150)),
                        Font = Enum.Font.SourceSansBold,
                        Text = "<",
                        TextSize = core.scale:getOffset(40),
                        [core.roact.Ref] = function(rbx) self.LeftButton = rbx end
                    }),
                    ["RightButton"] = core.roact.createElement(core.elements.TextButton, {
                        AnchorPoint = Vector2.new(0, .5),
                        Position = UDim2.new(1, 5, .5, 0),
                        Size = UDim2.new(0, core.scale:getOffset(70), 0, core.scale:getOffset(150)),
                        Font = Enum.Font.SourceSansBold,
                        Text = ">",
                        TextSize = core.scale:getOffset(40),
                        [core.roact.Ref] = function(rbx) self.RightButton = rbx end
                    }),
                    ["Open"] = core.roact.createElement("BindableEvent",        { [core.roact.Ref] = function(rbx) self.OpenEvent           = rbx end }),
                    ["Close"] = core.roact.createElement("BindableEvent",       { [core.roact.Ref] = function(rbx) self.CloseEvent          = rbx end }),
                    ['Init'] = core.roact.createElement("BindableEvent",        { [core.roact.Ref] = function(rbx) self.InitEvent           = rbx end }),
                    ['Exit'] = core.roact.createElement("BindableEvent",        { [core.roact.Ref] = function(rbx) self.ExitEvent           = rbx end }),
                })
            end
        })
    end

    function element:didMount()
        local tab = menu.Tabs:new(2, "Wheels")

        function tab.init(data)
            self.WheelRack = wheelrack.new(data.wheelrack, "3x3", data)
            self.WheelRack:update()

            for _, hldr in ipairs(self.WheelRack.Holders) do
                hldr:hideState()
            end

            self.UpdateWheel = Instance.new("BindableEvent")
            self.UpdateWheel.Name = "UpdateWheel"
            self.UpdateWheel.Event:Connect(function(wheelcap, icon)
                self.WheelRack:updateColor(wheelcap, icon)
            end)
            self.UpdateWheel.Parent = data.car.Model
        end

        function tab.open(data)
            self.WheelRack:setActive(true)

            local cf, boxSize = data.wheelrack:GetBoundingBox()
            local leftCorner = cf.Position - cf.RightVector *  boxSize.X * .5 - cf.UpVector * boxSize.Y * .5
            local rightCorner = cf.Position + cf.RightVector *  boxSize.X * .5 + cf.UpVector * boxSize.Y * .5

            local leftScreenPos = workspace.CurrentCamera:WorldToScreenPoint(leftCorner)
            local rightScreenPos = workspace.CurrentCamera:WorldToScreenPoint(rightCorner)

            self.Frame.Position = UDim2.fromOffset(leftScreenPos.X, leftScreenPos.Y)

            self.Frame.Size = UDim2.fromOffset(
                math.abs(rightScreenPos.X - leftScreenPos.X),
                math.abs(leftScreenPos.Y - rightScreenPos.Y)
            )

            self.Frame.Visible = true
        end
        
        function tab.close()
            self.WheelRack:setActive(false)
            self.Frame.Visible = false
        end

        function tab.exit()
            self.WheelRack:destroy()
            self.UpdateWheel = self.UpdateWheel:Destroy()
        end

        self.LeftButton.Activated:Connect(function()
            self.WheelRack:left()
        end)

        self.RightButton.Activated:Connect(function()
            self.WheelRack:right()
        end)
    end

    return element
end