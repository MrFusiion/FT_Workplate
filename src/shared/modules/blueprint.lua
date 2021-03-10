local PS = game:GetService("PhysicsService")

local client = require(game:GetService("StarterPlayer").StarterPlayerScripts.Modules)
local input = client.get("input")

--=====================================/Config/=====================================--
local PositionGridSize = .5
local ScaleGridSize = 1
local handleColor = Color3.new(1, 0.768627, 0)
--=====================================/Config/=====================================--

--====================================/Utility====================================--
local function Hit(part)
    local player = game:GetService("Players").LocalPlayer
    local mouse = player:GetMouse()
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = { part, player.Character }
    params.FilterType = Enum.RaycastFilterType.Blacklist

    local unit = mouse.UnitRay
    local result = workspace:Raycast(unit.Origin, unit.Direction * 1000, params)
    if result then
        return result.Instance, result.Normal, result.Position
    else
        return nil, nil, unit.Origin + unit.Direction * 10
    end
end

local function vector3SnapToGrid(vector, gridSize)
    return Vector3.new(
        math.floor(vector.X / gridSize),
        math.floor(vector.Y / gridSize),
        math.floor(vector.Z / gridSize)
    ) * gridSize
end

local function vector3Clamp(vector, min, max)
    min = typeof(min) == "number" and Vector3.new(1, 1, 1) * min or min
    max = typeof(max) == "number" and Vector3.new(1, 1, 1) * max or max
    return Vector3.new(
        math.min(max.X, math.max(vector.X, min.X)),
        math.min(max.Y, math.max(vector.Y, min.Y)),
        math.min(max.Z, math.max(vector.Z, min.Z))
    )
end

local function vector3Abs(vector)
    return Vector3.new(
        math.abs(vector.X),
        math.abs(vector.Y),
        math.abs(vector.Z)
    )
end
--====================================/Utility====================================--

local blueprint = {}
blueprint.mt = {}
blueprint.mt.__index = blueprint.mt
blueprint.Blueprints = {}

function blueprint.new(data)
    local newBlueprint = setmetatable({}, blueprint.mt)
    newBlueprint.__index = newBlueprint

    for key, value in pairs(data) do
        newBlueprint[key] = value
    end

    newBlueprint.PositionGridSize = PositionGridSize
    newBlueprint.ScaleGridSize = ScaleGridSize

    return newBlueprint
end

local folder = game:GetService("ReplicatedStorage"):WaitForChild("BlueprintStructures")
for _, catogory in ipairs(folder:GetChildren()) do
    for _, item in ipairs(catogory:GetChildren()) do
        local model = item:FindFirstChildWhichIsA("Model")
        if model then
            blueprint.Blueprints[item.Name] = blueprint.new{
                Name = item.Name,
                Image = item:FindFirstChild("Image") and item.Image.Value or "",
                MaxVolume = item:FindFirstChild("MaxVolume") and item.MaxVolume.Value or 16*16*16,
                MaxAxisSize = item:FindFirstChild("MaxAxisSize") and item.MaxAxisSize.Value or Vector3.new(1, 1, 1) * 16,
                Scalable = item:FindFirstChild("Scalable") and item.Scalable.Value or false,
                Model = model
            }
        else
            warn(string.format("Folder with name: %s could not be created into blueprint!", item.Name))
        end
    end
end

--=====================================/MetaTable/=====================================--
function blueprint.mt:new()
    local newInstance = setmetatable({}, self)

    newInstance.Model = self.Model:Clone()
    for _, descendant in ipairs(newInstance.Model:GetDescendants()) do
        if descendant:IsA("BasePart") and descendant ~= newInstance.PrimaryPart
            and descendant.Transparency ~= 1 then
            descendant.Transparency = .5
            descendant.CanCollide = false
            descendant.Anchored = true
            descendant.BrickColor = BrickColor.Black()
            descendant.Material = "SmoothPlastic"
        end
    end
    newInstance.Model.Parent = workspace

    newInstance.Box = Instance.new("SelectionBox")
    newInstance.Box.Color3 = handleColor
    newInstance.Box.LineThickness = .001
    newInstance.Box.Adornee = newInstance.Model.PrimaryPart
    newInstance.Box.Parent = newInstance.Model.PrimaryPart

    newInstance.Rotation = CFrame.new()

    return newInstance
end

function blueprint.mt:setupInput()
    input.bindPriority("BlueprintPlace", input.beginWrapper(function()
        self:confirmPlace()
        self:startSizing()

        input.bindPriority("BlueprintPlace", input.beginWrapper(function()
            input.safeUnbind("BlueprintPlace", "BlueprintCancel")
            self:confirmSize()
        end), false, 3000, Enum.KeyCode.E, Enum.KeyCode.ButtonX)

    end), false, 3000, Enum.KeyCode.E, Enum.KeyCode.ButtonX)

    input.bindPriority("BlueprintRotate", input.beginWrapper(function()
        self:rotate(90)
    end), false, 3000, Enum.KeyCode.R, Enum.KeyCode.DPadRight)

    input.bindPriority("BlueprintTurn", input.beginWrapper(function()
        self:turn(90)
    end), false, 3000, Enum.KeyCode.T, Enum.KeyCode.DPadUp)

    input.bindPriority("BlueprintCancel", input.beginWrapper(function()
        input.safeUnbind("BlueprintPlace", "BlueprintCancel")
        self:destroy()
    end), false, 3000, Enum.KeyCode.B, Enum.KeyCode.ButtonB)
end

function blueprint.mt:startPlacement()
    self:setupInput()

    self.PlaceConnection = game:GetService("RunService").Heartbeat:Connect(function()
        local intance, normal, pos = Hit(self.Model)
        normal = normal or Vector3.new()

        local cf = CFrame.new(vector3SnapToGrid(pos, self.PositionGridSize)) * self.Rotation
        self.Model:SetPrimaryPartCFrame(cf + normal * vector3Abs(cf:VectorToWorldSpace(self.Model.PrimaryPart.Size)) * .5)
    end)
end

function blueprint.mt:startSizing()
    if not self.Scalable then return self:confirmSize() end
    local size, cf
    self.Handles = Instance.new("Handles")
    self.Handles.Color3 = handleColor
    self.Handles.Transparency = .5
    self.Handles.Adornee = self.Model.PrimaryPart
    self.Handles.Parent = game:GetService("Players").LocalPlayer
        .PlayerGui:WaitForChild("Handles")

    self.Handles.MouseDrag:Connect(function(normalId, dist)
        if not size and not cf then
            size = self.Model.PrimaryPart.Size
            cf = self.Model:GetPrimaryPartCFrame()
        end

        local addSize = vector3SnapToGrid(vector3Abs(Vector3.fromNormalId(normalId)) * dist, self.ScaleGridSize)

        local newSize = vector3Clamp(size + addSize, 1, self.MaxAxisSize)

        if (newSize.X*newSize.Y*newSize.Z) <= self.MaxVolume then--TODO when exceeding limit extend axis to maximum
            for _, part in ipairs(self.Model:GetChildren()) do
                local mesh = part:FindFirstChildWhichIsA("SpecialMesh")
                if mesh then
                    mesh.Scale = newSize
                else
                    part.Size = newSize
                end
            end
            self.Model:SetPrimaryPartCFrame(CFrame.new(cf * (Vector3.fromNormalId(normalId) * (newSize - size) * .5)) * self.Rotation)
        end
    end)

    self.Handles.MouseButton1Up:Connect(function()
        size, cf = nil, nil
    end)
end

function blueprint.mt:confirmPlace()
    self.PlaceConnection:Disconnect()
    input.safeUnbind("BlueprintPlace", "BlueprintRotate", "BlueprintTurn")
end

function blueprint.mt:confirmSize()
    if self.Handles then
        self.Handles:Destroy()
    end
    self.Box:Destroy()
    input.safeUnbind("BlueprintPlace", "BlueprintRotate", "BlueprintTurn", "BlueprintCancel")
end

function blueprint.mt:destroy()
    self.Model:Destroy()
    if self.Handles then
        self.Handles:Destroy()
    end
    if self.PlaceConnection then
        self.PlaceConnection:Disconnect()
    end
    input.safeUnbind("BlueprintPlace", "BlueprintRotate", "BlueprintTurn", "BlueprintCancel")
end

function blueprint.mt:rotate(degrees)
    self.Rotation *= CFrame.Angles(0, math.rad(degrees), 0)
end

function blueprint.mt:turn(degrees)
    self.Rotation *= CFrame.Angles(0, 0, math.rad(degrees))
end

return blueprint