local attributes = {}
attributes.CustomAttributes = require(script.customAttributes)

function attributes.getAttribute(part : Instance, name : string) : any
    for _, customAttribute in pairs(attributes.CustomAttributes) do
        local value = customAttribute:getAttribute(part, name)
        if value then
            return value
        end
    end
    return part:GetAttribute(name)
end

function attributes.getAttributes(part : Instance)
    local attrs = part:GetAttributes()
    for attrName in pairs(attrs) do
        for _, customAttribute in pairs(attributes.CustomAttributes) do
            if customAttribute:isAttributeMyType(attrName) then
                local name = customAttribute:GetName(attrName)
                if name and not attrs[name] then
                    attrs[name] = customAttribute:getAttribute(part, name)
                end
                attrs[attrName] = nil
            end
        end
    end
    return attrs
end

function attributes.setAttribute(part : Instance, name : string, value : any)
    for _, customAttribute in pairs(attributes.CustomAttributes) do
        if customAttribute:isValueMyType(value) then
            return customAttribute:setAttribute(part, name, value)
        elseif value == nil then
            if customAttribute:getAttribute(part, name) then
                return customAttribute:setAttribute(part, name, nil)
            end
        end
    end
    part:SetAttribute(name, value)
end

return attributes