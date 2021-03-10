local crystalClass = require(script.Parent.Parent.Parent.CrystalClass)

return {
    ["Sparkles"] = crystalClass.particle.new("ParticleEmitter", {
        Color = ColorSequence.new(Color3.fromRGB(92, 163, 255), Color3.fromRGB(176, 212, 255)),
        LightEmission = 1,
        LightInfluence = 1,
        Size = NumberSequence.new(.5, .1),
        Texture = "rbxasset://textures/particles/sparkles_main.dds",
        Transparency = NumberSequence.new(0, 1),
        Acceleration = Vector3.new(),
        Drag = .25,
        Lifetime = NumberRange.new(1),
        Rate=20,
        RotSpeed = NumberRange.new(130),
        Speed = NumberRange.new(5),
        SpreadAngle = Vector2.new(10, 10)
    }),
}