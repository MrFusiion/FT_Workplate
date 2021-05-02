local light = {}
local light_mt = {}
light.__index = light_mt

function light.new(model, props)
    local newLight = setmetatable({}, light)
    newLight.Model = model

    newLight.Spot = Instance.new("SpotLight")
    newLight.Spot.Color = model.PrimaryPart.BrickColor.Color
    newLight.Spot.Angle = props.Angle or 90
    newLight.Spot.Brightness = props.Brightness or 1
    newLight.Spot.Range = props.Range or 20
    newLight.Spot.Parent = model.PrimaryPart

    newLight:off()

    return newLight
end

function light_mt:color(color)
    for _, part in pairs(self.Model:GetChildren()) do
        if part:IsA("BasePart") then
            part.BrickColor = color
        end
    end
    self.Spot.Color = color.Color
end

function light_mt:__props(props)
    for _, part in pairs(self.Model:GetChildren()) do
        if part:IsA("BasePart") then
            for k, v in pairs(props) do
                part[k] = v
            end
        end
    end
end

function light_mt:on()
    self.Enabled = true
    self:__props{
        Material = "Neon",
        Transparency = 0
    }
    self.Spot.Enabled = true
end

function light_mt:off()
    self.Enabled = false
    self:__props{
        Material = "Plastic",
        Transparency = .75
    }
    self.Spot.Enabled = false
end

return light