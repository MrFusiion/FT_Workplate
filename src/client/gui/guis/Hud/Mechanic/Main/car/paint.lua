local paint = {}
paint.__index = paint

function paint.new(carModel)
    local self = setmetatable({}, paint)
    self.Connections = {}
    self.Model = carModel

    self.Defualt = {}
    for _, catogory in ipairs{
        "Body", "Wheelcap", "Icon", "Seat", "Light"
    } do
        local attrName = ("%sColor"):format(catogory)
        self.Defualt[catogory] = BrickColor.new(carModel:GetAttribute(attrName))
        table.insert(self.Connections, carModel:GetAttributeChangedSignal(attrName):Connect(function()
            self.Defualt[catogory] = BrickColor.new(carModel:GetAttribute(attrName))
            self:color(catogory, self.Defualt[catogory])
        end))
    end

    self.Current = {}
    for k, v in pairs(self.Defualt) do
        self.Current[k] = v
    end

    self.Parts = {
        Body = {},
        Seat = {},
        Wheelcap = {},
        Icon = {},
        Light = {}
    }
    self.Spots = {}

    for _, child in ipairs(self.Model:GetChildren()) do
        if child:IsA("Seat") or child:IsA("VehicleSeat") then
            table.insert(self.Parts.Seat, child)
            for _, seatPart in ipairs(child.Body:GetDescendants()) do
                if seatPart:IsA("BasePart") then
                    table.insert(self.Parts.Seat, seatPart)
                end
            end
        elseif child.Name == "Wheels" then
            for _, axis in ipairs(child:GetChildren()) do
                for _, wheel in ipairs(axis:GetChildren()) do
                    for _, wheelPart in ipairs(wheel:GetChildren()) do
                        if wheelPart.Name == "WheelCap" then
                            table.insert(self.Parts.Wheelcap, wheelPart)
                        elseif wheelPart.Name == "Logo" then
                            table.insert(self.Parts.Icon, wheelPart)
                        end
                    end
                end
            end
        elseif child.Name == "Lights" then
            for _, light in ipairs(child:GetChildren()) do
                if light.Name == "Front" then
                    for _, part in ipairs(light:GetChildren()) do
                        table.insert(self.Parts.Light, part)
                        local spot = part:FindFirstChildWhichIsA("SpotLight")
                        if spot then
                            table.insert(self.Spots, spot)
                        end
                    end
                end
            end
        elseif child.Name == "Doors" then
            for _, door in ipairs(child:GetChildren()) do
                for _, doorPart in ipairs(door.Body:GetDescendants()) do
                    if doorPart:IsA("BasePart") then
                        table.insert(self.Parts.Body, doorPart)
                    end
                end
            end
        elseif child.Name == "Body" then
            for _, bodyPart in ipairs(child:GetDescendants()) do
                if bodyPart:IsA("BasePart") then
                    table.insert(self.Parts.Body, bodyPart)
                end
            end
        end
    end

    return self
end

function paint:color(catogory, color)
    local key = ("%sColor"):format(catogory)
    local parts = self.Parts[catogory]
    if parts then
        self.Current[key] = color
        for _, part in ipairs(parts) do
            part.BrickColor = color
        end
        if catogory == "Light" then
            for _, spot in ipairs(self.Spots) do
                spot.Color = color.Color
            end
        elseif catogory == "Wheelcap" or catogory == "Icons" then
            self.Model.UpdateWheel:Fire(catogory == "Wheelcap" and color or nil, catogory == "Icons" and color or nil)
        end
    else
        warn(("%s is not a valid Catogory"):format(catogory))
    end
end

function paint:reset(catogory)
    if catogory then
        self:color(catogory, self.Defualt[catogory])
    else
        for k, v in pairs(self.Defualt) do
            self:color(k, v)
        end
    end
end

function paint:apply()
    self.Model.Paint:FireServer(self.Current)
end

function paint:cleanup()
    for _, conn in ipairs(self.Connections) do
        conn:Disconnect()
    end
    self:reset()
end

return paint