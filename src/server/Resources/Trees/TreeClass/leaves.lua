local shared = require(game:GetService('ReplicatedStorage'):WaitForChild('modules'))
local random = shared.get('random').new(nil, false)

local leaves = {}
leaves.__index = leaves

function randomRange(value : table) : float
	return random:nextNumber(value.min, value.max)
end

function randomRangeInteger(value : table) : int
	return random:nextInt(value.min, value.max)
end

function leaves:init(tree)
    self.Main = Instance.new('Part')
    self.Main.Name = 'LeafPart'
    self.Main.Anchored = true
    self.Main.CanCollide = false

    local shader = random:choice(tree.LeafColors)
    self.Main.BrickColor = shader.color
    self.Main.Material = shader.material
    self.Main.Transparency = randomRange(shader.transparency or { min=0, max=0 })

    self.Main.Parent = tree.LeafModel
end

function leaves:update(section)
    if self.Main.Parent then
        self.Main.Size = self.LeafSizeFactor * section.Thickness
        self.Main.CFrame = section.StartCFrame * CFrame.new(0, section.Length + .75 * self.Main.Size.Y*.5, 0) * self.LeafAngle
    end
end

function leaves:destroy()
    if self.Main.Parent then
        self.Main:Destroy()
    end
end

return leaves