--@initApi
--@Class: "DataStore"
local shared = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"))
local event = shared.get("event")
local config = shared.get("settings").new(game:GetService("ServerScriptService"):WaitForChild("Config"))

local datastore = {}
datastore.__meta = {}
datastore.__meta.__type = "Datastore"
datastore.__meta.__index = datastore.__meta
datastore.__config = require(script.Parent:WaitForChild("config"))
datastore.__load, datastore.load = event.new()

local datastore_cache = {}

function datastore.deepCopy(t)
    local copy = {}
    for k, v in ipairs(t) do
        if typeof(v) == "table" then
            v = datastore.deepCopy(v)
        end
        copy[k] = v
    end
    return copy
end

function datastore.cacheKey(name, key)
    return ("%s\\%s"):format(name, key)
end

function datastore.new(name, scope, key)
    datastore_cache[scope] = datastore_cache[scope] or {}
    if datastore_cache[scope][datastore.cacheKey(name, key)] then
        return datastore_cache[scope][datastore.cacheKey(name, key)]
    else
        datastore_cache[scope][datastore.cacheKey(name, key)] = setmetatable({}, datastore.__meta)
        local newDatastore = datastore_cache[scope][datastore.cacheKey(name, key)]
        
        newDatastore.__type = datastore.__meta.__type
        newDatastore.Name = name
        newDatastore.Scope = scope
        newDatastore.Key = key
        newDatastore.Store = game:GetService("DataStoreService"):GetDataStore(newDatastore.Name, newDatastore.Scope)
        newDatastore.LastSet = time()
        newDatastore.Data = nil

        --for i=1, datastore.__config.MaxTries do
        local suc, err = pcall(function()
            newDatastore.Data = newDatastore.Store:GetAsync(key)
        end)
        if not suc then
            warn(string.format("[LOAD SAVE][ERROR] Name:[%s] Scope:[%s] Key:[%s]\n\t%s", name, scope, key, err))
        end
            --wait(datastore.__config.ErrorWaitTime)
        --end

        --========/Events/========--
        newDatastore.Events = {}
        newDatastore.Events.__onUpdate, newDatastore.Events.onUpdate = event.new()
        newDatastore.Events.__onRemove, newDatastore.Events.onRemove = event.new()

        return newDatastore, err
    end
end

function datastore.getDatastoreCount()
    local count = 0
    for _, scope in pairs(datastore_cache) do
        for _ in pairs(scope) do
            count += 1
        end
    end
    return count
end

function datastore.saveAll(scope)
    scope = scope or "global"
    for _, store in pairs(datastore_cache[scope] or {}) do
        store:save()
    end
end

function datastore.removeAll(scope)
    scope = scope or "global"
    for _, store in pairs(datastore_cache[scope] or {}) do
        store:remove()
    end
end

function datastore.saveAllPlayer(player)
    datastore.saveAll("User_"..player.UserId)
end

function datastore.removeAllPlayer(player)
    datastore.removeAll("User_"..player.UserId)
end

function datastore.player(player, key)
    local slot = player:WaitForChild("Slot").Value
    return datastore.new("Slot_"..slot, "User_"..player.UserId, key)
end

function datastore.global(name, key)
    return datastore.new(name, "global", key)
end

function datastore.__meta.get(self, defaultValue)
    if self.Data == nil then
        self:set(defaultValue)
    end
    return self.Data
end

function datastore.__meta.set(self, value)
    while not self.Events do
        wait()
    end
    local _, err = pcall(function()
        self.Data = value
        self.Events.__onUpdate:Fire(value)
    end)
    return err
end

function datastore.__meta.update(self, callback, defaultValue)
    return self:set(callback(self:get(defaultValue)))
end

function datastore.__meta.increment(self, value, defaultValue)
    return self:update(function(data)
        data += value or 1
        return data
    end, defaultValue)
end

function datastore.__meta.save(self)
    while not self.LastSet and not self.Key and not self.Name and not self.Scope and not self.Key do
        wait()
    end
    print(string.format("[START SAVE] Name:[%s] Scope:[%s] Key:[%s]", self.Name, self.Scope, self.Key))
    local waitTime = math.max(0, 7 - os.difftime(time(), self.LastSet))
    self.LastSet = time()
    print(string.format("[SAVE WAIT]: %d", waitTime))
    wait(waitTime)
    --local suc, err
    --for i=1, datastore.__config.MaxTries do
    local suc, err = pcall(function()
        local value = self:get()
        self.Store:SetAsync(self.Key, value)
        print(string.format("[SAVED] Name:[%s] Scope:[%s] Key:[%s] Value:[%s]", self.Name, self.Scope, self.Key, tostring(value)))
    end)
    if not suc then
        warn(string.format("[SAVE][ERROR] Name:[%s] Scope:[%s] Key:[%s]\n\t%s",self.Name, self.Scope, self.Key, err))--TODO log to analytics
    end
        --wait()
    --end
    print(string.format("[END SAVE] Name:[%s] Scope:[%s] Key:[%s]", self.Name, self.Scope, self.Key))
    return suc, err
end

function datastore.__meta.remove(self)
    while not self.Events and not self.Name and not self.Scope and not self.Key do
        wait()
    end
    self.Events.__onRemove:Fire(self)
    datastore_cache[self.Scope][datastore.cacheKey(self.Name, self.Key)] = nil
    print(string.format("[DATASTORE][CACHE][REMOVED] Name:[%s] Scope:[%s] Key:[%s]", self.Name, self.Scope, self.Key))
end

function datastore.__meta.connect(self, event, callback)
    while not self.Events do
        wait()
    end
    return self.Events[event]:Connect(callback)
end

function datastore:startAutosave()
    if not self.AutosaveRunning then
        self.AutosaveRunning = true
        spawn(function()
            if game:GetService("RunService"):IsStudio() and not config:get("SaveInStudio") then
                self:stopAutosave()
            end
            while wait(self.__config.AutoSaveInterval) and self.AutosaveRunning do
                print(string.format("[START AUTOSAVING]"))
                for _, player in ipairs(game:GetService("Players"):GetChildren()) do
                    self.saveAllPlayer(player)
                end
                self.saveAll("global")
                print(string.format("[END AUTOSAVING]"))
            end
        end)
    end
end

function datastore:stopAutosave()
    self.AutosaveRunning = false
end

datastore:startAutosave()

game:GetService("Players").PlayerAdded:Connect(function(player)
    datastore.__load:Fire(player)
end)

return datastore