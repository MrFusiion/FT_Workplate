local CS = game:GetService("CollectionService")

local equipment
local equiments = {}

game:GetService("Players").PlayerAdded:Connect(function(player)
    while not equipment do wait() end
    local newEquipment = equipment.new(player)
    newEquipment:clearBackAccesories()
    newEquipment:setVacuum()
    newEquipment:setBackpack()
    newEquipment:createTube()
    equiments[player.UserId] = newEquipment

    local char = player.Character or player.CharacterAdded:Wait()
    CS:AddTag(char, "Player")
    
    player.CharacterAdded:Connect(function(char)
        CS:AddTag(char, "Player")
    end)
end)

game:GetService("Players").PlayerRemoving:Connect(function(player)
    equiments[player.UserId] = nil
end)

script.GetVacuumStats.OnInvoke = function(player)
    if equiments[player.UserId] then
        return equiments[player.UserId]:getVacuumStats()
    end
end

script.AddResource.Event:Connect(function(player, name, value)
    local playerEquipment = equiments[player.UserId]
    if playerEquipment then
        playerEquipment.Content:addResource(name, value)
        playerEquipment.Content:render()
    end
end)

script.SetVacuum.Event:Connect(function(player, vacuumName)
    equiments[player.UserId]:setVacuum(vacuumName)
    equiments[player.UserId]:createTube()
end)

script.SetBackpack.Event:Connect(function(player, backpackName)
    equiments[player.UserId]:setBackpack(backpackName)
    equiments[player.UserId]:createTube()
end)

equipment = require(script:WaitForChild("equipment"))