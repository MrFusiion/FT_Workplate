local CS = game:GetService("CollectionService")
local RS = game:GetService("RunService")
local bf_GetPlayerCar = game.ServerScriptService.Objects.CarHandler.GetPlayerCar

local remoteMechanic = game:GetService("ReplicatedStorage"):WaitForChild("remote"):WaitForChild("mechanic")
local re_Enter = remoteMechanic:WaitForChild("Enter")
local re_Entered = remoteMechanic:WaitForChild("Entered")
local re_Exit = remoteMechanic:WaitForChild("Exit")

--[[+++++++[DEBUG]+++++++--
local function createPart(name, cf)
    local part = Instance.new("Part")
    part.Size = Vector3.new(1, 1, 1)
    part.Material = "SmoothPlastic"
    part.BrickColor = BrickColor.Red()
    part.Anchored = true
    part.CanCollide = false
    part.Name = name
    part.CFrame = cf
    part.Parent = workspace
end
--+++++++[DEBUG]+++++++]]--

local function posTween(car, speed, startCf, endCf)
    local bodyPos = Instance.new("BodyPosition")
    bodyPos.MaxForce = Vector3.new(1, 1, 1) * 40000
    bodyPos.D = 500
    bodyPos.P = 5000
    bodyPos.Position = startCf.Position
    bodyPos.Parent = car.Mass

    local bodyRot = Instance.new("BodyGyro")
    bodyRot.MaxTorque = Vector3.new(1, 1, 1) * 40000
    bodyRot.D = 500
    bodyRot.P = 5000
    bodyRot.CFrame = startCf
    bodyRot.Parent = car.Mass

    local ended = false
    local t = 0
    local rsConn
    rsConn = RS.Heartbeat:Connect(function(dt)
        t += speed * dt
        --car:SetPrimaryPartCFrame(startCf:Lerp(endCf, t))
        bodyPos.Position = startCf:Lerp(endCf, t).Position
        bodyRot.CFrame = startCf:Lerp(endCf, t)

        if t >= 1 then
            rsConn:Disconnect()
            ended = true
        end
    end)
    while not ended do wait() end

    bodyPos:Destroy()
    bodyRot:Destroy()
end

local function createWeld(part0, part1)
    local weld = Instance.new("WeldConstraint")
    weld.Part0  = part0
    weld.Part1 = part1
    weld.Parent = part0
    return weld
end

local mechanic = {}
mechanic.__index = mechanic

function mechanic.new(garageDoor, cameras, lights, wheelrack, enteredPart, enterRef, insideRef, exitRef)
    local newMechanic = {}

    newMechanic.GarageDoor = garageDoor
    newMechanic.Cameras = cameras
    newMechanic.Wheelrack = wheelrack
    newMechanic.Lights = lights

    newMechanic.StartCFrame = enterRef.CFrame * CFrame.new(0, -enterRef.Size.Y * .5, enterRef.Size.Z * .5)
    enterRef.Transparency = 1
    --createPart("Start", newMechanic.StartCFrame)

    newMechanic.InsideCFrame = insideRef.CFrame * CFrame.new(0, -insideRef.Size.Y * .5, 0)
    insideRef.Transparency = 1
    --createPart("End", newMechanic.EndCFrame)

    newMechanic.ExitCFrame = exitRef.CFrame * CFrame.new(0, -exitRef.Size.Y * .5, -exitRef.Size.Z * .5)
    exitRef.Transparency = 1

    newMechanic.Car = nil
    newMechanic.Entering = false
    newMechanic.Exiting = false

    newMechanic.EnteredPart = enteredPart
    enteredPart.Transparency = 1
    newMechanic.EnteredPart.Touched:Connect(function(part)
        local ownerID = part:GetAttribute("CarOwner")
        local player = ownerID and game.Players:GetPlayerByUserId(ownerID)
        if player and not newMechanic.Car then
            newMechanic:carEnter(player)
        end
    end)

    garageDoor.canOpen = function()
        return not newMechanic.Car or newMechanic.Exiting
    end

    garageDoor.canClose = function()
        return not newMechanic.Entering and not newMechanic.Exiting
    end

    return setmetatable(newMechanic, mechanic)
end

function mechanic:carEnter(player)
    if not self.Car and player then
        self.Car = bf_GetPlayerCar:Invoke(player)
        if self.Car then
            self.Car.Scriptable:Fire(true)
            --self.Car.Lock:Fire(true)
            --self.Car.PrimaryPart.Anchored = true
            re_Enter:FireClient(player, self.Cameras)

            local cf, size = self.Car:GetBoundingBox()
            local startCFrame = self.StartCFrame * CFrame.new(0, size.Y * .5, -size.Z * .5)
            local endCFrame = self.InsideCFrame * CFrame.new(0, size.Y * .5, 0)
            self.Entering = true
            posTween(self.Car, .3, startCFrame, endCFrame)
            self.Entering = false

            re_Entered:FireClient(player, self.Cameras, {
                car = self.Car,
                lights = self.Lights,
                wheelrack = self.Wheelrack
            })

            local exitConn
            exitConn = re_Exit.OnServerEvent:Connect(function(player)
                if player.UserId == self.Car.Mass:GetAttribute("CarOwner") then
                    self:carExit(player)
                end
                exitConn:Disconnect()
            end)
        end
    end
end

function mechanic:carExit(player)
    self.GarageDoor.ShouldOpen = true

    local cf, size = self.Car:GetBoundingBox()
    local startCFrame = self.InsideCFrame * CFrame.new(0, size.Y * .5, 0)
    local endCFrame = self.ExitCFrame * CFrame.new(0, size.Y * .5, size.Z * .5)

    self.Exiting = true
    posTween(self.Car, .3, startCFrame, endCFrame)
    self.Exiting = false

    re_Exit:FireClient(player)
    self.Car.Scriptable:Fire(false)
    --self.Car.Lock:Fire(false)
    --self.Car.PrimaryPart.Anchored = false

    self.Car = nil

    self.GarageDoor.ShouldOpen = nil
end

function mechanic:getCarOwner()
    local ownerID = self.Car and self.Car.Mass:GetAttribute("CarOwner")
    return ownerID and game.Players:GetPlayerByUserId(ownerID)
end

return mechanic