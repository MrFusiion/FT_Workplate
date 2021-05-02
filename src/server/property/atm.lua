local shared = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"))
local interaction = shared.get("interaction")

local properties = require(script.Parent.properties)

local remoteProperty = game:GetService("ReplicatedStorage")
    :WaitForChild("remote")
    :WaitForChild("property")
local re_BuyProperty = remoteProperty:WaitForChild("BuyProperty")
local re_ExpandProperty = remoteProperty:WaitForChild("ExpandProperty")

local atm = {}
atm.__index = atm

function atm.new(model, light)
    local newAtm = setmetatable({}, atm)
    newAtm.Light = { Part = light, Src = light:FindFirstChildWhichIsA("PointLight") }

    newAtm.Prompt = interaction.prompt.new()
    newAtm.Prompt.Triggered:Connect(function(player)
        newAtm:flashLight()
        local prop = properties:get(player.UserId)
        if prop then
            if not prop:maxUpgraded() then
                re_ExpandProperty:FireClient(player)
            end
        else
            re_BuyProperty:FireClient(player, properties)
        end
        print(properties)
    end)
    newAtm.Prompt.Parent = model

    return newAtm
end

function atm.enableLight(self, boolean)
    self.Light.Part.Material = boolean and "Neon" or "SmoothPlastic"
    if self.Light.Src then
        self.Light.Src.Enabled = boolean
    end
end

function atm.flashLight(self)
    spawn(function()
        self:enableLight(true)
        wait(.5)
        self:enableLight(false)
    end)
end

return atm