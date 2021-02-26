local core = require(script.Parent.Parent.Parent)
local bpButton = require(script.Parent:WaitForChild('bpButton'))

local item = {}
item.__index = {}

function item.new(name, image, ...)
    local newCatorgory = setmetatable({}, item)
    newCatorgory.Name = name
    newCatorgory.Image = image
    newCatorgory.Items = {}

    for _, it in ipairs{...} do
        newCatorgory:addSubItem(it)
    end

    return newCatorgory
end

function item.__index:addSubItem(it)
    self.Items[it.Name] = it
end

function item.__index:removeSubItem(itemName)
    self.Items[itemName] = nil
end

function item.__index:merge(other)
    for _, it in ipairs(other.Items) do
        self:addSubItem(it)
    end
    return self
end

function item.__index:render()
    return core.roact.createElement(bpButton, {
        Name = self.Name,
        Image = self.Image,
        [core.roact.Ref] = function(rbx)
            self.Button = rbx
        end
    })
end

function item.__index:renderSubItems()
    local items = {}
    for _, subItem in pairs(self.Items) do
        table.insert(items, subItem:render())
    end
    return items
end

return item