local SS = game:GetService("Selection")
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")

local BUTTONS = {
    SurfaceLight = require(script.buttons.SurfaceLight),
    PointLight = require(script.buttons.PointLight),
    SpotLight = require(script.buttons.SpotLight)
}

local lightButton = {}
lightButton.__index = lightButton

function lightButton.new(light, parent)
    local newLightButton = {}

    newLightButton.Light = light

    newLightButton.Button = BUTTONS[light.ClassName].new(parent)

    newLightButton.Button.Button.MouseButton1Down:Connect(function()
        newLightButton.Button.Click = true
    end)

    newLightButton.Button.Button.MouseButton1Up:Connect(function()
        newLightButton.Button.Click = false
        newLightButton:click()
    end)

    newLightButton.Button.Button.MouseEnter:Connect(function()
        print("mouse enter")
        TS:Create(newLightButton.Button.Button, TweenInfo.new(.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Size = UDim2.fromOffset(30, 30) }):Play()
    end)

    newLightButton.Button.Button.MouseLeave:Connect(function()
        print("mouse leave")
        TS:Create(newLightButton.Button.Button, TweenInfo.new(.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Size = UDim2.fromOffset(25, 25) }):Play()
    end)

    return setmetatable(newLightButton, lightButton)
end

function lightButton:initEvents()

end

function lightButton:show()
    self.Button.Visible = false
    self.Conn = RS.RenderStepped:Connect(function()
        self:update()
    end)
end

function lightButton:hide()
    if self.Conn then
        self.Conn:Disconnect()
    end
end

function lightButton:update()
    if self.Button.Button.Parent and self.Light and self.Light.Parent and self.Light.Parent:IsA("BasePart") then
        local camera = workspace.CurrentCamera
        local pos, onScreen = camera:WorldToScreenPoint(self.Light.Parent.Position)

        self.Button.Button.Visible = onScreen
        self.Button.Button.Position = UDim2.fromOffset(pos.X, pos.Y)
        self.Button:color(self.Light.Color)
    else
        self:destroy()
    end
end

function lightButton:click()
    SS:Set({self.Light})
end

function lightButton:destroy()
    if self.Button.Button and self.Button.Button.Parent then
        self.Button.Button:destroy()
    end
    if self.Conn then
        self.Conn:Disconnect()
    end
end

return lightButton