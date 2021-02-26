return require(script.Parent:WaitForChild("core"))

--[[ element template
local core = require(script.Parent)

local element = core.roact.PureComponent:extend("__" .. script.Name .. "__")

function element:init()
    
end

function element:render()
    
end

function element:didMount()
    
end

return element
]]