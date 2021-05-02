local PS = game:GetService("PhysicsService")

local utils = {}

function utils.setCarPartCollision(part)
    PS:SetPartCollisionGroup(part, "CarPart")
    return part
end

function utils.weld(part0, part1)
    part0.Anchored = false
    part1.Anchored = false

    utils.setCarPartCollision(part0)
    utils.setCarPartCollision(part1)

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = part0
    weld.Part1 = part1
    --weld.C0 = part0.CFrame:Inverse()
    --weld.C1 = part1.CFrame:Inverse()
    return weld
end

function utils.vector3Abs(vector)
    return Vector3.new(
        math.abs(vector.X),
        math.abs(vector.Y),
        math.abs(vector.Z)
    )
end

function utils.createSteer(part0, part1, stats)
    part0.Anchored = false
    part1.Anchored = false

    utils.setCarPartCollision(part0)
    utils.setCarPartCollision(part1)

    local steer = Instance.new("HingeConstraint")
    steer.Name = "Steer"
    steer.ServoMaxTorque = math.huge
    steer.ActuatorType = Enum.ActuatorType.Servo

    local normal = CFrame.new(part0.Position, part1.Position)

    local attachment0 = Instance.new("Attachment")
    attachment0.Position = part0.CFrame.UpVector * utils.vector3Abs(part1.CFrame:VectorToWorldSpace(part1.Size)) * .5
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
    steer.UpperAngle = stats.TurnAngle
    steer.LowerAngle = -stats.TurnAngle
    steer.AngularSpeed = stats.TurnSpeed
    return steer
end

function utils.createHinge(part0, part1)
    part0.Anchored = false
    part1.Anchored = false

    utils.setCarPartCollision(part0)
    utils.setCarPartCollision(part1)

    local hinge = Instance.new("HingeConstraint")
    hinge.Name = "Hinge"
    hinge.ActuatorType = Enum.ActuatorType.None

    local part0NormalCF = CFrame.new(part0.Position, part1.Position)
    local att0WorldPos = (part0NormalCF + part0NormalCF.LookVector * utils.vector3Abs(part0.CFrame:VectorToWorldSpace(part0.Size)) * .5).Position

    local part1NormalCF = CFrame.new(part1.Position, part0.Position)
    local att1WorldPos = (part1NormalCF + part1NormalCF.LookVector * utils.vector3Abs(part1.CFrame:VectorToWorldSpace(part1.Size)) * .5).Position

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

function utils.createMotor(part0, part1, stats)
    part0.Anchored = false
    part1.Anchored = false

    utils.setCarPartCollision(part0)
    utils.setCarPartCollision(part1)

    local motor = Instance.new("HingeConstraint")
    motor.Name = "Motor"
    motor.ActuatorType = Enum.ActuatorType.Motor

    local part0NormalCF = CFrame.new(part0.Position, part1.Position)
    local att0WorldPos = (part0NormalCF + part0NormalCF.LookVector * utils.vector3Abs(part0.CFrame:VectorToWorldSpace(part0.Size)) * .5).Position

    local part1NormalCF = CFrame.new(part1.Position, part0.Position)
    local att1WorldPos = (part1NormalCF + part1NormalCF.LookVector * utils.vector3Abs(part1.CFrame:VectorToWorldSpace(part1.Size)) * .5).Position

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

function utils.createDoorHinge(doorModel, part)
    doorModel.PrimaryPart.Anchored = false
    part.Anchored = false

    utils.setCarPartCollision(doorModel.PrimaryPart)
    utils.setCarPartCollision(part)

    local doorHinge = Instance.new("HingeConstraint")
    doorHinge.Name = "DoorHinge"
    doorHinge.AngularSpeed = 10
    doorHinge.ServoMaxTorque = math.huge
    doorHinge.LimitsEnabled = false
    doorHinge.LowerAngle = 0
    doorHinge.UpperAngle = 70
    doorHinge.ActuatorType = Enum.ActuatorType.Servo

    local cf, size = doorModel:GetBoundingBox()
    cf = cf + cf.LookVector * size.Z * .5 - cf.UpVector * size.Y * .5

    local attachment0 = Instance.new("Attachment")
    attachment0.Position = doorModel.PrimaryPart.CFrame:PointToObjectSpace(cf.Position)
    attachment0.Axis = Vector3.new(0, -1, 0)
    attachment0.SecondaryAxis = Vector3.new(0, 0, 1)
    attachment0.Parent = doorModel.PrimaryPart

    local attachment1 = Instance.new("Attachment")
    attachment1.Position = part.CFrame:PointToObjectSpace(cf.Position)
    attachment1.Axis = Vector3.new(0, -1, 0)
    attachment1.SecondaryAxis = Vector3.new(0, 0, 1)
    attachment1.Parent = part

    doorHinge.Attachment0 = attachment0
    doorHinge.Attachment1 = attachment1

    return doorHinge
end

return utils