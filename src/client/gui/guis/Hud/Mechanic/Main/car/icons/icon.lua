local wheelIconsFolder = game:GetService("ReplicatedStorage"):WaitForChild("WheelIcons")

local icon = {}
icon.__index = icon

local function createWeld(part0, part1)
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = part0
    weld.Part1 = part1
    weld.Parent = part0
    return weld
end

function icon.new(model : Model, iconName : string)
    local self = setmetatable({}, icon)
    self.Wheel = model
    self.Logo = model.Logo
    self.Logo.Transparency = 1

    self.Connections = {}
    table.insert(self.Connections, self.Logo:GetPropertyChangedSignal("BrickColor"):Connect (function()
        self:set(self.LastIconName)
    end))

    self:set(iconName)
    return self
end

function icon:refresh(iconName)
    self.Logo = self.Wheel.Logo
    self.Logo.Transparency = 1
    self:set(iconName)
end

function icon:set(name : string)
    self.LastIconName = name
    if self.TempIcon then
        self.TempIcon:Destroy()
    end

    self.TempIcon = wheelIconsFolder:FindFirstChild(name or "")
    self.TempIcon = self.TempIcon and self.TempIcon:Clone() or nil
    if self.TempIcon then
        local ratio = math.max(self.Logo.Size.X, self.Logo.Size.Z) / math.max(self.TempIcon.Size.X, self.TempIcon.Size.Z)

        self.TempIcon.Size = Vector3.new(
            self.TempIcon.Size.X * ratio,
            self.Logo.Size.Y,
            self.TempIcon.Size.Z * ratio
        )
        self.TempIcon.CFrame = self.Logo.CFrame
        self.TempIcon.Parent = self.Wheel

        self.TempIcon.BrickColor = self.Logo.BrickColor
        self.TempIcon.Material = self.Logo.Material

        createWeld(self.TempIcon, self.Wheel.PrimaryPart)
    else
        warn(("Icon with the name %s does not exist!"):format(name))
    end
end

function icon:cleanup()
    for _, conn in ipairs(self.Connections) do
        conn:Disconnect()
    end
    if self.TempIcon then
        self.TempIcon:Destroy()
    end
    self.Logo.Transparency = 0
end

return icon