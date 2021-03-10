local treeClass = require(script.Parent.Parent.TreeClass)

local treeType = setmetatable({}, treeClass)
treeType.__index = treeType
treeType.Name = "Fir"
--===============================================================================================================--
--===============================================/     Stats     /===============================================--

treeType.PlankPrice = 90
treeType.WoodPrice = 45
treeType.BarkPrice = 15
treeType.Hardness = 7

--===============================================/     Stats     /===============================================--
--===============================================================================================================--
--===============================================/   Apearence   /===============================================--

treeType.WoodMaterial = "Wood"
treeType.WoodColor = BrickColor.new("Brick yellow")
treeType.PlankMaterial = "WoodPlanks"
treeType.PlankColor = BrickColor.new("Brick yellow")
treeType.BarkMaterial = "Concrete"
treeType.BarkColor = BrickColor.new("Sand red")

treeType.BarkThickness = .13

treeType.LeafClass = nil

treeType.LeafColors={
	{material="Grass", color=BrickColor.new("Dark green") },
}

treeType.NumLeafParts = { min=1, max=2 }
treeType.LeafAngle = {
	X = { min=-10, max=10 },
	Y = { min=-20, max=20 },
	Z = { min=-10, max=10 }
}

treeType.LeafSizeFactor = {
	X = { min=3, max=7 }, --Leaf size as a factor of the thickness of its branch
	Y = { min=2, max=2 },
	Z = { min=3, max=7 }
}

treeType.BranchClasses = {
	{ class = script.branch, skipTrunkYield = false }
}

--===============================================/   Apearence   /===============================================--
--===============================================================================================================--
--===============================================/ Grow Behavior /===============================================--

--//////////////////////////////--
--//////////[ Main ]//////////--

treeType.GrowInterval = { min=10, max=17 }--Seconds between :Grow() is called

treeType.MaxGrowCalls = { min=60, max=70 }--Max distance from bottom of trunk to tip of farthest extremety

treeType.NewBranchCutoff = 10 --Don"t create a new section if we are within this many grow calls of maximum TODO rename
treeType.LifetimePerVolume = 45 --Tree will die after this much time after it stops growing
treeType.LeafDropTime = 140 --Tree will drop leaves at this time before death

treeType.SeedThickness = {	min=.5, max=.8 }--Initial outer diameter for seedling tree

treeType.ThicknessGrow = {	min=0.02, max=0.028 }--Amount the outer diameter thickens for each call of :Grow()

treeType.LengthGrow = {	min=0.55, max=0.65 }--Amount length of extremety branches increases for each call of :Grow()

treeType.NumNewSegmentAttempts = 250

treeType.SpaceCheckCone = { dist=5, angle=15 }

treeType.MinSpawnDistanceToOtherTrees = 6

--//////////[ Main ]//////////--
--//////////////////////////////--
--//////////[  Trunk ]//////////--

treeType.TrunkAnglePhi = { min=0, max=7 }--Angle away fron vertical normal of baseplate

treeType.TrunkAngleTheta = { min=0, max=360 }--Spin

treeType.TrunkDistanceUntilBending = {	min=10, max=15 }--Will yield these distance amounts before beginning regular yield cycles for bending/branching/splitting

treeType.TrunkDistanceUntilSpliting = { min=10000, max=10000 }

treeType.TrunkDistanceUntilBranching = { min=6, max=10 }

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

treeType.DistanceBetweenBends = { min=5, max=10 }--Will yield this distance between new bends

treeType.BendAngle = { min=2, max=5 }--Angle away from vertical normal of parent branch

treeType.BendUnitYComponentConstraints = { min=.88, max=1 }

treeType.BendThicknessReduce = { min=0.05, max=0.08 }--Starting thickness of new bend segments, subracted from parent branch

--//////////[  Bend  ]//////////--
--//////////////////////////////--
--//////////[ Branch ]//////////--

treeType.DistanceBetweenBranching = { min=.6, max=2.5 }--Will yield this distance between new splits

treeType.NumBranches = { min=7, max=10 }--Number of new segments at each split. 1 is no split.

treeType.BranchAngle = { min=80, max=110 }--Angle away from vertical normal of parent branch

treeType.AllowableAngleBetweenBranches = {	min=20, max=180 }--Value between 0 and 180 degrees

treeType.BranchUnitYComponentConstraints = { min=-0.3, max=.3 }

--//////////[ Branch ]//////////--
--//////////////////////////////--

--===============================================/ Grow Behavior /===============================================--
--===============================================================================================================--

function treeType.new(...)
    return setmetatable(treeClass.new(...), treeType)
end

return treeType