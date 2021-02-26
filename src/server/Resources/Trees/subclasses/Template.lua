local treeClass = require(script.Parent.Parent.TreeClass)

local treeType = setmetatable({}, treeClass)
treeType.__index = treeType
treeType.Name = ''
--===============================================================================================================--
--===============================================/     Stats     /===============================================--

treeType.PlankPrice = 0
treeType.WoodPrice = 0
treeType.BarkPrice = 0
treeType.Hardness = 0

--===============================================/     Stats     /===============================================--
--===============================================================================================================--
--===============================================/   Apearence   /===============================================--

treeType.WoodMaterial = 'Wood'
treeType.WoodColor = BrickColor.new('')

treeType.PlankMaterial = 'WoodPlanks'
treeType.PlankColor = BrickColor.new('')

treeType.BarkMaterial = 'Concrete'
treeType.BarkColor = BrickColor.new('')

treeType.BarkThickness = .02

treeType.LeafClass = nil

treeType.LeafColors={
	{material='Grass', color=BrickColor.new('') },
}

treeType.NumLeafParts = { min=1, max=1 }
treeType.LeafAngle = {
	X = { min=-10, max=10 },
	Y = { min=-20, max=20 },
	Z = { min=-10, max=10 }
}

treeType.LeafSizeFactor = {
	X = { min=3, max=3.5 }, --Leaf size as a factor of the thickness of its branch
	Y = { min=.75, max=1 },
	Y = { min=.75, max=1 },
	Z = { min=3, max=3.5 }
}

treeType.BranchClasses = nil

--===============================================/   Apearence   /===============================================--
--===============================================================================================================--
--===============================================/ Grow Behavior /===============================================--

--//////////////////////////////--
--//////////[ Main ]//////////--

treeType.GrowInterval = { min=0, max=0 }--Seconds between :Grow() is called

treeType.MaxGrowCalls = { min=0, max=0 }--Max distance from bottom of trunk to tip of farthest extremety

treeType.NewBranchCutoff = 0 --Don't create a new section if we are within this many grow calls of maximum TODO rename
treeType.LifetimePerVolume = 0 --Tree will die after this much time after it stops growing
treeType.LeafDropTime = 0 --Tree will drop leaves at this time before death

treeType.SeedThickness = {	min=0, max=0 }--Initial outer diameter for seedling tree

treeType.ThicknessGrow = {	min=0, max=0 }--Amount the outer diameter thickens for each call of :Grow()

treeType.LengthGrow = {	min=0, max=0 }--Amount length of extremety branches increases for each call of :Grow()

treeType.NumNewSegmentAttempts = 250

treeType.SpaceCheckCone = { dist=10, angle=15 }

treeType.MinSpawnDistanceToOtherTrees = 0

--//////////[ Main ]//////////--
--//////////////////////////////--
--//////////[  Trunk ]//////////--

treeType.TrunkAnglePhi = { min=0, max=0 }--Angle away fron vertical normal of baseplate

treeType.TrunkAngleTheta = { min=0, max=0 }--Spin

treeType.TrunkDistanceUntilBending = {	min=10000, max=10000 }--Will yield these distance amounts before beginning regular yield cycles for bending/branching/splitting

treeType.TrunkDistanceUntilSpliting = { min=10000, max=10000 }

treeType.TrunkDistanceUntilBranching = { min=10000, max=10000 }

--//////////[  Trunk ]//////////--
--//////////////////////////////--
--//////////[  Split ]//////////--

treeType.DistanceBetweenSplits = { min=0, max=0 }--Will yield this distance between new splits

treeType.NumSplits = { min=0, max=0 }--Number of new segments at each split. 1 is no split.

treeType.SplitAngle = {	min=0, max=0 }--Angle away from vertical normal of parent branch

treeType.AllowableAngleBetweenSplits = { min=0, max=0 }--Value between 0 and 180 degrees

treeType.SplitUnitYComponentConstraints = {	min=0, max=0 }

treeType.SplitThicknessReduce = { min=0, max=0 }--Starting thickness of new branch segments, subracted from parent branch

--//////////[  Split ]//////////--
--//////////////////////////////--
--//////////[  Bend  ]//////////--

treeType.DistanceBetweenBends = { min=0, max=0 }--Will yield this distance between new bends

treeType.BendAngle = { min=0, max=0 }--Angle away from vertical normal of parent branch

treeType.BendUnitYComponentConstraints = { min=0, max=0 }

treeType.BendThicknessReduce = { min=0, max=0 }--Starting thickness of new bend segments, subracted from parent branch

--//////////[  Bend  ]//////////--
--//////////////////////////////--
--//////////[ Branch ]//////////--

treeType.DistanceBetweenBranching = { min=0, max=0 }--Will yield this distance between new splits

treeType.NumBranches = { min=0, max=0 }--Number of new segments at each split. 1 is no split.

treeType.BranchAngle = { min=0, max=0 }--Angle away from vertical normal of parent branch

treeType.AllowableAngleBetweenBranches = {	min=0, max=0 }--Value between 0 and 180 degrees

treeType.BranchUnitYComponentConstraints = { min=-0, max=0 }

--//////////[ Branch ]//////////--
--//////////////////////////////--

--===============================================/ Grow Behavior /===============================================--
--===============================================================================================================--

function treeType.new(...)
    return setmetatable(treeClass.new(...), treeType)
end

return treeType