local core = require(script.Parent.Parent.Parent)

local remoteDebug = game:GetService("ReplicatedStorage"):WaitForChild("remote"):WaitForChild("debug")
local re_PlantTree = remoteDebug:WaitForChild("PlantTree")
local re_ClearTrees = remoteDebug:WaitForChild("ClearTrees")

local buttons = {}

buttons[1] = {
    Name = "Inventory",
    Keybind = "None",
    Icon = "rbxassetid://4918932777",
    Color = Color3.fromRGB(255, 190, 80),
    Padding = { x = -10, y = -10 },
    ConsoleButton = Enum.KeyCode.ButtonY,
    Callback = function()
        --print("Inventory")
        re_PlantTree:FireServer()
    end
}

buttons[2] = {
    Name = "Daily",
    Keybind = "None",
    Icon = "rbxassetid://5780596760",
    Color = Color3.fromRGB(230, 100, 100),
    ConsoleButton = Enum.KeyCode.ButtonB,
    Callback = function()
        re_ClearTrees:FireServer()
        --print("Daily")
    end
}

buttons[3] = {
    Name = "Store",
    Keybind = "None",
    Icon = "rbxassetid://6276330459",
    Color = Color3.fromRGB(140, 150, 255),
    ConsoleButton = Enum.KeyCode.DPadUp,
    Callback = function()
        print("Store")
    end
}


buttons[4] = {
    Name = "Settings",
    Keybind = "None",
    Icon = "rbxassetid://5780598054",
    Color = Color3.fromRGB(150, 150, 150),
    ConsoleButton = Enum.KeyCode.DPadDown,
    Callback = function()
        print("Settings")
    end
}

return buttons