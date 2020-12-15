local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
local class = modules.get("class")

local soundlist = class.new("Soundlist")

function soundlist.new()
    local newSoundlist = setmetatable({}, soundlist)
    newSoundlist.__List = {}
    return newSoundlist
end

function soundlist:add(name, id, overide)
    soundlist:memberFunctionAssert(self)
    assert(typeof(name)=='string', " `name` must be a string!")
    assert(typeof(id)=='number', " `id` must be a number!")
    assert(typeof(overide)=='boolean', " `id` must be a number!")
    assert(not self.__List[name] and not overide, string.format(' `%s` allready exist in soundlist pls consider removing it first or set overide to true!'))
    self.__List[name] = Instance.new("Sound")
    self.__List[name].SoundId = id
end

function soundlist:remove(name)
    soundlist:memberFunctionAssert(self)
    assert(typeof(name)=='string', " `name` must be a string!")
    assert(self.__List[name], string.format(' `%s` does not exist in soundlist!'))
    self.__List[name]:Destroy()
    self.__List[name] = nil
end

function soundlist:play(name)
    soundlist:memberFunctionAssert(self)
    assert(typeof(name)=='string', " `name` must be a string!")
    assert(self.__List[name], string.format(' `%s` does not exist in soundlist!'))
    self.__List[name]:Play()
end

return soundlist