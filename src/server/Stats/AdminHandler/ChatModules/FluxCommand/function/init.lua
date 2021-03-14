local command = require(script:WaitForChild("command"))

return function (player, msg)
    local cmd = command.getCommand(msg)
    if cmd and command.canPlayerUseCommand(player, cmd) then
        command.procces(player, cmd, msg)
        return true
    end
    return false
end