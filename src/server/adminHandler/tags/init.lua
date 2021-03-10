local tag = require(script:WaitForChild("tag"))

local tags = {}

tags.DEV = tag.new("DEV", Color3.new(0.992156, 0.529411, 0), {
	NameColor = Color3.new(0.854901, 0.278431, 0.278431)
})
tags.DEV.condition = function(_, rank)
	return rank == "DEV"
end

return tags