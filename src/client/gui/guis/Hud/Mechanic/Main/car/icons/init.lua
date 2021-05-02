local icons = {}
icons.__index = icons
icons.icon = require(script.icon)

function icons.new(carModel : Model)
    local self = setmetatable({}, icons)
    self.Model = carModel
    self.List = {}

    self.DefaultIcon = carModel:GetAttribute("WheelIcon")
    self.CurrentIcon = self.DefaultIcon

    self.Connections = {}
    table.insert(self.Connections, carModel:GetAttributeChangedSignal("WheelIcon"):Connect(function()
        self.DefaultIcon = carModel:GetAttribute("WheelIcon")
        for _, icon in ipairs(self.List) do
            icon:refresh(self.DefaultIcon)
        end
    end))

    for _, axis in ipairs(carModel.Wheels:GetChildren()) do
        for _, wheel in ipairs(axis:GetChildren()) do
            if wheel:IsA("Model") then
                table.insert(self.List, self.icon.new(wheel, self.DefaultIcon))
            end
        end
    end
    return self
end

function icons:set(name : string)
    self.CurrentIcon = name
    for _, icon in ipairs(self.List) do
        icon:set(name)
    end
end

function icons:apply()
    self.Model.setIcon(self.CurrentIcon)
end

function icons:reset()
    self:set(self.DefaultIcon)
end

function icons:apply()
    self.Model.Paint:FireServer({ icon = self.CurrentColor })
    self.Model.SetIcon:FireServer(self.CurrentIcon)
end

function icons:cleanup()
    for _, conn in ipairs(self.Connections) do
        conn:Disconnect()
    end
    self:reset()
    for _, icon in ipairs(self.Lists) do
        icon:cleanup()
    end
end

return icons