--Table utils are only supported on arrays not dictionaries
--TODO support dictionaries

local tableUtils = {}
tableUtils.enumerate = require(script:WaitForChild("enumerate"))
tableUtils.zip = require(script:WaitForChild("zip"))
tableUtils.contains = require(script:WaitForChild('contains'))

tableUtils.pop = function(t)
    local lastIndex = #t
    local value = t[lastIndex]
    table.remove(t, lastIndex)
    return value
end

return tableUtils