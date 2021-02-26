--@initApi
--@Class: 'Random'
local modules = require(script.Parent)

local settings = modules.get("settings")
local config = settings.new(game:GetService("ReplicatedStorage"):WaitForChild("config"))

local class = modules.get("class")
local random = class.new("Random")

--[[@Function: {
    'class' : 'Random',
    'name' : 'new',
    'args' : { 'seed' : 'number/nil', 'autoSeed' : 'boolean/nil' },
    'return' : 'Random',
    'info' : 'Creates a new Random object.'
}
@Properties: {
    'class' : 'Random',
    'props' : [{
        'name' : '__Seed',
        'type' : 'number',
        'info' : '[Private]'
    }, {
        'name' : '__SeedGenInterval',
        'type' : 'number',
        'info' : '[Private] time it takes for a new seed to be generated'
    }, {
        'name' : '__Random',
        'type' : 'Random(Roblox)',
        'info' : '[Private] (Roblox)Random object.'
    }, {
        'name' : '__RandTable',
        'type' : 'table',
        'info' : '[Private] random table asigned every seed generation.'
    }, {
        'name' : '__SeedGenRunning',
        'type' : 'boolean',
        'info' : '[Private] describes if the seed genration loop is running'
    }]
}]]
function random.new(seed, autoSeed)
    assert(typeof(seed)=="number" or seed==nil, " `seed` must be a number or nil!")
    assert(typeof(autoSeed)=="boolean" or autoSeed==nil, " `autoSeed` must be a boolean or nil!")

    local self = random:newInstance()
    self.__Seed = seed
    self.__SeedGenInterval = 5*60

    if autoSeed ~= false or autoSeed == nil then
        self:startSeedGen()
    end

    if not self.__Seed then self:__generateSeed() end
    self:__init()
    return self
end

--[[@Function: {
    'class' : 'Random',
    'name' : '__init',
    'args' : { 'self' : 'Random' },
    'info' : '[Private] initalizes the Random object.'
}]]
function random.__init(self)
    random:memberFunctionAssert(self)
    self.__Random = Random.new(self.__Seed)
end

--[[@Function: {
    'class' : 'Random',
    'name' : '__generateSeed',
    'args' : { 'self' : 'Random' },
    'info' : '[Private] Generates a new seed for this object.'
}]]
function random.__generateSeed(self)
    random:memberFunctionAssert(self)
    
    --random Table
    self.__RandTable = {}
    local hex = tostring(self.__RandTable):sub(7, 21)
    self.__Seed = tonumber(hex, 16) + os.time()
    config:ifEnabledPrintf("DebugPrint", "Generated seed: [%d]", self.__Seed)
    self:__init()
end

--[[@Function: {
    'class' : 'Random',
    'name' : 'startSeedGen',
    'args' : { 'self' : 'Random' },
    'info' : 'Starts the seed generation loop.'
}]]
function random.startSeedGen(self)
    if not self.__SeedGenRunning then
        self.__SeedGenRunning = true
        spawn(function()
            while self.__SeedGenRunning do
                wait(self.__SeedGenInterval)
                self:__generateSeed()
            end
        end)
    else
        warn("Seed generator allready running!")
    end
end

--[[@Function: {
    'class' : 'Random',
    'name' : 'stopSeedGen',
    'args' : { 'self' : 'Random' },
    'info' : 'Stops the seed generation loop.'
}]]
function random.stopSeedGen(self)
    self.__SeedGenRunning = false
end

--[[@Function: {
    'class' : 'Random',
    'name' : 'setSeedGenInterval',
    'args' : { 'self' : 'Random', 'interval' : 'number' },
    'info' : 'Sets the seed generate interval time.'
}]]
function random:setSeedGenInterval(self, interval)
    random:memberFunctionAssert(self)
    assert(typeof(interval)=="number" or interval==nil, " `interval` must be a number or nil!")

    self.__SeedGenInterval = interval or (5*60)
end

--[[@Function: {
    'class' : 'Random',
    'name' : 'nextInt',
    'args' : { 'self' : 'Random', 'min' : 'number/nil', 'max' : 'number/nil' },
    'info' : 'Returns a pseudorandom integer uniformly distributed over [min or 0, max or 1].'
}]]
function random.nextInt(self, min, max)
    random:memberFunctionAssert(self)
    assert(typeof(min)=="number" or min==nil, " `min` must be a number or nil!")
    assert(typeof(max)=="number" or max==nil, " `max` must be a number or nil!")

    if (min or 0)>=(max or 1) then
        return math.min(min, max)
    else
        return self.__Random:NextInteger(min or 0, max or 1)
    end
end

--[[@Function: {
    'class' : 'Random',
    'name' : 'nextRangeInt',
    'args' : { 'self' : 'Random', 't' : 'table' },
    'info' : 'Returns a pseudorandom integer uniformly distributed over [min or 0, max or 1].'
}]]
function random.nextRangeInt(self, t)
    random:memberFunctionAssert(self)
    assert(typeof(t)=="table", "t must be a table!")
    assert(typeof(t.min)=="number" or t.min==nil, " `t.min` must be a number or nil!")
    assert(typeof(t.max)=="number" or t.max==nil, " `t.max` must be a number or nil!")
    return self:nextInt(t.min, t.max)
end

--[[@Function: {
    'class' : 'Random',
    'name' : 'nextNumber',
    'args' : { 'self' : 'Random', 'min' : 'number/nil', 'max' : 'number/nil' },
    'return' : 'number',
    'info' : 'Returns a pseudorandom number uniformly distributed over [min or 0, max or 1).'
}]]
function random.nextNumber(self, min, max)
    random:memberFunctionAssert(self)
    assert(typeof(min)=="number" or min==nil, " `min` must be a number or nil!")
    assert(typeof(max)=="number" or max==nil, " `max` must be a number or nil!")

    if (min or 0)>=(max or 1) then
        return math.min(min, max)
    else
        return self.__Random:NextNumber(min or 0, max or 1)
    end 
end

--[[@Function: {
    'class' : 'Random',
    'name' : 'nextRange',
    'args' : { 'self' : 'Random', 't' : 'table' },
    'info' : 'Returns a pseudorandom integer uniformly distributed over [min or 0, max or 1].'
}]]
function random.nextRange(self, t)
    random:memberFunctionAssert(self)
    assert(typeof(t)=="table", "t must be a table!")
    assert(typeof(t.min)=="number" or t.min==nil, " `t.min` must be a number or nil!")
    assert(typeof(t.max)=="number" or t.max==nil, " `t.max` must be a number or nil!")
    return self:nextNumber(t.min, t.max)
end

--[[@Function: {
    'class' : 'Random',
    'name' : 'choice',
    'args' : { 'self' : 'Random', 't' : 'table' },
    'return' : 'any',
    'info' : 'Returns a pseudorandom element from the table.'
}]]
function random.choice(self, t)
    random:memberFunctionAssert(self)
    assert(typeof(t)=="table", " `t` must be a table!")

    local tLen = #t
    assert(tLen~=0, " `t` cannot be a empty table!")

    if tLen == 1 then
        return t[1]
    else
        return t[self:nextInt(1, tLen)]
    end
end

return random