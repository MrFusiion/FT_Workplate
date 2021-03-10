local expandDecal = require(script.Parent:WaitForChild("expandDecal"))

local propertyRemote = game:GetService("ReplicatedStorage")
    :WaitForChild("remote")
    :WaitForChild("property")

local re_ExpandProperty = propertyRemote:WaitForChild("ExpandProperty")
local rf_GetPlatePrice = propertyRemote:WaitForChild("GetPlatePrice")

local modules = require(game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts"):WaitForChild("Modules"))
local playerUtils = modules.get("playerUtils")

local expandPlate = {}
expandPlate.__index = expandPlate

function expandPlate.new(plate)
    if not plate:FindFirstChild("ExpandPlate") then
        local newExpandPlate = setmetatable({}, expandPlate)

        newExpandPlate.Plate = plate

        newExpandPlate.Part = Instance.new("Part")
        newExpandPlate.Part.Name = "ExpandPlate"
        newExpandPlate.Part.Transparency = 1
        newExpandPlate.Part.BrickColor = BrickColor.new("Black")
        newExpandPlate.Part.Material = "SmoothPlastic"
        newExpandPlate.Part.Anchored = true
        newExpandPlate.Part.CanCollide = false
        newExpandPlate.Part.CFrame = plate.CFrame
        newExpandPlate.Part.Size = plate.Size

        newExpandPlate.Decal = expandDecal()
        newExpandPlate.Decal.Parent = newExpandPlate.Part

        newExpandPlate.SelectionBox = Instance.new("SelectionBox")
        newExpandPlate.SelectionBox.Transparency = 1
        newExpandPlate.SelectionBox.SurfaceTransparency = 1
        newExpandPlate.SelectionBox.Color3 = Color3.new(0.262745, 0.431372, 0.988235)
        newExpandPlate.SelectionBox.SurfaceColor3 = Color3.new(0.227450, 0.525490, 0.972549)
        newExpandPlate.SelectionBox.Adornee = newExpandPlate.Part
        newExpandPlate.SelectionBox.Parent = newExpandPlate.Part

        newExpandPlate.ClickDetector = Instance.new("ClickDetector")
        newExpandPlate.ClickDetector.MaxActivationDistance = 50000
        newExpandPlate.ClickDetector.CursorIcon = "rbxasset://textures/ArrowFarCursor.png"
        newExpandPlate.ClickDetector.MouseHoverEnter:Connect(function()
            newExpandPlate:select()
        end)
        newExpandPlate.ClickDetector.MouseHoverLeave:Connect(function()
            newExpandPlate:unselect()
        end)
        newExpandPlate.ClickDetector.Parent = newExpandPlate.Part

        newExpandPlate.Part.Parent = plate

        return newExpandPlate
    end
end

function expandPlate.select(self)
    self.SelectionBox.Transparency = 0
    self.SelectionBox.SurfaceTransparency = .5
end

function expandPlate.unselect(self)
    self.SelectionBox.Transparency = 1
    self.SelectionBox.SurfaceTransparency = 1
end

function expandPlate.destroy(self)
    if self.Part then
        self.Part:Destroy()
    end
end

function expandPlate.claim(self, cost)
    local cash = playerUtils:getPlayer().leaderstats.Cash.Value
    cost = cost or rf_GetPlatePrice:InvokeServer()
    if cost <= cash then
        re_ExpandProperty:FireServer(self.Plate)
        self.Plate:GetPropertyChangedSignal("Transparency"):Wait()
        self.Part:Destroy()
    end
end

return expandPlate