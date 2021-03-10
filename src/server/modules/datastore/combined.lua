local shared = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"))
local event = shared.get("event")
local settings = shared.get("settings")

local datastore = require(script.Parent:WaitForChild("datastore"))

local combined = {}
combined.__meta = {}
combined.__meta.__type = "Combined"
combined.__meta.__index = combined.__meta

local combined_cache = {}
function combined.new(name, scope, mainKey, ...)
    local newCombined
    combined_cache[scope] = combined_cache[scope] or {}
    if combined_cache[scope][datastore.cacheKey(name, mainKey)] then
        newCombined = combined_cache[scope][datastore.cacheKey(name, mainKey)]
    else
        combined_cache[scope][datastore.cacheKey(name, mainKey)] = setmetatable({}, combined.__meta)
        newCombined = combined_cache[scope][datastore.cacheKey(name, mainKey)]

        newCombined.Datastore = datastore.new(name, scope, mainKey)
        newCombined.__type = combined.__meta.__type
        newCombined.Keys = {}
        newCombined.Events = {
            __onUpdate = {}, onUpdate = {},
            __onRemove = {}, onRemove = {}
        }
    end

    for _, key in pairs{...} do
        newCombined:addKey(key)
    end

    return newCombined
end

function combined.player(player, mainKey, ...)
    local slot = player:WaitForChild("Slot").Value
    return combined.new("Slot_"..slot, "User_"..player.UserId, mainKey, ...)
end

function combined.global(name, mainKey, ...)
    return combined.new(name, "global", mainKey, ...)
end

function combined.__meta.addKey(self, key)
    while not self.Keys and not self.Datastore and not self.Events do
        wait()
    end
    if not self.Keys[key] then
        self.Keys[key] = true
        self.Events.__onUpdate[key], self.Events.onUpdate[key] = event.new()
        self.Events.__onRemove[key], self.Events.onRemove[key] = self.Datastore.Events.__onRemove, self.Datastore.Events.onRemove
    end
end

function combined.__meta.get(self, key, defaultValue)
    while not self.Datastore do
        wait()
    end
    if self.Datastore:get({})[key] == nil then
        self:set(key, defaultValue)
    end
    return self.Datastore:get({})[key]
end

function combined.__meta.set(self, key, value)
    while not self.Datastore and not self.Events do
        wait()
    end
    local _, err = pcall(function()
        self.Datastore:update(function(data)
            data[key] = value
            return data
        end, {})
    end)
    self.Events.__onUpdate[key]:Fire(value)
    return err
end

function combined.__meta.update(self, key, callback, defaultValue)
    self:set(key, callback(self:get(key, defaultValue)))
end

function combined.__meta.increment(self, key, value, defaultValue)
    self:update(key, function(data)
        data += value or 1
        return data
    end, defaultValue)
end

function combined.__meta.save(self)
    while not self.Datastore do
        wait()
    end
    combined.Datastore:save()
end

function combined.__meta.remove(self)
    while not self.Datastore  do
        wait()
    end
    self.Datastore:remove()
    combined_cache[self.Datastore.Scope][datastore.cacheKey(self.Datastore.Name, self.Datastore.Key)] = nil
end

function combined.__meta.connect(self, event, key, callback)
    while not self.Events do
        wait()
    end
    return self.Events[event][key]:Connect(callback)
end

return combined