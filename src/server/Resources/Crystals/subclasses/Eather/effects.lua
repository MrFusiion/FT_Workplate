local crystalClass = require(script.Parent.Parent.Parent.CrystalClass)

return {
    ["Poison"] = crystalClass.particle.new("ParticleEmitter", {
        Color = ColorSequence.new(Color3.fromRGB(170, 0, 127)),
        LightEmission = .4,
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(  0, 1   ),
            NumberSequenceKeypoint.new( .2, .625),
            NumberSequenceKeypoint.new( .6, 1.4 ),
            NumberSequenceKeypoint.new(.75, 3   ),
            NumberSequenceKeypoint.new(  1, 3   )
        }),
        Texture = "http://www.roblox.com/asset/?id=243664672",
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(  0, 1       ),
            NumberSequenceKeypoint.new( .5, .725    ),
            NumberSequenceKeypoint.new(.75, .85, .15),
            NumberSequenceKeypoint.new(  1, 1       )
        }),
        Acceleration = Vector3.new(),
        Lifetime = NumberRange.new(1, 2),
        Rate=50,
        Rotation = NumberRange.new(-360, 360),
        RotSpeed = NumberRange.new(-200, 200),
        Speed = NumberRange.new(.4),
        SpreadAngle = Vector2.new(100, 100)
    }),
    ["PoisionSparkles"] = crystalClass.particle.new("ParticleEmitter", {
        Color = ColorSequence.new(Color3.fromRGB(170, 0, 127)),
        Size = NumberSequence.new(.15, .05),
        Texture = "http://www.roblox.com/asset/?id=118322059",
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new( 0, 0),
            NumberSequenceKeypoint.new(.8, 0),
            NumberSequenceKeypoint.new( 1, 1)
        }),
        Acceleration = Vector3.new(0, .2, 0),
        Lifetime = NumberRange.new(1, 1.5),
        Rate=5,
        RotSpeed = NumberRange.new(20, 40),
        Speed = NumberRange.new(2, 4),
        SpreadAngle = Vector2.new(100, 100)
    })
}