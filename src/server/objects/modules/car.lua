local content = require(script.Parent.content)

local car = {}
car.__index = car

--===============================================================================================================--
--===============================================/     Utils     /===============================================--

local function createMotor(part0, part1, stats)
    part0.Anchored = false
    part1.Anchored = false

    local motor = Instance.new("HingeConstraint")
    motor.Name = "Motor"
    motor.ActuatorType = Enum.ActuatorType.Motor

    local offset = part0.CFrame:PointToObjectSpace(part1.Position)
    local part0X = math.sign(offset.X) * part0.Size.X * .5
    local part1X = -math.sign(offset.X) * part1.Size.X * .5

    local attachment0 = Instance.new("Attachment")
    attachment0.Position = Vector3.new(part0X, 0, 0)
    attachment0.Parent = part0

    local attachment1 = Instance.new("Attachment")
    attachment1.Position = Vector3.new(part1X, 0, 0)
    attachment1.Parent = part1

    motor.Attachment0 = attachment0
    motor.Attachment1 = attachment1

    motor.MotorMaxAcceleration = stats.Acceleration
    motor.MotorMaxTorque = stats.Torque
    return motor
end

local function createSteer(part0, part1, stats)
    part0.Anchored = false
    part1.Anchored = false

    local steer = Instance.new("HingeConstraint")
    steer.Name = "Steer"
    steer.ServoMaxTorque = 9999999
    steer.ActuatorType = Enum.ActuatorType.Servo

    local offset = part0.CFrame:PointToObjectSpace(part1.Position)

    local attachment0 = Instance.new("Attachment")
    attachment0.Position = Vector3.new(0, part0.Size.Y * .5, 0)
    attachment0.Axis = Vector3.new(0, -1, 0)
    attachment0.SecondaryAxis = Vector3.new(math.sign(offset.X), 0, 0)
    attachment0.Parent = part0

    local attachment1 = Instance.new("Attachment")
    attachment1.Position = part1.CFrame:PointToObjectSpace(attachment0.WorldPosition)
    attachment1.Axis = Vector3.new(0, -1, 0)
    attachment1.SecondaryAxis = Vector3.new(-math.sign(offset.X), 0, 0)
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

    local offset = part0.CFrame:PointToObjectSpace(part1.Position)
    local part0X = math.sign(offset.X) * part0.Size.X * .5
    local part1X = -math.sign(offset.X) * part1.Size.X * .5

    local attachment0 = Instance.new("Attachment")
    attachment0.Position = Vector3.new(part0X, 0, 0)
    attachment0.Parent = part0

    local attachment1 = Instance.new("Attachment")
    attachment1.Position = Vector3.new(part1X, 0, 0)
    attachment1.Parent = part1

    hinge.Attachment0 = attachment0
    hinge.Attachment1 = attachment1
    return hinge
end

local function createNoCollision(part0, part1)
    local noCollision = Instance.new("NoCollisionConstraint")
    noCollision.Part0 = part0
    noCollision.Part1 = part1
    return noCollision
end

local function createWeld(part0, part1)
    part0.Anchored = false
    part1.Anchored = false

    local weld = Instance.new("Weld")
    weld.Part0 = part0
    weld.Part1 = part1
    weld.C0 = part0.CFrame:Inverse()
    weld.C1 = part1.CFrame:Inverse()
    return weld
end

local function weldParent(parent)
    local function inner(parent)
        for _, child in ipairs(parent:GetChildren()) do
            if child:IsA("Model") and child.Name ~= "Wheels" then
                if child.PrimaryPart then
                    createWeld(inner(child).PrimaryPart, parent:IsA("Model") and parent.PrimaryPart or parent).Parent = child.PrimaryPart
                else
                    warn(("Model %s has no PrimaryPart!"):format(child.Name))
                    child:Destroy()
                end
            elseif child:IsA("Seat") or child:IsA("VehicleSeat") then
                createWeld(inner(child), parent:IsA("Model") and parent.PrimaryPart or parent).Parent = child
            elseif child:IsA("BasePart") and child.Name ~= "LeftSteer" and child.Name ~= "RightSteer" then
                createWeld(child, parent:IsA("Model") and parent.PrimaryPart or parent).Parent = child
            elseif child.Name ~= "Wheels" then
                warn(("Instance with ClassName %s is not supported!"):format(child.ClassName))
                child:Destroy()
            end
        end
        return parent
    end
    return inner(parent)
end

--===============================================/     Utils     /===============================================--
--===============================================================================================================--
--===============================================/      Car      /===============================================--

function car.new(model)
    local newCar = setmetatable({}, car)

    model.PrimaryPart = model.Body.PrimaryPart

    newCar.Stats = {
        Acceleration = model:GetAttribute("Acceleration") or 50,
        Torque = model:GetAttribute("Torque") or 100,
        MaxAngle = model:GetAttribute("MaxAngle") or 25,
        MaxSpeed = model:GetAttribute("MaxSpeed") or 30,
        TurnSpeed = model:GetAttribute("TurnSpeed") or 1,
        MaxVolume = model:GetAttribute("MaxVolume") or 100
    }

    newCar.Model = weldParent(model)
    newCar.Chassis = model.Chassis
    newCar.Body = model.Body
    newCar.Lights = model.Lights
    newCar.Wheels = model.Wheels

    newCar.Content = content.new(model.Content, newCar.Stats.MaxVolume)

    newCar.Steer = {}
    newCar.Motor = {}
    newCar.Hinge = {}

    for _, axis in ipairs(newCar.Wheels:GetChildren()) do
        for _, child in ipairs(axis:GetChildren()) do
            if child:IsA("Model") then
                weldParent(child)

                for _, descendant in ipairs(newCar.Body:GetDescendants()) do
                    if descendant:IsA("BasePart") then
                        createNoCollision(child.PrimaryPart, descendant).Parent = child.PrimaryPart
                    end
                end

                local point = newCar.Body.PrimaryPart.CFrame:PointToObjectSpace(child.PrimaryPart.CFrame.Position)
                if axis.Name == "SteerAxis" then
                    local steer = createSteer(point.X > 0 and axis.Left or axis.Right, axis.PrimaryPart, newCar.Stats)
                    steer.Parent = newCar.Model
                    table.insert(newCar.Steer, steer)

                    local hinge = createHinge(child.Axis, point.X > 0 and axis.Left or axis.Right)
                    hinge.Parent = newCar.Model
                    table.insert(newCar.Hinge, hinge)
                elseif axis.Name == "MotorAxis" then
                    local motor = createMotor(child.Axis, axis.Motor, newCar.Stats)
                    motor.Parent = newCar.Model
                    table.insert(newCar.Motor, motor)
                else
                    warn(("Axis %s in not supported!"):format(axis.Name))
                end
            end
        end
        createWeld(axis.PrimaryPart, newCar.Chassis.PrimaryPart).Parent = axis.PrimaryPart
    end

    local driverSeat = model:FindFirstChildWhichIsA("VehicleSeat")
    if driverSeat then
        driverSeat:GetPropertyChangedSignal("ThrottleFloat"):Connect(function()
            newCar:throttle(driverSeat.ThrottleFloat)
        end)
        driverSeat:GetPropertyChangedSignal("Steer"):Connect(function()
            newCar:steer(driverSeat.Steer)
        end)
    else
        warn(("No VehicleSeat found in car %s!"):format(model.Name))
    end

    return newCar
end

function car:steer(value)
    for _, steer in pairs(self.Steer) do
        local angle = math.abs(math.min(steer.LowerAngle, steer.UpperAngle))
        steer.TargetAngle = angle * value
    end
end

function car:throttle(value)
    for _, motor in pairs(self.Motor) do
        local maxSpeed = self.Stats.MaxSpeed
        motor.AngularVelocity = maxSpeed * value
    end
end

function car:destroy()
    self.Model:Destroy()
end

--===============================================/      Car      /===============================================--
--===============================================================================================================--

return car