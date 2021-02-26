local themes = {}

for _, theme in pairs(script:GetChildren()) do
    if theme:IsA("ModuleScript") then
        if theme.Name ~= "get" then
            local _, err = pcall(function()
                themes[theme.Name] = require(theme)
            end)
            if err then
                warn(string.format(" Could not load theme error: \n\t%s", err))
            end
        else
            warn(" Theme name cannot be get!")
        end
    end
end

return themes