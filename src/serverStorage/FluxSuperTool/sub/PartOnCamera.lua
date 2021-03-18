local IS = game:GetService("InsertService")
local CS = game:GetService("CollectionService")
local CHS = game:GetService("ChangeHistoryService")

local function createCamera()
    local camera = Instance.new("Camera")
    camera.Name = "ThumbnailCamera"
    return camera
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
    local button = toolbar:CreateButton(script.Name, "Create cameraPart on camera for scripts to use its cframe position.", "http://www.roblox.com/asset/?id=6031572312", "Camera")
    button.ClickableWhenViewportHidden = false

    button.Click:Connect(function()
        local camera = workspace.CurrentCamera
        CHS:SetWaypoint("Loading Camera")
        local asset = IS:LoadAsset(6528202451)
        CHS:SetWaypoint("Loaded Camera")
        if asset then
            if not asset.PrimaryPart then
                createPrimaryPart(asset)
            end

            asset.Name = "FluxCamera"
            asset:SetPrimaryPartCFrame(camera.CFrame)
            asset.Parent = workspace

            createCamera().Parent = asset

            CS:AddTag(asset, "RBXStudioCamera")
        else
            warn("Model not found!")
        end
        button:SetActive(false)
    end)
end