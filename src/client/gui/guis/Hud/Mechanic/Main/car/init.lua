local paint = require(script.paint)
local icons = require(script.icons)

local car = {}
car.__index = car

function car.new(model : Model)
    local newCar = setmetatable({}, car)
    newCar.Model = model
    newCar.Paint = paint.new(model)
    newCar.Icons = icons.new(model)
    return newCar
end

function car:upgrade()
    --TODO
end

function car:apply()
    self.Paint:apply()
    self.Icons:apply()
end

function car:cleanup()
    self.Paint:cleanup()
    self.Icons:cleanup()
end

return car