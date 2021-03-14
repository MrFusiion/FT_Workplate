local content = require(game.ServerScriptService.Objects.modules.content)

local server = require(game.ServerScriptService.Modules)
local datastore = server.get("datastore")

local vacuumFolder = game:GetService("ReplicatedStorage"):WaitForChild("Vacuums")
local backpackFolder = game:GetService("ReplicatedStorage"):WaitForChild("Backpacks")

local equipment = {}
equipment.__index = equipment

local function createWeld(part0, part1)
    local weld = Instance.new("Weld")
    weld.Part0 = part0
    weld.Part1 = part1
    weld.C0 = part0.CFrame:Inverse()
    weld.C1 = part1.CFrame:Inverse()
    return weld
end

local function weldVacuum(vacuum)
    local handle = vacuum:FindFirstChild("Handle")
    local model = vacuum:FindFirstChild("Model")
    if handle and model then
        for _, descendant in ipairs(model:GetDescendants()) do
            if descendant:IsA("BasePart") then
                createWeld(descendant, handle).Parent = descendant
            end
        end
    else
        warn(("Vacuum %s has no %s!"):format(vacuum.Name, not handle and "Handle" or "Model"))
    end
    return vacuum
end

local function weldBackpack(backpack)
    local handle = backpack:FindFirstChild("Handle")
    local model = backpack:FindFirstChild("Model")
    local contentPart = backpack:FindFirstChild("Content")
    if handle and model and contentPart then
        for _, descendant in ipairs(model:GetDescendants()) do
            if descendant:IsA("BasePart") then
                createWeld(descendant, handle).Parent = descendant
            end
        end
        createWeld(contentPart, handle).Parent = contentPart
    else
        warn(("Backpack %s has no %s!"):format(backpack.Name, not handle and "Handle" or (not model and "Model" or "Content(Part)")))
    end
    return backpack
end

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
    if name then self.Store:set("Vacuum", name)
    else name = self.Store:get("Vacuum", "StarterVacuum")
    end
    if name then
        local vacuum = vacuumFolder:FindFirstChild(name)
        if vacuum then
            if self.Vacuum then self.Vacuum:Destroy() end

            self.Vacuum = weldVacuum(vacuum:Clone())
            self.Vacuum:SetAttribute("Vacuum", true)

            if self.Vacuum:FindFirstChild("Test") then
                self.Vacuum.Test:Destroy()
            end

            self.Vacuum.Parent = self.Player.Backpack
        else
            warn(("Vacuum with the name %s doesn't exist!"):format(name))
        end
    else
        warn("No Vacuum name found!")
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
    if name then self.Store:set("Backpack", name)
    else name = self.Store:get("Backpack", "StarterBackpack")
    end
    if name then
        local bacpack = backpackFolder:FindFirstChild(name)
        if bacpack then
            local oldContentData
            if self.Backpack then self.Backpack:Destroy() end
            if self.Content then oldContentData = self.Content:export() self.Content:destroy() end

            self.Backpack = weldBackpack(bacpack:Clone())
            self.Backpack:SetAttribute("Backpack", true)

            self.Content = content.new(self.Backpack:WaitForChild("Content"), self.Backpack:GetAttribute("MaxVolume") or 0)
            if oldContentData then
                self.Content:import(oldContentData)
                self.Content:render()
            end

            self.Humanoid:AddAccessory(self.Backpack)
        else
            warn(("Backpack with the name %s doesn't exist!"):format(name))
        end
    else
        warn("No Vacuum name found!")
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
    tube.Attachment0 = self.Backpack.Handle.TubeAttachment
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