local carFolder = game:GetService("ReplicatedStorage"):WaitForChild("Cars")
local car = require(script.car)

local HEIGHT_CHECK = 10
local MAX_TRIES = 100

local cars = {}
--[[+++++++++[DEBUG]++++++
local function debug(origin, dir)
    local part = Instance.new("Part")
    part.Name = "CarSpawnRayDebug"
    part.Anchored = true
    part.Transparency = 1
    part.CanCollide = false
    part.Parent = workspace

    local attachment0 = Instance.new("Attachment")
    attachment0.Name = "origin"
    attachment0.Position = part.CFrame:PointToObjectSpace(origin)
    attachment0.Parent = part

    local attachment1 = Instance.new("Attachment")
    attachment1.Name = "direction"
    attachment1.Position = part.CFrame:PointToObjectSpace(origin + dir)
    attachment1.Parent = part

    local beam = Instance.new("Beam")
    beam.Name = "ray"
    beam.Color = ColorSequence.new(Color3.new(1, 0, 0))
    beam.FaceCamera = true
    beam.Parent = part

    beam.Attachment0 = attachment0
    beam.Attachment1 = attachment1
end
+++++++++[DEBUG]++++++]]

game:GetService("Players").PlayerRemoving:Connect(function(player)
    local c = cars[player.UserId]
    if c then
        c:destroy()
    end
    cars[player.UserId] = nil
end)

local function getSpot(carModel, cframe)
    local ignoreList = {}
    for _, plr in pairs(game.Players:GetPlayers()) do
        table.insert(ignoreList, plr)
    end

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = ignoreList

    for _=1, MAX_TRIES do
        local origin = (cframe * CFrame.new(0, HEIGHT_CHECK, 0)).Position
        local dir = -cframe.UpVector * HEIGHT_CHECK * 2
        --debug(origin, dir)
        local result = workspace:Raycast(origin, dir, params)
        if result and result.Instance:GetAttribute("RegionPart") then
            table.insert(ignoreList, result.Instance)
            continue
        elseif result then
            local cf, size = carModel:GetBoundingBox()
            return result.Position + cf.UpVector * size.Y * .5
        end
    end
end

script.SpawnCar.Event:Connect(function(player, name, cf)
    local carModel = carFolder:FindFirstChild(name)
    local playerCar = car.new(player, name)

    if playerCar then
        if cars[player.UserId] then
            cars[player.UserId]:destroy()
        end

        local pos = getSpot(playerCar.Model, cf)
        if pos then
            --local carData = 
            playerCar.Model:SetPrimaryPartCFrame(CFrame.new(pos))
            playerCar.Model.Parent = workspace
            cars[player.UserId] = playerCar
        else
            warn(("No valid spawn spot found at %s!"):format(tostring(cf.Position)))
        end

    else
        warn(("Car %s doesn't exist"):format(name))
    end
end)

script.GetPlayerCar.OnInvoke = function(player)
    return cars[player.UserId].Model
end