local CS = game:GetService("CollectionService")

local content = require(game.ServerScriptService.Objects.modules.content)
local door = require(script.door)
local wheel = require(script.wheel)
local light = require(script.light)
local utils = require(script.utils)

local carFolder = game:GetService("ReplicatedStorage"):WaitForChild("Cars")

local server = require(game:GetService("ServerScriptService").Modules)
local datastore = server.get("datastore")

local shared = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"))
local mathUtils = shared.get("mathUtils")

local remoteMessage = game:GetService("ReplicatedStorage")
    :WaitForChild("remote")
    :WaitForChild("message")
local re_Notify = remoteMessage:WaitForChild("Notify")

local car = {}
car.__index = car

local REPAINT_PRICE = 50000
local function UPGRADE_PRICE(stage)
    local MODIFIER = 500
    return mathUtils.roundStep(MODIFIER * 3.25^stage, 500)
end

--===============================================================================================================--
--===============================================/     Utils     /===============================================--

local function weldParent(parent, massless)
    local function inner(parent)
        for _, child in ipairs(parent:GetChildren()) do
            if child:IsA("Model") and child.Name ~= "Wheels" and child.Name ~= "Doors" then

                if child.PrimaryPart then
                    utils.weld(inner(child).PrimaryPart, parent:IsA("Model") and parent.PrimaryPart or parent).Parent = child.PrimaryPart
                else
                    warn(("Model %s has no PrimaryPart!"):format(child.Name))
                    child:Destroy()
                end

            elseif child:IsA("Seat") or child:IsA("VehicleSeat") then

                utils.weld(inner(child), parent:IsA("Model") and parent.PrimaryPart or parent).Parent = child

            elseif child:IsA("BasePart") and child.Name ~= "LeftSteer" and child.Name ~= "RightSteer" then

                child.Massless = massless
                utils.weld(child, parent:IsA("Model") and parent.PrimaryPart or parent).Parent = child

            elseif child.Name ~= "Wheels" and child.Name ~= "Doors" then
                warn(("Instance with ClassName %s is not supported!"):format(child.ClassName))
                child:Destroy()
            end
        end
        return parent
    end
    return inner(parent)
end

local function setData(player, carName, key, value)
    --put the data in the players datastore
    local store = datastore.combined.player(player, "Data", "Cars"):update("Cars", function(data)
        data[carName] = data[carName] or {}
        data[carName][key] = value
        return data
    end, {})
end

--===============================================/     Utils     /===============================================--
--===============================================================================================================--
--===============================================/      Car      /===============================================--

function car.new(player, carName)
    local model = carFolder:FindFirstChild(carName)
    model = model and model:Clone()

    if not model then
        warn(("Car with name %s not found!"):format(carName))
        return
    end

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
    newCar.Mass:SetAttribute("CarOwner", player.UserId)

    model.PrimaryPart = newCar.Mass

    CS:AddTag(model, "Car")

    newCar.Stats = {
        Acceleration = model:GetAttribute("Acceleration") or 50,
        Torque = model:GetAttribute("Torque") or 100,
        MaxSpeed = model:GetAttribute("MaxSpeed") or 30,
        TurnSpeed = model:GetAttribute("TurnSpeed") or 1,
        TurnAngle = model:GetAttribute("TurnAngle") or 25,
        MaxVolume = model:GetAttribute("MaxVolume") or 100
    }

    newCar.Model = weldParent(model, true)
    newCar.Body = model.Body
    newCar.Owner = player
    newCar.Name = model.Name
    
    newCar.DriverSeat = model:FindFirstChildWhichIsA("VehicleSeat")
    newCar.Seats = {}

    newCar.FrontLights = {}
    newCar.RearLights = {}
    newCar.SignalLeftLights = {}
    newCar.SignalRightLights = {}
    newCar.DetailLights = {}

    newCar.Doors = {}
    newCar.Wheels = {}
    newCar.Steer = {}
    newCar.Motor = {}

    newCar.Locked = false

    newCar.Content = content.new(model.Content, newCar.Stats.MaxVolume)

    local ScriptableEvent = Instance.new("BindableEvent")
    ScriptableEvent.Name = "Scriptable"
    ScriptableEvent.Parent = model
    ScriptableEvent.Event:Connect(function(boolean)
        newCar.Locked = boolean

        for _, motor in ipairs(newCar.Motor) do
            motor:setType(boolean and "None" or "Motor")
        end

        if not newCar.DriverSeat.Occupant then
            local char = player.Character
            local humanoid = char and char.Humanoid
            if humanoid then
                newCar.DriverSeat:Sit(humanoid)
            else
                newCar.Locked = false
                return
            end
        end

        for _, carDoor in ipairs(newCar.Doors) do
            if boolean then
                carDoor:close()
            end
            carDoor.CanOpen = not boolean
        end

        if not boolean and newCar.OldOccupantJumpPower then
            newCar.DriverSeat.Occupant.JumpPower = newCar.OldOccupantJumpPower
            newCar.OldOccupantJumpPower = nil
        elseif boolean then
            newCar.OldOccupantJumpPower = newCar.DriverSeat.Occupant.JumpPower
            newCar.DriverSeat.Occupant.JumpPower = 0
        end
    end)

    local setColorEvent = Instance.new("RemoteEvent")
    setColorEvent.Name = "SetColor"
    setColorEvent.Parent = model
    setColorEvent.OnServerEvent:Connect(function(plr, catogory, brickColor)
        if plr == player then
            local cashV = player.leaderstats.Cash
            if cashV.Value >= REPAINT_PRICE then
                newCar:color(catogory, brickColor)
                cashV.Value -= REPAINT_PRICE
            else
                re_Notify:FireClient(plr, "", ("You need <font color=\"rgb(0, 170, 0)\">$%d</font> more to able to buy this!"):format(REPAINT_PRICE - cashV.Value))
            end
        end
    end)

    local setIconEvent = Instance.new("RemoteEvent")
    setIconEvent.Name = "SetIcon"
    setIconEvent.Parent = model
    setIconEvent.OnServerEvent:Connect(function(plr, iconName)
        if plr == player then
            local cashV = player.leaderstats.Cash
            local price = newCar:getWheelIconPrice(iconName)
            if price then
                if cashV.Value >= price then
                    newCar:setWheelIcon(iconName)
                    cashV.Value -= price
                else
                    re_Notify:FireClient(plr, "", ("You need <font color=\"rgb(0, 170, 0)\">$%d</font> more to able to buy this!"):format(price - cashV.Value))
                end
            end
        end
    end)

    local upgradeStatEvent = Instance.new("RemoteEvent")
    upgradeStatEvent.Name = "UpgradeStat"
    upgradeStatEvent.Parent = model
    upgradeStatEvent.OnServerEvent:Connect(function(plr, statName)
        if plr == player then
            print(statName)
            local cashV = player.leaderstats.Cash
            local price = model:GetAttribute(("PRICE_STAT_%s"):format(statName))
            if cashV.Value >= price then
                newCar:upgrade(statName)
                cashV.Value -= price
            else
                re_Notify:FireClient(plr, "", ("You need <font color=\"rgb(0, 170, 0)\">$%d</font> more to able to buy this!"):format(price - cashV.Value))
            end
        end
    end)

    local lightOn = false
    local enableLightEvent = Instance.new("RemoteEvent")
    enableLightEvent.Name = "EnableLight"
    enableLightEvent.Parent = model
    enableLightEvent.OnServerEvent:Connect(function(plr, boolean)
        if plr == player then
            boolean = boolean == nil and not lightOn or boolean
            newCar:enableLights(boolean, newCar.FrontLights)
            lightOn = boolean
        end
    end)

    local repaintPriceFunction = Instance.new("RemoteFunction")
    repaintPriceFunction.Name = "GetRepaintPrice"
    repaintPriceFunction.Parent = model
    function repaintPriceFunction.OnServerInvoke(plr, boolean)
        return REPAINT_PRICE
    end

    --==============================[Setup Lights]==============================--
    for _, l in ipairs(model.Lights:GetChildren()) do
        if l:IsA("Model") then
            if l.Name == "Front" then
                table.insert(newCar.FrontLights, light.new(l, {
                    Brightness = 10,
                    Range = 20,
                }))
            elseif l.Name == "Rear" then
                table.insert(newCar.RearLights, light.new(l, {
                    Brightness = 2,
                    Range = 15,
                }))
            elseif l.Name == "LeftSignal" then
                table.insert(newCar.SignalLeftLights, light.new(l, {
                    Brightness = 1,
                    Range = 10,
                }))
            elseif l.Name == "RightSignal" then
                table.insert(newCar.SignalRightLights, light.new(l, {
                    Brightness = 1,
                    Range = 10,
                }))
            elseif l.Name == "Detail" then
                local newLight = light.new(l, {
                    Brightness = 0,
                    Range = 0,
                })
                newLight:on()
                table.insert(newCar.DetailLight, newLight)
            end
        end
    end

    --==============================[Setup Wheels]==============================--
    for _, axis in ipairs(model.Wheels:GetChildren()) do
        for _, child in ipairs(axis:GetChildren()) do
            if child:IsA("Model") then
                table.insert(newCar.Wheels, child)
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
        utils.weld(axis.PrimaryPart, model.Chassis.PrimaryPart).Parent = axis.PrimaryPart
    end

    --==============================[Setup Doors]==============================--
    for _, child in ipairs(model:GetChildren()) do
        if child:IsA("Seat") or child:IsA("VehicleSeat") then
            table.insert(newCar.Seats, child)
        end
    end

    for _, child in ipairs(model.Doors:GetChildren()) do
        table.insert(newCar.Doors, door.new(weldParent(child, true), model.Body.PrimaryPart, newCar.Seats))
    end

    --==============================[Setup Events]==============================--
    if newCar.DriverSeat then
        newCar.DriverSeat:GetPropertyChangedSignal("ThrottleFloat"):Connect(function()
            if not newCar.Locked then
                for _, motor in pairs(newCar.Motor) do
                    motor:throttle(newCar.DriverSeat.ThrottleFloat, newCar.Stats.MaxSpeed)
                end

                newCar:enableLights(newCar.DriverSeat.ThrottleFloat < 0, newCar.RearLights)
            else
                for _, motor in pairs(newCar.Motor) do
                    motor:throttle(0, newCar.Stats.MaxSpeed)
                end
            end
        end)

        newCar.DriverSeat:GetPropertyChangedSignal("Steer"):Connect(function()
            if not newCar.Locked then
                for _, steer in pairs(newCar.Steer) do
                    steer:steer(newCar.DriverSeat.Steer, newCar.Stats.TurnAngle)
                end

                if newCar.DriverSeat.Steer ~= 0 then
                    newCar:enableLights(newCar.DriverSeat.Steer < 0, newCar.SignalLeftLights)
                    newCar:enableLights(newCar.DriverSeat.Steer > 0, newCar.SignalRightLights)
                else
                    newCar:enableLights(false, newCar.SignalLeftLights, newCar.SignalRightLights)
                end
            else
                for _, steer in pairs(newCar.Steer) do
                    steer:steer(0, newCar.Stats.TurnAngle)
                end
            end
        end)
    else
        warn(("No VehicleSeat found in car %s!"):format(model.Name))
    end

    --Setup all data
    local data = datastore.combined.player(player, "Data", "Cars"):get("Cars", {})[newCar.Name] or {}

    newCar:upgrade("Acceleration", data.Acceleration or 0)
    newCar:upgrade("Speed", data.Speed or 0)
    newCar:upgrade("TireTraction", data.TireTraction or 0)
    newCar:upgrade("TankCapacity", data.TankCapacity or 0)

    for _, colorCatogory in ipairs{
        "Body", "Wheelcap", "Icon", "Seat", "Light"
    } do
        if data[colorCatogory] then
            local color = BrickColor.new(data[colorCatogory])
            newCar:color(colorCatogory, color)
        else
            newCar:color(colorCatogory, BrickColor.new(model:GetAttribute(("%sColor"):format(colorCatogory))))
        end
    end

    if data.WheelIcon then
        newCar:setWheelIcon(data.WheelIcon)
    else
        newCar:setWheelIcon(model:GetAttribute("WheelIcon"))
    end

    return newCar
end

function car:upgrade(statName, amount)
    amount = amount or 1

    local prevAmount = self.Model:GetAttribute(("STAT_%s"):format(statName)) or 0
    local newAmount = prevAmount + amount
    local mult = (1 + (1 / 5 * newAmount))

    if statName == "Speed" then
        self.Model:SetAttribute("PRICE_STAT_Speed", UPGRADE_PRICE(newAmount))
        self.DriverSeat.MaxSpeed = self.Stats.MaxSpeed * mult
    elseif statName == "Acceleration" then
        self.Model:SetAttribute("PRICE_STAT_Acceleration", UPGRADE_PRICE(newAmount))
        for _, motor in pairs(self.Motor) do
            motor.MotorMaxAcceleration = self.Stats.Acceleration * mult
        end
    elseif statName == "TireTraction" then
        self.Model:SetAttribute("PRICE_STAT_TireTraction", UPGRADE_PRICE(newAmount))
        --TODO add tire traction logic
    elseif statName == "TankCapacity" then
        self.Model:SetAttribute("PRICE_STAT_TankCapacity", UPGRADE_PRICE(newAmount))
        self.Content.MaxVolume = self.Stats.MaxVolume * mult
    else
        warn(("can't upgrade stat: %s"):format(statName))
    end

    --put the data in the players datastore
    setData(self.Owner, self.Name, statName, newAmount)

    self.Model:SetAttribute(("STAT_%s"):format(statName), newAmount)
end

function car:setWheelIcon(iconName)
    self.Model:SetAttribute("WheelIcon", iconName)
    for _, motor in pairs(self.Motor) do
        motor:setIcon(iconName)
    end

    for _, steer in pairs(self.Steer) do
        steer:setIcon(iconName)
    end

    --put the data in the players datastore
    setData(self.Owner, self.Name, "WheelIcon", iconName)
end

local icons = game:GetService("ReplicatedStorage")
    :WaitForChild("WheelIcons")
function car:getWheelIconPrice(iconName)
    local icon = icons[iconName]
    if icon then
        return icon:GetAttribute("Price")
    end
end

function car:color(catogory, brickColor)
    if catogory == "Body" then
        self.Model:SetAttribute("BodyColor", brickColor.Name)
        for _, descendant in ipairs(self.Body:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.BrickColor = brickColor
            end
        end
        for _, dr in ipairs(self.Doors) do
            dr:color(brickColor)
        end
    elseif catogory == "Wheelcap" then
        self.Model:SetAttribute("WheelcapColor", brickColor.Name)
        for _, steer in ipairs(self.Steer) do
            steer:color(brickColor)
        end
        for _, motor in ipairs(self.Motor) do
            motor:color(brickColor)
        end
    elseif catogory == "Icon" then
        self.Model:SetAttribute("IconColor", brickColor.Name)
        for _, steer in ipairs(self.Steer) do
            steer:iconColor(brickColor)
        end
        for _, motor in ipairs(self.Motor) do
            motor:iconColor(brickColor)
        end
    elseif catogory == "Seat" then
        self.Model:SetAttribute("SeatColor", brickColor.Name)
        for _, seat in ipairs(self.Seats) do
            for _, child in ipairs(seat.Body:GetChildren()) do
                if child:IsA("BasePart") then
                    child.BrickColor = brickColor
                end
            end
            seat.BrickColor = brickColor
        end
    elseif catogory == "Light" then
        self.Model:SetAttribute("LightColor", brickColor.Name)
        for _, l in ipairs(self.FrontLights) do
            l:color(brickColor)
        end
    end

    --put the data in the players datastore
    setData(self.Owner, self.Name, catogory, brickColor.Name)
end

function car:material(catogory, material)
    if catogory == "Body" then
        for _, descendant in ipairs(self.Body:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.Material = material
            end
        end
        for _, dr in ipairs(self.Doors) do
            dr:material(material)
        end
    elseif catogory == "Wheelcap" then
        for _, steer in ipairs(self.Steer) do
            steer:material(material)
        end
        for _, motor in ipairs(self.Motor) do
            motor:material(material)
        end
    elseif catogory == "Icon" then
        for _, steer in ipairs(self.Steer) do
            steer:iconMaterial(material)
        end
        for _, motor in ipairs(self.Motor) do
            motor:iconMaterial(material)
        end
    elseif catogory == "Seat" then
        for _, seat in ipairs(self.Seats) do
            for _, child in ipairs(seat.Body:GetChildren()) do
                if child:IsA("BasePart") then
                    child.Material = material
                end
            end
            seat.Material = material
        end
    end
end

function car:enableLights(boolean, ...)
    for _, lights in ipairs{...} do
        for _, l in ipairs(lights) do
            if boolean then
                l:on()
            else
                l:off()
            end
        end
    end
end

function car:destroy()
    self.Model:Destroy()
end

--===============================================/      Car      /===============================================--
--===============================================================================================================--

return car