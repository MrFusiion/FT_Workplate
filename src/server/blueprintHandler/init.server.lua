local server = require(game:GetService("ServerScriptService"):WaitForChild("Modules"))
local validate = server.get("validate")

local remoteBlueprint = game:GetService("ReplicatedStorage")
    :WaitForChild("remote")
    :WaitForChild("blueprints")
