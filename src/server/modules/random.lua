local settings = require(script.Parent:WaitForChild("settings"))
local config = settings.new(game:GetService("ServerScriptService"):WaitForChild("config"))

local class = require(script.Parent:WaitForChild("class"))
local random = class.new("Random")
random.__index = random

function random.new(seed, autoSeed)
    assert(typeof(seed)=="number" or seed==nil, " `seed` must be a number or nil!")
    assert(typeof(autoSeed)=="boolean" or autoSeed==nil, " `autoSeed` must be a boolean or nil!")

    local self = random:newInstance()
    self.__Seed = seed
    self.__SeedGenInterval = 5*60

    if autoSeed ~= false or autoSeed == nil then
        spawn(function()
            while true do
                wait(self.__SeedGenInterval)
                self:__generateSeed()
            end
        end)
    end

    if not self.__Seed then self:__generateSeed() end
    self:__init()
    return self
end

function random:__init()
    random:memberFunctionAssert(self)
    self.__Random = Random.new(self.__Seed)
end

function random:__generateSeed()
    random:memberFunctionAssert(self)
    
    --random Table
    self.__RandTable = {}
    local hex = tostring(self.__RandTable):sub(7, 21)
    self.__Seed = tonumber(hex, 16) + os.time()
    config:ifEnabledPrintf("DebugPrint", "Generated seed: [%d]", self.__Seed)
    self:__init()
end

function random:setSeedGenInterval(interval)
    random:memberFunctionAssert(self)
    assert(typeof(interval)=="number" or interval==nil, " `interval` must be a number or nil!")

    self.__SeedGenInterval = interval or 5*60
end

function random:nextInt(min, max)
    random:memberFunctionAssert(self)
    assert(typeof(min)=="number" or min==nil, " `min` must be a number or nil!")
    assert(typeof(max)=="number" or max==nil, " `max` must be a number or nil!")
    assert((min or 0)<(max or 1), " `min` cannot be >= then `max`!")

    return self.__Random:NextInteger(min or 0, max or 1)
end

function random:nextNumber(min, max)
    random:memberFunctionAssert(self)
    assert(typeof(min)=="number" or min==nil, " `min` must be a number or nil!")
    assert(typeof(max)=="number" or max==nil, " `max` must be a number or nil!")
    assert((min or 0)<(max or 1), " `min` cannot be >= then `max`!")
        
    return self.__Random:NextNumber(min or 0, max or 1)
end

function random:choice(t)
    random:memberFunctionAssert(self)
    assert(typeof(t)=="table", " `t` must be a table!")

    local tLen = #t
    assert(tLen==0, " `t` cannot be a empty table!")

    if tLen == 1 then
        return t[1]
    else
        return t[self:nextInt(1, tLen)]
    end
end

return random