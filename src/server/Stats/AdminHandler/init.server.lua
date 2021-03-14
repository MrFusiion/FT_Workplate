local server = require(game:GetService("ServerScriptService"):WaitForChild("Modules"))
local datastore = server.get("datastore")

local tags
game:GetService("Players").PlayerAdded:Connect(function(player)
    local store = datastore.combined.player(player, "Data", "Rank")

    local bannedStore = datastore.global("Banned", player.UserId)
    local bannedData = bannedStore:get({ Banned = false, Info = "" })
    if bannedData.Banned then
        player:Kick("Banned: " .. bannedData.Info)
    end

    if player.UserId == 1084911946 or player.UserId == -1 then store:set("Rank", "DEV") end
    local rank = store:get("Rank")
    repeat wait() until tags
    for _, tag in pairs(tags) do
        if tag.condition(player, rank) then
            tag:apply(player)
        end
    end
end)

--Insert custom ChatModules in ChatModules
local folder = script:WaitForChild("ChatModules")
local targetFolder = game:GetService("Chat"):WaitForChild("ChatModules")
for _, module in ipairs(folder:GetChildren()) do
    if module:IsA("ModuleScript") then
        local bFunction = module:FindFirstChildWhichIsA("BindableFunction")
        local onInvoke = module:FindFirstChildWhichIsA("ModuleScript")
        if bFunction and onInvoke then
            local suc, err = pcall(function()
                bFunction.OnInvoke = require(onInvoke)
            end)
            if not suc then
                warn(string.format("[ADMIN][LOADING COMMAND][ERROR][%s]: %s", module.Name, err))
            end
        end
        local oldModule = targetFolder:FindFirstChild(module.Name)
        if oldModule then oldModule:Destroy() end
        module.Parent = targetFolder
    end
end

tags = require(script:WaitForChild("Tags"))