local Gui = {}

Gui.__List = {}

function Gui:Add(name, bool)
	local enabled = Instance.new("BoolValue")
	enabled.Name = name
	enabled.Value = bool or false
	self.__List[name] = enabled
	return enabled
end

function Gui:Get(name)
	return self.__List[name]
end

return Gui