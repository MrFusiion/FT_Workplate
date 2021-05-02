local server = require(game:GetService("ServerScriptService"):WaitForChild("Modules"))
local datastore = server.get("datastore")

local shared = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"))
local stringUtils = shared.get("stringUtils")

local COMMAND_PREFIX = "/"
local ranks = require(script.Parent.ranks)

local commands = require(script.Parent.commands)
local command = {}

function command.getCommand(msg)
    for msgPrefix in stringUtils.splitIter(msg) do
        for _, cmd in pairs(commands) do
            for _, prefix in ipairs(cmd.prefix) do
                if msgPrefix == COMMAND_PREFIX..prefix then
                    return cmd
                end
            end
        end
        break
    end
end

function command.canPlayerUseCommand(player, cmd)
    local store = datastore.combined.player(player, "Data", "Rank")
    local rank = store:get("Rank")
    return ranks[rank] <= ranks[cmd.rank]
end

function command.getArgValue(player, str, arg)

    local Validators = {}

    Validators[1] = {
        type = "number",
        func = function(value)
            local suc, n = pcall(function()
                return tonumber(value)
            end)
            if suc then
                return n
            else
                --print("unvalid number!", value)
            end
        end
    }

    Validators[2] = {
        type = "string",
        func = function(value)
            if value then
                return tostring(value)
                --local len = #value
                --if (value:sub(1, 1) == "\"" or value:sub(1, 1) == "'") and
                        --(value:sub(len, len) == "\"" or value:sub(len, len) == "'") then
                    --return value:sub(2, len-1)
                --else
                    --print("unvalid string!", value)
                --end
            end
        end
    }

    Validators[3] = {
        type = "player",
        func = function(value)
            local name = Validators[2].func(value)
            if name then
                if name == "me" then
                    return player
                else
                    return game:GetService("Players"):FindFirstChild(name)
                end
            else
                local id = Validators[1].func(value)
                return game:GetService("Players"):GetPlayerByUserId(id)
            end
        end
    }

    for _, validator in ipairs(Validators) do
        if arg.find(arg, validator.type) or arg.find(arg, "variant") then
            local value = validator.func(str)
            if value ~= nil then
                return value
            end
        end
    end
end

function command.getArgs(player, cmd, msg)
    local args = {}
    local splittedMsg = stringUtils.split(msg)
    for i, arg in ipairs(cmd.args) do
        local argValue = command.getArgValue(player, splittedMsg[i + 1], arg)
        if argValue then
            table.insert(args, argValue)
        else
            return --TODO Write Error msg to client's chat
        end
    end
    return args
end

function command.procces(player, cmd, msg)
    local args = command.getArgs(player, cmd, msg)
    if args then
        cmd.callback(player, table.unpack(args))
    end
end

return command