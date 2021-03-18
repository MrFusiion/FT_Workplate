local SS = game:GetService("Selection")
local CHS = game:GetService("ChangeHistoryService")

local function isClassOf(object, className)
    return typeof(object) == "Instance" and object:IsA(className)
end

local function createPrimaryPart(model)
    CHS:SetWaypoint("Creating BoundingBox")
    local part = Instance.new("Part")
    CHS:SetWaypoint("Created BoundingBox")
    part.Name = "BoundingBox"
    part.Transparency = .5
    part.BrickColor = BrickColor.new("Persimmon")
    part.Material = "Neon"

    local cf, size = model:GetBoundingBox()
    part.Size = size
    part.CFrame = cf

    part.Parent = workspace
    return part
end

return function(toolbar)
    local button = toolbar:CreateButton(script.Name, "Creates a bounding box for the current selected model.", "http://www.roblox.com/asset/?id=6035047375", "BoundingBox")
    button.ClickableWhenViewportHidden = false

    button.Click:Connect(function()
        local selection = SS:Get()
        local model = selection[1]

        if isClassOf(model, "Model") then
            local part = createPrimaryPart(model)
            SS:Set({part})
        else
            warn(("Selection 1 is a %s but needs to be a Model"):format(typeof(model)))
        end
    end)
end