local light = {}
light.__index = light

function light.new(model)
    local self = setmetatable({}, light)
    self.Lights = {}
    self.Parts = {}

    for _, descendant in ipairs(model:GetDescendants()) do
        if descendant:IsA("BasePart") and descendant.Material == Enum.Material.Neon then
            table.insert(self.Parts, descendant)
        elseif descendant:IsA("SpotLight") or descendant:IsA("SurfaceLight") or descendant:IsA("PointLight") then
            table.insert(self.Lights, descendant)
        end
    end

    return self
end

function light:on()
    for _, part in ipairs(self.Parts) do
        part.Material = "Neon"
    end
    for _, l in ipairs(self.Lights) do
        l.Enabled = true
    end
end

function light:off()
    for _, part in ipairs(self.Parts) do
        part.Material = "SmoothPlastic"
    end
    for _, l in ipairs(self.Lights) do
        l.Enabled = false
    end
end

return light