--@initApi
--@Class: "StringUtils"

local stringUtils = {}

--[[@Function: {
    "class" : "StringUtils",
    "name" : "splitIter",
    "args" : { "str" : "string", "sep" : "string/table" },
    "return" : "function",
    "info" : "Returns a iterator with the splited string contents."
}]]
function stringUtils.splitIter(str : string, sep : any) : any
    sep = sep or "%s"
    if type(sep) == "table" then
        sep = table.concat(sep)
    end
    return string.gmatch(str, "([^"..sep.."]+)")
end

--[[@Function: {
    "class" : "StringUtils",
    "name" : "split",
    "args" : { "str" : "string", "sep" : "string/table" },
    "return" : "table",
    "info" : "Returns a table with the splited string contents."
}]]
function stringUtils.split(str : string, sep : any) : table
    local t={}
    for s in stringUtils.splitIter(str, sep) do
        table.insert(t, s)
    end
    return t
end

--[[@Function: {
    "class" : "StringUtils",
    "name" : "sepUppercase",
    "args" : { "str" : "string", "sep" : "string/nil" },
    "return" : "string",
    "info" : "Returns a string with each word starting with upercase serperated by seperator or space."
}]]
function stringUtils.sepUppercase(str : string, sep : any) : string
    sep = sep or " "
    local out = ""
    for s in string.gmatch(str, "(%u[a-z0-9]+)") do
        out = out..sep..s
    end
    return out
end

return stringUtils