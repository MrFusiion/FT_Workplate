local CS = game:GetService('CollectionService')
local HS = game:GetService('HttpService')

local customAttrubute = require(script.Parent.customAttribute)

local customAttrubutes = {}

--====================================================================================================--
--=============================================/ CFrame /=============================================--

customAttrubutes.CFrame = customAttrubute.new('CFrame__%s__%s', 'CFrame__(.+)__(.+)', 'CFrame')

customAttrubutes.CFrame.getAttribute = function(self, part, name)
    local values = {}
    for _, cfAxisName in ipairs{'Pos', 'Right', 'Up', 'Back', } do
        local value = part:GetAttribute(string.format(self.Symbol, name, cfAxisName))
        if value then
            for _, v in ipairs{ value.X, value.Y, value.Z } do
                table.insert(values, v)
            end
        else
            return nil
        end
    end
    return CFrame.new(table.unpack(values))
end

customAttrubutes.CFrame.setAttribute = function(self, part, name, value)
    if value == nil then
        for i, cfAxisName in ipairs{'Pos', 'Right', 'Up', 'Back', } do
            part:SetAttribute(string.format(self.Symbol, name, cfAxisName), nil)
        end
    elseif typeof(value) == 'CFrame' then
        local values = { value:GetComponents() }
        for i, cfAxisName in ipairs{'Pos', 'Right', 'Up', 'Back', } do
            local index = (i - 1)
            part:SetAttribute(string.format(self.Symbol, name, cfAxisName), Vector3.new(
                values[index * 3 + 1], values[index * 3 + 2], values[index * 3 + 3]
            ))
        end
    else
        warn(string.format('%s is not a CFrame', tostring(value)))
    end
end

--====================================================================================================--
--=============================================/ Object /=============================================--

customAttrubutes.Object = customAttrubute.new('Object__%s', 'Object__(.+)', 'Instance')
customAttrubutes.Object.IdMatch = string.format('{%s-%s-%s-%s-%s}',
    string.rep('(%x)', 8),
    string.rep('(%x)', 4),
    string.rep('(%x)', 4),
    string.rep('(%x)', 4),
    string.rep('(%x)', 12)
)--for sure their needs to be a better pattern but this works :)

customAttrubutes.Object.getID = function(self, part, name)
    return part:GetAttribute(string.format(self.Symbol, name))
end

customAttrubutes.Object.addID = function(self, instance)
    local id = HS:GenerateGUID(true)
    CS:AddTag(instance, id)
    return id
end

customAttrubutes.Object.removeID = function(self, instance, id)
    CS:RemoveTag(instance, id)
end

customAttrubutes.Object.getObject = function(self, id)
    return CS:GetTagged(id)[1]
end

customAttrubutes.Object.getAttribute = function(self, part, name)
    local id = self:getID(part, name)
    return id and self:getObject(id)
end

customAttrubutes.Object.setAttribute = function(self, part, name, value)
    local id = self:getID(part, name)

    local object = id and self:getObject(id)
    if id and object then
        self:removeID(object, self:getID(part, name))
    end

    if value == nil then

        return part:SetAttribute(string.format(self.Symbol, name), nil)
    elseif typeof(value) == 'Instance' then
        if not id then
            id = self:addID(value)
        else
            CS:AddTag(value, id)
        end
        return part:SetAttribute(string.format(self.Symbol, name), id)
    else
        warn(string.format('%s is not a Instance', tostring(value)))
    end
end

--====================================================================================================--

return customAttrubutes