local CS = game:GetService("CollectionService")

local content = require(game.ServerScriptService.Objects.modules.content)
local door = require(script.door)
local wheel = require(script.wheel)

local car = {}
car.__index = car

--===============================================================================================================--
--===============================================/     Utils     /===============================================--

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

local function weldParent(parent, massless)
    local function inner(parent)
        for _, child in ipairs(parent:GetChildren()) do
            if child:IsA("Model") and child.Name ~= "Wheels" and child.Name ~= "Doors" then

                if child.PrimaryPart then
                    createWeld(inner(child).PrimaryPart, parent:IsA("Model") and parent.PrimaryPart or parent).Parent = child.PrimaryPart
                else
                    warn(("Model %s has no PrimaryPart!"):format(child.Name))
                    child:Destroy()
                end

            elseif child:IsA("Seat") or child:IsA("VehicleSeat") then

                createWeld(inner(child), parent:IsA("Model") and parent.PrimaryPart or parent).Parent = child

            elseif child:IsA("BasePart") and child.Name ~= "LeftSteer" and child.Name ~= "RightSteer" then

                child.Massless = massless
                createWeld(child, parent:IsA("Model") and parent.PrimaryPart or parent).Parent = child

            elseif child.Name ~= "Wheels" and child.Name ~= "Doors" then
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

function car.new(player, model)
    local newCar = setmetatable({}, car)

    local cf, size = model:GetBoundingBox()
    newCar.Mass = Instance.new("Part")
    newCar.Mass.Name = "Mass"
    newCar.Mass.Size = size
    newCar.Mass.CFrame = cf
    newCar.Mass.Transparency = 1
    newCar.Mass.CanCollide = false
    newCar.Mass.Material = "Plastic"
    newCar.Mass.Parent = model

    createWeld(newCar.Mass, model.Body.PrimaryPart).Parent = newCar.Mass
    newCar.Mass:SetAttribute("CarOwner", player.UserId)

    model.PrimaryPart = newCar.Mass

    CS:AddTag(model, "Car")

    newCar.Stats = {
        Acceleration = model:GetAttribute("Acceleration") or 50,
        Torque = model:GetAttribute("Torque") or 100,
        MaxAngle = model:GetAttribute("MaxAngle") or 25,
        MaxSpeed = model:GetAttribute("MaxSpeed") or 30,
        TurnSpeed = model:GetAttribute("TurnSpeed") or 1,
        MaxVolume = model:GetAttribute("MaxVolume") or 100
    }

    newCar.Model = weldParent(model, true)
    newCar.Body = model.Body
    newCar.Doors = {}
    newCar.Locked = false

    newCar.Content = content.new(model.Content, newCar.Stats.MaxVolume)

    local lockEvent = Instance.new("BindableEvent")
    lockEvent.Event:Connect(function(boolean)
        newCar.Locked = boolean
    end)
    lockEvent.Name = "Lock"
    lockEvent.Parent = model

    newCar.Steer = {}
    newCar.Motor = {}

    --==============================[Setup Wheels]==============================--
    for _, axis in ipairs(model.Wheels:GetChildren()) do
        for _, child in ipairs(axis:GetChildren()) do
            if child:IsA("Model") then
                local point = model.Body.PrimaryPart.CFrame:PointToObjectSpace(child.PrimaryPart.CFrame.Position)
                if axis.Name == "SteerAxis" then
                    table.insert(newCar.Steer, wheel.steerWheel.new(weldParent(child, false), (point.X > 0 and axis.Left or axis.Right), axis.PrimaryPart, newCar.Body, newCar.Stats))
                elseif axis.Name == "MotorAxis" then
                    table.insert(newCar.Motor, wheel.motorWheel.new(weldParent(child, false), axis.Motor, newCar.Stats))
                else
                    warn(("Axis %s in not supported!"):format(axis.Name))
                end
            end
        end
        createWeld(axis.PrimaryPart, model.Chassis.PrimaryPart).Parent = axis.PrimaryPart
    end

    --==============================[Setup Doors]==============================--
    local seats = {}
    for _, child in ipairs(model:GetChildren()) do
        if child:IsA("Seat") or child:IsA("VehicleSeat") then
            table.insert(seats, child)
        end
    end

    for _, child in ipairs(model.Doors:GetChildren()) do
        table.insert(newCar.Doors, door.new(weldParent(child, true), model.Body.PrimaryPart, seats))
    end

    --==============================[Setup Events]==============================--
    local driverSeat = model:FindFirstChildWhichIsA("VehicleSeat")
    if driverSeat then
        driverSeat:GetPropertyChangedSignal("ThrottleFloat"):Connect(function()
            if not newCar.Locked then
                for _, motor in pairs(newCar.Motor) do
                    motor:throttle(driverSeat.ThrottleFloat, newCar.Stats.MaxSpeed)
                end
            end
        end)
        driverSeat:GetPropertyChangedSignal("Steer"):Connect(function()
            if not newCar.Locked then
                for _, steer in pairs(newCar.Steer) do
                    steer:steer(driverSeat.Steer, newCar.Stats.MaxAngle)
                end
            end
        end)
    else
        warn(("No VehicleSeat found in car %s!"):format(model.Name))
    end

    return newCar
end

function car:color(brickColor)
    for _, descendant in ipairs(self.Body:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.BrickColor = brickColor
        end
    end

    for _, dr in ipairs(self.Doors) do
        dr:color(brickColor)
    end
end

function car:material(material)
    for _, descendant in ipairs(self.Body:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.Material = material
        end
    end

    for _, dr in ipairs(self.Doors) do
        dr:material(material)
    end
end

function car:wheelCapColor(brickColor)
    for _, steer in ipairs(self.Steer) do
        steer:color(brickColor)
    end
    for _, motor in ipairs(self.Motor) do
        motor:color(brickColor)
    end
end

function car:wheelCapMaterial(material)
    for _, steer in ipairs(self.Steer) do
        steer:material(material)
    end
    for _, motor in ipairs(self.Motor) do
        motor:material(material)
    end
end

function car:destroy()
    self.Model:Destroy()
end

--===============================================/      Car      /===============================================--
--===============================================================================================================--

return car