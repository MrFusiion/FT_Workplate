local RayUtils = require(script:WaitForChild("Ray"))
--------------------------------------------
------------- Instantiation ----------------

SuperTree = {}
SuperTree.__index = SuperTree

function SuperTree.new(ParentModel, BranchParentTree, BranchParentSection)
    local newtree = {}
    --setmetatable(newtree, SuperTree)

	newtree.IsABranch = not not BranchParentTree
	newtree.BranchParentTree = BranchParentTree
	newtree.ParentModel = ParentModel
	
	newtree.Sections={}
	newtree.Cuts={}
	newtree.Branches = {}
	
	newtree.GrowCalls = 0
	newtree.FinishedGrowing = false
	newtree.AdultStage = "Growing"
	
	--newtree.Billboard = script.Parent.Billboard:Clone()
	
    return newtree
end


--------------------------------------------
------------- Grow Clocking ----------------

function SuperTree:GrowCheck(timePassed, acceleratedGrowth) -- Grow if only if it is time
--[[	if self.FinishedGrowing then 
		return 
	end]]
	
	self.TimeToNextGrow = self.TimeToNextGrow - timePassed
	if self.TimeToNextGrow <= 0 and not self.FinishedGrowing then
		self:Grow()
		self.TimeToNextGrow += randomRange(self.GrowInterval) -- Add negative value
	elseif self.FinishedGrowing and not acceleratedGrowth then
		self:Age(timePassed)
	end
end


--------------------------------------------
------------- Seed Plant -------------------

function SuperTree:CanSeedHere(cframe, otherTrees)
	for _, tree in pairs(otherTrees) do
		if tree.SeedCFrame then
			if (tree.SeedCFrame.p - cframe.p).magnitude < self.MinSpawnDistanceToOtherTrees then
				return false
			end
		end
	end
	return true
end

function SuperTree:PlantSeed(cframe, distUpBranch)
	if not self.IsABranch then--[mrfusiion] This means its a trunk
		cframe *= CFrame.Angles(0, math.rad(randomRange(self.TrunkAngleTheta)), math.rad(randomRange(self.TrunkAnglePhi)))
	end
	
	self.SeedCFrame = cframe
	
	self.MaxGrowCalls = randomRange(self.MaxGrowCalls)
	
	self.Model = Instance.new("Model", self.ParentModel)
	self.Model.Name = self.Name
	self.LeafModel = Instance.new("Model", self.Model)
	self.LeafModel.Name = "Leaves"
	
	self.Type = Instance.new("StringValue", self.Model)
	self.Type.Name = "TreeClass"
	self.Type.Value = self.Name
	
	--self.CutEvent = Instance.new("BindableEvent", self.Model)
	--self.CutEvent.Name = "CutEvent"
	--self.CutConnection = self.CutEvent.Event:connect(function(...) self:GetCut(...) end)
	
	self:NewSection(cframe, "Seed", distUpBranch)
	self.TimeToNextGrow = randomRange(self.GrowInterval)
	
	if not self.BranchParentTree then
		self.Owner = Instance.new("ObjectValue", self.Model)
		self.Owner.Name = "Owner"
		local lastInteraction = Instance.new("IntValue", self.Owner)
		lastInteraction.Name = "LastInteraction"
		
		game.ServerScriptService.Trees.LooseWoodManagement.RunTreeOwnershipLoop:Fire(self)
	else
		self.Owner = self.BranchParentTree.Owner
	end
end


--------------------------------------------
------------- Cleanup ----------------------

function SuperTree:Destroy()
	--error("Destroying")
	if self.CutConnection then
		self.CutConnection:disconnect()
	end
	self.Model:Destroy()
	self = nil
end


function SuperTree:Age(timePassed)
	if self.AdultStage == "Growing" or self.AdultStage == "Leaves fallen" then
		self.TimeUntilDeath = (self.TimeUntilDeath - timePassed) * self:GetVolume() / self.FinalVolume
		self.FinalVolume = self:GetVolume()
	else
		self.TimeUntilDeath = self.TimeUntilDeath - timePassed
	end
	
	if self.AdultStage == "Growing" then --Finished growing, wait for leaves to fall
		if self.TimeUntilDeath < self.LeafDropTime --[[/ (self.FinalVolume * self.LifetimePerVolume) < 0.25]]  then
			self.AdultStage = "Leaves fallen" 
			
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
		
		--self:UpdateAllCuts()
		
	elseif self.AdultStage == "Leaves fallen" then --Leaves fallen, wait to fall apart
		if self.TimeUntilDeath <= 0  then
			self.AdultStage = "Broken up"
			self.TimeUntilDeath = 0
			
			self.CutEvent:Destroy()
			self.Type:Destroy()
			self.Owner:Destroy()
			 
			local existingSections = #self.Sections
			for ID = 1, existingSections do
				local section = self.Sections[ID]
				if section and section.Part then
					section.Part.BrickColor = BrickColor.new("Black")
					section.Part.Anchored = false
					if section["TopInner"] then
						section["TopInner"]:Destroy()
						section["TopInner"] = nil
					end
				end	
			end
		end
		
	elseif self.AdultStage == "Broken up" then --Fallen apart, wait for final cleanup
		if self.TimeUntilDeath < -20  then
			self.AdultStage = "Dead"
			
			local existingSections = #self.Sections
			for ID = 1, existingSections do
				local section = self.Sections[ID]
				if section and section.Part then
					section.Part.CanCollide = false
				end	
			end
		end
		
	elseif self.AdultStage == "Dead" then
		if self.TimeUntilDeath < -23  then
			self:Destroy()
		end
	end
end
--------------------------------------------
------------- Segment Growing --------------

function SuperTree:Grow(timePassed)
	if self.FinishedGrowing then
		return
	end	
	
	self.GrowCalls += 1
	
	local foundGrowingSection = false
	
	local existingSections = #self.Sections
	for ID = 1, existingSections do
		local section = self.Sections[ID]
		if section and section.IsGrowing then
			foundGrowingSection = true
			
			local stopForBranches = self.MaxGrowCalls - self.GrowCalls < self.NewBranchCutoff and self.BranchClass
			
			if section.IsExtremety and not stopForBranches and self:ConeCheck(section) then
					
				
				local lengthGrow = randomRange(self.LengthGrow)
				
				section.Length = section.Length + lengthGrow
				section.DistanceToBend = section.DistanceToBend - lengthGrow
				section.DistanceToSplit = section.DistanceToSplit - lengthGrow
				section.DistanceToBranch = section.DistanceToBranch - lengthGrow
				 
				if section.DistanceToSplit <= 0 and section.Length > 2 then --Time to split
					self.Sections[ID].IsExtremety = false
					self:Split(section, "Split", section.Length, self.NumSplits, self.SplitAngle, self.SplitUnitYComponentConstraints, self.AllowableAngleBetweenSplits)
				elseif section.DistanceToBend <=0 and section.Length > 2 then --Time to bend
					self.Sections[ID].IsExtremety = false
					self:Split(section, "Bend", section.Length, {min=1,max=1}, self.BendAngle, self.BendUnitYComponentConstraints, {min=0,max=180})
				elseif section.DistanceToBranch <=0 and self.BranchClass then --Time to branch
					section.DistanceToBranch = randomRange(self.DistanceBetweenBranching)
					self:Split(section, "Branch", section.Length, self.NumBranches, self.BranchAngle, self.BranchUnitYComponentConstraints, self.AllowableAngleBetweenBranches)
					--TODO after prototype
					
				end
			end
			section.Thickness = section.Thickness + randomRange(self.ThicknessGrow)
			
			section.Part.Size = Vector3.new(section.Thickness, section.Length, section.Thickness)
			section.Part.CFrame = section.StartCFrame * CFrame.new(0, section.Length / 2, 0)
			
			self:UpdateLeaves(section)
			
			--[[if section.Length + section.AncestryLength > self.MaxGrowLength then
				print("Done growing")
				self.FinishedGrowing = true
			end]]
		end
	end
	
	if self.GrowCalls > self.MaxGrowCalls or not foundGrowingSection then
		self.FinishedGrowing = true
		self.FinalVolume = self:GetVolume()
		self.TimeUntilDeath = self.FinalVolume * self.LifetimePerVolume
	end
	
	--self:UpdateAllCuts() Cuts
	
	for i, branch in pairs(self.Branches) do
		branch.Branch:Grow(timePassed)
		if not branch.Branch.Model.Parent then
			self.Branches[i] = nil
		end
	end
end


function SuperTree:GetVolume()
	local volume = 0
	local existingSections = #self.Sections
	for ID = 1, existingSections do
		local section = self.Sections[ID]
		if section and section.Part then
			volume += section.Part.Size.X * section.Part.Size.Y * section.Part.Size.Z
		end	
	end

	for i, branch in pairs(self.Branches) do
		volume = volume + branch.Branch:GetVolume()
	end	
	
	return volume
end

local numThetaChecks = 6
local rhoRes = 3
function SuperTree:ConeCheck(section, nosectioncframe)
	local coneIgnoreList = {self.LeafModel, self.Model}
	
	for _, player in pairs(game.Players:GetPlayers()) do
		table.insert(coneIgnoreList, player.Character)
	end
	--[[
	if section and self.Sections[section.ParentId] then
		table.insert(coneIgnoreList, self.Sections[section.ParentId].Part)
		for _, childId in pairs(self.Sections[section.ParentId].ChildrenSections) do
			table.insert(coneIgnoreList, self.Sections[childId].Part)
		end
	end]]
	
	local checkCFrame = nosectioncframe or section.StartCFrame * CFrame.new(0, section.Length, 0)
	
	for rhoCount = 0, rhoRes, 1 do
		local rho = rhoCount * (self.SpaceCheckCone.Angle / 3)
		for theta=math.pi * 2 / numThetaChecks, math.pi * 2, math.pi * 2 / numThetaChecks do
			local unit=(checkCFrame * CFrame.Angles(0, theta, math.rad(rho))).UpVector
			local ray = RayUtils.new(checkCFrame.p, unit * self.SpaceCheckCone.Distance)
			
			if workspace:FindPartOnRayWithIgnoreList(ray, coneIgnoreList, 1) then
				if section then
					section.IsGrowing = false
					
					if section.ID == 1 then --TODO: Tree lifetime dependent on number/ volume of sections
						self:Destroy()
					end
					
				end
				return false
			end
		end
	end
	return true
end

--------------------------------------------
------------- Splitting --------------------

function SuperTree:Split(parentBranch, type, distUpBranch, numSplits, splitAngle, unitYComponentConstraints, allowableAngleBetweenSplits)
	
	
	local diff1 = self.MaxGrowCalls - self.GrowCalls
	local diff2 = self.BranchParentTree and self.BranchParentTree.MaxGrowCalls - self.BranchParentTree.GrowCalls or self.NewBranchCutoff	
	if diff1 < self.NewBranchCutoff or diff2 < self.NewBranchCutoff then --Too close to growth completion to create stubby new branches
		return
	end
	
	numSplits=randomRangeInteger(numSplits)
	--print("Splitting "..numSplits)

	local splitDistanceBounds = {min = math.sqrt(2 - 2 * math.cos(math.rad(allowableAngleBetweenSplits.min))), max = math.sqrt(2 - 2 * math.cos(math.rad(allowableAngleBetweenSplits.max)))} --Values between 0 and 2
	
	local newCFrames = {}
	for _ = 1, self.NumNewSegmentAttempts do
		
		local splitSucces = true
		for _ = #newCFrames + 1, numSplits do
			
 			local newTheta = randomRange({min = 0, max = math.pi*2}) --http://msemac.redwoods.edu/~darnold/math50c/mathjax/spherical/spherical2.png
			local newPhi = math.rad(randomRange(splitAngle))
			local angle = CFrame.Angles(0, newTheta, newPhi) * CFrame.Angles(0, -newTheta, 0)
			local resultantCFrame = parentBranch.StartCFrame * CFrame.new(0, parentBranch.Length, 0) * angle
			
			local unitVector = (resultantCFrame * CFrame.Angles(math.pi/2, 0, 0)).lookVector --Check that section attempts do not violate Y unit vector bounds and do cone check
			if unitVector.Y > unitYComponentConstraints.max or unitVector.Y < unitYComponentConstraints.min or not self:ConeCheck(nil, resultantCFrame) then
				splitSucces = false
				print("Y violation")
				break --Throw out new branch, but keep other branches in the list
			end

			local success2 = true
			for _, cframe in pairs(newCFrames) do --Check that section attempts do not violate bounds for allowable angle between splits
				local d = ((resultantCFrame * CFrame.new(0,1,0)).p - (cframe.netCframe * CFrame.new(0,1,0)).p).magnitude
				if d < splitDistanceBounds.min or d > splitDistanceBounds.max then
					newCFrames = {}--Throw out new branch, clean out list and start over
					success2 = false
					--print("Angle violation: "..d)
					break 
				end
			end
			
			
			if not success2 then
				splitSucces = false
				break
			end

			
			table.insert(newCFrames, {netCframe = resultantCFrame, angle = angle}) --New branch proposal worked; add it to the list
		end
		
		if splitSucces then
			break
		end
	end
	
	local success = #newCFrames > 0 --Success does not necessarily mean the amount of desired branches was reached
	 
	if success then
		for _, cframe in pairs(newCFrames) do
			self:NewSection(cframe.netCframe,type,distUpBranch,parentBranch.ID, cframe.angle)
		end
		if not (type == "Branch") then
			self:DestroyLeaves(parentBranch)
		end
	elseif not success and not (type == "Branch") then --Branch growing is now just halted
		parentBranch.IsGrowing = false
	end
end

--------------------------------------------
------------- Segment Creation -------------

function SuperTree:NewSection(cframe, originType, distanceUpParentBranch, parentId, bendAngle)
	local parentSection = self.Sections[parentId]
	
	if originType == "Branch" then
		local branch = self.BranchClass[math.random(1, #self.BranchClass)]
		local newTree = require(branch.Class)
		
		newTree = newTree.new(self.Model, self, parentSection)
		newTree.SkipTrunkYield = branch.skipTrunkYield

		newTree:PlantSeed(cframe)
	
		local idValue = Instance.new("IntValue")
		idValue.Name = "ParentTreeSectionId"
		idValue.Value = parentId
		idValue.Parent = newTree.Model
		
		local angleValue = Instance.new("CFrameValue")
		angleValue.Name = "BranchAngle"
		angleValue.Value = bendAngle
		angleValue.Parent = newTree.Model
		
		local distValue = Instance.new("NumberValue")
		distValue.Name = "DistUpParentTreeSection"
		distValue.Value = distanceUpParentBranch
		distValue.Parent = newTree.Model
		
		table.insert(self.Branches, {Branch = newTree, ParentId = parentId})
		return
	end
	
	local section = {}

	section.Part = newPart()
	section.Part.Name = originType
	section.Part.BrickColor = self.BarkColor
	section.Part.Material = self.BarkMaterial
	
	section.InsideWoods = {}
	
	if parentSection then --Came from another branch
		if originType == "Bend" then
			section.Thickness = parentSection.Thickness - randomRange(self.BendThicknessReduce)
		elseif originType == "Split" then
			section.Thickness = parentSection.Thickness - randomRange(self.SplitThicknessReduce)
		end
		section.AncestryLength = parentSection.Length + parentSection.AncestryLength
	elseif originType == "Seed" then --Is a seed
		section.Thickness = randomRange(self.SeedThickness)
		section.AncestryLength = 0
	end
	section.Length = 0.2
	
	section.StartCFrame=cframe
	section.Part.Size = Vector3.new(section.Thickness, section.Length, section.Thickness)
	section.Part.CFrame = section.StartCFrame * CFrame.new(0, section.Length / 2, 0)
	section.Part.Parent = self.Model
	
	section.LeafBunch = self:NewLeafBunch(section)
	
	section.IsExtremety = true
	section.IsGrowing = true

	if originType == "Seed" then	--Do special trunk yielding?
		if self.SkipTrunkYield then
			section.DistanceToBend = randomRange(self.DistanceBetweenBends)
			section.DistanceToSplit = randomRange(self.DistanceBetweenSplits)
			section.DistanceToBranch = randomRange(self.DistanceBetweenBranching)
		else
			section.DistanceToBend = randomRange(self.TrunkDistanceUntilBending)
			section.DistanceToSplit = randomRange(self.TrunkDistanceUntilSpliting)
			section.DistanceToBranch = randomRange(self.TrunkDistanceUntilBranching)
		end
	elseif parentSection then --Or inherent parent yield values?
		if originType == "Bend" then
			section.DistanceToBend = randomRange(self.DistanceBetweenBends)
			section.DistanceToSplit = parentSection.DistanceToSplit
		elseif originType == "Split" then
			section.DistanceToBend = parentSection.DistanceToBend
			section.DistanceToSplit = randomRange(self.DistanceBetweenSplits)
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
		angleValue.Value = bendAngle
	end
	section.ChildrenSections = {}

	self.Sections[#self.Sections + 1] = section
end


--------------------------------------------
------------- Leaf Creation ----------------

function SuperTree:NewLeafBunch(section)	
	local numLeaves = game.Lighting.Spook.Value and 0 or randomRangeInteger(self.NumLeafParts)
	
	local leaves = {}
	for i = 1, numLeaves do --All the parts that make up a leaf bunch
		local newLeaf = {}
		
		newLeaf.LeafSizeFactor = Vector3.new(randomRange(self.LeafSizeFactor.X),
							  				randomRange(self.LeafSizeFactor.Y),
                                                randomRange(self.LeafSizeFactor.Z))
                                                
		newLeaf.LeafAngle = CFrame.Angles(0, math.pi/2, 0) --Orient correctly
							* CFrame.Angles(0, math.rad(randomRange(self.LeafAngle.Y)), 0) --Spin
							* CFrame.Angles(math.rad(randomRange(self.LeafAngle.X)), 0, math.rad(randomRange(self.LeafAngle.Z))) --Tilt
		
		
		newLeaf.Part = newPart()
		newLeaf.Part.CanCollide = false
		local colorChoice = self.LeafColors[math.random(1,#self.LeafColors)]
		newLeaf.Part.BrickColor = colorChoice.Color
		newLeaf.Part.Material = colorChoice.Material
		
		newLeaf.Part.Parent = self.LeafModel
		newLeaf.Part.Name = "LeafPart"
	
		leaves[i] = newLeaf
	end
	
	self:UpdateLeaves(section, leaves)	
	
	return leaves
end


function SuperTree:UpdateLeaves(section, leavesIn)
	
	local leaves = leavesIn or section.LeafBunch --Section.LeafChunk will not be valid for the call fron the :NewLeafBunch leaf constructor
	for _, leaf in pairs(leaves) do --Get all the parts in a given leaf bunch
		if leaf.Part.Parent then
			leaf.Part.Size = leaf.LeafSizeFactor * section.Thickness
			leaf.Part.CFrame = section.StartCFrame * CFrame.new(0, section.Length + 0.75 * leaf.Part.Size.Y/2, 0) * leaf.LeafAngle
		end
	end
end


function SuperTree:DestroyLeaves(section)
	local leaves = section.LeafBunch --Section.LeafChunk will not be valid for the call fron the :NewLeafBunch leaf constructor
	if leaves then
		for _, leaf in pairs(leaves) do
			if leaf.Part.Parent then
				leaf.Part:Destroy()
			end
		end
		self.Sections[section.ID].LeafBunch = {}
	end
end

--------------------------------------------
------------- Utility Functions ------------

function newPart()	
	local part=Instance.new("Part")
	part.TopSurface=Enum.SurfaceType.Smooth
	part.BottomSurface=Enum.SurfaceType.Smooth
	part.Elasticity = 0.2
	part.Anchored=true	
	part.CustomPhysicalProperties = PhysicalProperties.new(1, 0.3, 0.5)
	--print(part.Elasticity)
	return part
end

function weldBetween(a, b)
    local weld = Instance.new("Weld", a)
    weld.Part0 = a
    weld.Part1 = b
    weld.C0 = a.CFrame:inverse() * b.CFrame
    return weld
end

function randomRange(value)
	return math.random() * (value.max - value.min) + value.min
end

function randomRangeInteger(value)
	return math.random(value.min, value.max)
end



--------------------------------------------
------------- Module Return ----------------

return SuperTree
