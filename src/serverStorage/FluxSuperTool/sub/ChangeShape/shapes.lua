local shapes = {}
shapes["Part"] = {}

shapes["Part"]["Block"] = function()
    local part = Instance.new("Part")
    part.Shape = Enum.PartType.Block
    return part
end

shapes["Part"]["Cylinder"] = function()
    local part = Instance.new("Part")
    part.Shape = Enum.PartType.Cylinder
    return part
end

shapes["Part"]["Ball"] = function()
    local part = Instance.new("Part")
    part.Shape = Enum.PartType.Ball
    return part
end

shapes["WedgePart"] = function()
    return Instance.new("WedgePart")
end

shapes["TrussPart"] = function()
    return Instance.new("TrussPart")
end

shapes["CornerWedgePart"] = function()
    return Instance.new("CornerWedgePart")
end

shapes["MeshPart"] = function()
    return Instance.new("MeshPart")
end

return shapes