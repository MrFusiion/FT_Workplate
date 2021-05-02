local shared = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"))
local random = shared.get("random")

local _spot = require(script.spot)

local castlePuzzle = {}
castlePuzzle.__index = castlePuzzle

function castlePuzzle.new(spots : table, symbols : table)
    local self = setmetatable({}, castlePuzzle)

    self.Symbols = symbols
    self.SymbolsCount = #symbols

    self.Spots = {}
    for i, spotModel in pairs(spots) do
        self.Spots[i] = _spot.new(spotModel, symbols)
    end

    spawn(function()
        while wait(3) do
            self:reset()
            wait(.5)
            self:init()
        end
    end)

    return self
end

function castlePuzzle:init()
    local indexes = {}
    for _, spot in pairs(self.Spots) do
        local index
        while not index and not indexes[index] do
            index = random:nextInt(1, self.SymbolsCount)
        end
        indexes[index] = self.Symbols[index]:Clone()
        spot:setSymbol(indexes[index])
    end
end

function castlePuzzle:reset()
    for _, spot in pairs(self.Spots) do
        spot:setSymbol()
    end
end

function castlePuzzle:isSolved()
    
end

return castlePuzzle