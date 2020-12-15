local color = {}

function color.shade(color, factor)
    assert(typeof(color)=='Color3', " `color` must be a Color3!")
    assert(typeof(factor)=='number', " `factor` must be a number!")
    return Color3.new(
        color.R * (1 - factor),
        color.G * (1 - factor),
        color.B * (1 - factor)
    )
end

function color.tint(color, factor)
    assert(typeof(color)=='Color3', " `color` must be a Color3!")
    assert(typeof(factor)=='number', " `factor` must be a number!")
    return Color3.new(
        color.R + (1 - color.R) * factor,
        color.G + (1 - color.G) * factor,
        color.B + (1 - color.B) * factor
    )
end

--returns a value between (0 - 1)
--where 0 is darkest and 1 is the lightest
function  color.getLuma(color)
    assert(typeof(color)=='Color3', " `color` must be a Color3!")
    local luma = .2126 * color.R + .7152 * color.G + .0722 * color.B
    return math.clamp(luma, 0, 1)
end

return color