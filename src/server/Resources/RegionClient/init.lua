local shared = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"))
local random = shared.get("random")

local region = {}
region.GrowingClient = require(script.GrowingClient)
region.__index = region

function region.new(name, ...) -- ... = growingClients
    local newRegion = setmetatable({}, region)

    newRegion.Name = name

    newRegion.GrowingClients = {...}

    newRegion.Model = Instance.new("Model", workspace)
    newRegion.Model.Name = ("Region(%s)"):format(newRegion.Name)

    for _, client in ipairs(newRegion.GrowingClients) do
        client.Model.Parent = newRegion.Model
    end

    return newRegion
end

function region:initialized()
    for _, client in ipairs(self.GrowingClients) do
        if not client.Initialized then
            return false
        end
    end
    return true
end

function region:init()
    for _, client in ipairs(self.GrowingClients) do
        local co = coroutine.create(function()
            client.GrowSpeed = 100
            client.SuperSpeed = true
            while client.Resources.Len < client.MaxResources do
                wait(1)
            end
            wait(10)
            client.GrowSpeed = 1
            client.SuperSpeed = false
            client.Initialized = true
        end)
        coroutine.resume(co)
    end
end

function region:start()
    self.Running = true
    while self.Running do
        wait()
        for _, client in ipairs(self.GrowingClients) do
            spawn(function()
                client:plantNewResource()
                client:updateResources()
            end)
        end
    end
end

function region:stop()
    self.Running = false
end

return region