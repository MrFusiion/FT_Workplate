local content = require(game.ServerScriptService.Objects.modules.content)

local server = require(game.ServerScriptService.Modules)
local datastore = server.get("datastore")

local vacuumFolder = game:GetService("ReplicatedStorage"):WaitForChild("Vacuums")
local backpackFolder = game:GetService("ReplicatedStorage"):WaitForChild("Backpacks")

local equipment = {}
equipment.__index = equipment

function equipment.new(player)
    local newEquipment = setmetatable({}, equipment)
    newEquipment.Store = datastore.combined.player(player, "Data", "Vacuum", "Backpack")
    newEquipment.Player = player
    newEquipment.Character = player.Character or player.CharacterAdded:Wait()
    newEquipment.Humanoid = newEquipment.Character:WaitForChild("Humanoid")
    newEquipment.Vacuum = nil
    newEquipment.Backpack = nil
    newEquipment.Content = nil

    newEquipment.Player.CharacterAdded:Connect(function(char)
        newEquipment.Character = char
        newEquipment.Humanoid = char:WaitForChild("Humanoid")
        newEquipment:clearBackAccesories()
        newEquipment:setVacuum()
        newEquipment:setBackpack()
        newEquipment:createTube()
    end)

    return newEquipment
end

function equipment:setVacuum(name)
    if name then
        self.Store:set("Vacuum", name)
    else
        name = self.Store:get("Vacuum", "StarterVacuum")
    end
    if name then
        local vacuum = vacuumFolder:FindFirstChild(name)
        if vacuum then
            if self.Vacuum then self.Vacuum:Destroy() end
            local clone = vacuum:Clone()
            clone:SetAttribute("Vacuum", true)
            self.Vacuum = clone
        else
            warn(("Vacuum with the name %s doesn't exist!"):format(name))
        end
        self.Vacuum.Parent = self.Player.Backpack
    end
end

function equipment:getVacuumStats()
    if self.Vacuum then
        return {
            damage = self.Vacuum:GetAttribute("Damage"),
            speed = self.Vacuum:GetAttribute("Speed"),
            range = self.Vacuum:GetAttribute("Range")
        }
    end
end

function equipment:setBackpack(name)
    if name then
        self.Store:set("Backpack", name)
    else
        name = self.Store:get("Backpack", "StarterBackpack")
    end
    if name then
        local bacpack = backpackFolder:FindFirstChild(name)
        if bacpack then
            local oldContentData
            if self.Backpack then self.Backpack:Destroy() end
            if self.Content then oldContentData = self.Content:export() self.Content:destroy() end
            local clone = bacpack:Clone()
            clone:SetAttribute("Backpack", true)
            self.Backpack = clone
            self.Content = content.new(self.Backpack:WaitForChild("Content"), self.Backpack:GetAttribute("MaxVolume") or 0)
            if oldContentData then
                self.Content:import(oldContentData)
                self.Content:render()
            end
        else
            warn(("Backpack with the name %s doesn't exist!"):format(name))
        end
        self.Humanoid:AddAccessory(self.Backpack)
    end
end

function equipment:createTube()
    local tube = self.Vacuum:FindFirstChildWhichIsA("RopeConstraint")
    if tube then
        tube:Destroy()
    end

    tube = Instance.new("RopeConstraint")
    tube.Visible = true
    tube.Thickness = .3
    tube.Color = BrickColor.new("Really black")
    tube.Attachment0 = self.Backpack.Handle.Glass.TubeAttachment
    tube.Attachment1 = self.Vacuum.Handle.TubeAttachment
    tube.Parent = self.Vacuum
end

function equipment:clearBackAccesories()
    repeat wait() until self.Player:HasAppearanceLoaded()
    for _, part in ipairs(self.Humanoid:GetAccessories()) do
        if not part:GetAttribute("Backpack") then
            local handle = part:FindFirstChild("Handle")
            local weld = handle and handle:FindFirstChildWhichIsA("Weld")
            if weld and weld.Part1.Name == "UpperTorso" then
                part:Destroy()
            end
        end
    end
end

return equipment