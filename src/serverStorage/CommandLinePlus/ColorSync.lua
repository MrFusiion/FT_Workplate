local element = {}
element.__index = element

function element.new(object)
	local newElement = setmetatable({}, element)
	newElement.Object = object
	newElement.Guides = {}
	return newElement
end

function element:addGuide(propName, guide, callback)
	table.insert(self.Guides, {
		propName = propName,
		guide = guide,
		callback = callback or function(color) return color end
	})
end

function element:syncColor()
	for _, guide in ipairs(self.Guides) do
		self.Object[guide.propName] = guide.callback(settings().Studio.Theme:GetColor(guide.guide))
	end
end

local mt = {}
mt.__index = mt
local elements = setmetatable({}, mt)

function mt:add(object)
	local elem = element.new(object)
	table.insert(self, elem)
	return elem
end

settings().Studio.ThemeChanged:Connect(function()
	for _, elem in pairs(elements) do
		elem:syncColor()
	end
end)

return elements