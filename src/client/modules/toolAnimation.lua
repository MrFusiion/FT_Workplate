local client = require(game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts"):WaitForChild("Modules"))
local playerUtils = client.get("playerUtils")

local toolAnimation = {}
toolAnimation.__index = toolAnimation

function toolAnimation.new(props)
    local newToolAnimation = setmetatable({}, toolAnimation)

    newToolAnimation.Anim = Instance.new("Animation")
    if props.Id then
        newToolAnimation.Anim.AnimationId = typeof(props.Id) == "number" and ("rbxassetid://%d"):format(props.Id) or props.Id
        props.Id = nil
    end

    newToolAnimation.Props = props

    return newToolAnimation
end

function toolAnimation:loadAnimation()
    local humanoid = playerUtils:getHumanoid()
    if humanoid then
        self.Track = humanoid:WaitForChild("Animator"):LoadAnimation(self.Anim)
        for propName, propValue in pairs(self.Props) do
            self.Track[propName] = propValue
        end
    end
    return self.Track
end

function toolAnimation:play()
    self:loadAnimation():Play()
end

function toolAnimation:stop()
    if self.Track then
        self.Track:Stop()
    end
end

return toolAnimation