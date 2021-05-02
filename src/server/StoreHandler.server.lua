local server = require(game:GetService("ServerScriptService"):WaitForChild("Modules"))
local store = server.get("store")

local remote = game:GetService("ReplicatedStorage"):WaitForChild("remote"):WaitForChild("store")
local re_PomptGamepass = remote:WaitForChild("PromptGamepass")

local rf_HasGamepass = remote:WaitForChild("HasGamepass")

re_PomptGamepass.OnServerEvent:Connect(function(player, asset)
    store:promptGamepass(player, asset)
end)

function rf_HasGamepass.OnServerInvoke(player, id)
    return store:hasGamepass(player, id)
end