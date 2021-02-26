local treeClass = require(script.Parent.Parent.TreeClass)

local treeType = setmetatable({}, treeClass)
treeType.__index = treeType
treeType.Name = 'Oak'
--===============================================================================================================--
--===============================================/     Stats     /===============================================--

treeType.PlankPrice = 90
treeType.WoodPrice = 45
treeType.BarkPrice = 15
treeType.Hardness = 5.2

--===============================================/     Stats     /===============================================--
--===============================================================================================================--
--===============================================/   Apearence   /===============================================--

treeType.WoodMaterial = 'Wood'
treeType.WoodColor = BrickColor.new('Cork')
treeType.PlankMaterial = 'WoodPlanks'
treeType.PlankColor = BrickColor.new('Cork')
treeType.BarkMaterial = 'Concrete'
treeType.BarkColor = BrickColor.new('Pine Cone')

treeType.BarkThickness = 0.095

treeType.LeafClass = nil

treeType.LeafColors={
	{ material='Grass', color=BrickColor.new("Bright green")	},
	{ material='Grass', color=BrickColor.new("Dark green")	}
}

treeType.NumLeafParts = { min=1, max=1 }
treeType.LeafAngle = {
	X = {min=-10, max=10},
	Y = {min=-20, max=20},
	Z = {min=-10, max=10}
}

treeType.LeafSizeFactor = {
	X = {min=8, max=11}, --Leaf size as a factor of the thickness of its branch
	Y = {min=4, max= 6},
	Z = {min=8, max=11}
}

treeType.BranchClasses = nil

--===============================================/   Apearence   /===============================================--
--===============================================================================================================--
--===============================================/ Grow Behavior /===============================================--

--//////////////////////////////--
--//////////[ Main ]//////////--

treeType.GrowInterval = { min=8, max=15 }--Seconds between :Grow() is called

treeType.MaxGrowCalls = { min=65, max=90 }--Max distance from bottom of trunk to tip of farthest extremety

treeType.NewBranchCutoff = 10 --Don't create a new section if we are within this many grow calls of maximum TODO rename
treeType.LifetimePerVolume = 25 --Tree will die after this much time after it stops growing
treeType.LeafDropTime = 130 --Tree will drop leaves at this time before death

treeType.SeedThickness = {	min=0.3, max=0.5 }--Initial outer diameter for seedling tree

treeType.ThicknessGrow = {	min=0.02, max=0.028 }--Amount the outer diameter thickens for each call of :Grow()

treeType.LengthGrow = {	min=0.56, max=0.65 }--Amount length of extremety branches increases for each call of :Grow()

treeType.NumNewSegmentAttempts = 250

treeType.SpaceCheckCone = { dist=10, angle=15 }

treeType.MinSpawnDistanceToOtherTrees = 30

--//////////[ Main ]//////////--
--//////////////////////////////--
--//////////[  Trunk ]//////////--

treeType.TrunkAnglePhi = { min=0, max=10 }--Angle away fron vertical normal of baseplate

treeType.TrunkAngleTheta = { min=0, max=360 }--Spin

treeType.TrunkDistanceUntilBending = {	min=10000, max=100000 }--Will yield these distance amounts before beginning regular yield cycles for bending/branching/splitting

treeType.TrunkDistanceUntilSpliting = {	min=10, max=18 }

treeType.TrunkDistanceUntilBranching = { min=10, max=14 }

--//////////[  Trunk ]//////////--
--//////////////////////////////--
--//////////[  Split ]//////////--

treeType.DistanceBetweenSplits = { min=8, max=13 }--Will yield this distance between new splits

treeType.NumSplits = { min=2, max=4 }--Number of new segments at each split. 1 is no split.

treeType.SplitAngle = {	min=0, max=65 }--Angle away fron vertical normal of parent branch

treeType.AllowableAngleBetweenSplits = { min=40, max=140 }--Value between 0 and 180 degrees

treeType.SplitUnitYComponentConstraints = {	min=0.1, max=1 }

treeType.SplitThicknessReduce = { min=0.2, max=0.32 }--Starting thickness of new branch segments, subracted from parent branch

--//////////[  Split ]//////////--
--//////////////////////////////--
--//////////[  Bend  ]//////////--

treeType.DistanceBetweenBends = { min=3, max=5 }--Will yield this distance between new bends

treeType.BendAngle = { min=10, max=30 }--Angle away fron vertical normal of parent branch

treeType.BendUnitYComponentConstraints = { min=0, max=1 }

treeType.BendThicknessReduce = { min=0.7, max=0.9 }--Starting thickness of new bend segments, subracted from parent branch

--//////////[  Bend  ]//////////--
--//////////////////////////////--
--//////////[ Branch ]//////////--

treeType.DistanceBetweenBranching = { min=4, max=10 }--Will yield this distance between new splits

treeType.NumBranches = { min=1, max=1 }--Number of new segments at each split. 1 is no split.

treeType.BranchAngle = { min=0, max=80 }--Angle away fron vertical normal of parent branch

treeType.AllowableAngleBetweenBranches = {	min=30, max=180 }--Value between 0 and 180 degrees

treeType.BranchUnitYComponentConstraints = { min=-0.6, max=1 }

--//////////[ Branch ]//////////--
--//////////////////////////////--

--===============================================/ Grow Behavior /===============================================--
--===============================================================================================================--

function treeType.new(...)
    return setmetatable(treeClass.new(...), treeType)
end

return treeType