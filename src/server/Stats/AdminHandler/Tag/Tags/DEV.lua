local server = require(game.ServerScriptService.Modules)
local datastore = server.get("datastore")
local tag = require(script.Parent.Parent)

local newTag = tag.new("DEV", Color3.new(0.992156, 0.529411, 0), 5, {
        NameColor = Color3.new(0.854901, 0.278431, 0.278431)
    }
)

function newTag:condition(player)
    local store = datastore.combined.player(player, "Data", "Rank")
	return "DEV" == store:get("Rank")
end

function newTag:shouldUpdate()
    return false
end

return newTag