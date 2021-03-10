local crystalClass = require(script.Parent.Parent.Parent.CrystalClass)

return {
    ["Electric"] = crystalClass.particle.new("ParticleEmitter", {
        Color = ColorSequence.new(Color3.new(1)),
        LightEmission = 1,
        Size = NumberSequence.new(2),
        Texture = "http://www.roblox.com/asset/?id=243098098",
        Transparency = NumberSequence.new(.7),
        Acceleration = Vector3.new(),
        Lifetime = NumberRange.new(.2),
        Rate=500,
        Rotation = NumberRange.new(0, 360),
    })
}