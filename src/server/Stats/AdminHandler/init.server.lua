local server = require(game:GetService("ServerScriptService"):WaitForChild("Modules"))
local datastore = server.get("datastore")

local MAX_TAGS = 3
local DEVS = {
    -1, --Player1
    1084911946 --S3nt1ne3l
}

local tags
game:GetService("Players").PlayerAdded:Connect(function(player)
    local store = datastore.combined.player(player, "Data", "Rank")

    local bannedStore = datastore.global("Banned", player.UserId)
    local bannedData = bannedStore:get({ Banned = false, Info = "" })
    if bannedData.Banned then
        player:Kick("Banned: " .. bannedData.Info)
    end

    --Check if player is a DEV from local table if so set his rank to DEV
    for _, id in ipairs(DEVS) do
        if player.UserId == id then
            store:set("Rank", "DEV")
        end
    end

    --Get all Tags
    local playerTags = {}
    repeat wait() until tags
    for _, tag in pairs(tags) do
        if tag:condition(player) then
            table.insert(tags, tag)
            if #playerTags == MAX_TAGS then
                break
            end
        end
    end

    --Sort Tags by priority
    table.sort(playerTags, function(a, b)
        return a.Priority < b.Priority
    end)

    --Apply all Tags
    for _, tag in ipairs(playerTags) do
        tag:apply(player)
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

tags = require(script.Tag.Tags)