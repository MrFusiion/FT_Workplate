local class = {}
class.__index = class

function class.new(className)
    assert(typeof(className)=="string", " `className` must be a string!")

    local self = setmetatable({}, class)
    self.__IsClass = true
    self.__Static = true
    self.__ClassName = className
    return self
end

function class:newInstance()
    assert(typeof(self)=="table" and self.__IsClass, " member function got called with . istead of :!")
        
    local newInst = setmetatable({}, self)
    newInst.__IsClass = true
    newInst.__Static = false
    newInst.__ClassName = self.__ClassName
    return newInst
end

function class:isInstaceOfMe(instance)
    assert(typeof(self)=="table" and self.__IsClass, " member function got called with . istead of :!")
    assert(instance~=nil, " `instance` is required!")

    if typeof(instance)=="table" and instance.__IsClass and instance.__ClassName==self.__ClassName then
        return true
    else
        return false
    end
end

function class:memberFunctionAssert(instance)
    assert(instance~=nil and self:isInstaceOfMe(instance), " member function got called with . istead of :!")
    assert(not instance.__Static, string.format(" this member function cannot be called on a static class: %s", self.__ClassName))
end

return class