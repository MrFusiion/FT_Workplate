local equipment
local equiments = {}

game:GetService("Players").PlayerAdded:Connect(function(player)
    while not equipment do wait() end
    equiments[player.UserId] = equipment.new(player)
    equiments[player.UserId]:clearBackAccesories()
    equiments[player.UserId]:setVacuum()
    equiments[player.UserId]:setBackpack()
    equiments[player.UserId]:createTube()
end)

game:GetService("Players").PlayerRemoving:Connect(function(player)
    equiments[player.UserId] = nil
end)

script.GetVacuumStats.OnInvoke = function(player)
    return equiments[player.UserId]:getVacuumStats()
end

equipment = require(script:WaitForChild("equipment"))