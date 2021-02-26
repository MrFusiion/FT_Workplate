local color = {}

function color.shade(clr, factor)
    assert(typeof(clr)=='Color3', " `clr` must be a Color3!")
    assert(typeof(factor)=='number', " `factor` must be a number!")
    return Color3.new(
        clr.R * (1 - factor),
        clr.G * (1 - factor),
        clr.B * (1 - factor)
    )
end

function color.tint(clr, factor)
    assert(typeof(clr)=='Color3', " `clr` must be a Color3!")
    assert(typeof(factor)=='number', " `factor` must be a number!")
    return Color3.new(
        clr.R + (1 - clr.R) * factor,
        clr.G + (1 - clr.G) * factor,
        clr.B + (1 - clr.B) * factor
    )
end

function color.auto(clr, factor, tolerance)
    tolerance = tolerance or .5
    assert(typeof(clr)=='Color3', " `clr` must be a Color3!")
    assert(typeof(factor)=='number', " `factor` must be a number!")
    assert(typeof(tolerance)=='number', " `tolerance` must be a number or nil!")
    return color.getLuma(clr) < tolerance and color.tint(clr, factor) or color.shade(clr, factor)
end

--returns a value between (0 - 1)
--where 0 is darkest and 1 is the lightest
function  color.getLuma(clr)
    assert(typeof(clr)=='Color3', " `clr` must be a Color3!")
    local luma = .2126 * clr.R + .7152 * clr.G + .0722 * clr.B
    return math.clamp(luma, 0, 1)
end

return color