local wire = {}
wire.__index = wire

function wire.new(part0, part1, color)
    local newWire = setmetatable({}, wire)

    newWire.Att0 = Instance.new("Attachment")
    newWire.Att0.Position = Vector3.new()
newWire.Att0.Parent = part0

    newWire.Att1 = Instance.new("Attachment")
    newWire.Att1.WorldPosition = Vector3.new()
    newWire.Att1.Parent = part1

    newWire.Constraint = Instance.new("RopeConstraint")
    newWire.Constraint.Attachment0 = newWire.Att0
    newWire.Constraint.Attachment1 = newWire.Att1
    newWire.Constraint.Visible = true
    newWire.Constraint.Parent = part0

    newWire.Constraint.Color = color or BrickColor.Black()
    
    return newWire
end

function wire:setColor(color)
    self.Constraint.Color = color
end

function wire:getLength()
    local len = (self.Att0.WorldPosition - self.Att1.WorldPosition).magnitude
    print(len)
    return len
end

function wire:destroy()
    self.Att0:Destroy()
    self.Att1:Destroy()
    self.Constraint:Destroy()
end

return wire