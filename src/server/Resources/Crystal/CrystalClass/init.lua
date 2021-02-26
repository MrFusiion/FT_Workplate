local DS = game:GetService('Debris')

local shared = require(game:GetService('ReplicatedStorage'):WaitForChild('modules'))
local random = shared.get('random').new()

local conecheckIgnoreList = { workspace:WaitForChild('Regions') }

local shapes = game:GetService('ReplicatedStorage'):WaitForChild('Crystals')

local crystalClass = {}
crystalClass.__index = crystalClass

--===========================================================================================--
--======================================/ ParticeClass /======================================--

crystalClass.particle = {}
crystalClass.particle.mt = {}
crystalClass.particle.mt.__index = crystalClass.particle.mt

function crystalClass.particle.new(type, props)
	local newParticle = setmetatable({}, crystalClass.particle.mt)
	newParticle.Type = type
	newParticle.Props = props
	return newParticle
end

function crystalClass.particle.mt:new()
	local particle = Instance.new(self.Type)
	for propName, propValue in pairs(self.Props) do
		particle[propName] = propValue
	end
	return particle
end

--===========================================================================================--
--======================================/ Constructor /======================================--

function crystalClass.new(ParentModel : Model)
    local newCrystal = {}
    newCrystal.ParentModel = ParentModel

	newCrystal.GrowCalls = 0
    newCrystal.FinishedGrowing = false
	newCrystal.Stage = "Growing"

	return newCrystal
end

--=========================================================================================--
--====================================/ Grow Clocking /====================================--

function crystalClass:growCheck(timePassed : float, acceratedGrowth : boolean)
	self.TimeToNextGrow -= timePassed
	if self.TimeToNextGrow <= 0 and not self.FinishedGrowing then
		self:grow()
		self.TimeToNextGrow = random:nextRange(self.GrowInterval)
	elseif self.FinishedGrowing and not acceratedGrowth then
		self:Age(timePassed)
	end
end

--=========================================================================================--
--====================================/ Seed Planting /====================================--

function crystalClass:canPlaceHere(cf : CFrame, otherTrees : table) : boolean
	for _, tree in pairs(otherTrees) do
		if tree.SeedCFrame then
			if (tree.SeedCFrame.Position - cf.Position).Magnitude < self.MinSpawnDistanceToOtherCrystals then
				return false
			end
		end
	end
	return true
end

function crystalClass:place(cf : CFrame, distUp : int)
	self.OriginCFrame = cf
	self.MaxGrowCalls = random:nextRange(self.MaxGrowCalls)

	self.Model = Instance.new('Model')
	self.Model.Name = self.Name
	self.Model.Parent = self.ParentModel

	self.Type = Instance.new("StringValue", self.Model)
	self.Type.Name = "CrystalClass"
	self.Type.Value = self.Name

    self.Onwer = Instance.new('ObjectValue', self.Model)
	self.Onwer.Name = 'Owner'
	local lastInteractionV = Instance.new('IntValue', self.Onwer)
	lastInteractionV.Name = 'LastInteraction'
	
	self.Size = random:nextRange(self.ClusterSize)
	self.TimeToNextGrow = random:nextRange(self.GrowInterval)

	self.ShellPart = shapes[self.Shape]:Clone()
	self.ShellPart.Name = 'CrystalShell'
	self.ShellPart.Anchored = true
	self.ShellPart.Transparency = self.ShellTransparency
	self.ShellPart.BrickColor = self.ShellColor
	self.ShellPart.Material = self.ShellMaterial
	self.ShellPart.Size = Vector3.new(1, 1, 1) * self.Size
	self.ShellPart.CFrame = self.OriginCFrame * CFrame.new(0, self.Size*(.5 + self.Offset), 0)
	self.ShellPart.Parent = self.Model

	self.InnerPart = shapes[self.Shape]:Clone()
	self.InnerPart.Name = 'CrystalInner'
	self.InnerPart.Anchored = true
	self.InnerPart.Transparency = self.InnerTransparency
	self.InnerPart.BrickColor = self.InnerColor
	self.InnerPart.Material = self.InnerMaterial
	self.InnerPart.Size = Vector3.new(1, 1, 1) * (self.Size - self.ShellThickness)
	self.InnerPart.CFrame = self.ShellPart.CFrame
	self.InnerPart.Parent = self.Model

	if self.Light then
		local light = Instance.new('PointLight')
		for propName, propValue in pairs(self.Light) do
			light[propName] = propValue
		end
		light.Parent = self.InnerPart
	end

	if self.Effects then
		for name, effect in pairs(self.Effects) do
			effect:new().Parent = self.ShellPart
		end
	end
end

--===================================================================================--
--====================================/ Cleanup /====================================--

function crystalClass:destroy()
	self.Model:Destroy()
end

function crystalClass:age(timePassed : int)
	if self.Stage == 'Growing' then
		self.TimeUntilDeath = (self.TimeUntilDeath - timePassed) * self:getVolume() / self.FinalVolume
		self.FinalVolume = self:getVolume()
	else
		self.TimeUntilDeath = self.TimeUntilDeath - timePassed
	end

	if self.Stage == 'Growing' then
		if self.TimeUntilDeath <= 0 then
			self.Stage = 'Broken Up'
			self.TimeUntilDeath = 0

            self.Owner:Destroy()

			self.InnerPart:Destroy()
			for _, effect in ipairs(self.ShellPart:GetChildren()) do
				effect:Destroy()
			end

			self.ShellPart.BrickColor = BrickColor.new('Black')
			self.ShellPart.Anchored = false
			DS:AddItem(self.ShellPart, 10)
        end
	elseif self.Stage == 'Broken Up' then
		if self.TimeUntilDeath < -10 then
			self.Stage = 'Dead'
		end
	elseif self.Stage == 'Dead' then
		if self.TimeUntilDeath < -15 then
			self:destroy()
		end
	end
end

--===========================================================================================--
--====================================/ Segment Growing /====================================--

local MIN_REQUIRED_LENGTH_FOR_SPLITTING = .025
function crystalClass:grow(timePassed : int)
    if self.FinishedGrowing then return end

    self.GrowCalls += 1

	if self:coneCheck(self.OriginCFrame * CFrame.new(0, self.Size, 0)) then
		local lengthGrow = random:nextRange(self.SizeGrow)
		self.Size += lengthGrow
	end

	self.ShellPart.Size = Vector3.new(1, 1, 1) * self.Size
	self.ShellPart.CFrame = self.OriginCFrame * CFrame.new(0, self.Size*(.5 + self.Offset), 0)
	self.InnerPart.Size = Vector3.new(1, 1, 1) * (self.Size - self.ShellThickness)
	self.InnerPart.CFrame = self.ShellPart.CFrame

    if self.GrowCalls > self.MaxGrowCalls then
		self.FinishedGrowing = true
		self.FinalVolume = self:getVolume()
		self.TimeUntilDeath = self.FinalVolume * self.LifetimePerVolume
	end
end

function crystalClass:getVolume() : int
	return self.Size^3
end

local numThetaChecks = 6
local numRhoChecks = 3
function crystalClass:coneCheck(cf : any) : boolean
	local ignoreList = { self.Model }

	for _, ignoreItem in ipairs(conecheckIgnoreList) do
		table.insert(ignoreList, ignoreItem)
	end

	for _, player in pairs(game.Players:GetPlayers()) do
		table.insert(ignoreList, player.Character)
	end

	local checkCFrame = cf
	for rho=math.rad(self.SpaceCheckCone.angle)/numRhoChecks, math.rad(self.SpaceCheckCone.angle), math.rad(self.SpaceCheckCone.angle)/numRhoChecks do
		for theta=math.pi*2/numThetaChecks, math.pi*2, math.pi*2/numThetaChecks do
			local unit=(checkCFrame * CFrame.Angles(0, theta, rho) * CFrame.Angles(math.pi/2,0,0) * CFrame.new(0, 1, 0)).LookVector

			local rayParams = RaycastParams.new()
			rayParams.FilterDescendantsInstances = ignoreList
			rayParams.FilterType = Enum.RaycastFilterType.Blacklist

			if workspace:Raycast(checkCFrame.Position, unit * self.SpaceCheckCone.dist, rayParams) then
				self.FinishedGrowing = true
				self.FinalVolume = self:getVolume()
				self.TimeUntilDeath = self.FinalVolume * self.LifetimePerVolume
				return false
			end
		end
	end
	return true
end

return crystalClass