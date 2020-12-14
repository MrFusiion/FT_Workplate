local class = require(script.Parent:WaitForChild("class"))

local settings = class.new("Settings")
settings.__index = settings
settings.__Static = true

function settings.new(folder)
    assert(typeof(folder)=="Instance" and (folder.ClassName=="Folder" or folder.ClassName=="Configuration"), " `folder must be a Instance of a Folder or Configuration!`")

    local self = settings:newInstance()
    self.__Folder = folder
    return self
end

function settings:enabled(name)
    settings:memberFunctionAssert(self)
    assert(typeof(name)=="string", " `name` must be a string!")
    
    local setting = self.__Folder:FindFirstChild(name)
    if setting and typeof(setting) == "Instance" and (
        setting.ClassName == "BoolValue" or setting.ClassName == "NumberValue" or setting.ClassName == "IntValue" or 
        setting.ClassName == "StringValue" or setting.ClassName == "Vector3Value" or setting.ClassName == "Color3Value" or
        setting.ClassName == "ObjectValue" or setting.ClassName == "RayValue" or setting.ClassName == "CFrameValue" or setting.ClassName == "BrickColorValue" ) then
            return setting.Value
        else
            warn(string.format(" %s that has been found is not in a correct format pls use only (Instance)Value's!", setting))
            return false
        end
end

function settings:ifEnabled(name, cb)
    settings:memberFunctionAssert(self)
    assert(typeof(name)=="string", " `name` must be a string!")
    assert(typeof(cb)=="function", " `cb` must be a function!")

    if self:enabled(name) then
        cb(name)
    end
end

function settings:ifEnabledPrintf(name, msg, ...)
    settings:memberFunctionAssert(self)
    assert(typeof(name)=="string", " `name` must be a string!")
    assert(typeof(msg)=="string", " `msg` must be a string!")
    
    local args = {...}
    self:ifEnabled(name, function()
        print(string.format(msg, table.unpack(args)))
    end)
end

return settings