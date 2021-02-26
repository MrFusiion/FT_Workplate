local server = require(game:GetService('ServerScriptService'):WaitForChild('modules'))
local datastore = server.get('datastore')

local shared = require(game:GetService('ReplicatedStorage'):WaitForChild('modules'))
local stringUtils = shared.get('stringUtils')

local COMMAND_PREFIX = '/'
local RANK_TREE = { ['DEV'] = 1, ['ADMIN'] = 2, ['USER'] = 3 }

local commands = require(script.Parent:WaitForChild('commands'))
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
    local store = datastore.combined.player(player, 'Data', 'Rank')
    local rank = store:get('Rank')
    return RANK_TREE[rank] <= RANK_TREE[cmd.rank]
end

function command.getArgValue(str, arg)

    local validateType = {
        string = function(value)
            if value then
                local len = #value
                if (value:sub(1, 1) == '\'' or value:sub(1, 1) == '\"') and
                        (value:sub(len, len) == '\'' or value:sub(len, len) == '\"') then
                    return value:sub(2, len-1)
                end
            end
        end,
        number = function(value)
            local suc, n = pcall(function()
                return tonumber(value)
            end)
            if suc then
                return n
            end
        end
    }

    for _, type in ipairs({ 'string', 'number' }) do
        if arg.find(arg, type) or arg.find(arg, 'variant') then
            local value = validateType[type](str)
            if value ~= nil then
                return value
            end
        end
    end
end

function command.getArgs(cmd, msg)
    local args = {}
    local splittedMsg = stringUtils.split(msg)
    for i, arg in ipairs(cmd.args) do
        local argValue = command.getArgValue(splittedMsg[i + 1], arg)
        if argValue then
            table.insert(args, argValue)
        else
            return
        end
    end
    return args
end

function command.procces(player, cmd, msg)
    local args = command.getArgs(cmd, msg)
    if args then
        cmd.callback(player, table.unpack(args))
    end
end

return command