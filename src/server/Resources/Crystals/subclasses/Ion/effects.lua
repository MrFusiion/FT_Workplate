local crystalClass = require(script.Parent.Parent.Parent.CrystalClass)

return {
    ["Fire"] = crystalClass.particle.new("ParticleEmitter", {
        Color = ColorSequence.new(Color3.fromRGB(84, 255, 0), Color3.fromRGB(127, 255, 92)),
        LightEmission = 1,
        Size = NumberSequence.new(.5),
        Texture = "rbxasset://textures/particles/fire_main.dds",
        Transparency = NumberSequence.new(0),
        Acceleration = Vector3.new(),
        Lifetime = NumberRange.new(1.5, 2),
        Rate=100,
        Rotation = NumberRange.new(0, 5),
        RotSpeed = NumberRange.new(5, 25),
        Speed = NumberRange.new(.1),
    })
}