local shared = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"))
local tableUtils = shared.get("tableUtils")

local resourceFolder = game.ServerScriptService.Resources
local treeFolder = resourceFolder.Trees.subclasses
local crystalFolder = resourceFolder.Crystals.subclasses
local oreFolder = resourceFolder.Ores.subclasses

local content = {}
content.__index = content

local function getResourceData(name)
    local resource
    for _, folder in ipairs{ treeFolder, crystalFolder, oreFolder } do
        resource = folder:FindFirstChild(name)
        if resource then break end
    end
    if resource then
        local data = require(resource)
        return {
            material = data.BarkMaterial or data.InnerMaterial or data.OreMaterial,
            color = data.BarkColor or data.InnerColor or data.OreColor
        }
    end
end

local function weldParts(part0, part1)
    local weld = Instance.new("Weld")
    weld.Part0 = part0
    weld.Part1 = part1
    weld.C0 = part0.CFrame:Inverse()
    weld.C1 = part1.CFrame:Inverse()
    return weld
end

function content.new(contentPart, maxVolume)
    local newContent = setmetatable({}, content)
    newContent.ContentPart = contentPart
    newContent.Sections = {}
    newContent.MaxVolume = maxVolume
    newContent.Volume = 0
    return newContent
end

function content:render()
    local cf = self.ContentPart.CFrame + -self.ContentPart.CFrame.UpVector * self.ContentPart.Size.Y * .5
    for _, section in pairs(self.Sections) do
        section.Part.Parent = nil

        if section.Weld then
            section.Weld:Destroy()
        end

        section.Part.Size = Vector3.new(self.ContentPart.Size.X, self.ContentPart.Size.Y * (section.Value / self.MaxVolume), self.ContentPart.Size.Z)
        section.Part.CFrame = cf + cf.UpVector * section.Part.Size.Y * .5

        cf = cf + cf.UpVector * section.Part.Size.Y

        section.Weld = weldParts(section.Part, self.ContentPart)
        section.Weld.Parent = section.Part

        section.Part.Parent = self.ContentPart
    end
end

function content:newSection(name, value)
    local data = getResourceData(name)
    if data then
        local section = {}

        section.Value = value or 0

        section.Part = Instance.new("Part")
        section.Part.Massless = true
        section.Part.CanCollide = false

        if typeof(data.material) == "function" then
            data.material(section.Part)
        else
            section.Part.Material = data.material
        end

        if typeof(data.color) == "function" then
            data.color(section.Part)
        else
            section.Part.BrickColor = data.color
        end

        self.Volume += value

        return section
    end
end

function content:addResource(name, value)
    value = math.min(self.MaxVolume - self.Volume, value)
    if value > 0 then
        if self.Sections[name] then
            self.Sections[name].Value += value
            self.Volume += value
        else
            self.Sections[name] = self:newSection(name, value)
        end
    end
end

function content:export()
    local data = {}
    for name, section in pairs(self.Sections) do
        data[name] = section.Value
    end
    return data
end

function content:import(data)
    for name, value in pairs(data) do
        self:addResource(name, value)
    end
end

function content:destroy()
    for _, section in pairs(self.Sections) do
        section.Part:Destroy()
    end
end

return content