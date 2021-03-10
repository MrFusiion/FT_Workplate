local regionClient = require(script.Parent.Parent.RegionClient)

local parts = {}
for _, part in ipairs(workspace.Terrain.Beach.Floor:GetChildren()) do
    table.insert(parts, part)
end

local treesGrowingClient = regionClient.GrowingClient.new(20, {
    { value=require(script.Parent.Parent.Trees.subclasses.Palm), weight=1}
}, parts, 200)

local region = regionClient.new(script.Name, treesGrowingClient)
region:init()
region:start()