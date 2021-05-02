local shared = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"))
local random = shared.get("random")
local tableUtils = shared.get("tableUtils")

local resourceDebug = game:GetService("ReplicatedStorage"):WaitForChild("ResourceDebug")

local resTable = require(script.resTable)

local MAX_FIND_SPOT_TRIES = 200
local RAY_HEIGHT = 100

local growingClient = {}
growingClient.__index = growingClient

local function getMinSpawnDistance(resource)
    return resource.MinSpawnDistanceToOtherTrees or
    resource.MinSpawnDistanceToOtherCrystals or
    resource.MinSpawnDistanceToOtherOres
end

function growingClient.new(maxResources, resourceTypes, parts, topSpawnRate, customSpawnRateFunc, ...) -- ... = growing client links for the findPlantSpot collision Detection
    local newGrowingClient = setmetatable({}, growingClient)

    newGrowingClient.Resources = resTable.new()
    newGrowingClient.Types = random.toWeightedList(table.unpack(resourceTypes))
    newGrowingClient.MaxResources = maxResources
    newGrowingClient.Links = {...}

    newGrowingClient.Initialized = false
    newGrowingClient.SuperSpeed = false
    newGrowingClient.GrowSpeed = 1
    newGrowingClient.TopSpawnRate = topSpawnRate

    newGrowingClient.LastPlant = 0
	newGrowingClient.ThisTick = nil
	newGrowingClient.LastTick = nil

    newGrowingClient.FloorSymbol = ("REGIONPART_%s"):format(tostring(newGrowingClient):gsub("table: ", ""))

    newGrowingClient.customSpawnRateFunc = customSpawnRateFunc

    newGrowingClient.Parts = parts
    newGrowingClient.RegionBounds = {min = Vector3.new(1,1,1) * 10000000, max = Vector3.new(1,1,1) *  -10000000}

	for _, part in pairs(parts) do
		if part:IsA("BasePart") then
			for x = -1, 1, 2 do
				for y = -1, 1, 2 do
					for z = -1, 1, 2 do
						local point = (part.CFrame * CFrame.new(Vector3.new(x * part.Size.X * .5, y * part.Size.Y * .5, z * part.Size.Z * .5))).Position
						newGrowingClient.RegionBounds.max = Vector3.new(
                            math.max(newGrowingClient.RegionBounds.max.X, point.X),
							math.max(newGrowingClient.RegionBounds.max.Y, point.Y),
						    math.max(newGrowingClient.RegionBounds.max.Z, point.Z)
                        )

                        newGrowingClient.RegionBounds.min = Vector3.new(
                            math.min(newGrowingClient.RegionBounds.min.X, point.X),
							math.min(newGrowingClient.RegionBounds.min.Y, point.Y),
						    math.min(newGrowingClient.RegionBounds.min.Z, point.Z)
                        )

                        part:SetAttribute(newGrowingClient.FloorSymbol, true)
					end
				end
			end
		end
	end

    --[[++++++[DEBUG]++++++--

    local reg = Region3.new(newGrowingClient.RegionBounds.min, newGrowingClient.RegionBounds.max)

    local field = Instance.new("Part")
    field.Name = "DebugField"
    field.Anchored = true
    field.CanCollide = false
    field.Size = reg.Size + Vector3.new(1, 1, 1) * .05
    field.CFrame = reg.CFrame
    field.Transparency = .5
    field.BrickColor = BrickColor.Red()
    field.Parent = workspace

    --++++++[DEBUG]++++++]]--

    newGrowingClient.Model = Instance.new("Model", workspace)
    local classes = {}
    for _, resourceType in ipairs(resourceTypes) do
        if not tableUtils.contains(classes, resourceType.value.Class) then
            table.insert(classes, resourceType.value.Class)
        end
    end
    newGrowingClient.Model.Name = ("GrowingClient(%s)"):format(table.concat(classes, "/"))

    return newGrowingClient
end

function growingClient:getSpawnRate()
    if self.CustomSpawnRateFunc then
        return self.TopSpawnRate * self.CustomSpawnRateFunc(self.Resources.Len / self.MaxResources)
    else
        return self.TopSpawnRate * (self.Resources.Len / self.MaxResources) ^ (1/2)
    end
end

function growingClient:timeToPlant()
    return self.Resources.Len < self.MaxResources and ((tick() - self.LastPlant) * self.GrowSpeed > self:getSpawnRate() or self.SuperSpeed)
end

function growingClient:canPlaceHere(cf : CFrame) : boolean
    local function canPlace(cf, list)
        for _, resource in list:iter() do
            if resource.OriginCFrame then
                if (resource.OriginCFrame.Position - cf.Position).Magnitude < getMinSpawnDistance(resource) then
                    return false
                end
            end
        end
        return true
    end

    for _, client in pairs({ self, table.unpack(self.Links) }) do
        if not canPlace(cf, client.Resources) then
            return false
        end
    end
    return true
end

function growingClient:findPlantSpot(resource)
    local ignoreStuff = {}
	for _, player in pairs(game.Players:GetPlayers()) do
		table.insert(ignoreStuff, player)
	end

    for _= 1, MAX_FIND_SPOT_TRIES do
		local randPoint = Vector3.new(
            random:nextNumber(self.RegionBounds.min.X, self.RegionBounds.max.X),
            self.RegionBounds.max.Y + RAY_HEIGHT,
            random:nextNumber(self.RegionBounds.min.Z, self.RegionBounds.max.Z)
        )

        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = ignoreStuff
        rayParams.FilterType = Enum.RaycastFilterType.Blacklist

		local result = workspace:Raycast(randPoint, Vector3.new(0, self.RegionBounds.min.Y - self.RegionBounds.max.Y - RAY_HEIGHT, 0), rayParams)

		if result and result.Instance:GetAttribute(self.FloorSymbol) then
            local point = CFrame.new(result.Position)

            if self:canPlaceHere(point) then
                return point
            end
        elseif result and (result.Instance.Transparency == 1 or not result.Instance.Anchored) then
            table.insert(ignoreStuff, result.Instance)
		end
	end
end

function growingClient:plantNewResource()
    if self:timeToPlant() then
        local newResource = random:choice(self.Types).new(self.Model)

        local spot
        for i = 1, 100 do
            spot = self:findPlantSpot(newResource)
            if spot then
                break
            end
        end

        if spot then
            newResource:place(spot)
            local index = self.Resources:add(newResource)

            --[[++++++[DEBUG]++++++--

            local debugPart = Instance.new("Part")
            debugPart.Name = "Debug"
            debugPart.Anchored = true
            debugPart.CanCollide = false
            debugPart.Transparency = 1
            debugPart.CFrame = spot * CFrame.new(0, 2, 0)
            debugPart.Parent = newResource.Model

            local gui = resourceDebug:Clone()
            gui.Name = "Gui"
            gui.Parent = debugPart

            --++++++[DEBUG]++++++]]--
        end
    end
end

function growingClient:updateResources()
    self.LastTick = self.ThisTick or tick() - .1
	self.ThisTick = tick()
	local timeDiff = self.ThisTick - self.LastTick

    local removeResource
	for id, resource in self.Resources:iter() do
		local success, error = pcall(function()
			resource:growCheck(timeDiff  * self.GrowSpeed, self.SuperSpeed)
		end)

		if not success then
			warn(error)
			resource:destroy()
		end

        if removeResource == nil and not resource.Model.Parent then
            removeResource = id
        end

        --[[++++++[DEBUG]++++++--

        local debug = resource.Model:FindFirstChild("Debug")
        local gui = debug and debug:FindFirstChild("Gui") or nil

        local stage = gui and gui:FindFirstChild("Stage") or nil
        local timeUntil = gui and gui:FindFirstChild("TimeUntil") or nil
        local growCalls = gui and gui:FindFirstChild("GrowCalls") or nil

        if stage and timeUntil then

            local stageValue = resource.Stage or "None"
            local timeUntilValue = resource.TimeUntilDeath or 0
            local growcallsValue = resource.GrowCalls or 0

            local color = stageValue == "Growing" and Color3.fromRGB(255,219,61) or
                stageValue == "Grown" and Color3.fromRGB(61,255,80) or
                stageValue == "Leaves Fallen" and Color3.fromRGB(255,190,61) or
                (stageValue == "Dead" or stageValue == "Broken Up") and Color3.fromRGB(255,61,61) or nil
            if color then
                stage.Text = ("<font color=\"rgb(%d,%d,%d)\">%s</font>"):format(color.R, color.G, color.B, stageValue)
            else
                stage.Text = stageValue
            end

            timeUntil.Text = ("<font color=\"rgb(%d,%d,%d)\">%.2f</font>"):format(
                timeUntilValue >= 0 and table.unpack{61,255,80,timeUntilValue} or table.unpack{255,61,61,timeUntilValue})

            growCalls.Text = ("<font color=\"rgb(%d,%d,%d)\">%d</font>/%d"):format(
                resource.GrowCalls > resource.MaxGrowCalls and 
                table.unpack{61,168,255,resource.GrowCalls, resource.MaxGrowCalls} or 
                table.unpack{61,255,80,resource.GrowCalls, resource.MaxGrowCalls})
        end

        --++++++[DEBUG]++++++]]--
    end

    if removeResource ~= nil then
        self.Resources:removeAt(removeResource)
    end
    wait(1)
end

function growingClient:addLinks(...)
    for _, link in ipairs{...} do
        table.insert(self.Links, link)
    end
end

return growingClient