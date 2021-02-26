SuperTree = require(game.ServerScriptService.Trees.TreeSuperClass)

Tree = {}
Tree.__index = Tree
setmetatable(Tree, SuperTree)

function Tree.new(...)
    local newtree = SuperTree.new(...)
    setmetatable(newtree, Tree)

	

	--------------[[ Wood Stats ]]--------------
	
	newtree.Name = script.Name

	newtree.Hardness = 5.5 --Hit points per cross sectional square stud
	newtree.LogValue = 3.2
	newtree.PlankValue = 18


	--------------[[ Apearance ]]--------------


	newtree.WoodColor = BrickColor.new("Brick yellow")
	newtree.WoodMaterial = Enum.Material.Wood
	newtree.BarkColor = BrickColor.new("Sand red")
	newtree.BarkMaterial = Enum.Material.Concrete
	newtree.BarkThickness = 0.13
	
	

	newtree.LeafColors={{Material=Enum.Material.Grass,Color=BrickColor.new("Dark green")}}--,
						--{Material=Enum.Material.Grass,Color=BrickColor.new("Medium green")}}
	newtree.NumLeafParts = { min=1,
							 max=2 }
	newtree.LeafAngle = { X = {min=-10, max=10},
						  Y = {min=-20, max=20},
						  Z = {min=-10, max=10}}
	newtree.LeafSizeFactor = { X = {min=5, max=7}, --Leaf size as a factor of the thickness of its branch
							   Y = {min=2, max=2},
	  						   Z = {min=5, max=7}}
	
	
	newtree.BranchClass = {{Class = script.FirBranch, skipTrunkYield = false}}



	--------------[[ Growth Behavior ]]--------------
	
	
	newtree.GrowInterval = {	min=10, --Seconds between :Grow() is called
								max=17 }
	newtree.MaxGrowCalls = {	min=30, --Max distance from bottom of trunk to tip of farthest extremety
								max=60 }
	newtree.NewBranchCutoff = 10 --Don't create a new section if we are within this many grow calls of maximum
	newtree.LifetimePerVolume = 45 --Tree will die after this much time after it stops growing
	newtree.LeafDropTime = 140 --Tree will drop leaves at this time before death
	
	
	newtree.SeedThickness = {	min=0.5, --Initial outer diameter for seedling tree
								max=0.8 }
	newtree.ThicknessGrow = {	min=0.02, --Amount the outer diameter thickens for each call of :Grow()
								max=0.028 }
	newtree.LengthGrow = {	min=0.55, --Amount length of extremety branches increases for each call of :Grow()
							max=0.65 }
	newtree.BendThicknessReduce = {	min=0.05, --Starting thickness of new bend segments, subracted from parent branch
									max=0.08 }
	newtree.SplitThicknessReduce = {min=0.0, --Starting thickness of new branch segments, subracted from parent branch
									max=0.0 }
	
	
	
	newtree.TrunkAnglePhi = {	min=0, --Angle away fron vertical normal of baseplate
								max=7 }
	newtree.TrunkAngleTheta = {	min=0, --Spin
								max=360 }
	newtree.TrunkDistanceUntilBending = {	min=10, --Will yield these distance amounts before beginning regular yield cycles for bending/branching/splitting
											max=15 }
	newtree.TrunkDistanceUntilSpliting = {	min=1000,
											max=1000 }
	newtree.TrunkDistanceUntilBranching = { min=6,
											max=10 }
	
	
	
	newtree.DistanceBetweenSplits = {	min=0, --Will yield this distance between new splits
										max=0 }
	newtree.NumSplits = {	min=0, --Number of new segments at each split. 1 is no split.
							max=0 }
	newtree.SplitAngle = {	min=0, --Angle away fron vertical normal of parent branch
							max=0 }
	newtree.AllowableAngleBetweenSplits = {	min=0, --Value between 0 and 180 degrees
											max=0 }
	newtree.SplitUnitYComponentConstraints = {	min=0,
												max=0 }

 


	newtree.DistanceBetweenBends = {	min=5, --Will yield this distance between new bends
										max=10 }
	newtree.BendAngle = {	min=2, --Angle away fron vertical normal of parent branch
							max=5 }
	newtree.BendUnitYComponentConstraints = {min=0.88,
											max=1 }




	newtree.DistanceBetweenBranching = {min=0.6, --Will yield this distance between new splits
										max=2.5 }
	newtree.NumBranches = {	min=2, --Number of new segments at each split. 1 is no split.
							max=5 }
	newtree.BranchAngle = {	min=80, --Angle away fron vertical normal of parent branch
							max=110 }
	newtree.AllowableAngleBetweenBranches = {	min=20, --Value between 0 and 180 degrees
											max=180 }
	newtree.BranchUnitYComponentConstraints = {	min=-0.3,
												max=0.3 }



	newtree.SpaceCheckCone = {Distance=5,
							  Angle=15	}
	newtree.NumNewSegmentAttempts = 250
	
	newtree.MinSpawnDistanceToOtherTrees = 6


    return newtree
end

return Tree