--@initApi
--@Class: "Validate"
local validate = {}

--[[@Function: {
    "class" : "Random",
    "name" : "isInstanceOf",
    "args" : { "className" : "string", "cb" : "function/nil" },
    "return" : "boolean",
    "info" : "checks if instance is same class as `className`"
}]]
function validate.isInstanceOf(instance, className, cb)
    local boolean = (typeof(instance)=="Instance" and instance.ClassName==className)
    if typeof(cb)=="function" and boolean then
        cb()
    end
    return boolean
end

return validate