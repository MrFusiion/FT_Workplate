local client = require(script.Parent.Parent:WaitForChild('modules'))
local playerUtils = client.get('playerUtils')

local shared = require(game:GetService('ReplicatedStorage'):WaitForChild('modules'))
local blueprint = shared.get('blueprint')

local bpTool = {}
bpTool.__index = bpTool
bpTool.HoldAnimation = Instance.new('Animation')
bpTool.HoldAnimation.AnimationId = 'rbxassetid://6276634576'

local blueprintsGui = playerUtils:getPlayerGui():WaitForChild('Hud'):WaitForChild('Blueprints')
local activated = blueprintsGui:WaitForChild('Activated')

function bpTool.new(tool)
    local newTool = setmetatable({}, bpTool)
    tool.Equipped:Connect(function()
        newTool:LoadHoldAnimation():Play()
        blueprintsGui.Visible = true
    end)

    tool.Unequipped:Connect(function()
        if newTool.Track then
            newTool.Track:Stop()
        end
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

function bpTool.LoadHoldAnimation(self)
    local humanoid = playerUtils:getHumanoid()
    if humanoid then
        self.Track = humanoid:WaitForChild('Animator'):LoadAnimation(bpTool.HoldAnimation)
        self.Track.Looped = true
        self.Track.Priority = Enum.AnimationPriority.Action
    end
    return self.Track
end

return bpTool