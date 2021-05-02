local utils = require(script.Parent.utils)

local iconFolder = game:GetService("ReplicatedStorage"):WaitForChild("WheelIcons")
function setWheelIcon(wheel, iconName)

    local icon = iconFolder:FindFirstChild(iconName)
    if icon then
        icon = icon:Clone()

        local logo = wheel.Logo
        local ratio = math.max(logo.Size.X, logo.Size.Z) / math.max(icon.Size.X, icon.Size.Z)

        icon.Anchored = true
        icon.Size = Vector3.new(
            icon.Size.X * ratio,
            logo.Size.Y,
            icon.Size.Z * ratio
        )
        icon.CFrame = logo.CFrame
        icon.Parent = wheel

        icon.BrickColor = logo.BrickColor
        icon.Material = logo.Material

        utils.weld(icon, wheel.PrimaryPart).Parent = icon

        logo:Destroy()

        icon.Name = "Logo"
    else
        warn(("Icon %s cannot be found!"):format(iconName))
    end
end

local steerWheel = {}
steerWheel.__index = steerWheel

function steerWheel.new(wheelModel, attachPart, rack, carBody, stats)
    local newWheel = setmetatable({}, steerWheel)

    local SIZE_OFFSET = Vector3.new(1, 1, 1) * 5
    local cf, size = wheelModel:GetBoundingBox()
    local region = Region3.new(cf.Position - (size * .5 + SIZE_OFFSET), cf.Position + (size * .5 + SIZE_OFFSET))

    --[[
    local parts = workspace:FindPartsInRegion3WithWhiteList(region, {carBody}, 100)
    for _, part in ipairs(carBody:GetChildren()) do
        if part:IsA("BasePart") then
            createNoCollision(wheelModel.PrimaryPart, part).Parent = wheelModel.PrimaryPart
        end
    end]]

    newWheel.Model = wheelModel

    newWheel.Steer = utils.createSteer(attachPart, rack, stats)
    newWheel.Steer.Parent = wheelModel

    newWheel.Hinge = utils.createHinge(wheelModel.Axis, attachPart)
    newWheel.Hinge.Parent = wheelModel

    return newWheel
end

function steerWheel:steer(value, angle)
    self.Steer.TargetAngle = value * angle
end

function steerWheel:color(brickColor)
    for _, descendant in ipairs(self.Model:GetDescendants()) do
        if descendant.Name == "WheelCap" and descendant:IsA("BasePart") then
            descendant.BrickColor = brickColor
        end
    end
end

function steerWheel:material(material)
    for _, descendant in ipairs(self.Model:GetDescendants()) do
        if descendant.Name == "WheelCap" and descendant:IsA("BasePart") then
            descendant.Material = material
        end
    end
end

function steerWheel:setIcon(iconName)
    setWheelIcon(self.Model, iconName)
end

function steerWheel:iconColor(brickColor)
    self.Model.Logo.BrickColor = brickColor
end

function steerWheel:iconMaterial(material)
    self.Model.Logo.Material = material
end

local motorWheel = {}
motorWheel.__index = motorWheel

function motorWheel.new(wheelModel, attachPart, stats)
    local newWheel = setmetatable({}, motorWheel)

    newWheel.Model = wheelModel

    newWheel.Motor = utils.createMotor(wheelModel.Axis, attachPart, stats)
    newWheel.Motor.Parent = wheelModel

    return newWheel
end

function motorWheel:throttle(value, speed)
    self.Motor.AngularVelocity = value * speed
end

function motorWheel:color(brickColor)
    for _, descendant in ipairs(self.Model:GetDescendants()) do
        if descendant.Name == "WheelCap" and descendant:IsA("BasePart") then
            descendant.BrickColor = brickColor
        end
    end
end

function motorWheel:material(material)
    for _, descendant in ipairs(self.Model:GetDescendants()) do
        if descendant.Name == "WheelCap" and descendant:IsA("BasePart") then
            descendant.Material = material
        end
    end
end

function motorWheel:setIcon(iconName)
    setWheelIcon(self.Model, iconName)
end

function motorWheel:iconColor(brickColor)
    self.Model.Logo.BrickColor = brickColor
end

function motorWheel:iconMaterial(material)
    self.Model.Logo.Material = material
end

return {
    steerWheel = steerWheel,
    motorWheel = motorWheel
}