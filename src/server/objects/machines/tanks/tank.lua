--@initApi
--@Class: "Tank"
local super = script.Parent.Parent.Parent
local getModel = require(super:WaitForChild("getModel"))
local submodule = require(super:WaitForChild("submodules"))
local contentClass = submodule.get("content")

local tankClass = {}
tankClass.__index = tankClass
tankClass.Name = "Tank"

--[[@Function: {
    "class" : "Tank",
    "name" : "new",
    "args" : { "parent" : "Instance", "cf" : "CFrame", "type" : "string", "fluidType" : "string" },
    "return" : "Tank",
    "info" : "Creates a new Tank object."
}
@Properties: {
    "class" : "Tank",
    "props" : [{
        "name" : "Model",
        "type" : "Model",
    }, {
        "name" : "Content",
        "type" : "Content",
    }]
}]]
tankClass.MODEL = getModel("tier2\\machines\\tanks\\Tank")
function tankClass.new(parent, cf, type, fluidType)
    local newTank = setmetatable({}, tankClass)

    newTank.Model = tankClass.MODEL:Clone()
    newTank.Model:SetPrimaryPartCFrame(cf + cf.UpVector * tankClass.MODEL.PrimaryPart.Size.Y / 2)
    newTank.Model.Parent = parent

    newTank.Content = contentClass.new(newTank.Model.Container, type, 100)
    --[[
        TODO make this automatic by getting a contents type
    ]]
    type = type or "solid"
    fluidType = fluidType or "water"
    if type == "solid" then
        newTank.Content.BrickColor = BrickColor.new("Pastel light blue")
        newTank.Content.Material = "Foil"
    elseif type == "gas" then
        newTank.Content.BrickColor = BrickColor.new("Alder")
    elseif type == "fluid" then
        newTank.Content:setFluidType(fluidType)
        if fluidType == "water" then
            newTank.Content.BrickColor = BrickColor.Blue()
        elseif fluidType == "lava" then
            newTank.Content.BrickColor = BrickColor.new(Color3.fromRGB(127, 65, 12))
        end
    end

    return newTank
end

return tankClass