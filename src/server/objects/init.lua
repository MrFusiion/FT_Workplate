local function getObjects(parent)
    local t = {}
    for _, child in ipairs(parent:GetChildren()) do
        if child:IsA("Folder") then
            t[child.Name] = getObjects(child)
        elseif child:IsA("ModuleScript") then
            local suc, err = pcall(function()
                t[child.Name] = require(child)
            end)
            if not suc then
                warn(("Module %s experienced an error while loading: %s"):format(child.Name, err))
            end
        end
    end
    return t
end

local objects = {}
for _, catogory in ipairs(script:GetChildren()) do
    if catogory:IsA("Folder") then
        objects[catogory.Name] = getObjects(catogory)
    end
end

return objects