local MAIN_FOLDER = game:GetService("ReplicatedStorage"):WaitForChild("Models")

local shared = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
local stringUtils = shared.get("stringUtils")
local mathUtils = shared.get("mathUtils")

local VECTOR_ROUND_PRECISION = 1
local function createPrimaryPart(model)
    local cf, size = model:GetBoundingBox()
    local newSize = Vector3.new(
        mathUtils.ceilStep(mathUtils.round(size.X, VECTOR_ROUND_PRECISION), .5),
        mathUtils.ceilStep(mathUtils.round(size.Y, VECTOR_ROUND_PRECISION), .5),
        mathUtils.ceilStep(mathUtils.round(size.Z, VECTOR_ROUND_PRECISION), .5)
    )

    local primaryPart = Instance.new("Part")
    primaryPart.Name = "Root"
    primaryPart.Anchored = true
    primaryPart.Transparency = 1
    primaryPart.CanCollide = false
    primaryPart.Size = newSize
    primaryPart.CFrame = cf + (cf.UpVector * (newSize.X - size.X) / 2)
    primaryPart.Parent = model

    model.PrimaryPart = primaryPart
end

return function (path)
    local current = MAIN_FOLDER
    for subPath in stringUtils.splitIter(path, { '\\', '/' }) do
        current = current:WaitForChild(subPath)
    end
    if typeof(current) == "Instance" and current.ClassName == "Model" then
        if not current.PrimaryPart then
            createPrimaryPart(current)
        end
        return current
    else
        error("Object that was found is not a Model!")
    end
end