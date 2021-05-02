local machines = {}

for _, folder in ipairs(script:GetChildren()) do
    machines[folder.Name] = {}
    for _, module in ipairs(folder:GetChildren()) do
        machines[folder.Name][module.Name] = require(module)
    end
end

return machines