local misc = {}

misc.kill = {
    prefix = { "kill" },
    args = { "<player>" },
    rank = "ADMIN",
    callback = function(player, target)
        if target then
            local char = target.Character
            if char then
                local head = char:FindFirstChild("Head")
                if head then
                    head:Destroy()
                end
            end
        end
    end
}

misc.tp_to = {
    prefix = { "tpto" },
    args = { "<player>", "<player>" },
    rank = "ADMIN",
    callback = function(_, playerFrom, playerTo)
        if playerFrom ~= playerTo then
            local charFrom = playerFrom.Character or playerFrom.CharacterAdded:Wait()
            local hrtFrom = charFrom:FindFirstChild("HumanoidRootPart")
            local charTo = playerTo.Character or playerTo.CharacterAdded:Wait()
            local hrtTo = charTo:FindFirstChild("HumanoidRootPart")
            if hrtFrom and hrtTo then
                hrtFrom.CFrame = hrtTo.CFrame
            end
        end
    end
}

misc.set_speed = { 
    prefix = { "speed" },
    args = { "<player>", "<number>" },
    rank = "ADMIN",
    callback = function(_, target, speed)
        local char = target.Character or target.CharacterAdded:Wait()
        local hmd = char:FindFirstChild("Humanoid")
        if hmd then
            hmd.WalkSpeed = speed
        end
    end
}

misc.set_jump_power = {
    prefix = { "jumppower" },
    args = { "<player>", "<number>" },
    rank = "ADMIN",
    callback = function(_, target, power)
        local char = target.Character or target.CharacterAdded:Wait()
        local hmd = char:FindFirstChild("Humanoid")
        if hmd then
            hmd.JumpPower = power
        end
    end
}

misc.fly = {
    prefix = { "fly" },
    args = {},
    rank = "ADMIN",
    callback = function(player)
        local flyScript = player.PlayerGui:FindFirstChild("flight")
        if flyScript then
            local cleanup = script.fly.cleanup:Clone()
            cleanup.Parent = player.PlayerGui
            flyScript:Destroy()
        else
            local fly = script.fly.flight:Clone()
            fly.Parent = player.PlayerGui
        end
    end
}

return misc