local random = {}
random.__index = random

function random.new(seed, autoSeed)
    local self = setmetatable({}, random)
    self.__Seed = seed
    self.__SeedGenInterval = 5*60
    self.__ClassName = "Random"

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
    assert(typeof(self)=="table" and self.__ClassName=="Random", " member function got called with . istead of :!")
    self.__Random = Random.new(self.__Seed)
end

function random:__generateSeed()
    assert(typeof(self)=="table" and self.__ClassName=="Random", " member function got called with . istead of :!")
    
    --random Table
    self.__RandTable = {}
    local hex = tostring(self.__RandTable):sub(7, 21)
    print(hex)
    self.__Seed = tonumber(hex, 16) + os.time()
    self:__init()
end

function random:setSeedGenInterval(interval)
    assert(typeof(self)=="table" and self.__ClassName=="Random", " member function got called with . istead of :!")
        assert(typeof(interval)=="number" or interval==nil, " `interval` must be a number or nil!")

    self.__SeedGenInterval = interval or 5*60
end

function random:nextInt(min, max)
    assert(typeof(self)=="table" and self.__ClassName=="Random", " member function got called with . istead of :!")
        assert(typeof(min)=="number" or min==nil, " `min` must be a number or nil!")
        assert(typeof(max)=="number" or max==nil, " `max` must be a number or nil!")
        assert((min or 0)<(max or 1), " `min` cannot be >= then `max`!")
    return self.__Random:NextInteger(min or 0, max or 1)
end

function random:nextNumber(min, max)
    assert(typeof(self)=="table" and self.__ClassName=="Random", " member function got called with . istead of :!")
        assert(typeof(min)=="number" or min==nil, " `min` must be a number or nil!")
        assert(typeof(max)=="number" or max==nil, " `max` must be a number or nil!")
        assert((min or 0)<(max or 1), " `min` cannot be >= then `max`!")
    return self.__Random:NextNumber(min or 0, max or 1)
end

function random:choice(t)
    assert(typeof(self)=="table" and self.__ClassName=="Random", " member function got called with . istead of :!")
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