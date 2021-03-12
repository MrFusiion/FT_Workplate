local oreClass = require(script.Parent.Parent.OreClass)

local oreType = setmetatable({}, oreClass)
oreType.__index = oreType
oreType.Name = "Iron"

--===============================================================================================================--
--===============================================/     Stats     /===============================================--

oreType.RawPrice = 0
oreType.ProcessedPrice = 0
oreType.Hardness = .2

--===============================================/     Stats     /===============================================--
--===============================================================================================================--
--===============================================/   Apearence   /===============================================--

oreType.OreColor = BrickColor.new("Pastel brown")
oreType.OreMaterial = "Metal"

oreType.Effects = nil

oreType.TextColor = oreType.OreColor.Color

--===============================================================================================================--
--===============================================/ Grow Behavior /===============================================--

--//////////////////////////////--
--//////////[ Main ]//////////--

oreType.GrowInterval = { min=10, max=15 }--Seconds between :grow() is called

oreType.MaxGrowCalls = { min=15, max=20 }--Total growcalls

oreType.LifetimePerVolume = .025 --Ore will break after this much time after it stops growing

oreType.SectionCount = { min=4, max=6 }

oreType.SectionSize = { min=.5, max=1 }--Initial size

oreType.SectionOffset = { min=-.5, max=.5 }

oreType.SizeGrow = { min=.2, max=.23 }

oreType.SectionPhi = { min=-20, max=20 }

oreType.SectionTheta = { min=-360, max=360 }

oreType.MinSpawnDistanceToOtherOres = 20

--//////////[ Main ]//////////--
--//////////////////////////////--

function oreType.new(...)
    return setmetatable(oreClass.new(...), oreType)
end

return oreType