local shared = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"))
local tableUtils = shared.get("tableUtils")

--ResourceTable
local resTable = {}
resTable.__index = resTable

function resTable.new(t)
    assert(t == nil or typeof(t) == "table", "'t' must be a table or nil!")
    local newTable = setmetatable({}, resTable)
    newTable.Values = t or {}
    newTable.EmptyIndeces = {}
    newTable.Len = t and #t or 0
    return newTable
end

function resTable:add(value)
    self.Len += 1
    if next(self.EmptyIndeces) ~= nil then
        local index = tableUtils.pop(self.EmptyIndeces)
        self.Values[index] = value
        return index
    else
        table.insert(self.Values, value)
        return self.Len
    end
end

function resTable:removeAt(index)
    if self.Values[index] ~= nil then
        table.insert(self.EmptyIndeces, index)
        self.Values[index] = nil
        self.Len -= 1
    end
end

function resTable:iter()
    return pairs(self.Values)
end

return resTable