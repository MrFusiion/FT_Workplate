local SS = game:GetService("Selection")
local CHS = game:GetService("ChangeHistoryService")

local function isClassOf(object, ...)
    if typeof(object) == "Instance" then
        for _, className in ipairs{...} do
            if object:IsA(className) then
                return true
            end
        end
    end
    return false
end

local function createPrimaryPart(model)
    local part = Instance.new("Part")
    part.Name = "TempPrimaryPart"
    part.Transparency = 1

    local cf, size = model:GetBoundingBox()
    part.Size = Vector3.new(size.Z, size.Y, size.X)
    part.CFrame = cf * CFrame.Angles(0, -math.pi * .5, 0)

    model.PrimaryPart = part
    part.Parent = model
    return part
end

return function(toolbar)
    local button = toolbar:CreateButton(script.Name, "Moves one CFrame to another CFrame.", "http://www.roblox.com/asset/?id=6026647916", "Move cf to cf")
    button.ClickableWhenViewportHidden = false

    button.Click:Connect(function()
        local selection = SS:Get()
        local instance_1 = selection[1]
        local instance_2 = selection[2]
        if isClassOf(instance_1, "Model", "BasePart") and isClassOf(instance_2, "Model", "BasePart") then
            local endPosition = instance_2:IsA("BasePart") and instance_2.CFrame or instance_2:GetBoundingBox()
            if instance_1:IsA("BasePart") then
                instance_1.CFrame = endPosition
            else
                local tempPart = instance_1.PrimaryPart or createPrimaryPart(instance_1)
                CHS:SetWaypoint("Moving Instance")
                instance_1:SetPrimaryPartCFrame(endPosition)
                CHS:SetWaypoint("Moved Instance")
                if tempPart then tempPart:Destroy() end
            end
        else
            if not isClassOf(instance_1, "Model", "BasePart") then
                warn(("Selection 1 is a %s but needs to be a Model or BasePart"):format(typeof(instance_1)))
            elseif not isClassOf(instance_2, "Model", "BasePart") then
                warn(("Selection 2 is a %s but needs to be a Model or BasePart"):format(typeof(instance_2)))
            end
        end
    end)
end