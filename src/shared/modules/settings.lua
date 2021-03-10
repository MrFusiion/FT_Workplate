--@initApi
--@Class: "Settings"
local modules = require(script.Parent)
local class = modules.get("class")

local settings = class.new("Settings")
settings.__index = settings
settings.__Static = true

--[[@Function: {
    "class" : "Settings",
    "name" : "new",
    "args" : { "folder" : "(Instance)Folder/Configuration" },
    "return" : "Settings",
    "info" : "Creates a new Settings object."
}
@Properties: {
    "class" : "Settings",
    "props" : [{
        "name" : "__Folder",
        "type" : "(Instance)Folder/Configuration",
        "info" : "[Private]"
    }]
}]]
function settings.new(folder)
    assert(typeof(folder)=="Instance" and (folder.ClassName=="Folder" or folder.ClassName=="Configuration"), " `folder must be a Instance of a Folder or Configuration!`")

    local self = settings:newInstance()
    self.__Folder = folder
    return self
end

--[[@Function: {
    "class" : "Settings",
    "name" : "get",
    "args" : { "self" : "Settings", "name" : "string" },
    "return" : "any",
    "info" : "Gets the value if a setting in the folder."
}]]
function settings.get(self, name)
    settings:memberFunctionAssert(self)
    assert(typeof(name)=="string", " `name` must be a string!")
    
    local setting = self.__Folder:FindFirstChild(name)
    if setting and typeof(setting) == "Instance" and (
            setting.ClassName == "BoolValue" or setting.ClassName == "NumberValue" or setting.ClassName == "IntValue" or 
            setting.ClassName == "StringValue" or setting.ClassName == "Vector3Value" or setting.ClassName == "Color3Value" or
            setting.ClassName == "ObjectValue" or setting.ClassName == "RayValue" or setting.ClassName == "CFrameValue" or setting.ClassName == "BrickColorValue" ) then
        return setting.Value
    elseif setting ~= nil then
        warn(string.format(" %s that has been found is not in a correct format pls use only (Instance)Value's!", tostring(setting)))
    end
end

--[[@Function: {
    "class" : "Settings",
    "name" : "ifEnabled",
    "args" : { "self" : "Settings", "name" : "string", "cb" : "function" },
    "info" : "Calls the callback method if setting in the folder is enabled."
}]]
function settings.ifEnabled(self, name, cb)
    settings:memberFunctionAssert(self)
    assert(typeof(name)=="string", " `name` must be a string!")
    assert(typeof(cb)=="function", " `cb` must be a function!")

    if self:get(name) then
        cb(name)
    end
end

--[[@Function: {
    "class" : "Settings",
    "name" : "ifEnabledPrintf",
    "args" : { "self" : "Settings", "name" : "string", "msg" : "string", "..." : "any" },
    "info" : "Prints the message if setting in the folder is enabled."
}]]
function settings.ifEnabledPrintf(self, name, msg, ...)
    settings:memberFunctionAssert(self)
    assert(typeof(name)=="string", " `name` must be a string!")
    assert(typeof(msg)=="string", " `msg` must be a string!")
    
    local args = {...}
    self:ifEnabled(name, function()
        print(string.format(msg, table.unpack(args)))
    end)
end

--[[@Function: {
    "class" : "Settings",
    "name" : "updateConnect",
    "args" : { "self" : "Settings", "name" : "string", "callback" : "function",},
    "info" : "Connects a function to the value"s update event." 
}]]
function settings.updateConnect(self, name, callback)
    settings:memberFunctionAssert(self)
    assert(typeof(name)=="string", " `name` must be a string!")
    assert(typeof(callback)=="function", " `callback` must be a function!")

    local setting = self.__Folder:FindFirstChild(name)
    if setting then
        setting:GetPropertyChangedSignal("Value"):Connect(callback)
    end
end

return settings