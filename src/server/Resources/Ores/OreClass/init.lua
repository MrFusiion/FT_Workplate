local DS = game:GetService("Debris")
local PS = game:GetService("PhysicsService")

local shared = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"))
local random = shared.get("random")

local conecheckIgnoreList = { workspace:WaitForChild("Regions") }

local vacuumLock = require(script.Parent.Parent.vacuumLock)

local oreClass = {}
oreClass.Class = "Ore"
oreClass.__index = oreClass

local function newPart(model)
	local part = Instance.new("Part")

	part.Anchored = true

	part:SetAttribute("Resource", true)
	part:SetAttribute("Owner", 0)
	part:SetAttribute("LastInteraction", 0)

	local modelValue = Instance.new("ObjectValue")
	modelValue.Name = "Model"
	modelValue.Value = model
	modelValue.Parent = part

	PS:SetPartCollisionGroup(part, "Resource")

	return part
end

--===========================================================================================--
--======================================/ ParticeClass /======================================--

oreClass.particle = {}
oreClass.particle.mt = {}
oreClass.particle.mt.__index = oreClass.particle.mt

function oreClass.particle.new(type, props)
	local newParticle = setmetatable({}, oreClass.particle.mt)
	newParticle.Type = type
	newParticle.Props = props
	return newParticle
end

function oreClass.particle.mt:new()
	local particle = Instance.new(self.Type)
	for propName, propValue in pairs(self.Props) do
		particle[propName] = propValue
	end
	return particle
end

--===========================================================================================--
--======================================/ Constructor /======================================--

function oreClass.new(ParentModel : Model)
    local newOre = {}
    newOre.ParentModel = ParentModel

	newOre.Sections = {}
	newOre.Locked = false

	newOre.GrowCalls = 0
    newOre.FinishedGrowing = false
	newOre.Stage = "Growing"

	return newOre
end

--=========================================================================================--
--====================================/ Grow Clocking /====================================--

function oreClass:growCheck(timePassed : float, acceratedGrowth : boolean)
	if self.VacuumLock.Locked then return end
	self.TimeToNextGrow -= timePassed
	if self.TimeToNextGrow <= 0 and not self.FinishedGrowing then
		self:grow()
		self.TimeToNextGrow = random:nextRange(self.GrowInterval)
	elseif self.FinishedGrowing and not acceratedGrowth then
		self:age(timePassed)
	end
end

--=========================================================================================--
--====================================/ Seed Planting /====================================--

function oreClass:place(cf : CFrame)
	self.OriginCFrame = cf
	self.MaxGrowCalls = random:nextRange(self.MaxGrowCalls)

	self.Model = Instance.new("Model")
	self.Model.Name = self.Name
	self.Model:SetAttribute("Resource", true)
	self.Model.Parent = self.ParentModel

	self.VacuumLock = vacuumLock.new(self)

	self.TimeToNextGrow = random:nextRange(self.GrowInterval)
	
	for _=1, random:nextRangeInt(self.SectionCount) do
		self:newSection(self.OriginCFrame)
	end
end

--===================================================================================--
--====================================/ Cleanup /====================================--

function oreClass:destroy()
	self.Model:Destroy()
end

function oreClass:age(timePassed : int)
	if self.Stage == "Growing" then
		self.Stage = "Grown"
	end

	if self.Stage == "Grown" then
		self.TimeUntilDeath -= timePassed
	else
		self.TimeUntilDeath -= timePassed
	end

	if self.Stage == "Grown" then
		if self.TimeUntilDeath <= 0 then
			self.Stage = "Broken Up"
			self.TimeUntilDeath = 0
			self:kill()
        end
	elseif self.Stage == "Broken Up" then
		if self.TimeUntilDeath < -10 then
			self.Stage = "Dead"
		end
	end
end

--===========================================================================================--
--====================================/ Segment Growing /====================================--

local MIN_REQUIRED_LENGTH_FOR_SPLITTING = .025
function oreClass:grow(timePassed : int)
    if self.FinishedGrowing then return end

    self.GrowCalls += 1

	for _, section in pairs(self.Sections) do
		section.Size = section.Size + Vector3.new(
			random:nextRange(self.SizeGrow),
			random:nextRange(self.SizeGrow),
			random:nextRange(self.SizeGrow)
		)

		section.Part.Size = section.Size
		section.Part.CFrame = section.StartCFrame * CFrame.new(0, section.Size.Y*.5, 0) * section.Angle * CFrame.new(section.Size * section.Offset)
	end

    if self.GrowCalls > self.MaxGrowCalls then
		self.FinishedGrowing = true
		self.FinalVolume = self:getVolume()
		self.TimeUntilDeath = self.FinalVolume * self.LifetimePerVolume
		self.Stage = "Grown"
	end
end

function oreClass:getVolume() : int
	local volume = 0
	for _, section in pairs(self.Sections) do
		volume += section.Size.X * section.Size.Y * section.Size.Z
	end
	return volume
end

--============================================================================================--
--====================================/ Segment Creation /====================================--

function oreClass:newSection(cf : CFrame)
	local section = {}
	section.Part = newPart(self.Model)
	section.Part.Name = "Section"

	if self.Effects then
		for name, effect in pairs(self.Effects) do
			effect:new().Parent = section.Part
		end
	end

	if typeof(self.OreColor) == "function" then
		self:OreColor(section.Part)
	else
		section.Part.BrickColor = self.OreColor
	end

	if typeof(self.OreMaterial) == "function" then
		self:OreMaterial(section.Part)
	else
		section.Part.Material = self.OreMaterial
	end

	section.Offset = Vector3.new(
		random:nextRange(self.SectionOffset),
		0,
		random:nextRange(self.SectionOffset)
	)

	section.Size = Vector3.new(
		random:nextRange(self.SectionSize),
		random:nextRange(self.SectionSize),
		random:nextRange(self.SectionSize)
	)

	local phi = random:nextRange(self.SectionPhi)
	local theta = random:nextRange(self.SectionTheta)
	section.Angle = CFrame.Angles(0, theta, phi) * CFrame.Angles(0, -theta, 0)

	section.StartCFrame = cf
	section.Part.Size = section.Size
	section.Part.CFrame = section.StartCFrame * CFrame.new(0, section.Size.Y*.5, 0) * section.Angle * CFrame.new(section.Size * section.Offset)
	section.Part.Parent = self.Model

	section.ID = #self.Sections + 1

	local idValue = Instance.new("IntValue", section.Part)
	idValue.Name = "ID"
	idValue.Value = section.ID

	self.Sections[#self.Sections + 1] = section
end

function oreClass:kill()
	spawn(function()
		for _, section in pairs(self.Sections) do
			for _, effect in pairs(section.Part:GetChildren()) do
				effect:Destroy()
			end
			section.Part.Material = "SmoothPlastic"
			section.Part.BrickColor = BrickColor.new("Black")
			section.Part.Anchored = false

			DS:AddItem(section.Part, 15)
		end

		wait(10)

		for _, section in pairs(self.Sections) do
			section.Part.CanCollide = false
		end

		wait(5)

		self:destroy()
	end)
end

return oreClass