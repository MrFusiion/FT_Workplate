local treeClass = require(script.Parent.Parent.TreeClass)

local treeType = setmetatable({}, treeClass)
treeType.__index = treeType
treeType.Name = "Cave"
--===============================================================================================================--
--===============================================/     Stats     /===============================================--

treeType.PlankPrice = 0
treeType.WoodPrice = 0
treeType.BarkPrice = 0
treeType.Hardness = 1

--===============================================/     Stats     /===============================================--
--===============================================================================================================--
--===============================================/   Apearence   /===============================================--

treeType.WoodMaterial = "Neon"
treeType.WoodColor = BrickColor.new("Lapis")

treeType.PlankMaterial = "WoodPlanks"
treeType.PlankColor = BrickColor.new("Lapis")

treeType.BarkMaterial = "Neon"
treeType.BarkColor = BrickColor.new("Lapis")

treeType.BarkThickness = .02

treeType.LeafClass = nil

treeType.LeafColors={
	{material="Sand", color=BrickColor.new("Plum") },
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
	Z = { min=3, max=3.5 }
}

treeType.BranchClasses = {
    { class=script.mushroom, skipTrunkYield=false }
}

treeType.TextColor = treeType.BarkColor.Color

--===============================================/   Apearence   /===============================================--
--===============================================================================================================--
--===============================================/ Grow Behavior /===============================================--

--//////////////////////////////--
--//////////[ Main ]//////////--

treeType.GrowInterval = { min=10, max=15 }--Seconds between :Grow() is called

treeType.MaxGrowCalls = { min=70, max=75 }--Max distance from bottom of trunk to tip of farthest extremety

treeType.NewBranchCutoff = 10 --Don"t create a new section if we are within this many grow calls of maximum TODO rename
treeType.LifetimePerVolume = .1 --Tree will die after this much time after it stops growing
treeType.LeafDropTime = 5 --Tree will drop leaves at this time before death

treeType.SeedThickness = {	min=.1, max=.15 }--Initial outer diameter for seedling tree

treeType.ThicknessGrow = {	min=.01, max=.007 }--Amount the outer diameter thickens for each call of :Grow()

treeType.LengthGrow = {	min=.5, max=.55 }--Amount length of extremety branches increases for each call of :Grow()

treeType.NumNewSegmentAttempts = 250

treeType.SpaceCheckCone = { dist=10, angle=15 }

treeType.MinSpawnDistanceToOtherTrees = 20

--//////////[ Main ]//////////--
--//////////////////////////////--
--//////////[  Trunk ]//////////--

treeType.TrunkAnglePhi = { min=50, max=70 }--Angle away fron vertical normal of baseplate

treeType.TrunkAngleTheta = { min=0, max=360 }--Spin

treeType.TrunkDistanceUntilBending = {	min=10, max=15 }--Will yield these distance amounts before beginning regular yield cycles for bending/branching/splitting

treeType.TrunkDistanceUntilSpliting = { min=5, max=9 }

treeType.TrunkDistanceUntilBranching = { min=4, max=5 }

--//////////[  Trunk ]//////////--
--//////////////////////////////--
--//////////[  Split ]//////////--

treeType.DistanceBetweenSplits = { min=10000, max=10000 }--Will yield this distance between new splits

treeType.NumSplits = { min=2, max=3 }--Number of new segments at each split. 1 is no split.

treeType.SplitAngle = {	min=25, max=50 }--Angle away from vertical normal of parent branch

treeType.AllowableAngleBetweenSplits = { min=25, max=40 }--Value between 0 and 180 degrees

treeType.SplitUnitYComponentConstraints = {	min=0, max=1 }

treeType.SplitThicknessReduce = { min=.01, max=.02 }--Starting thickness of new branch segments, subracted from parent branch

--//////////[  Split ]//////////--
--//////////////////////////////--
--//////////[  Bend  ]//////////--

treeType.DistanceBetweenBends = { min=10, max=15 }--Will yield this distance between new bends

treeType.BendAngle = { min=25, max=60 }--Angle away from vertical normal of parent branch

treeType.BendUnitYComponentConstraints = { min=0, max=1 }

treeType.BendThicknessReduce = { min=.01, max=.02 }--Starting thickness of new bend segments, subracted from parent branch

--//////////[  Bend  ]//////////--
--//////////////////////////////--
--//////////[ Branch ]//////////--

treeType.DistanceBetweenBranching = { min=1, max=2 }--Will yield this distance between new splits

treeType.NumBranches = { min=1, max=1 }--Number of new segments at each split. 1 is no split.

treeType.BranchAngle = { min=80, max=100 }--Angle away from vertical normal of parent branch

treeType.AllowableAngleBetweenBranches = {	min=0, max=0 }--Value between 0 and 180 degrees

treeType.BranchUnitYComponentConstraints = { min=-1, max=1 }

--//////////[ Branch ]//////////--
--//////////////////////////////--

--===============================================/ Grow Behavior /===============================================--
--===============================================================================================================--

function treeType.new(...)
    return setmetatable(treeClass.new(...), treeType)
end

return treeType