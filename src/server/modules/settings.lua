local settings = {}
settings.__index = settings
settings.__Static = true

function settings.new(folder)
    assert(typeof(folder)=="Instance" and (folder.ClassName=="Folder" or folder.ClassName=="Configurations"), " `folder must be a Instance of a folder or Configurations!`")

    local self = setmetatable({}, settings)
    self.__Folder = folder
    self.__ClassName = "Settings"
    self.__Static = false
    return self
end

function settings:enabled(name)
    assert(typeof(self)=="table" and self.__ClassName=="Settings", " member function got called with . istead of :!")
    assert(not self.__Static, string.format(" this member function cannot be called on ", self.__ClassName))
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
    assert(typeof(self)=="table" and self.__ClassName=="Settings", " member function got called with . istead of :!")
    assert(not self.__Static, string.format(" this member function cannot be called on ", self.__ClassName))
    assert(typeof(name)=="string", " `name` must be a string!")
    assert(typeof(cb)=="function", " `cb` must be a function!")

    if self:enabled(name) then
        cb(name)
    end
end

function setting:ifEnabledPrintf(name, msg, ...)
    assert(typeof(self)=="table" and self.__ClassName=="Settings", " member function got called with . istead of :!")
    assert(not self.__Static, string.format(" this member function cannot be called on ", self.__ClassName))
    assert(typeof(name)=="string", " `name` must be a string!")
    assert(typeof(msg)=="string", " `msg` must be a string!")

    self:ifEnabled(name, function()
        print(string.format(msg, table.unpack({...})))
    end)
end

return settings