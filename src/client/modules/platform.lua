local UIS = game:GetService("UserInputService")

local shared = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"))
local event = shared.get("event")

local platform = {}
platform.LastPlatform = nil
platform.LastInputType = nil
platform.__PlatformChange, platform.PlafromChange = event.new()

--========================/init/========================--
if (game:GetService("GuiService"):IsTenFootInterface()) then
    platform.LastInputType = Enum.UserInputType.Gamepad1
elseif (game:GetService("UserInputService").TouchEnabled and not game:GetService("UserInputService").MouseEnabled) then
    platform.LastInputType = Enum.UserInputType.Touch
else
    platform.LastInputType = Enum.UserInputType.Keyboard
end
--========================/init/========================--

function platform.getPlatform()
    if platform.LastInputType then
        if platform.LastInputType == Enum.UserInputType.Focus then
            return platform.LastPlatform
        end
        if Enum.UserInputType.Keyboard == platform.LastInputType or Enum.UserInputType.TextInput == platform.LastInputType then
            platform.LastPlatform = "PC"
            return "PC"
        elseif Enum.UserInputType.Touch  == platform.LastInputType then
            platform.LastPlatform = "MOBILE"
            return "MOBILE"
        elseif string.find(tostring(platform.LastInputType), "Enum.UserInputType.Gamepad") then
            platform.LastPlatform = "CONSOLE"
            return "CONSOLE"
        end

        for _, type in pairs{ Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseButton2,
                Enum.UserInputType.MouseButton3, Enum.UserInputType.MouseMovement, Enum.UserInputType.MouseWheel } do
            if type == platform.LastInputType then
                platform.LastPlatform = "PC"
                return "PC"
            end
        end
    end
end

function platform.getConsoleImage(keycode)
    local gamepadButtonImage = {
        [Enum.KeyCode.ButtonX] =    "rbxassetid://4954053197",
        [Enum.KeyCode.ButtonY] =    "rbxassetid://5528142049",
        [Enum.KeyCode.ButtonA] =    "rbxassetid://5528141664",
        [Enum.KeyCode.ButtonB] =    "rbxassetid://4954313180",
        [Enum.KeyCode.DPadUp] =     "rbxassetid://6292428951",
        [Enum.KeyCode.DPadRight] =  "rbxassetid://6292429056",
        [Enum.KeyCode.DPadDown] =   "rbxassetid://6292429251",
        [Enum.KeyCode.DPadLeft] =   "rbxassetid://6292429148",
    }
    if not gamepadButtonImage[keycode] then
        warn("No image found for that button!")
    end
    return gamepadButtonImage[keycode]
end

function platform.KeyCodeToText(keycode)
    local KeyCodeTextMapping = {
        [Enum.KeyCode.E] = "E"
    }
    if not KeyCodeTextMapping[keycode] then
        warn("Key cannot be mapped to text!")
    end
    return KeyCodeTextMapping[keycode]
end

UIS.LastInputTypeChanged:Connect(function(uis)
    local oldPlatform = platform.getPlatform()
    if oldPlatform == nil then print(platform.LastInputType) end
    platform.LastInputType = uis
    if oldPlatform ~= platform.getPlatform() then
        platform.__PlatformChange:Fire(platform.getPlatform())
    end
end)

return platform