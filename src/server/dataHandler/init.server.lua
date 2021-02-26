local server = require(game:GetService("ServerScriptService"):WaitForChild('modules'))
local datastore = server.get('datastore')
local analytics = server.get('analytics')

local shared = require(game:GetService('ReplicatedStorage'):WaitForChild('modules'))
local config = shared.get('settings').new(game:GetService('ServerScriptService'):WaitForChild('config'))

local data = require(script:WaitForChild('data'))
datastore.load:Connect(function(player)
    local stats = Instance.new('Folder')
    stats.Name = 'leaderstats'
    stats.Parent = player

    local conf = Instance.new('Configuration')
    conf.Name = 'config'
    conf.Parent = player

    for name, d in pairs(data.session) do
        local dataV = Instance.new(d.type)
        dataV.Name = name
        dataV.Value = d.value
        dataV.Parent = player
    end

    for name, d in pairs(data.config) do
        local dataV = Instance.new(d.type)
        dataV.Name = name
        dataV.Value = d.value
        dataV.Parent = conf
    end

    local store = datastore.combined.player(player, 'Data', 'Cash', 'Cores')
    for name, d in pairs(data.save) do
        local dataV = Instance.new(d.type)
        dataV.Name = name
        dataV.Value = store:get(name, d.value)
        dataV.Parent = d.stat and stats or player

        store:connect('onUpdate', name, function(value)
            dataV.Value = value
        end)
    end
    --analytics.purchase('Test', 1234567, 500)
end)

game:GetService('Players').PlayerRemoving:Connect(function(player)
    if game:GetService('RunService'):IsStudio() and not config:get('SaveInStudio') then
        return
    end
    print(string.format('[PLAYER REMOVING]: %s[%d]', player.DisplayName, player.UserId))
    datastore.saveAllPlayer(player)
    datastore.removeAllPlayer(player)
end)

game:BindToClose(function()
    print(string.format('[SERVER CLOSING]'))
    if game:GetService('RunService'):IsStudio() and not config:get('SaveInStudio') then
        return
    end
    datastore.AutosaveRunning = false
    
    local dataCount = datastore.getDatastoreCount()
    print(string.format('[SERVER CLOSING][START SAVING]'))
    print(string.format('[SERVER CLOSING][START SAVING]: datastore\'s %d left.', dataCount))
    for _, player in ipairs(game:GetService('Players'):GetChildren()) do
        player:Kick('Server closing')
    end
    datastore.saveAll('global')
    datastore.removeAll('global')

    dataCount = datastore.getDatastoreCount()
    repeat
        dataCount = datastore.getDatastoreCount()
        print(string.format('[SERVER CLOSING][WAITING]: datastore\'s %d left.', dataCount))
        wait(1)
    until dataCount <= 0
    print(string.format('[SERVER CLOSING][END SAVING]'))
end)