local crystalClass = require(script.Parent.Parent.CrystalClass)

local crystalType = setmetatable({}, crystalClass)
crystalType.__index = crystalType
crystalType.Name = "Either"

--===============================================================================================================--
--===============================================/     Stats     /===============================================--

crystalType.RawPrice = 0
crystalType.ProcessedPrice = 0
crystalType.Hardness = 0

--===============================================/     Stats     /===============================================--
--===============================================================================================================--
--===============================================/   Apearence   /===============================================--

crystalType.Shape = "Artificial"

crystalType.ShellColor = BrickColor.new("Lime green")
crystalType.ShellMaterial = "Slate"
crystalType.ShellTransparency = .2
crystalType.ShellThickness = .2

crystalType.InnerColor = BrickColor.new("Lime green")
crystalType.InnerMaterial = "Neon"
crystalType.InnerTransparency = 0

crystalType.Light = { Color=Color3.new(1), Brightness=14, Range=8 }

crystalType.Effects = require(script.effects)

--===============================================================================================================--
--===============================================/ Grow Behavior /===============================================--

--//////////////////////////////--
--//////////[ Main ]//////////--

crystalType.GrowInterval = { min=10, max=15 }--Seconds between :grow() is called

crystalType.MaxGrowCalls = { min=10, max=40 }--Total growcalls

crystalType.LifetimePerVolume = 140 --Crystal will break after this much time after it stops growing

crystalType.ClusterSize = { min=.5, max=1 }--Initial size

crystalType.SizeGrow = { min=.09, max=.12 }

crystalType.SpaceCheckCone = { dist=3, angle=15 }

crystalType.ClusterPhi = { min=-20, max=20 }

crystalType.ClusterTheta = { min=-360, max=360 }

crystalType.MinSpawnDistanceToOtherCrystals = 20

crystalType.Offset = -.2

--//////////[ Main ]//////////--
--//////////////////////////////--

function crystalType.new(...)
    return setmetatable(crystalClass.new(...), crystalType)
end

return crystalType