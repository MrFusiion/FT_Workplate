local spot = {}
spot.__index = spot

function spot.new(model : Model, symbols : table)
    local self = setmetatable({}, spot)
    self.Parent = model
    self.SpotCFrame = model:GetPrimaryPartCFrame()
    return self
end

function spot:setSymbol(part)
    if self.CurrentSymbol then
        self.CurrentSymbol:Destroy()
    end

    if part then
        self.CurrentSymbol = part:Clone()

        self.CurrentSymbol.Material = "Neon"
        self.CurrentSymbol.BrickColor = BrickColor.new("Cool yellow")
        self.CurrentSymbol.Transparency = 0

        self.CurrentSymbol.Anchored = true
        self.CurrentSymbol.CFrame = self.SpotCFrame

        self.CurrentSymbol.Parent = self.Parent
    end
end

return spot