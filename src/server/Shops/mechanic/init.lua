local CS = game:GetService("CollectionService")
local RS = game:GetService("RunService")
local bf_GetPlayerCar = game.ServerScriptService.Objects.CarHandler.GetPlayerCar

local remoteMehcanic = game:GetService("ReplicatedStorage"):WaitForChild("remote"):WaitForChild("mechanic")
local re_Entering = remoteMehcanic:WaitForChild("Entering")

--+++++++[DEBUG]+++++++--
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
--+++++++[DEBUG]+++++++--

local mechanic = {}
mechanic.__index = mechanic

function mechanic.new(garageDoor, camera, enteredPart, enterStartRef, enterEndRef)
    local newMechanic = {}
    newMechanic.GarageDoor = garageDoor

    newMechanic.StartCFrame = enterStartRef.CFrame * CFrame.new(0, -enterStartRef.Size.Y * .5, enterStartRef.Size.Z * .5)
    enterStartRef.Transparency = 1
    --createPart("Start", newMechanic.StartCFrame)

    newMechanic.EndCFrame = enterEndRef.CFrame * CFrame.new(0, -enterEndRef.Size.Y * .5, 0)
    enterEndRef.Transparency = 1
    --createPart("End", newMechanic.EndCFrame)

    newMechanic.Camera = camera

    newMechanic.Car = nil
    newMechanic.Entering = false

    newMechanic.EnteredPart = enteredPart
    newMechanic.EnteredPart.Touched:Connect(function(part)
        if part:GetAttribute("CarOwner") then
            local onwerID = part:GetAttribute("CarOwner")
            local player = game.Players:GetPlayerByUserId(onwerID)
            newMechanic.Car = player and bf_GetPlayerCar:Invoke(player)
            if newMechanic.Car then
                re_Entering:FireClient(player, newMechanic.Camera)
                newMechanic.Car.Lock:Fire(true)
                newMechanic.Entering = false
                newMechanic.Car.PrimaryPart.Anchored = true

                local cf, size = newMechanic.Car:GetBoundingBox()
                local startCFrame = newMechanic.StartCFrame * CFrame.new(0, size.Y * .5, -size.Z * .5)
                local endCFrame = newMechanic.EndCFrame * CFrame.new(0, size.Y * .5, 0)

                local t = 0
                local speed = .4
                local rsConn
                rsConn = RS.Heartbeat:Connect(function(dt)
                    t += speed * dt
                    newMechanic.Car:SetPrimaryPartCFrame(startCFrame:Lerp(endCFrame, t))
                    if t >= 1 then
                        rsConn:Disconnect()
                        --newMechanic.Car.Lock:Fire(false)
                        newMechanic.Entering = false
                        --newMechanic.Car.PrimaryPart.Anchored = false
                    end
                end)
            end
        end
    end)
    enteredPart.Transparency = 1

    garageDoor.canOpen = function()
        return not newMechanic.Car
    end

    garageDoor.canClose = function()
        return not newMechanic.Entering
    end

    return setmetatable(newMechanic, mechanic)
end

return mechanic