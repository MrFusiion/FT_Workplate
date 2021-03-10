--@initApi
--@Class: "playerUtils"
local playerUtils = {}
local player = game:GetService("Players").LocalPlayer

local function safeWaitForChild(parent, childName, timeOut)
    timeOut = timeOut or 5
    local child
    local start = time()
    repeat
        child = parent:FindFirstChild(childName)
        wait(.1)
    until child or os.difftime(time(), start) >= timeOut
    return child
end

--[[@Function: {
    "class" : "playerUtils",
    "name" : "getPlayer",
    "return" : "Player",
    "info" : "Returns the local player."
}]]
function playerUtils.getPlayer()
    return player
end

--[[@Function: {
    "class" : "playerUtils",
    "name" : "getMouse",
    "return" : "Mouse",
    "info" : "Returns the local player's Mouse."
}]]
function playerUtils.getMouse()
    local plyr = playerUtils.getPlayer()
    return plyr:GetMouse()
end

--[[@Function: {
    "class" : "playerUtils",
    "name" : "getPlayerGui",
    "return" : "Player",
    "info" : "Returns the player."
}]]
function playerUtils.getPlayerGui()
    return safeWaitForChild(player, "PlayerGui")
end

--[[@Function: {
    "class" : "playerUtils",
    "name" : "getChar",
    "return" : "Model",
    "info" : "Returns the player"s Character."
}]]
function playerUtils.getChar()
    return player.Character or player.CharacterAdded:Wait()
end

--[[@Function: {
    "class" : "playerUtils",
    "name" : "getHumanoid",
    "return" : "Humanoid",
    "info" : "Returns the player"s Humanoid."
}]]
function playerUtils.getHumanoid()
    return safeWaitForChild(playerUtils.getChar(), "Humanoid")
end

--[[@Function: {
    "class" : "playerUtils",
    "name" : "lock",
    "args" : { "boolean" : "boolean" },
    "info" : "anchors the player root if boolean is true."
}]]
function playerUtils.lock(boolean)
    assert(typeof(boolean)=="boolean", " `boolean` must be type of boolean!")
    local char = playerUtils.getChar()
    local root = char:WaitForChild("HumanoidRootPart")
    root.Anchored = boolean
end

--[[@Function: {
    "class" : "playerUtils",
    "name" : "getStat",
    "args" : { "statName" : "string", "timeOut" : "number" },
    "return" : "Value",
    "info" : "Gets a specific stat of the player."
}]]
function playerUtils.getStat(statName, timeOut)
    assert(typeof(statName)=="string", " `statName` must be type of string!")
    assert(timeOut == nil or typeof(timeOut)=="number", " `timeOut` must be type of number or nil!")
    timeOut = timeOut or 5
    local stats = safeWaitForChild(player, "leaderstats", timeOut)
    if stats then
        local statValue = safeWaitForChild(stats, statName, timeOut)
        return statValue
    end
end

--[[@Function: {
    "class" : "playerUtils",
    "name" : "getConfig",
    "args" : { "statName" : "string", "timeOut" : "number" },
    "return" : "Value",
    "info" : "Gets a specific config setting of the player."
}]]
function playerUtils.getConfig(configName, timeOut)
    assert(typeof(configName)=="string", " `configName` must be type of string!")
    assert(timeOut == nil or typeof(timeOut)=="number", " `timeOut` must be type of number or nil!")
    timeOut = timeOut or 5
    local config = safeWaitForChild(player, "config", timeOut)
    if config then
        local configValue = safeWaitForChild(config, configName, timeOut)
        return configValue
    end
end

--[[@Function: {
    "class" : "playerUtils",
    "name" : "getSlot",
    "args" : { timeOut" : "number" },
    "return" : "number",
    "info" : "Gets the current saveslot of the player."
}]]
function playerUtils.getSlot(timeOut)
    assert(timeOut == nil or typeof(timeOut)=="number", " `timeOut` must be type of number or nil!")
    timeOut = timeOut or 5
    local slotValue = safeWaitForChild(player, "Slot", timeOut)
    if slotValue then
        return slotValue.Value
    end
end

--[[@Function: {
    "class" : "playerUtils",
    "name" : "onDead",
    "args" : { "func" : "function" },
    "info" : "Connects a function to the humanoid died event."
}]]
function playerUtils.onDead(func)
    assert(typeof(func)=="function", " `func` must be type of function!")
    return playerUtils.getHumanoid().Died:Connect(func)
end

return playerUtils