local shared = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"))
local event = shared.get("event")

local region = {}
region.__index = region

local function TiggerSignalWrapper(signal)
    return function(part)
        if part.Name == "HumanoidRootPart" then
            signal:Fire(game:GetService("Players"):GetPlayerFromCharacter(part.Parent))
        end
    end
end

function region.new(name, parts, color)
    local EnterSignal, EnterEvent = event.new()
    local LeaveSignal, LeaveEvent = event.new()

    local newRegion = setmetatable({}, region)
    newRegion.OnEnter = EnterEvent
    newRegion.OnLeave = LeaveEvent
    newRegion.Name = name
    newRegion.Color = color
    newRegion.Connections = {}

    for _, part in pairs(typeof(parts)=="table" and parts or {parts}) do
        table.insert(newRegion.Connections, part.Touched:Connect(TiggerSignalWrapper(EnterSignal)))
        table.insert(newRegion.Connections, part.TouchEnded:Connect(TiggerSignalWrapper(LeaveSignal)))
        
        part.Anchored = true
        part.Transparency = 1
        part.CanCollide = false
        part.Material = "SmoothPlastic"
    end

    return newRegion
end

function region:destroy()
    for _, conn in ipairs(self.Connections) do
        conn:Disconnect()
    end
    self.Connections = {}
end

return region