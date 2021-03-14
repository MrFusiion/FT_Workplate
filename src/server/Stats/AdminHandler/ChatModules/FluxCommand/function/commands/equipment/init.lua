local equipment = {}

local be_SetVacuum = game.ServerScriptService.EquipmentHandler.SetVacuum
equipment.give_vacuum = {
    prefix = { "gfvacuum" },
    args = { "<player>", "<string>" },
    rank = "DEV",
    callback = function(player, target, vacuumName)
        if target then
            print("gfvacuum", target.Name, vacuumName)
            be_SetVacuum:Fire(target, vacuumName)
        end
    end
}

local be_SetBackpack = game.ServerScriptService.EquipmentHandler.SetBackpack
equipment.give_backpack = {
    prefix = { "gfbackpack" },
    args = { "<player>", "<string>" },
    rank = "DEV",
    callback = function(player, target, backpackName)
        if target then
            print("gfbackpack", target.Name, backpackName)
            be_SetBackpack:Fire(target, backpackName)
        end
    end
}

local be_SpawnCar = game.ServerScriptService.Objects.CarHandler.SpawnCar
equipment.spawn_car = {
    prefix = { "spawncar" },
    args = { "<player>", "<string>" },
    rank = "DEV",
    callback = function(player, target, carName)
        if target and target.Character then
            local hrt = target.Character.HumanoidRootPart
            local cf = hrt.CFrame + hrt.CFrame.LookVector * 15
            be_SpawnCar:Fire(target, carName, cf)
        end
    end
}

return equipment