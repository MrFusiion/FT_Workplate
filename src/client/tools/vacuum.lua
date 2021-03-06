local RS = game:GetService("RunService")

local client = require(game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts"):WaitForChild("Modules"))
local toolAnimation = client.get("toolAnimation")
local playerUtils = client.get("playerUtils")

local vacuum = {}
vacuum.__index = vacuum
vacuum.Hold = toolAnimation.new{
    Id = 6495548892,
    Looped = true,
    Priority = Enum.AnimationPriority.Action
}

local function setSelectionBox(instance, boolean)
    local selectionBox = instance:FindFirstChildWhichIsA("SelectionBox")
    selectionBox.Visible = boolean
end

function vacuum.new(tool, barrelEnd)
    local newVacuum = setmetatable({}, vacuum)

    newVacuum.Tool = tool
    newVacuum.Beam = tool:FindFirstChildWhichIsA("Beam")

    tool.Equipped:Connect(function(mouse)
        vacuum.Hold:play()
    end)

    tool.Unequipped:Connect(function()
        vacuum.Hold:stop()
        playerUtils:getMouse().Icon = ""
        newVacuum:unlock()
    end)

    tool.Activated:Connect(function()
        newVacuum:lock(newVacuum:raycast())
    end)

    local conn
    conn = playerUtils:getHumanoid().Died:Connect(function()
        newVacuum:unlock()
        conn:Disconnect()
    end)

    return newVacuum
end

function vacuum:raycast()
    local mouse = playerUtils:getMouse()
    local unit = mouse.UnitRay

    local params = RaycastParams.new()
    params.CollisionGroup = "Resource"

    local result = workspace:Raycast(unit.Origin, unit.Direction * 1000, params)
    if result then
        return result.Instance
    end
end

function vacuum:lock(instance)
    local mouse = playerUtils:getMouse()
    if instance and instance:GetAttribute("Resource") then
        local model = instance:FindFirstAncestorWhichIsA("Model")
        while not model:FindFirstChild("LockEvent") do
            model = model:FindFirstAncestorWhichIsA("Model")
        end

        local lockEvent = model:FindFirstChild("LockEvent")
        local unlockEvent = model:FindFirstChild("UnlockEvent")

        if lockEvent and unlockEvent then

            self.unlock = function()
                unlockEvent:FireServer()
            end
            lockEvent:FireServer()
        end
    end
end

function vacuum:unlock()
    
end

return vacuum