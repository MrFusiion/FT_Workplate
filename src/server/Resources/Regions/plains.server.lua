local regionClient = require(script.Parent.Parent.RegionClient)

local parts = {}
for _, part in ipairs(workspace.Terrain.EatherCave.Floor:GetChildren()) do
    table.insert(parts, part)
end

local treesGrowingClient = regionClient.GrowingClient.new(5, {
    { value=require(script.Parent.Parent.Trees.subclasses.Cave), weight=1}
}, parts, 200)

local crystalsGrowingClient = regionClient.GrowingClient.new(5, {
    { value=require(script.Parent.Parent.Crystals.subclasses.Eather), weight=1}
}, parts, 200)

local oresGrowingClient = regionClient.GrowingClient.new(5, {
    { value=require(script.Parent.Parent.Ores.subclasses.Iron), weight=1}
}, parts, 200)

treesGrowingClient:addLinks(crystalsGrowingClient, oresGrowingClient)
crystalsGrowingClient:addLinks(treesGrowingClient, oresGrowingClient)
oresGrowingClient:addLinks(crystalsGrowingClient, treesGrowingClient)

local region = regionClient.new(script.Name, treesGrowingClient, crystalsGrowingClient, oresGrowingClient)
region:init()
region:start()