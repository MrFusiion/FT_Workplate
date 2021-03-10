--@initApi
--@Class: "BioGenerator"
local super = script.Parent.Parent.Parent
local getModel = require(super:WaitForChild("getModel"))
local submodule = require(super:WaitForChild("submodules"))
local contentClass = submodule.get("content")

local bioGenClass = {}
bioGenClass.__index = bioGenClass
bioGenClass.Name = "BioGenerator"

--[[
@Function: {
    "class" : "BioGenerator",
    "name" : "new",
    "args" : { "part" : "BasePart" },
    "return" : "Property",
    "info" : "Creates a new BioGenerator."
}
@Properties: {
    "class" : "BioGenerator",
    "props" : [{
        "name" : "Model",
        "type" : "Model"
    }, {
        "name" : "Content",
        "type" : "Content"
    }]
}]]
bioGenClass.MODEL = getModel("tier2\\machines\\generators\\BioGenerator")
function bioGenClass.new(parent, cf)
    local newBioGen = setmetatable({}, bioGenClass)

    newBioGen.Model = bioGenClass.MODEL:Clone()
    newBioGen.Model:SetPrimaryPartCFrame(cf + cf.UpVector * bioGenClass.MODEL.PrimaryPart.Size.Y / 2)
    newBioGen.Model.Parent = parent

    newBioGen.Content = contentClass.new(newBioGen.Model.Water, "fluid", 100)
    newBioGen.Content:setFluidType("water")
    newBioGen.Content.BrickColor = BrickColor.new("Shamrock")

    return newBioGen
end

return bioGenClass