local crystalClass = require(script.Parent.Parent.CrystalClass)

local crystalType = setmetatable({}, crystalClass)
crystalType.__index = crystalType
crystalType.Name = "Eather"

--===============================================================================================================--
--===============================================/     Stats     /===============================================--

crystalType.RawPrice = 0
crystalType.ProcessedPrice = 0
crystalType.Hardness = 1

--===============================================/     Stats     /===============================================--
--===============================================================================================================--
--===============================================/   Apearence   /===============================================--

crystalType.Shape = "Dense"

crystalType.ShellColor = BrickColor.new("Magenta")
crystalType.ShellMaterial = "Granite"
crystalType.ShellTransparency = .5
crystalType.ShellThickness = .5

crystalType.InnerColor = BrickColor.new("Hot pink")
crystalType.InnerMaterial = "Neon"
crystalType.InnerTransparency = 0

crystalType.Light = { Color=Color3.fromRGB(170, 0, 255), Brightness=14, Range=8 }

crystalType.Effects = require(script.effects)

crystalType.TextColor = crystalType.InnerColor.Color

--===============================================================================================================--
--===============================================/ Grow Behavior /===============================================--

--//////////////////////////////--
--//////////[ Main ]//////////--

crystalType.GrowInterval = { min=10, max=15 }--Seconds between :grow() is called

crystalType.MaxGrowCalls = { min=10, max=40 }--Total growcalls

crystalType.LifetimePerVolume = .7 --Crystal will break after this much time after it stops growing

crystalType.ClusterSize = { min=.5, max=1 }--Initial size

crystalType.SizeGrow = { min=.09, max=.12 }

crystalType.SpaceCheckCone = { dist=3, angle=15 }

crystalType.ClusterPhi = { min=-20, max=20 }

crystalType.ClusterTheta = { min=-360, max=360 }

crystalType.MinSpawnDistanceToOtherCrystals = 20

crystalType.Offset = -.25

--//////////[ Main ]//////////--
--//////////////////////////////--

function crystalType.new(...)
    return setmetatable(crystalClass.new(...), crystalType)
end

return crystalType