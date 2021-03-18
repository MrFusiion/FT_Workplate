local CS = game:GetService("CollectionService")
local TS = game:GetService("TweenService")

local TWEEN_INFO_OPEN = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
local TWEEN_INFO_CLOSE = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

local REGION_CHECK_INTERVAL = .5
local SOUND_ID = "rbxassetid://4637847785"

local garageDoor = {}
garageDoor.__index = garageDoor

local function createBodyGyro()
    local gyro = Instance.new("BodyGyro")
    gyro.D = 1000
    gyro.MaxTorque = Vector3.new(1, 1, 1) * math.huge
    gyro.P = 5000
    return gyro
end

local function createSound(soundID)
    local sound = Instance.new("Sound")
    sound.SoundId = soundID
    sound.Volume = .4
    return sound
end

local function createWeld(part0, part1)
    local weld = Instance.new("Weld")
    weld.Part0 = part0
    weld.Part1 = part1
    weld.C0 = part0.CFrame:Inverse()
    weld.C1 = part1.CFrame:Inverse()
    return weld
end

local function weldModel(model)
    for _, descendant in ipairs(model:GetDescendants()) do
        if descendant:IsA("BasePart") and descendant ~= model.PrimaryPart then
            createWeld(descendant, model.PrimaryPart).Parent = descendant
        end
    end
    return model
end

function garageDoor.new(model, playerAllowed)
    local newGarageDoor = setmetatable({}, garageDoor)

    newGarageDoor.Model = model
    newGarageDoor.Door = weldModel(model.Door)
    newGarageDoor.OriginCFrame = newGarageDoor.Door.PrimaryPart.CFrame
    createBodyGyro().Parent = newGarageDoor.Door.PrimaryPart
    createSound(SOUND_ID).Parent = newGarageDoor.Door.PrimaryPart

    local pos = model.Trigger.Position
    local halfSize = model.Trigger.Size * .5
    newGarageDoor.Region = Region3.new(pos - halfSize, pos + halfSize)
    model.Trigger:Destroy()

    newGarageDoor.Door.PrimaryPart.Locked = not newGarageDoor.Door.PrimaryPart.Locked--Physics unsleep
    newGarageDoor.Door.PrimaryPart.Locked = not newGarageDoor.Door.PrimaryPart.Locked--Physics unsleep

    --[[+++++++++[DEBUG]+++++++++--
    local part = Instance.new("Part")
    part.Anchored = true
    part.Transparency = .7
    part.BrickColor = BrickColor.Red()
    part.CanCollide = false
    part.Size = newGarageDoor.Region.Size
    part.CFrame = newGarageDoor.Region.CFrame
    part.Parent = workspace
    --+++++++++[DEBUG]+++++++++--]]

    spawn(function()
        while wait(REGION_CHECK_INTERVAL) do
            local players = playerAllowed and CS:GetTagged("Player") or {}
            local cars = CS:GetTagged("Car")

            local player = workspace:FindPartsInRegion3WithWhiteList(newGarageDoor.Region, players, 1)
            local car = not next(player) and workspace:FindPartsInRegion3WithWhiteList(newGarageDoor.Region, cars, 1)

            if next(player or {}) or next(car or {}) then
                newGarageDoor:open()
            else
                newGarageDoor:close()
            end
        end
    end)

    return newGarageDoor
end

function garageDoor:canOpen()
    return true
end

function garageDoor:carClose()
    return true
end

function garageDoor:open()
    if not self.Open and self:canOpen() then
        --self.Door.PrimaryPart.Sound:Play()
        self.Door.PrimaryPart.BodyGyro.CFrame = self.OriginCFrame * CFrame.Angles(0, 0, math.rad(-85))
        --self.Door.PrimaryPart.Locked = not self.Door.PrimaryPart.Locked--Physics unsleep
        self.Open = true
    end
end

function garageDoor:close()
    if self.Open and self:carClose() then
        --self.Door.PrimaryPart.Sound:Play()
        self.Door.PrimaryPart.BodyGyro.CFrame = self.OriginCFrame * CFrame.Angles(0, 0, 0)
        --self.Door.PrimaryPart.Locked = not self.Door.PrimaryPart.Locked--Physics unsleep
        self.Open = false
    end
end

return garageDoor