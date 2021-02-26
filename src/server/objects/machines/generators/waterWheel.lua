--@initApi
--@Class: 'WaterWheel'
local TS = game:GetService("TweenService")

local super = script.Parent.Parent.Parent
local getModel = require(super:WaitForChild("getModel"))
local submodule = require(super:WaitForChild("submodules"))
local fluid = submodule.get("fluid")
local producer = submodule.get("producer")

local waterWheel = {}
waterWheel.__index = waterWheel
waterWheel.Name = 'WaterWheel'

local generators = {}

--[[@Function: {
    'class' : 'WaterWheel',
    'name' : 'new',
    'args' : { 'parent' : 'Instance', 'cf' : 'CFrame' },
    'return' : 'WaterWheel',
    'info' : "Creates a new WaterWheel."
}
@Properties: {
    'class' : 'WaterWheel',
    'props' : [{
        'name' : 'Speed',
        'type' : 'number'
    }, {
        'name' : 'Model',
        'type' : 'Model'
    }, {
        'name' : 'Model',
        'type' : 'Model'
    }, {
        'name' : 'Wheel',
        'type' : 'Model'
    }, {
        'name' : 'Fluid',
        'type' : 'Fluid'
    }, {
        'name' : 'Producer',
        'type' : 'Producer'
    }, {
        'name' : 'Running',
        'type' : 'boolean'
    }]
}]]
waterWheel.MODEL = getModel("tier1\\machines\\generators\\WaterWheel")
function waterWheel.new(parent, cf)
    local newWaterWheel = setmetatable({}, waterWheel)

    newWaterWheel.Speed = 10-- times it takes for a full rotation

    newWaterWheel.Model = waterWheel.MODEL:Clone()
    newWaterWheel.Model:SetPrimaryPartCFrame(cf + cf.UpVector * waterWheel.MODEL.PrimaryPart.Size.Y / 2)
    newWaterWheel.Model.Parent = parent

    newWaterWheel.Wheel = newWaterWheel.Model.Wheel

    local waterPart = newWaterWheel.Model.Water
    newWaterWheel.Fluid = fluid.new()
    newWaterWheel.Fluid.BrickColor = BrickColor.Blue()
    newWaterWheel.Fluid.Transparency = .5
    newWaterWheel.Fluid.Anchored = true
    newWaterWheel.Fluid.Size = waterPart.Size
    newWaterWheel.Fluid.CFrame = waterPart.CFrame
    newWaterWheel.Fluid.Parent = waterPart

    newWaterWheel.Producer = producer.new(500, 50000, 5)

    --Weld the waterWheel togheter
    local primaryPart = newWaterWheel.Wheel.PrimaryPart
    for _, child in pairs(newWaterWheel.Wheel:GetChildren()) do
        if child:IsA("BasePart") then
            if child ~= primaryPart then
                local weld = Instance.new("Weld")
                weld.Part0 = primaryPart
                weld.Part1 = child
                weld.C0 = primaryPart.CFrame:Inverse() * child.CFrame
                weld.Parent = primaryPart
                child.Anchored = false
            end
        end
    end
    --primaryPart.Anchored = false
    newWaterWheel:run()
    newWaterWheel.Producer:startLoop()

    return newWaterWheel
end

--[[@Function: {
    'class' : 'WaterWheel',
    'name' : 'run',
    'args' : { 'self' : 'WaterWheel' },
    'info' : "Starts the WaterWheel turn animation."
}]]
function waterWheel.run(self)
    if self.Running then return end
    self.Running = true
    spawn(function()
        local tween
        while self.Running do
            tween = TS:Create(self.Wheel.PrimaryPart, TweenInfo.new(self.Speed * .5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
                CFrame = self.Wheel:GetPrimaryPartCFrame() * CFrame.Angles(math.pi, 0, 0)
            })
            tween:Play()
            tween.Completed:Wait()
        end
        if tween then
            tween:Stop()
        end
    end)
end

--[[@Function: {
    'class' : 'WaterWheel',
    'name' : 'stop',
    'args' : { 'self' : 'WaterWheel' },
    'info' : "Stops the WaterWheel turn animation."
}]]
function waterWheel.stop(self)
    self.Running = false
end

return waterWheel