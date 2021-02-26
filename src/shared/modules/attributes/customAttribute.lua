local customAttribute = {}
customAttribute.__index = customAttribute

function customAttribute.new(symbol : string, symbolMatch : string, type : string) : customAttribute
    local newCustomAttr = setmetatable({}, customAttribute)
    newCustomAttr.Symbol = symbol
    newCustomAttr.SymbolMatch = symbolMatch
    newCustomAttr.Type = type
    return newCustomAttr
end

--========================================================--
--================/ overidable fucntions /================--

function customAttribute:getName(symbol) : string
    local name = string.format(self.SymbolMatch, symbol)
    return name
end

function customAttribute:getAttribute(part : Instance, name : string) : any
    return part:GetAttribute(string.format(self.Symbol, name))
end

function customAttribute:setAttribute(part : Instance, name : string, value : any)
    return part:SetAttribute(string.format(self.Symbol, name), value)
end

--========================================================--

function customAttribute:isValueMyType(value : any)
    return typeof(value) == self.Type
end

return customAttribute