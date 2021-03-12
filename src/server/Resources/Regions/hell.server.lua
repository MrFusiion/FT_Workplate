local regionClient = require(script.Parent.Parent.RegionClient)

local parts = {}
for _, part in ipairs(workspace.Terrain.Hell.Floor:GetChildren()) do
    table.insert(parts, part)
end

local treesGrowingClient = regionClient.GrowingClient.new(10, {
    { value=require(script.Parent.Parent.Trees.subclasses.Lava), weight=1}
}, parts, 200)

local crystalsGrowingClient = regionClient.GrowingClient.new(10, {
    { value=require(script.Parent.Parent.Crystals.subclasses.Hell), weight=1}
}, parts, 200)

treesGrowingClient:addLinks(crystalsGrowingClient)
crystalsGrowingClient:addLinks(treesGrowingClient)

local region = regionClient.new(script.Name, treesGrowingClient, crystalsGrowingClient)
region:init()
region:start()