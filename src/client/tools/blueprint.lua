local client = require(script.Parent.Parent:WaitForChild("Modules"))
local playerUtils = client.get("playerUtils")
local toolAnimation = client.get("toolAnimation")

local shared = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"))
local blueprint = shared.get("blueprint")

local bpTool = {}
bpTool.__index = bpTool
bpTool.Hold = toolAnimation.new{
    Id = 6276634576,
    Looped = true,
    Priority = Enum.AnimationPriority.Action
}

local blueprintsGui = playerUtils:getPlayerGui():WaitForChild("Hud"):WaitForChild("Blueprints")
local activated = blueprintsGui:WaitForChild("Activated")

function bpTool.new(tool)
    local newTool = setmetatable({}, bpTool)
    tool.Equipped:Connect(function()
        bpTool.Hold:play()
        blueprintsGui.Visible = true
    end)

    tool.Unequipped:Connect(function()
        bpTool.Hold:stop()
        blueprintsGui.Visible = false
    end)
    
    activated.Event:Connect(function(name)
        local bp = blueprint.Blueprints[name]:new()
        if bp then
            bp:startPlacement()
        end

        playerUtils:getHumanoid():UnequipTools()
    end)
end

return bpTool