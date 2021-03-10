--@initApi
--@Class: "Class"
local class = {}
class.__index = class

--[[@Function: {
    "class" : "Class",
    "name" : "new",
    "args" : { "className" : "string", "baseClass" : "table/nil" },
    "return" : "Class",
    "info" : "Creates a new Class object."
}
@Properties: {
    "class" : "Class",
    "props" : [{
        "name" : "__index",
        "type" : "table",
        "info" : "[Private]"
    }, {
        "name" : "__IsClass",
        "type" : "boolean",
        "info" : "[Private]"
    }, {
        "name" : "__Static",
        "type" : "boolean",
        "info" : "[Private]"
    }, {
        "name" : "__ClassName",
        "type" : "string",
        "info" : "[Private]"
    }]
}]]
function class.new(className, baseClass)
    assert(typeof(className)=="string", " `className` must be a string!")
    assert(baseClass == nil or typeof(baseClass)=="table", " `className` must be a table or nil!")

    local self = {}
    if baseClass then
        local mt = setmetatable({}, class)
        mt.__index = baseClass
        setmetatable(self, mt)
    else
        setmetatable(self, class)
    end
        
    self.__index = self
    self.__IsClass = true
    self.__Static = true
    self.__ClassName = className
    return self
end

--[[@Function: {
    "class" : "Class",
    "name" : "newInstance",
    "args" : { "self" : "Class"},
    "return" : "table",
    "info" : "Returns a new instance of this class object."
}]]
function class.newInstance(self)
    assert(typeof(self)=="table" and self.__IsClass, " member function got called with . istead of :!")
    local newInst = setmetatable({}, self)
    newInst.__IsClass = true
    newInst.__Static = false
    newInst.__ClassName = self.__ClassName
    return newInst
end

--[[@Function: {
    "class" : "Class",
    "name" : "isInstaceOfMe",
    "args" : { "self" : "Class", "instance" : "table"},
    "return" : "boolean",
    "info" : "Checks if object is and istance of this class object."
}]]
function class.isInstaceOfMe(self, instance)
    assert(typeof(self)=="table" and self.__IsClass, " member function got called with . istead of :!")
    assert(instance~=nil, " `instance` is required!")

    if typeof(instance)=="table" and instance.__IsClass and instance.__ClassName==self.__ClassName then
        return true
    else
        return false
    end
end

--[[@Function: {
    "class" : "Class",
    "name" : "memberFunctionAssert",
    "args" : { "self" : "Class", "instance" : "table"},
    "info" : "Asserts when instance is not a member of this class."
}]]
function class.memberFunctionAssert(self, instance)
    assert(instance~=nil and self:isInstaceOfMe(instance), " member function got called with . istead of :!")
    assert(not instance.__Static, string.format(" this member function cannot be called on a static class: %s", self.__ClassName))
end

return class