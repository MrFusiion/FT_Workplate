local playerUtils = require(script.Parent.playerUtils)

local backpackUtils = {}

local tools = {}
local connections = {}

function backpackUtils.getBackpack()
    local player = playerUtils.getPlayer()
    return player.Backpack
end

function backpackUtils.getEquippedTool()
    local char = playerUtils.getChar()
    return char:FindFirstChildWhichIsA("Tool")
end

function backpackUtils.hide()
    if #connections > 1 then return end
    local backpack = backpackUtils.getBackpack()

    --local equippedTool = backpackUtils.getEquippedTool()
    --if equippedTool then
        --equippedTool.Parent = nil
        --table.insert(tools, equippedTool)
    --end
    playerUtils.getHumanoid():UnequipTools()

    for _, tool in ipairs(backpack:GetChildren()) do
        tool.Parent = nil
        table.insert(tools, tool)
    end

    table.insert(connections, backpack.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            child.Parent = nil
            table.insert(tools, child)
        end
    end))
end

function backpackUtils.show()
    if #connections == 0 then return end
    local backpack = backpackUtils.getBackpack()

    for _, conn in ipairs(connections) do
        conn:Disconnect()
    end

    for _, tool in ipairs(tools) do
        tool.Parent = backpack
    end

    tools = {}
    connections = {}
end

return backpackUtils