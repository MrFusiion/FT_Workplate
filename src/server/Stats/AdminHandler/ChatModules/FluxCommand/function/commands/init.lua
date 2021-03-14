local commands = {}

for _, module in ipairs(script:GetChildren()) do
    if module:IsA("ModuleScript") then
        local suc, cmds = pcall(function()
            return require(module)
        end)
        if suc then
            for key, cmd in pairs(cmds) do
                if not commands[key] then
                    commands[key] = cmd
                else
                    warn(("Key %s allready Used, Command: %s is not added!"):format(key, cmd.prefix[1]))
                end
            end
        else
            warn(("Could not load %s commands!"):format(module.Name))
            warn(cmds)
        end
    end
end


return commands