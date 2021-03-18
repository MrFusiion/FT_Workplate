local lightButton = require(script.LightButton)

local active = false

local function getGui()
    local gui = game:GetService("CoreGui"):FindFirstChild("FluxTools")
    if not gui then
        gui = Instance.new("ScreenGui")
        gui.Name = "FluxTools"
        gui.Parent = game:GetService("CoreGui")
    end
    return gui
end

local connAdded
return function(toolbar, plugin)
    local button = toolbar:CreateButton(script.Name, "Open light editor.", "http://www.roblox.com/asset/?id=6026568247", "Lights")
    button.ClickableWhenViewportHidden = false

    local frame
    frame = Instance.new("Frame")
    frame.BackgroundTransparency = 1
    frame.Name = "Lights"
    frame.Size = UDim2.fromScale(1, 1)
    frame.Visible = true
    frame.Parent = getGui()

    local lights = {}
    for _, descendant in ipairs(workspace:GetDescendants()) do
        if descendant:IsA("PointLight") or descendant:IsA("SurfaceLight") or descendant:IsA("SpotLight") then
            table.insert(lights, lightButton.new(descendant, frame))
        end
    end

    connAdded = workspace.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("PointLight") or descendant:IsA("SurfaceLight") or descendant:IsA("SpotLight") then
            local lButton = lightButton.new(descendant, frame)
            if active then
                lButton:show()
            else
                lButton:hide()
            end
            table.insert(lights, lButton)
        end
    end)

    button.Click:Connect(function()
        active = not active
        button:setActive(active)
        if active then
            frame.Visible = true
            for _, light in pairs(lights) do
                light:show()
            end
        elseif frame then
            frame.Visible = false
            for _, light in pairs(lights) do
                light:hide()
            end
        end
    end)

    plugin.Unloading:Connect(function()
        frame:Destroy()
        if connAdded then
            connAdded:Disconnect()
        end
    end)
end