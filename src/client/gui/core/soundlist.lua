local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"))
local class = modules.get("class")

local SS = game:GetService("SoundService")

local soundlist = class.new("Soundlist")

function soundlist.new()
    local newSoundlist = soundlist:newInstance()
    newSoundlist.__List = {}
    return newSoundlist
end

function soundlist:add(name, id, overide)
    soundlist:memberFunctionAssert(self)
    assert(typeof(name)=="string", " `name` must be a string!")
    assert(typeof(id)=="number", " `id` must be a number!")
    assert(not overide or typeof(overide)=="boolean", " `overide` must be a boolean or nil!")
    assert(not self.__List[name] and not overide, string.format(" `%s` allready exist in soundlist pls consider removing it first or set overide to true!", name))
    self.__List[name] = Instance.new("Sound")
    self.__List[name].SoundId = "rbxassetid://"..id
end

function soundlist:remove(name)
    soundlist:memberFunctionAssert(self)
    assert(typeof(name)=="string", " `name` must be a string!")
    assert(self.__List[name], string.format(" `%s` does not exist in soundlist!", name))
    self.__List[name]:Destroy()
    self.__List[name] = nil
end

function soundlist:play(name)
    soundlist:memberFunctionAssert(self)
    assert(typeof(name)=="string", " `name` must be a string!")
    assert(self.__List[name], string.format(" `%s` does not exist in soundlist!", name))
    SS:PlayLocalSound(self.__List[name])
end

return soundlist