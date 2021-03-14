local wheel = {}
wheel.__index = wheel

local function vector3Abs(vector)
    return Vector3.new(
        math.abs(vector.X),
        math.abs(vector.Y),
        math.abs(vector.Z)
    )
end

local function createNoCollision(part0, part1)
    local noCollision = Instance.new("NoCollisionConstraint")
    noCollision.Part0 = part0
    noCollision.Part1 = part1
    return noCollision
end

local function createSteer(part0, part1, stats)
    part0.Anchored = false
    part1.Anchored = false

    local steer = Instance.new("HingeConstraint")
    steer.Name = "Steer"
    steer.ServoMaxTorque = math.huge
    steer.ActuatorType = Enum.ActuatorType.Servo

    local normal = CFrame.new(part0.Position, part1.Position)

    local attachment0 = Instance.new("Attachment")
    attachment0.Position = part0.CFrame.UpVector * vector3Abs(part1.CFrame:VectorToWorldSpace(part1.Size)) * .5
    attachment0.Axis = -part0.CFrame.UpVector
    attachment0.SecondaryAxis = normal.LookVector
    attachment0.Parent = part0

    local attachment1 = Instance.new("Attachment")
    attachment1.Position = part1.CFrame:PointToObjectSpace(attachment0.WorldPosition)
    attachment1.Axis = -part1.CFrame.UpVector
    attachment1.SecondaryAxis = -normal.LookVector
    attachment1.Parent = part1

    steer.Attachment0 = attachment1
    steer.Attachment1 = attachment0

    steer.LimitsEnabled = true
    steer.UpperAngle = stats.MaxAngle
    steer.LowerAngle = -stats.MaxAngle
    steer.AngularSpeed = stats.TurnSpeed
    return steer
end

local function createHinge(part0, part1)
    part0.Anchored = false
    part1.Anchored = false

    local hinge = Instance.new("HingeConstraint")
    hinge.Name = "Hinge"
    hinge.ActuatorType = Enum.ActuatorType.None

    local part0NormalCF = CFrame.new(part0.Position, part1.Position)
    local att0WorldPos = (part0NormalCF + part0NormalCF.LookVector * vector3Abs(part0.CFrame:VectorToWorldSpace(part0.Size)) * .5).Position

    local part1NormalCF = CFrame.new(part1.Position, part0.Position)
    local att1WorldPos = (part1NormalCF + part1NormalCF.LookVector * vector3Abs(part1.CFrame:VectorToWorldSpace(part1.Size)) * .5).Position

    local attachment0 = Instance.new("Attachment")
    attachment0.Position = part0.CFrame:PointToObjectSpace(att0WorldPos)
    attachment0.Axis = part0NormalCF.LookVector

    local x0, y0, z0 = (part0.CFrame * CFrame.Angles(0, math.pi, 0)):ToEulerAnglesYXZ()
    attachment0.Orientation = Vector3.new(math.deg(x0), math.deg(y0), math.deg(z0))
    attachment0.Parent = part0
    hinge.Attachment0 = attachment0

    local attachment1 = Instance.new("Attachment")
    attachment1.Position = part1.CFrame:PointToObjectSpace(att1WorldPos)
    attachment1.Axis = part1NormalCF.LookVector

    local x1, y1, z1 = (part1.CFrame * CFrame.Angles(0, math.pi, 0)):ToEulerAnglesYXZ()
    attachment1.Orientation = Vector3.new(math.deg(x1), math.deg(y1), math.deg(z1))
    attachment1.Parent = part1
    hinge.Attachment1 = attachment1

    return hinge
end

local function createMotor(part0, part1, stats)
    part0.Anchored = false
    part1.Anchored = false

    local motor = Instance.new("HingeConstraint")
    motor.Name = "Motor"
    motor.ActuatorType = Enum.ActuatorType.Motor

    local part0NormalCF = CFrame.new(part0.Position, part1.Position)
    local att0WorldPos = (part0NormalCF + part0NormalCF.LookVector * vector3Abs(part0.CFrame:VectorToWorldSpace(part0.Size)) * .5).Position

    local part1NormalCF = CFrame.new(part1.Position, part0.Position)
    local att1WorldPos = (part1NormalCF + part1NormalCF.LookVector * vector3Abs(part1.CFrame:VectorToWorldSpace(part1.Size)) * .5).Position

    local attachment0 = Instance.new("Attachment")
    attachment0.Position = part0.CFrame:PointToObjectSpace(att0WorldPos)
    attachment0.Axis = part0NormalCF.LookVector

    local x0, y0, z0 = (part0.CFrame * CFrame.Angles(0, math.pi, 0)):ToEulerAnglesYXZ()
    attachment0.Orientation = Vector3.new(math.deg(x0), math.deg(y0), math.deg(z0))
    attachment0.Parent = part0
    motor.Attachment0 = attachment0

    local attachment1 = Instance.new("Attachment")
    attachment1.Position = part1.CFrame:PointToObjectSpace(att1WorldPos)
    attachment1.Axis = part1NormalCF.LookVector

    local x1, y1, z1 = (part1.CFrame * CFrame.Angles(0, math.pi, 0)):ToEulerAnglesYXZ()
    attachment1.Orientation = Vector3.new(math.deg(x1), math.deg(y1), math.deg(z1))
    attachment1.Parent = part1
    motor.Attachment1 = attachment1

    motor.MotorMaxAcceleration = stats.Acceleration
    motor.MotorMaxTorque = stats.Torque
    return motor
end

local steerWheel = {}
steerWheel.__index = steerWheel

function steerWheel.new(wheelModel, attachPart, rack, carBody, stats)
    local newWheel = setmetatable({}, steerWheel)

    local SIZE_OFFSET = Vector3.new(1, 1, 1) * 5
    local cf, size = wheelModel:GetBoundingBox()
    local region = Region3.new(cf.Position - (size * .5 + SIZE_OFFSET), cf.Position + (size * .5 + SIZE_OFFSET))

    local parts = workspace:FindPartsInRegion3WithWhiteList(region, {carBody}, 100)
    for _, part in ipairs(carBody:GetChildren()) do
        if part:IsA("BasePart") then
            createNoCollision(wheelModel.PrimaryPart, part).Parent = wheelModel.PrimaryPart
        end
    end

    newWheel.Model = wheelModel

    newWheel.Steer = createSteer(attachPart, rack, stats)
    newWheel.Steer.Parent = wheelModel

    newWheel.Hinge = createHinge(wheelModel.Axis, attachPart)
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

local motorWheel = {}
motorWheel.__index = motorWheel

function motorWheel.new(wheelModel, attachPart, stats)
    local newWheel = setmetatable({}, motorWheel)

    newWheel.Model = wheelModel

    newWheel.Motor = createMotor(wheelModel.Axis, attachPart, stats)
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

return {
    steerWheel = steerWheel,
    motorWheel = motorWheel
}