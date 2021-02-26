local server = require(game:GetService('ServerScriptService'):WaitForChild('modules'))
local datastore = server.get('datastore')

local shared = require(game:GetService('ReplicatedStorage'):WaitForChild('modules'))

local printCF = require(game:GetService('ServerStorage'):WaitForChild('printCF'))

local function getPlayer(player, nameOrid)
    if typeof(nameOrid) == 'string' then
        if nameOrid == 'me' then
            return player
        else
            return game:GetService('Players'):FindFirstChild(nameOrid)
        end
    elseif typeof(nameOrid) == 'number' then
        return game:GetService('Players'):GetPlayerByUserId(nameOrid)
    end
end

local commands = {}

commands.set = {
    prefix = { 'set' },
    args = { '<number/string>', '<string>', '<variant>' },
    rank = 'DEV',
    callback = function(player, target, key, value)
        target = getPlayer(player, target)
        if target then
            local store = datastore.combined.player(target, 'Data')
            if store.Keys[key] then
                local oldValue = store:get(key)
                if oldValue == nil or typeof(oldValue) == typeof(value) then
                    store:set(key, value)
                end
            end
        end
    end
}

commands.get = {
    prefix = { 'get' },
    args = { '<number/string>', '<string>' },
    rank = 'DEV',
    callback = function(player, target, key)
        target = getPlayer(player, target)
        if target then
            local store = datastore.combined.player(target, 'Data')
            print(store:get(key))
        end
    end
}

commands.set_rank = {
    prefix = { 'setRank' },
    args = { '<number/string>', '<string>' },
    rank = 'DEV',
    callback = function(player, target, newRank)
        pcall(function()
            target = getPlayer(player, target)
            if target then
                local store = datastore.combined.player(target, 'Data', 'Rank')
                for _, rank in ipairs{ 'dev', 'admin', 'user' } do
                    if newRank:lower() == rank then
                        store:set('Rank', rank:upper())
                    end
                end
            end
        end)
    end
}

commands.kill = {
    prefix = { 'kill' },
    args = { '<number/string>' },
    rank = 'ADMIN',
    callback = function(player, target)
        target = getPlayer(player, target)
        if target then
            local char = target.Character
            if char then
                local head = char:FindFirstChild('Head')
                if head then
                    head:Destroy()
                end
            end
        end
    end
}

commands.fly = {
    prefix = { 'fly' },
    args = {},
    rank = 'ADMIN',
    callback = function(player)
        local flyScript = player.PlayerGui:FindFirstChild('flight')
        if flyScript then
            local cleanup = script.fly.cleanup:Clone()
            cleanup.Parent = player.PlayerGui
            flyScript:Destroy()
        else
            local fly = script.fly.flight:Clone()
            fly.Parent = player.PlayerGui
        end
    end
}

commands.tp_to = {
    prefix = { 'tpto' },
    args = { '<number/string>', '<number/string>' },
    rank = 'ADMIN',
    callback = function(_, playerFrom, playerTo)
        playerFrom = getPlayer(playerFrom)
        playerTo = getPlayer(playerTo)
        if playerFrom ~= playerTo then
            local charFrom = playerFrom.Character or playerFrom.CharacterAdded:Wait()
            local hrtFrom = charFrom:FindFirstChild('HumanoidRootPart')
            local charTo = playerTo.Character or playerTo.CharacterAdded:Wait()
            local hrtTo = charTo:FindFirstChild('HumanoidRootPart')
            if hrtFrom and hrtTo then
                hrtFrom.CFrame = hrtTo.CFrame
            end
        end
    end
}

commands.kick = {
    prefix = { 'kick' },
    args = { '<number/string>', '<string>' },
    rank = 'ADMIN',
    callback = function(player, target, reason)
        target = getPlayer(player, target)
        if target ~= player then
            target:Kick(reason)
        end
    end
}

commands.ban = {
    prefix = { 'ban' },
    args = { '<number/string>', '<string>' },
    rank = 'DEV',
    callback = function(player, target, reason)
        target = getPlayer(player, target)
        if target  ~= player then
            local store = datastore.combined.player(player, 'Data', 'Banned')
            store:update(function(data)
                data.Banned = true
                data.Info = reason or 'No reason specified!'
            end)
        end
    end
}

commands.unban = {
    prefix = { 'unban' },
    args = { '<number/string>', '<string>' },
    rank = 'DEV',
    callback = function(player, target)
        target = getPlayer(player, target)
        if target  ~= player then
            local store = datastore.global('Banned', player.UserId)
            store:update(function(data)
                data.Banned = false
                data.Info = ''
            end)
        end
    end
}

commands.printCF = {
    prefix = { 'printCF' },
    args = { '<number>', '<number>', '<number>' },
    rank = 'USER',
    callback = function(_, x, y, z)
        printCF(CFrame.Angles(math.rad(x), math.rad(y), math.rad(z)))
    end
}

return commands