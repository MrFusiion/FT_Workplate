local DS = game:GetService('Debris')

local shared = require(game:GetService('ReplicatedStorage'):WaitForChild('modules'))
local random = shared.get('random').new()
local attributes = shared.get('attributes')

local conecheckIgnoreList = { workspace:WaitForChild('Regions') }

local treeClass = {}
treeClass.__index = treeClass
treeClass.DefaultLeafClass = require(script.leaves)

--===========================================================================================--
--======================================/ Constructor /======================================--

function treeClass.new(ParentModel : Model, BranchParentTree : treeClass) : treeClass
    local newTree = {}

	newTree.IsABranch = not not BranchParentTree
	newTree.BranchParentTree = BranchParentTree
    newTree.ParentModel = ParentModel

	newTree.Sections = {}
	--newTree.Cuts = {}
	newTree.Branches = {}

	newTree.GrowCalls = 0
	newTree.FinishedGrowing = false
	newTree.Stage = "Growing"

    return newTree
end
--=========================================================================================--
--====================================/ Grow Clocking /====================================--

function treeClass:growCheck(timePassed : float, acceratedGrowth : boolean)
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

function treeClass:canPlaceHere(cf : CFrame, otherTrees : table) : boolean
	for _, tree in pairs(otherTrees) do
		if tree.SeedCFrame then
			if (tree.SeedCFrame.Position - cf.Position).Magnitude < self.MinSpawnDistanceToOtherTrees then
				return false
			end
		end
	end
	return true
end

function treeClass:place(cf : CFrame, distUp : int)
	if not self.IsABranch then--then its a trunk
		cf *= CFrame.Angles(0, math.rad(random:nextRange(self.TrunkAngleTheta)), math.rad(random:nextRange(self.TrunkAnglePhi)))
	end

	self.SeedCFrame = cf
	self.MaxGrowCalls = random:nextRange(self.MaxGrowCalls)

	self.Model = Instance.new('Model')
	self.Model.Name = self.Name
	self.Model.Parent = self.ParentModel

	self.LeafModel = Instance.new('Model')
	self.LeafModel.Name = 'Leaves'
	self.LeafModel.Parent = self.Model

	self.Type = Instance.new("StringValue", self.Model)
	self.Type.Name = "TreeClass"
	self.Type.Value = self.Name

	self:newSection(cf, 'Seed', distUp)
	self.TimeToNextGrow = random:nextRange(self.GrowInterval)

	if not self.BranchParentTree then
		self.Onwer = Instance.new('ObjectValue', self.Model)
		self.Onwer.Name = 'Owner'
		local lastInteractionV = Instance.new('IntValue', self.Onwer)
		lastInteractionV.Name = 'LastInteraction'

		--TODO Tree owner ship mannager script
	else
		self.Onwer = self.BranchParentTree.Onwer
	end
end

--===================================================================================--
--====================================/ Cleanup /====================================--

function treeClass:destroy()
	self.Model:Destroy()
end

function treeClass:age(timePassed : int)
	if self.Stage == 'Growing' or self.Stage == 'Leaves Fallen' then
		self.TimeUntilDeath = (self.TimeUntilDeath - timePassed) * self:getVolume() / self.FinalVolume
		self.FinalVolume = self:getVolume()
	else
		self.TimeUntilDeath = self.TimeUntilDeath - timePassed
	end
	
	if self.Stage == 'Growing' then
		if self.TimeUntilDeath < self.LeafDropTime then
			self.Stage = 'Leaves Fallen'
			local existingSections = #self.Sections
			for ID = 1, existingSections do
				local section = self.Sections[ID]
				if section and section.LeafBunch then
					for _, leaf in pairs(section.LeafBunch) do
						leaf.Part.Anchored = false
					end
				end
			end
		end
	elseif self.Stage == 'Leaves Fallen' then
		if self.TimeUntilDeath <= 0 then
			self.Stage = 'Broken Up'
			self.TimeUntilDeath = 0

			--BACKself.CutEvent:Destroy()
			--BACKself.Type:Destroy()
			self.Owner:Destroy()

			local existingSections = #self.Sections
			for ID = 1, existingSections do
				local section = self.Sections[ID]
				if section and section.Part then
					section.Part.BrickColor = BrickColor.new('Black')
					section.Part.Anchored = false
					if section.TopInner then--BACK
						section.TopInner = section.TopInner:Destroy()
					end
					DS:AddItem(section.Part, 10)
				end
			end
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
function treeClass:grow(timePassed : int)
	if self.FinishedGrowing then return end

	self.GrowCalls += 1

	local foundGrowingSection = false
	local existingSections = #self.Sections
	for ID = 1, existingSections do
		local section = self.Sections[ID]
		if section and section.IsGrowing then
			foundGrowingSection = true

			local stopForBranches = self.MaxGrowCalls - self.GrowCalls < self.NewBranchCutoff and self.BranchClasses
			if section.IsExtremety and not stopForBranches and self:coneCheck(section) then
				local lengthGrow = random:nextRange(self.LengthGrow)

				section.Length += lengthGrow
				section.DistanceToBend -= lengthGrow
				section.DistanceToSplit -= lengthGrow
				section.DistanceToBranch -= lengthGrow
				
				if self.Name == 'Mushroom' then
					print(section.DistanceToBend, section.Length)
				end

				if section.DistanceToSplit <= 0 and section.Length > MIN_REQUIRED_LENGTH_FOR_SPLITTING then
					self.Sections[ID].IsExtremety = false
					self:split(section, 'Split', section.Length, self.NumSplits, self.SplitAngle, self.SplitUnitYComponentConstraints, self.AllowableAngleBetweenSplits)
				elseif section.DistanceToBend <= 0 and section.Length > MIN_REQUIRED_LENGTH_FOR_SPLITTING then
					self.Sections[ID].IsExtremety = false
					self:split(section, 'Bend', section.Length, { min=1, max=1 }, self.BendAngle, self.BendUnitYComponentConstraints, { min=0, max=180 })
				elseif section.DistanceToBranch <= 0 and self.BranchClasses then
					section.DistanceToBranch = random:nextRange(self.DistanceBetweenBranching)--BACK
					self:split(section, 'Branch', section.Length, self.NumBranches, self.BranchAngle, self.BranchUnitYComponentConstraints, self.AllowableAngleBetweenBranches)
				end
			end

			section.Thickness += random:nextRange(self.ThicknessGrow)
			section.Part.Size = Vector3.new(section.Thickness, section.Length, section.Thickness)
			section.Part.CFrame = section.StartCFrame * CFrame.new(0, section.Length * .5, 0)

			self:updateLeaves(section)
		end
	end

	if self.GrowCalls > self.MaxGrowCalls or not foundGrowingSection then
		self.FinishedGrowing = true
		self.FinalVolume = self:getVolume()
		self.TimeUntilDeath = self.FinalVolume * self.LifetimePerVolume
	end

	for i, branch in pairs(self.Branches) do
		branch.branch:grow(timePassed)
		if not branch.branch.Model.Parent then
			self.Branches[i] = nil
		end
	end
end

function treeClass:getVolume() : int
	local volume = 0
	local existingSections = #self.Sections
	for ID = 1, existingSections do
		local section = self.Sections[ID]
		if section and section.Part then
			volume += section.Part.Size.X * section.Part.Size.Y * section.Part.Size.Z
		end
	end

	for i, branch in pairs(self.Branches) do
		volume += branch.branch:getVolume()
	end

	return volume
end

local numThetaChecks = 6
local numRhoChecks = 3
function treeClass:coneCheck(sectionOrCFrame : any) : boolean
	local ignoreList = { self.LeafModel, self.Model }

	for _, ignoreItem in ipairs(conecheckIgnoreList) do
		table.insert(ignoreList, ignoreItem)
	end

	for _, player in pairs(game.Players:GetPlayers()) do
		table.insert(ignoreList, player.Character)
	end

	if typeof(sectionOrCFrame) == 'table' and self.Sections[sectionOrCFrame.ParentId] then
		table.insert(ignoreList, self.Sections[sectionOrCFrame.ParentId].Part)
		for _, childId in pairs(self.Sections[sectionOrCFrame.ParentId].ChildrenSections) do
			table.insert(ignoreList, self.Sections[childId].Part)
		end
	end

	local checkCFrame = typeof(sectionOrCFrame) == 'CFrame' and sectionOrCFrame or sectionOrCFrame.StartCFrame * CFrame.new(0, sectionOrCFrame.Length, 0)
	for rho=math.rad(self.SpaceCheckCone.angle)/numRhoChecks, math.rad(self.SpaceCheckCone.angle), math.rad(self.SpaceCheckCone.angle)/numRhoChecks do
		for theta=math.pi*2/numThetaChecks, math.pi*2, math.pi*2/numThetaChecks do
			local unit=(checkCFrame * CFrame.Angles(0, theta, rho) * CFrame.Angles(math.pi/2,0,0) * CFrame.new(0, 1, 0)).LookVector

			local rayParams = RaycastParams.new()
			rayParams.FilterDescendantsInstances = ignoreList
			rayParams.FilterType = Enum.RaycastFilterType.Blacklist

			if workspace:Raycast(checkCFrame.Position, unit * self.SpaceCheckCone.dist, rayParams) then
				if typeof(sectionOrCFrame) == 'table' then
					sectionOrCFrame.IsGrowing = false
					if sectionOrCFrame.ID == 1 then
						self:destroy()
					end
					return false
				end
			end
		end
	end
	return true
end

--=========================================================================================--
--======================================/ Splitting /======================================--

function treeClass:split(parentBranch : section, type : string, distUp : int, numSplits : table, splitAngle : table, unitYComponentConstraints : table, allowableAngleBetweenSplits : table)
	local diff1 = self.MaxGrowCalls - self.GrowCalls
	local diff2 = self.BranchParentTree and self.BranchParentTree.MaxGrowCalls - self.BranchParentTree.GrowCalls or self.NewBranchCutoff
	if diff1 < self.NewBranchCutoff or diff2 < self.NewBranchCutoff then
		return
	end

	numSplits = random:nextRangeInt(numSplits)

	local splitDistBounds = { min=math.sqrt(2 - 2 * math.cos(math.rad(allowableAngleBetweenSplits.min))), max=math.sqrt(2 - 2 * math.cos(math.rad(allowableAngleBetweenSplits.max))) }--Values between 0 and 2

	local newCFrames = {}
	for _=1, self.NumNewSegmentAttempts do
		local splitSuccess = true
		for _=#newCFrames + 1, numSplits do
			local newTheta = random:nextRange({ min=0, max=math.pi*2 })
			local newPhi = math.rad(random:nextRange(splitAngle))
			local angle = CFrame.Angles(0, newTheta, newPhi) * CFrame.Angles(0, -newTheta, 0)
			local resultCFrame = parentBranch.StartCFrame * CFrame.new(0, parentBranch.Length, 0) * angle

			local unit = (resultCFrame * CFrame.Angles(math.pi*.5, 0, 0)).LookVector --Check that section attempts do not violate Y unit vector bounds and do cone check
			if unit.Y > unitYComponentConstraints.max or unit.Y < unitYComponentConstraints.min or not self:coneCheck(resultCFrame) then
				--print("Y violation")
				splitSuccess = false
				break
			end

			local success = true
			for _, cf in ipairs(newCFrames) do--Check that section attempts do not violate bounds for allowable angle between splits
				local dist = ((resultCFrame * CFrame.new(0, 1, 0)).Position - (cf.netCFrame * CFrame.new(0, 1, 0)).Position).Magnitude
				if dist < splitDistBounds.min or dist > splitDistBounds.max then
					newCFrames = {}--Throw out new branch, clean out list and start over
					--print('D violation', 'min: ', splitDistBounds.min, 'max: ', splitDistBounds.max, 'dist: ', dist)
					success = false
					break
				end
			end

			if not success then
				splitSuccess = false
				break
			end

			table.insert(newCFrames, {netCFrame=resultCFrame, angle=angle})
		end

		if splitSuccess then
			break
		end
	end

	local success = #newCFrames > 0 --Success does not necessarily mean the amount of desired branches was reached
	if success then
		for _, cf in ipairs(newCFrames) do
			self:newSection(cf.netCFrame, type, distUp, parentBranch.ID, cf.angle)
		end
		if type ~= 'Branch' then
			self:destroyLeaves(parentBranch)
		end
	elseif not success and type ~= 'Branch' then
		parentBranch.IsGrowing = false
		print('No SplitSuccess')
	end
end

--============================================================================================--
--====================================/ Segment Creation /====================================--

function treeClass:newSection(cf : CFrame, type : string, distUp : int, parentId : int, angle : CFrame)
	local parentSection = self.Sections[parentId]

	if type == 'Branch' then
		local branch = random:choice(self.BranchClasses)
		local newTree = require(branch.class)

		newTree = newTree.new(self.Model, self)
		newTree.SkipTrunkYield = branch.skipTrunkYield

		newTree:place(cf)

		local idValue = Instance.new("IntValue")
		idValue.Name = "ParentTreeSectionId"
		idValue.Value = parentId
		idValue.Parent = newTree.Model

		local angleValue = Instance.new("CFrameValue")
		angleValue.Name = "BranchAngle"
		angleValue.Value = angle
		angleValue.Parent = newTree.Model

		local distValue = Instance.new("NumberValue")
		distValue.Name = "DistUpParentTreeSection"
		distValue.Value = distUp
		distValue.Parent = newTree.Model

		table.insert(self.Branches, { branch=newTree, parentId=parentId })
		return
	end

	local section = {}
	section.Part = Instance.new('Part')
	section.Part.Name = type
	section.Part.Anchored = true

	if typeof(self.BarkColor) == 'function' then
		self:BarkColor(section.Part)
	else
		section.Part.BrickColor = self.BarkColor
	end

	if typeof(self.BarkMaterial) == 'function' then
		self:BarkMaterial(section.Part)
	else
		section.Part.Material = self.BarkMaterial
	end

	section.InnerWoods = {}

	if parentSection then --Came from another branch
		if type == 'Bend' then
			section.Thickness = parentSection.Thickness - random:nextRange(self.BendThicknessReduce)
		elseif type == 'Split' then
			section.Thickness = parentSection.Thickness - random:nextRange(self.SplitThicknessReduce)
		end
		section.AncestryLength = parentSection.Length + parentSection.AncestryLength
	elseif type == 'Seed' then
		section.Thickness = random:nextRange(self.SeedThickness)
		section.AncestryLength = 0
	end
	section.Length = .2

	section.StartCFrame = cf
	section.Part.Size = Vector3.new(section.Thickness, section.Length, section.Thickness)
	section.Part.CFrame = section.StartCFrame * CFrame.new(0, section.Length*.5, 0)
	section.Part.Parent = self.Model

	section.LeafBunch = self:newLeafBunch(section)

	section.IsExtremety = true
	section.IsGrowing = true

	if type == 'Seed' then
		if self.SkipTrunkYield then
			section.DistanceToBend = random:nextRange(self.DistanceBetweenBends)
			section.DistanceToSplit = random:nextRange(self.DistanceBetweenSplits)
			section.DistanceToBranch = random:nextRange(self.DistanceBetweenBranching)
		else
			section.DistanceToBend = random:nextRange(self.TrunkDistanceUntilBending)
			section.DistanceToSplit = random:nextRange(self.TrunkDistanceUntilSpliting)
			section.DistanceToBranch = random:nextRange(self.TrunkDistanceUntilBranching)
		end
	elseif parentSection then
		if type == 'Bend' then
			section.DistanceToBend = random:nextRange(self.DistanceBetweenBends)
			section.DistanceToSplit = parentSection.DistanceToSplit
		elseif type == 'Split' then
			section.DistanceToBend = parentSection.DistanceToBend
			section.DistanceToSplit = random:nextRange(self.DistanceBetweenSplits)
		end
		section.DistanceToBranch = parentSection.DistanceToBranch
	end

	section.ID = #self.Sections + 1
	section.ParentId = parentId

	local idValue = Instance.new("IntValue", section.Part)
	idValue.Name = "ID"
	idValue.Value=section.ID

	local parentValue = Instance.new("IntValue", section.Part)
	parentValue.Name = "ParentID"
	parentValue.Value = parentId

	local childrenValue = Instance.new("IntValue", section.Part)
	childrenValue.Name = "ChildIDs"

	if parentSection then
		table.insert(self.Sections[parentId].ChildrenSections, section.ID)

		local childValue = Instance.new("IntValue", self.Sections[parentId].Part.ChildIDs)
		childValue.Name = "Child"
		childValue.Value = section.ID

		local angleValue = Instance.new("CFrameValue", childValue)
		angleValue.Name = "Angle"
		angleValue.Value = angle
	end
	section.ChildrenSections = {}

	self.Sections[#self.Sections + 1] = section
end

--=============================================================================================--
--======================================/ Leaf Creation /======================================--

function treeClass:newLeafBunch(section)
	local numLeaves = random:nextRangeInt(self.NumLeafParts)

	local leaves = {}
	for i=1, numLeaves do --All the parts that make up a leaf bunch
		local newLeaf = setmetatable({}, self.LeafClass or treeClass.DefaultLeafClass)

		newLeaf.LeafSizeFactor = Vector3.new(
			random:nextRange(self.LeafSizeFactor.X),
			random:nextRange(self.LeafSizeFactor.Y),
			random:nextRange(self.LeafSizeFactor.Z)
    	)

    	newLeaf.LeafAngle = CFrame.Angles(0, math.pi*.5, 0)--Orient correctly
                        * CFrame.Angles(0, math.rad(random:nextRange(self.LeafAngle.Y)), 0)--Spin
                        * CFrame.Angles(math.rad(random:nextRange(self.LeafAngle.X)), 0, math.rad(random:nextRange(self.LeafAngle.Z)))--Tilt

		newLeaf:init(self)

		leaves[i] = newLeaf
	end

	self:updateLeaves(section, leaves)

	return leaves
end

function treeClass:updateLeaves(section, leavesIn)
	local leaves = leavesIn or section.LeafBunch
	for _, leaf in pairs(leaves) do
		leaf:update(section)
	end
end

function treeClass:destroyLeaves(section)
	local leaves = section.LeafBunch
	for _, leaf in pairs(leaves or {}) do
		leaf:destroy()
	end
	self.Sections[section.ID].LeafBunch = {}
end

return treeClass