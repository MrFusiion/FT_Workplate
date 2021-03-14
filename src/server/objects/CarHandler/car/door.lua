local door = {}
door.__index = door

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

local function createDoorHinge(doorModel, part)
    doorModel.PrimaryPart.Anchored = false
    part.Anchored = false

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

function door.new(doorModel, carBodyPart, seats)
    local newDoor = setmetatable({}, door)

    local offset = doorModel.PrimaryPart.CFrame:PointToObjectSpace(carBodyPart.Position)

    newDoor.Model = doorModel
    newDoor.Sign = -math.sign(offset.X)
    newDoor.Open = false

    newDoor.Hinge = createDoorHinge(doorModel, carBodyPart)
    newDoor.Hinge.Parent = doorModel

    local cf, size = doorModel:GetBoundingBox()
    local boundingBox = Instance.new("Part")
    boundingBox.Transparency = 1
    boundingBox.CanCollide = false
    boundingBox.Size = size
    boundingBox.CFrame = cf
    boundingBox.Parent = doorModel
    createWeld(boundingBox, doorModel.PrimaryPart).Parent = boundingBox

    local closestSeat
    for _, seat in ipairs(seats) do
        if not closestSeat then
            closestSeat = seat
        elseif (closestSeat.Position - cf.Position).Magnitude > (seat.Position - cf.Position).Magnitude then
            closestSeat = seat
        end
    end
    closestSeat:GetPropertyChangedSignal("Occupant"):Connect(function()
        if closestSeat.Occupant then
            newDoor:close()
        else
            newDoor:open()
        end
    end)

    local click = Instance.new("ClickDetector")
    click.MaxActivationDistance = 30
    click.CursorIcon = "rbxasset://textures/ArrowCursor.png"
    click.MouseClick:Connect(function()
        if newDoor.Open then
            newDoor:close()
        else
            newDoor:open()
        end
    end)
    click.Parent = boundingBox

    return newDoor
end

function door:open()
    self.Open = true
    self.Hinge.TargetAngle = self.Sign * 70
end

function door:close()
    self.Open = false
    self.Hinge.TargetAngle = 0
end

function door:color(brickColor)
    for _, descendant in ipairs(self.Model.Body:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.BrickColor = brickColor
        end
    end
end

function door:material(material)
    for _, descendant in ipairs(self.Model.Body:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.Material = material
        end
    end
end

return door