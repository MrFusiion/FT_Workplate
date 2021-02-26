local function getShortestLength(...)
    local tables = {...}
    local len = tables[1]
    for _, t in ipairs(tables) do
        if #t < len then
            len = #t
        end
    end
    return len
end

local function getValue(index, table, ...)
    return table[index], getValue(index, ...)
end

return function(...)
    local tables = {...}
    local len = getShortestLength(...)
    local index = 0
    return function()
        index += 1
        if index <= len then
            return getValue(index, table.unpack(tables))
        end
    end
end