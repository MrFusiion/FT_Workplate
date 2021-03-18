local client = require(game.StarterPlayer.StarterPlayerScripts.Modules)
local playerUtils = client.get("playerUtils")

local backpack = {}
backpack.__index = backpack

function backpack.new(accessory)
    local newBackpack = setmetatable({}, backpack)
    
    newBackpack.Model = accessory.Model

    local conn = newBackpack:connectFirstPersonEvent()
    playerUtils.onDead(function()
        conn:Disconnect()
        conn = newBackpack:connectFirstPersonEvent()
    end)

    return newBackpack
end

function backpack:transparency(value)
    for _, descendant in ipairs(self.Model:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.LocalTransparencyModifier = value
        elseif descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") then
            descendant.Enabled = value == 0
        end
    end
end

function backpack:connectFirstPersonEvent()
    local head = playerUtils:getChar():WaitForChild("Head")
    return head:GetPropertyChangedSignal("LocalTransparencyModifier"):Connect(function()
        self:transparency(head.LocalTransparencyModifier)
    end)
end

return backpack