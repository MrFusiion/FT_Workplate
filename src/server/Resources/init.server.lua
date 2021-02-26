local shared = require(game:GetService('ReplicatedStorage'):WaitForChild('modules'))
local random = shared.get('random').new()

local remoteDebug = game:GetService('ReplicatedStorage'):WaitForChild('remote'):WaitForChild('debug')
local re_PlantTree = remoteDebug:WaitForChild('PlantTree')
local re_CrearTrees = remoteDebug:WaitForChild('ClearTrees')

local treeTypes = {
    --script.Trees.subclasses.Cave,
    --script.Trees.subclasses.Cave.mushroom,
    --script.Trees.subclasses.Palm,
    script.Crystal.subclasses.Either,
    script.Crystal.subclasses.Hell,
    script.Crystal.subclasses.Astral,
    script.Crystal.subclasses.Ion
}

local region = Instance.new('Model')
region.Name =  'RegionTest'
region.Parent = workspace

local plantPlate = workspace.TreeTypes.PlantPlate

function randomRange(value)
	return math.random() * (value.max - value.min) + value.min
end

function getPlantSpot()
    local halfSize = plantPlate.Size*.5
    local randX = randomRange({ min=-halfSize.X, max=halfSize.X })
    local randZ = randomRange({ min=-halfSize.Z, max=halfSize.Z })

    return plantPlate.CFrame * CFrame.new(randX, halfSize.Y, randZ)
end

local plantedTrees = {}

function plantTree()
    local cf = getPlantSpot()
    local newTree = require(random:choice(treeTypes)).new(region)
    newTree:place(cf)
    return newTree
end

re_PlantTree.OnServerEvent:Connect(function()                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
    table.insert(plantedTrees, plantTree())
end)

re_CrearTrees.OnServerEvent:Connect(function()
    for i=#plantedTrees, 1, -1 do
        local tree = plantedTrees[i]
        tree:destroy()
        table.remove(plantedTrees, i)
    end
end)

spawn(function()
    local thisTick, lastTick

    while wait() do
        lastTick = thisTick or tick() - .1
        thisTick = tick()
        local timeDiff = thisTick - lastTick

        for _, tree in pairs(plantedTrees) do
            tree:growCheck(timeDiff * 100, true)
        end
    end
end)

local rotPart = workspace.RotPart
rotPart:GetPropertyChangedSignal('CFrame'):Connect(function()
    local unit = (rotPart.CFrame * CFrame.Angles(math.pi*.5, 0, 0)).LookVector
    print('Y:', unit.Y)
end)