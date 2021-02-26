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
	newtree.BarkThickness = 0.06
	
	newtree.LeafColors={{Material=Enum.Material.Grass,Color=BrickColor.new("Dark green")}}--,
						--{Material=Enum.Material.Grass,Color=BrickColor.new("Medium green")}}
	newtree.NumLeafParts = { min=1,
							 max=2 }
	newtree.LeafAngle = { X = {min=-10, max=10},
						  Y = {min=-20, max=20},
						  Z = {min=-10, max=10}}

	newtree.LeafSizeFactor = { X = {min=3, max=6}, --Leaf size as a factor of the thickness of its branch
							   Y = {min=10, max=15},
	  						   Z = {min=3, max=6}}
	
	newtree.BranchClass = nil

	--------------[[ Growth Behavior ]]--------------
	
	newtree.GrowInterval = {	min=5, --Seconds between :Grow() is called
								max=7 }
	newtree.MaxGrowCalls = {	min=60, --Max distance from bottom of trunk to tip of farthest extremety
								max=70 }
								
	newtree.NewBranchCutoff = 10 --Don't create a new section if we are within this many grow calls of maximum
	newtree.LifetimePerVolume = 45 --Tree will die after this much time after it stops growing
	newtree.LeafDropTime = 140 --Tree will drop leaves at this time before death
	
	newtree.SeedThickness = {	min=0.3, --Initial outer diameter for seedling tree
								max=0.26 }
	newtree.ThicknessGrow = {	min=0.008, --Amount the outer diameter thickens for each call of :Grow()
								max=0.010 }

	newtree.LengthGrow = {	min=0.2, --Amount length of extremety branches increases for each call of :Grow()
							max=0.3 }
	newtree.BendThicknessReduce = {	min=0.1, --Starting thickness of new bend segments, subracted from parent branch
									max=0.22 }
	newtree.SplitThicknessReduce = {min=0.1, --Starting thickness of new branch segments, subracted from parent branch
									max=0.22 }
									
	newtree.TrunkAnglePhi = { min=0, --Angle away fron vertical normal of baseplate
								max=0 }
	newtree.TrunkAngleTheta = {	min=0, --Spin
								max=0 }

	newtree.TrunkDistanceUntilBending = {	min=1000, --Will yield these distance amounts before beginning regular yield cycles for bending/branching/splitting
											max=1000 }
	newtree.TrunkDistanceUntilSpliting = {	min=4,
											max=6 }
	newtree.TrunkDistanceUntilBranching = { min=0,
											max=0 }

	newtree.DistanceBetweenSplits = {	min=10, --Will yield this distance between new splits
										max=20 }
	newtree.NumSplits = {	min=2, --Number of new segments at each split. 1 is no split.
							max=3 }
	newtree.SplitAngle = {	min=0, --Angle away fron vertical normal of parent branch
							max=40 }
	newtree.AllowableAngleBetweenSplits = {	min=20, --Value between 0 and 180 degrees
											max=180 }
	newtree.SplitUnitYComponentConstraints = {	min=-0.5,
												max=0.5 }

 


	newtree.DistanceBetweenBends = {	min=0, --Will yield this distance between new bends
										max=0 }
	newtree.BendAngle = {	min=0, --Angle away fron vertical normal of parent branch
							max=0 }
	newtree.BendUnitYComponentConstraints = {min=0,
											max=0 }




	newtree.DistanceBetweenBranching = {min=0, --Will yield this distance between new splits
										max=0 }
	newtree.NumBranches = {	min=0, --Number of new segments at each split. 1 is no split.
							max=0 }
	newtree.BranchAngle = {	min=0, --Angle away fron vertical normal of parent branch
							max=0 }
	newtree.AllowableAngleBetweenBranches = {	min=0, --Value between 0 and 180 degrees
											max=0 }
	newtree.BranchUnitYComponentConstraints = {	min=0,
												max=0 }



	newtree.SpaceCheckCone = {Distance=5,
							  Angle=15	}
	newtree.NumNewSegmentAttempts = 250
	
	newtree.MinSpawnDistanceToOtherTrees = 6


    return newtree
end

return Tree