local PS = game:GetService("PhysicsService")

local remoteVacuum = game:GetService("ReplicatedStorage"):WaitForChild("remote"):WaitForChild("vacuum")
local re_TargetDetails = remoteVacuum:WaitForChild("re_TargetDetails")

local bf_GetVacuumStats = game.ServerScriptService.EquipmentHandler.GetVacuumStats

local vacuumLock = {}
vacuumLock.__index = vacuumLock

local function getColor(resource)
    return resource.BarkColor or resource.InnerColor or resource.OreColor
end

function vacuumLock.new(resource)
    local newVacuumLock = setmetatable({}, vacuumLock)

    newVacuumLock.Resource = resource
    newVacuumLock.Model = resource.Model

    newVacuumLock.Locked = false

    newVacuumLock.Part = Instance.new("Part")
    newVacuumLock.Part.Name = "VacuumLock"
    newVacuumLock.Part.Transparency = 1
    newVacuumLock.Part.CanCollide = false
    newVacuumLock.Part.Anchored = true
    newVacuumLock.Part.Size = Vector3.new(1, 1, 1) * .01
    newVacuumLock.Part.Parent = newVacuumLock.Model

    newVacuumLock.Lock = Instance.new("Attachment")
	newVacuumLock.Lock.Name = "Lock"
	newVacuumLock.Lock.Parent = newVacuumLock.Part

    newVacuumLock.CurrentLock = nil

    local lockEvent = Instance.new("RemoteEvent")
    lockEvent.Name = "LockEvent"
    lockEvent.Parent = newVacuumLock.Model

    lockEvent.OnServerEvent:Connect(function(player)
        newVacuumLock.Part.Position = resource.OriginCFrame.Position + Vector3.new(0, 3, 0) * .5
        local tool = player.Character and player.Character:FindFirstChildWhichIsA("Tool")
        if tool then
            local stats = bf_GetVacuumStats:Invoke(player)
            newVacuumLock:lock(tool)
            spawn(function()
                local maxHealt = resource.Hardness * resource:getVolume()
                local health = maxHealt
                while newVacuumLock.Locked do
                    re_TargetDetails:FireClient(player, resource.Name, getColor(resource), health, maxHealt)
                    wait(stats.speed)
                    health -= stats.damage

                    if health <= maxHealt then
                        print(string.format("%s Harvested %s with %s", player.Name, resource.Name, tool.Name))
                    end
                end
            end)
        end
    end)

    local unlockEvent = Instance.new("RemoteEvent")
    unlockEvent.Name = "UnlockEvent"
    unlockEvent.Parent = newVacuumLock.Model

    unlockEvent.OnServerEvent:Connect(function(player)
        newVacuumLock:unlock()
    end)

    return newVacuumLock
end

function vacuumLock:lock(tool)
    if not self.CurrentLock then
        local handle = tool:FindFirstChild("Handle")--to be sure no error's happen, find the handle the safe way
        local beam = handle and handle:FindFirstChildWhichIsA("Beam")

        if beam then
            self.Locked = true
            beam.Attachment1 = self.Lock
            self.CurrentLock = { tool = tool }
        end
    end
end

function vacuumLock:unlock()
    if self.CurrentLock then
        local handle = self.CurrentLock.tool:FindFirstChild("Handle")--to be sure no error's happen, find the handle the safe way
        local beam = handle and handle:FindFirstChildWhichIsA("Beam")

        if beam then
            self.Locked = false
            beam.Attachment1 = nil
            self.CurrentLock = nil
        end
    end
end

function vacuumLock:update()
    
end

return vacuumLock