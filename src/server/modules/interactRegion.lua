local shared = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"))
local event = shared.get("event")

local interactRegion = {}
interactRegion.__index = interactRegion

interactRegion.Folder = Instance.new("Folder")
interactRegion.Folder.Name = "InteractRegions"
interactRegion.Parent = workspace

function interactRegion.new(position, radius)
    local newRegion = {}

    newRegion.Part = Instance.new("Part")
    newRegion.Part.Shape = Enum.PartType.Ball
    newRegion.Part.CanCollide = false
    newRegion.Part.Anchored = true
    newRegion.Part.Transparency = 1
    newRegion.Part.Position = position
    newRegion.Part.Size = Vector3.new(1, 1, 1) * radius / 2
    newRegion.Part.Parent = interactRegion.Folder

    newRegion.__PlayerEnter, newRegion.PlayerEnter = event.new()
    newRegion.__PlayerExit, newRegion.PlayerExit = event.new()

    interactRegion.init(newRegion)
    return newRegion
end

function interactRegion.init(self)
    self.Part.Touched:Connect(function(part)
        if part.Name == "HumanoidRootPart" then
            local player = game:GetService("Players"):GetPlayerFromCharacter(part.Parent)
            if player then
                self.__PlayerEnter:Fire(player)
            end
        end
    end)
    self.Part.TouchEnded:Connect(function(part)
        if part.Name == "HumanoidRootPart" then
            local player = game:GetService("Players"):GetPlayerFromCharacter(part.Parent)
            if player then
                self.__PlayerExit:Fire(player)
            end
        end
    end)
end

return interactRegion