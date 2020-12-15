local modules = require(game:GetService("ServerScriptService"):WaitForChild("modules"))
local random = modules.get("random")

local rand = random.new()
rand:setSeedGenInterval(1)

game:WaitForChild("hello")