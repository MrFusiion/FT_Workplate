--@initApi
--@Class: "mathUtils"
local mathUtils = {}

--[[@Function: {
   "class" : "mathUtils",
   "name" : "round",
   "args" : { "num" : "number", "precision" : "number/nil" },
   "return" : "number",
   "info" : "Returns a rounded number with a decimal precision."
}]]
function mathUtils.round(num, precision)
    assert(typeof(num)=="number", "`num` must be type of number!")
    assert(typeof(precision)=="number" or precision == nil, "`precision` must be type of number or nil!")
    return tonumber(string.format("%." .. (precision or 0) .. "f", num))
end

--[[@Function: {
   "class" : "mathUtils",
   "name" : "roundStep",
   "args" : { "num" : "number", "step" : "number/nil" },
   "return" : "number",
   "info" : "Returns a grid number."
}]]
function mathUtils.roundStep(num, step)
    assert(typeof(num)=="number", "`num` must be type of number!")
    assert(typeof(step)=="number" or step == nil, "`step` must be type of number or nil!")
    return mathUtils.round(num / (step or 1)) * (step or 1)
end

--[[@Function: {
   "class" : "mathUtils",
   "name" : "floorStep",
   "args" : { "num" : "number", "step" : "number/nil" },
   "return" : "number",
   "info" : "Returns a floored grid number."
}]]
function mathUtils.floorStep(num, step)
    assert(typeof(num)=="number", "`num` must be type of number!")
    assert(typeof(step)=="number" or step == nil, "`step` must be type of number or nil!")
    return math.floor(num / (step or 1)) * (step or 1)
end

--[[@Function: {
   "class" : "mathUtils",
   "name" : "ceilStep",
   "args" : { "num" : "number", "step" : "number/nil" },
   "return" : "number",
   "info" : "Returns a ceiled grid number."
}]]
function mathUtils.ceilStep(num, step)
    assert(typeof(num)=="number", "`num` must be type of number!")
    assert(typeof(step)=="number" or step == nil, "`step` must be type of number or nil!")
    return math.ceil(num / (step or 1)) * (step or 1)
end

--[[@Function: {
   "class" : "mathUtils",
   "name" : "ceilStep",
   "args" : { "num" : "number", "min" : "number", "max" : "number" },
   "return" : "boolean",
   "info" : "Returns True if num is between [min, max]."
}]]
function mathUtils.between(num, min, max)
    assert(typeof(num)=="number", "`num` must be type of number!")
    assert(typeof(min)=="number", "`min` must be type of number!")
    assert(typeof(max)=="number", "`max` must be type of number!")
    return num >= min and num <= max
end

return mathUtils