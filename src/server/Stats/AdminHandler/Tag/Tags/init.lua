local tags = {}

for _, module in ipairs(script:GetChildren()) do
    if module:IsA("ModuleScript") then
        local suc, tag = pcall(function()
            return require(module)
        end)
        if suc then
            if not tags[module.Name] then
                tags[module.Name] = tag
            else
                warn(("Tag %s allready added!"):format(module.Name))
            end
        else
            warn(("Could not load %s Tag!"):format(module.Name))
            warn(tag)
        end
    end
end

return tags