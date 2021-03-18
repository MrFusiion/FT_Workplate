local SS = game:GetService("Selection")
local CHS = game:GetService("ChangeHistoryService")

local shapes = require(script.shapes)

local function changeInstance(oldInst, func)
    CHS:SetWaypoint("Creating Part")
    local newInst = func()
    CHS:SetWaypoint("Created Part")
    CHS:SetWaypoint("Destroying Part")
    oldInst:Destroy()
    CHS:SetWaypoint("Destroyed Part")

    newInst.Size = oldInst.Size
    newInst.CFrame = oldInst.CFrame
    newInst.Material = oldInst.Material
    newInst.BrickColor = oldInst.BrickColor
    newInst.Transparency = oldInst.Transparency
    newInst.CanCollide = oldInst.CanCollide
    newInst.Massless = oldInst.Massless
    newInst.Reflectance = oldInst.Reflectance
    newInst.CastShadow = oldInst.CastShadow
    newInst.Parent = oldInst.Parent

    SS:Set({newInst})
end

local function getSelected()
    local selection = SS:Get()
    if selection[1] and typeof(selection[1]) == "Instance" and selection[1]:IsA("BasePart") then
        return selection[1]
    else
        warn("No BasePart Selected!")
    end
end

local function createShapeMenu(plugin, t)
    local parentMenu = plugin:CreatePluginMenu(script.Name, "Shapes", "http://www.roblox.com/asset/?id=6034767621")

    local function inner(t, menu)
        for shapeName, value in pairs(t) do
            if typeof(value) == "table" then
                local subMenu = plugin:CreatePluginMenu(("%s_%s"):format(script.Name, shapeName), shapeName)
                inner(value, subMenu)
                menu:AddMenu(subMenu)
            else
                local action = menu:AddNewAction(("Shape_%s"):format(shapeName), shapeName)
                action.Triggered:Connect(function()
                    local selected = getSelected()
                    if selected then
                        changeInstance(selected, value)
                        --parentMenu:
                    end
                end)
            end
        end
    end
    inner(t, parentMenu)
    return parentMenu
end

return function(toolbar, plugin)
    local button = toolbar:CreateButton(script.Name, "Change a shape of a part.", "http://www.roblox.com/asset/?id=6034767621", "Shape")
    button.ClickableWhenViewportHidden = false

    local pluginMenu = createShapeMenu(plugin, shapes)

    button.Click:Connect(function()
        if getSelected() then
            pluginMenu:ShowAsync()
        end
    end)
end