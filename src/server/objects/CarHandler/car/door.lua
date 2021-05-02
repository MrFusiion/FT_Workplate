local utils = require(script.Parent.utils)

local door = {}
door.__index = door

local SIZE_OFFSET = .01
function door.new(doorModel, carBodyPart, seats)
    local newDoor = setmetatable({}, door)

    local offset = doorModel.PrimaryPart.CFrame:PointToObjectSpace(carBodyPart.Position)

    newDoor.Model = doorModel
    newDoor.Sign = -math.sign(offset.X)
    newDoor.Open = false

    newDoor.CanOpen = true

    newDoor.Hinge = utils.createDoorHinge(doorModel, carBodyPart)
    newDoor.Hinge.Parent = doorModel

    local cf, size = doorModel:GetBoundingBox()
    local boundingBox = Instance.new("Part")
    boundingBox.Transparency = 1
    boundingBox.CanCollide = false
    boundingBox.Size = size + Vector3.new(1, 1, 1) * SIZE_OFFSET
    boundingBox.CFrame = cf
    boundingBox.Parent = doorModel
    utils.weld(boundingBox, doorModel.PrimaryPart).Parent = boundingBox

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
            if newDoor.CanOpen  then
                newDoor:open()
            end
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