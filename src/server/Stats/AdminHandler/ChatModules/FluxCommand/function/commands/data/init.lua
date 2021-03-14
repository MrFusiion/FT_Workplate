local server = require(game:GetService("ServerScriptService"):WaitForChild("Modules"))
local datastore = server.get("datastore")

local data = {}

data.set = {
    prefix = { "set" },
    args = { "<player>", "<string>", "<variant>" },
    rank = "DEV",
    callback = function(player, target, key, value)
        if target then
            local store = datastore.combined.player(target, "Data")
            if store.Keys[key] then
                local oldValue = store:get(key)
                if oldValue == nil or typeof(oldValue) == typeof(value) then
                    store:set(key, value)
                end
            end
        end
    end
}

data.get = {
    prefix = { "get" },
    args = { "<player>", "<string>" },
    rank = "DEV",
    callback = function(player, target, key)
        if target then
            local store = datastore.combined.player(target, "Data")
            print(store:get(key))
        end
    end
}

return data