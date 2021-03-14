local server = require(game:GetService("ServerScriptService"):WaitForChild("Modules"))
local datastore = server.get("datastore")

local admin = {}

admin.set_rank = {
    prefix = { "setRank" },
    args = { "<player>", "<string>" },
    rank = "DEV",
    callback = function(player, target, newRank)
        pcall(function()
            if target then
                local store = datastore.combined.player(target, "Data", "Rank")
                for _, rank in ipairs{ "dev", "admin", "user" } do
                    if newRank:lower() == rank then
                        store:set("Rank", rank:upper())
                    end
                end
            end
        end)
    end
}

admin.kick = {
    prefix = { "kick" },
    args = { "<player>", "<string>" },
    rank = "ADMIN",
    callback = function(player, target, reason)
        if target ~= player then
            target:Kick(reason)
        end
    end
}

admin.ban = {
    prefix = { "ban" },
    args = { "<player>", "<string>" },
    rank = "DEV",
    callback = function(player, target, reason)
        if target  ~= player then
            local store = datastore.combined.player(player, "Data", "Banned")
            store:update(function(data)
                data.Banned = true
                data.Info = reason or "No reason specified!"
            end)
        end
    end
}

admin.unban = {
    prefix = { "unban" },
    args = { "<player>", "<string>" },
    rank = "DEV",
    callback = function(player, target, reason)
        if target  ~= player then
            local store = datastore.global("Banned", player.UserId)
            store:update(function(data)
                data.Banned = false
                data.Info = ""
            end)
        end
    end
}

return admin