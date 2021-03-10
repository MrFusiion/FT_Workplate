--@initApi
--@Class: "Random"
local modules = require(script.Parent)

local tableUtils = modules.get("tableUtils")

local settings = modules.get("settings")
local config = settings.new(game:GetService("ReplicatedStorage"):WaitForChild("Config"))

local class = modules.get('class')

local random = {}
random.__index = random

local function __init(self)
    self.__Random = Random.new(self.__Seed)
end

local function __generateSeed(self)
    --random Table
    self.__RandTable = {}
    local hex = tostring(self.__RandTable):sub(7, 21)
    self.__Seed = tonumber(hex, 16) + os.time()

    config:ifEnabledPrintf("DebugPrint", "Generated seed: [%d]", self.__Seed)
    __init(self)
end

local function newRandom(seed, autoSeed)
    assert(typeof(seed)=="number" or seed==nil, " `seed` must be a number or nil!")
    assert(typeof(autoSeed)=="boolean" or autoSeed==nil, " `autoSeed` must be a boolean or nil!")

    local newRandomGen = setmetatable({}, random)
    newRandomGen.__Seed = seed
    newRandomGen.__SeedGenInterval = 5*60

    if autoSeed ~= false or autoSeed == nil then
        newRandomGen:startSeedGen()
    end

    if not seed then __generateSeed(newRandomGen) end
    __init(newRandomGen)
    return newRandomGen
end

--[[@Function: {
    "class" : "Random",
    "name" : "startSeedGen",
    "args" : { "self" : "Random" },
    "info" : "Starts the seed generation loop."
}]]
function random.startSeedGen(self)
    if not self.__SeedGenRunning then
        self.__SeedGenRunning = true
        spawn(function()
            while self.__SeedGenRunning do
                wait(self.__SeedGenInterval)
                __generateSeed(self)
            end
        end)
    else
        warn("Seed generator allready running!")
    end
end

--[[@Function: {
    "class" : "Random",
    "name" : "stopSeedGen",
    "args" : { "self" : "Random" },
    "info" : "Stops the seed generation loop."
}]]
function random.stopSeedGen(self)
    self.__SeedGenRunning = false
end

--[[@Function: {
    "class" : "Random",
    "name" : "setSeedGenInterval",
    "args" : { "self" : "Random", "interval" : "number" },
    "info" : "Sets the seed generate interval time."
}]]
function random:setSeedGenInterval(self, interval)
    assert(typeof(interval)=="number" or interval==nil, " `interval` must be a number or nil!")

    self.__SeedGenInterval = interval or (5*60)
end

--[[@Function: {
    "class" : "Random",
    "name" : "toWeightedList",
    "args" : { "..." : "table" },
    "info" : "Returns a table where each item is added n times given by the weigth."
}]]
function random.toWeightedList(...)
    local weightedList = {}
    for _, t in ipairs{...} do
        for _=1, t.weight do
            table.insert(weightedList, t.value)
        end
    end
    return weightedList
end

--[[@Function: {
    "class" : "Random",
    "name" : "nextInt",
    "args" : { "self" : "Random", "min" : "number/nil", "max" : "number/nil" },
    "info" : "Returns a pseudorandom integer uniformly distributed over [min or 0, max or 1]."
}]]
function random.nextInt(self, min, max)
    assert(typeof(min)=="number" or min==nil, " `min` must be a number or nil!")
    assert(typeof(max)=="number" or max==nil, " `max` must be a number or nil!")

    if (min or 0)>=(max or 1) then
        return math.min(min, max)
    else
        return self.__Random:NextInteger(min or 0, max or 1)
    end
end

--[[@Function: {
    "class" : "Random",
    "name" : "nextRangeInt",
    "args" : { "self" : "Random", "t" : "table" },
    "info" : "Returns a pseudorandom integer uniformly distributed over [min or 0, max or 1]."
}]]
function random.nextRangeInt(self, t)
    assert(typeof(t)=="table", "t must be a table!")
    assert(typeof(t.min)=="number" or t.min==nil, " `t.min` must be a number or nil!")
    assert(typeof(t.max)=="number" or t.max==nil, " `t.max` must be a number or nil!")
    return self:nextInt(t.min, t.max)
end

--[[@Function: {
    "class" : "Random",
    "name" : "nextNumber",
    "args" : { "self" : "Random", "min" : "number/nil", "max" : "number/nil" },
    "return" : "number",
    "info" : "Returns a pseudorandom number uniformly distributed over [min or 0, max or 1)."
}]]
function random.nextNumber(self, min, max)
    assert(typeof(min)=="number" or min==nil, " `min` must be a number or nil!")
    assert(typeof(max)=="number" or max==nil, " `max` must be a number or nil!")

    if (min or 0)>=(max or 1) then
        return math.min(min, max)
    else
        return self.__Random:NextNumber(min or 0, max or 1)
    end 
end

--[[@Function: {
    "class" : "Random",
    "name" : "nextRange",
    "args" : { "self" : "Random", "t" : "table" },
    "info" : "Returns a pseudorandom integer uniformly distributed over [min or 0, max or 1]."
}]]
function random.nextRange(self, t)
    assert(typeof(t)=="table", "t must be a table!")
    assert(typeof(t.min)=="number" or t.min==nil, " `t.min` must be a number or nil!")
    assert(typeof(t.max)=="number" or t.max==nil, " `t.max` must be a number or nil!")
    return self:nextNumber(t.min, t.max)
end

--[[@Function: {
    "class" : "Random",
    "name" : "choice",
    "args" : { "self" : "Random", "t" : "table" },
    "return" : "any",
    "info" : "Returns a pseudorandom element from the table."
}]]
function random.choice(self, t)
    assert(typeof(t)=="table", " `t` must be a table!")

    local tLen = #t
    assert(tLen~=0, " `t` cannot be a empty table!")

    if tLen == 1 then
        return t[1]
    else
        return t[self:nextInt(1, tLen)]
    end
end

local r = newRandom(nil, true)
return r