local TS = game:GetService("TweenService")

local core = require(game:GetService("StarterPlayer").StarterPlayerScripts.gui.core)

local function createWeld(part0, part1)
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = part0
    weld.Part1 = part1
    weld.Parent = part0
    part0.Anchored = false
    return weld
end

local wheelIconsFolder = game:GetService("ReplicatedStorage"):WaitForChild("WheelIcons")
local function getImage(iconName)
    local icon = wheelIconsFolder:FindFirstChild(iconName)
    if icon then
        return icon:GetAttribute("Image")
    end
end

local function getPrice(iconName)
    local icon = wheelIconsFolder:FindFirstChild(iconName)
    if icon then
        return tonumber(icon:GetAttribute("Price") or 0)
    end
end

local wheels = {}
for i, wheel in ipairs(game:GetService("ReplicatedStorage"):WaitForChild("Wheels"):GetChildren()) do
    local clone = wheel:Clone()
    local part1 = clone.PrimaryPart
    for _, part0 in ipairs(clone:GetDescendants()) do
        if part0:IsA("BasePart") and part0 ~= part1 then
            createWeld(part0, part1)
        end
    end
    part1.Anchored = true
    wheels[wheel.Name] = clone
end

local holder = {}
holder.__index = holder

function holder.new(model, WheelSize, data)
    local self = {}
    self.Car = data.car
    self.Ref = model.PrimaryPart

    self.Label = model.Gui.Surface.TextLabel
    self.Image = model.Gui.Surface.ImageLabel

    self.Click = Instance.new("ClickDetector")
    self.Click.CursorIcon = "rbxasset://textures/ArrowCursor.png"
    self.Click.MouseClick:Connect(function()
        if self.Active then
            self.Car.Icons:set(self.Icon.Name)
            data.invoice.Add:Invoke("Icon", getPrice(self.Icon.Name), nil, getImage(self.Icon.Name)):Connect(function()
                self.Car.Icons:reset()
            end)
            --self.Car.SetIcon:FireServer(self.Icon.Name)
        end
    end)
    self.Click.MouseHoverEnter:Connect(function()
        if self.Active then
            self:highlight(true)
        end
    end)
    self.Click.MouseHoverLeave:Connect(function()
        if self.Active then
            self:highlight(false)
        end
    end)
    self.Click.Parent = self.Ref

    self.WheelRef = wheels[WheelSize]
    return setmetatable(self, holder)
end

function holder:setActive(boolean)
    if not boolean then
        self:highlight(false)
    end
    self.Active = boolean
end

function holder:highlight(boolean)
    if boolean then
        if self.Current and self.Current.PrimaryPart then
            local tween = TS:Create(self.Current.PrimaryPart, TweenInfo.new(
                .1,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.Out
            ), {
                CFrame = self.Ref.CFrame * CFrame.new(.5, .5, 0),
            }):Play()
        end
    else
        if self.Current and self.Current.PrimaryPart then
            local tween = TS:Create(self.Current.PrimaryPart, TweenInfo.new(
                .1,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.In
            ), {
                CFrame = self.Ref.CFrame,
            }):Play()
        end
    end
end

function holder:updateColor(wheelcapColor, iconColor)
    if self.Current and wheelcapColor then
        self.Current.WheelCap.BrickColor = wheelcapColor
    end

    if self.Icon and iconColor then
        self.Icon.BrickColor = iconColor
    end

    self.WheelcapColor = wheelcapColor or self.WheelcapColor
    self.IconColor = iconColor or self.IconColor
end

function holder:set(icon)
    self.Icon = icon
    if self.Current then
        self.Current:Destroy()
        self.Current = nil
    end

    if icon then
        self.Current = self.WheelRef:Clone()

        local logo = self.Current.Logo
        local ratio = math.max(logo.Size.X, logo.Size.Z) / math.max(icon.Size.X, icon.Size.Z)

        icon.Anchored = true
        icon.Size = Vector3.new(
            icon.Size.X * ratio,
            logo.Size.Y,
            icon.Size.Z * ratio
        )
        icon.CFrame = logo.CFrame
        icon.Parent = self.Current

        icon.BrickColor = self.IconColor or logo.BrickColor
        icon.Material = logo.Material

        createWeld(icon, self.Current.PrimaryPart)

        logo:Destroy()

        self.Current.WheelCap.BrickColor = self.WheelcapColor or self.Current.WheelCap.BrickColor

        self.Current:SetPrimaryPartCFrame(self.Ref.CFrame)
        self.Current.Parent = self.Ref
    end

    self:updateState()
end

function holder:updateState()
    if not self.Icon then
        self:hideState()
    else
        self:showState()
        if self.Car.Model:GetAttribute("WheelIcon") == self.Icon.Name then
            self.Image.ImageTransparency = 0
            self.Label.TextColor3 = Color3.fromRGB(3, 137, 255)
            self.Label.Text = "ACTIVE"
        else
            self.Image.ImageTransparency = 1
            self.Label.TextColor3 = Color3.fromRGB(0, 170, 0)

            local price = self.Icon:GetAttribute("Price")
            self.Label.Text = ("$ %s"):format(core.subfix.addSubfix(price, 1))
        end
    end
end

function holder:hideState()
    self.Label.Visible = false
    self.Image.Visible = false
end

function holder:showState()
    self.Label.Visible = true
    self.Image.Visible = true
end

function holder:destroy()
    self:set()
    self.Click:Destroy()
end

return holder