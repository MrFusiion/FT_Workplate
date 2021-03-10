local car = {}
car.__index = car

function car.new(props)
    local newCar = setmetatable({}, car)
    newCar.Motor =  typeof(props['motor'])  == 'table' and props['motor']   or {props['motor']}
    newCar.Steer =  typeof(props['steer'])  == 'table' and props['steer']   or {props['steer']}
    newCar.Driver = props['driver']
    newCar.Seat =   typeof(props['seat'])   == 'table' and props['seat']    or {props['seat']}

    newCar.Driver:GetPropertyChangedSignal("SteerFloat"):Connect(function()
        newCar:steer(newCar.Driver.SteerFloat)
    end)

    newCar.Driver:GetPropertyChangedSignal("ThrottleFloat"):Connect(function()
        newCar:throttle(newCar.Driver.ThrottleFloat)
    end)

    return newCar
end

function car:steer(value)
    for _, steer in pairs(self.Steer) do
        local angle = math.abs(math.min(steer.LowerAngle, steer.UpperAngle))
        steer.TargetAngle = angle * value
    end
end

function car:throttle(value)
    for _, motor in pairs(self.Motor) do
        local maxSpeed = self.Driver.MaxSpeed
        motor.AngularVelocity = maxSpeed * value
    end
end

return car