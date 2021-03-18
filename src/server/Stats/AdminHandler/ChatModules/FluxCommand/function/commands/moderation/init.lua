local server = require(game:GetService("ServerScriptService"):WaitForChild("Modules"))
local datastore = server.get("datastore")

local ranks = require(script.Parent.Parent.ranks)

local admin = {}

admin.set_rank = {
    prefix = { "setRank" },
    args = { "<player>", "<string>" },
    rank = "DEV",
    callback = function(player, target, rankName)
        pcall(function()
            local store = datastore.combined.player(target, "Data", "Rank")
            for rank in pairs(ranks) do
                if rankName:upper() == rank then
                    store:set("Rank", rank)
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
        if target ~= player then
            local bannedStore = datastore.global("Banned", player.UserId)
            bannedStore:update(function(data)
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