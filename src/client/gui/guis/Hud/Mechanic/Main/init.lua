local core = require(script.Parent.Parent.Parent)

local cameraUtils = core.client.get("cameraUtils")

local menu = require(script.Menu)
local car = require(script.car)
local light = require(script.light)

local element = core.roact.Component:extend("Mechanic_Main")

function element:init()
    self.Menu = menu.new()
end

function element:render()
    return core.roact.createElement(core.elements.global:getConsumer(), {
        render = function(global)
            local tabs = {}
            for _, tab in ipairs(script.Tabs:GetChildren()) do
                tabs[tab.Name] = core.roact.createElement(require(tab)(self.Menu))
            end

            return core.roact.createElement("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(.5, .5),
                Size = UDim2.fromScale(1, 1),
                Visible = false,
                [core.roact.Ref] = function(rbx) self.Frame = rbx end
            }, {
                [1] = core.roact.createFragment(tabs),
                ["Invoice"] = core.roact.createElement(require(script.invoice), {
                    [core.roact.Ref] = function(rbx) self.Invoice = rbx end
                }),
                ["CatogoryLabel"] = core.roact.createElement("TextLabel", {
                    AnchorPoint = Vector2.new(.5, 0),
                    BackgroundColor3 = global.theme.BgClr,
                    Position = core.scale.udim2.new(.5, 0, 0, 150),
                    Size = core.scale.udim2.fromOffset(300, 50),
                    ZIndex = 2,
                    Font = Enum.Font.SourceSansBold,
                    Text = "",
                    TextColor3 = global.theme.TextClr,
                    TextSize = core.scale:getTextSize(30),
                    [core.roact.Ref] = function(rbx) self.Label = rbx end
                }, {
                    ["Corner"] = core.roact.createElement(core.elements.UICorner),
                    ["Shadow"] = core.roact.createElement("Frame", {
                        AnchorPoint = Vector2.new(.5, .5),
                        BackgroundColor3 = core.color.shade(global.theme.BgClr, .5),
                        Position = core.scale.udim2.new(.5, 0, .5, 5),
                        Size = UDim2.fromScale(1, 1),
                        ZIndex = 1
                    }, {
                        ["Corner"] = core.roact.createElement(core.elements.UICorner)
                    }),
                    ["LeftButton"] = core.roact.createElement(core.elements.TextButton, {
                        AnchorPoint = Vector2.new(1, .5),
                        Position = core.scale.udim2.new(0, -5, .5, 0),
                        Size = core.scale.udim2.new(0, 50, 1, 0),
                        Font = Enum.Font.SourceSansBold,
                        Text = "<",
                        TextSize = core.scale:getTextSize(40),
                        [core.roact.Ref] = function(rbx) self.LeftButton = rbx end
                    }),
                    ["RightButton"] = core.roact.createElement(core.elements.TextButton, {
                        AnchorPoint = Vector2.new(0, .5),
                        Position = core.scale.udim2.new(1, 5, .5, 0),
                        Size = core.scale.udim2.new(0, 50, 1, 0),
                        Font = Enum.Font.SourceSansBold,
                        Text = ">",
                        TextSize = core.scale:getTextSize(40),
                        [core.roact.Ref] = function(rbx) self.RightButton = rbx end
                    })
                }),
                ["ExitButton"] = core.roact.createElement(core.elements.TextButton, {
                    AnchorPoint = Vector2.new(.5, 1),
                    BackgroundColor3 = global.theme.ExitBgClr,
                    Position = core.scale.udim2.new(.5, 0, 1, -150),
                    Size = core.scale.udim2.fromOffset(200, 50),
                    Font = Enum.Font.SourceSansSemibold,
                    Text = "Exit",
                    TextColor3 = global.theme.ExitTextClr,
                    TextSize = core.scale:getTextSize(30),
                    [core.roact.Ref] = function(rbx) self.ExitButton = rbx end
                }),
                ["Open"] = core.roact.createElement("BindableEvent", { [core.roact.Ref] = function(rbx) self.OpenEvent = rbx end }),
                --["Close"] = core.roact.createElement("BindableEvent", { [core.roact.Ref] = function(rbx) self.CloseEvent = rbx end }),
                ['Exit'] = core.roact.createElement("BindableEvent", { [core.roact.Ref] = function(rbx) self.ExitEvent = rbx end })
            })
        end
    })
end

function element:updateCamera(tabName, tween)
    local camera = self.Cameras[tabName]
    if camera then
        if tween then
            local tw = cameraUtils.tween(camera.PrimaryPart.CFrame, TweenInfo.new(
                .5,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.InOut
            ))
            tw:Play()
            wait(.5)
        else
            cameraUtils.getCamera().CFrame = camera.PrimaryPart.CFrame
        end
    end
end

function element:didMount()
    local parent = self.Frame.Parent

    self.ExitButton.Activated:Connect(function()
        --Close current Frame and this Frame
        self.Frame.Visible = false
        self.Data.car.Paint:reset()
        self.Data.car.Icons:reset()

        --Fire the exit event on all subFrames so they know that they need to cleanup their mess
        self.Menu:exit(self.Data)

        --Reset Camera to default postion
        self.Menu:reset(self.Data)
        self.Label.Text = self.Menu.Current.Name
        self:updateCamera(self.Menu.Current.Name, false)

        --Fire exit event so the client listener nows were ready
        self.ExitEvent:Fire()
    end)

    --Cycle left in the list
    self.LeftButton.Activated:Connect(function()
        self.LeftButton.Active = false
        self.RightButton.Active = false
        self.Menu:select(nil, self.Data)
        self.Menu:cycleUp()
        self:updateCamera(self.Menu.Current.Name, true)
        self.Menu:selectCurrent(self.Data)
        self.LeftButton.Active = true
        self.RightButton.Active = true
    end)

    --Cycle right in the list
    self.RightButton.Activated:Connect(function()
        self.LeftButton.Active = false
        self.RightButton.Active = false
        self.Menu:select(nil, self.Data)
        self.Menu:cycleDown()
        self:updateCamera(self.Menu.Current.Name, true)
        self.Menu:selectCurrent(self.Data)
        self.LeftButton.Active = true
        self.RightButton.Active = true
    end)

    self.OpenEvent.Event:Connect(function(cameras, data)
        --Setup Data
        self.Cameras = cameras
        self.Data = data
        self.Data.car = car.new(self.Data.car)
        self.Data.invoice = self.Invoice
        for i, l in ipairs(self.Data.lights) do
            self.Data.lights[i] = light.new(l)
        end

        self.Menu:init(self.Data)

        --Open Frame and setup Camera
        self.Frame.Visible = true
        self.Menu:reset()
        self.Label.Text = self.Menu.Current.Name
        self:updateCamera(self.Menu.Current.Name, true)
        self.Menu:selectCurrent(self.Data)
    end)
end

return element