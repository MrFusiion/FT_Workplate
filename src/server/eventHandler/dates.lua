local shared = require(game:GetService('ReplicatedStorage'):WaitForChild('modules'))
local mathUtils = shared.get('mathUtils')

return {
    Halloween = function()
        return '31/10'
    end,
    Christmas = function()
        return '25/12'
    end,
    Easter = function(_, _, year) --True for years (2000-2099)
        year = tonumber(year)
        local D = 225 - 11 * (year % 19)
        if D > 50 then
            while D > 51 do
                D -= 30
            end
        elseif D > 48 then
            D -= 1
        end
        local E = (year + math.floor(year / 4) + D + 1) % 7
        local Q = D + 7 - E
        if Q < 32 then
            return string.format('%02d/03', Q)
        else
            return string.format('%02d/04', Q)
        end
    end
}