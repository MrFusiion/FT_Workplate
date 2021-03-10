local client = require(game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts"):WaitForChild("Modules"))
local toolAnimation = client.get("toolAnimation")
local playerUtils = client.get("playerUtils")

local axe = {}
axe.__index = axe
axe.Swing = toolAnimation.new{
    Id = 4900180656,
    Priority = Enum.AnimationPriority.Action
}

--"rbxasset://textures/GunWaitCursor.png"
--"rbxasset://textures/GunCursor.png"

function axe.new(tool)
    local newAxe = setmetatable({}, axe)

    tool.Equipped:Connect(function(mouse)
        mouse.Icon = "rbxasset://textures/GunCursor.png"
    end)

    tool.Activated:Connect(function()
        axe.Swing:play()
    end)

    tool.Unequipped:Connect(function()
        axe.Swing:stop()
        playerUtils:getMouse().Icon = ""
    end)

    return newAxe
end

return axe