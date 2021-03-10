local function getObjects(parent)
    local t = {}
    for _, child in ipairs(parent:GetChildren()) do
        if child:IsA("Folder") then
            t[child.Name] = getObjects(child)
        elseif child:IsA("ModuleScript") then
            t[child.Name] = require(child)
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