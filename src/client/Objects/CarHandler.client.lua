local L = game:GetService("Lighting")

local client = require(game:GetService("StarterPlayer").StarterPlayerScripts.Modules)
local playerUtils = client.get("playerUtils")
local input = client.get("input")

local shared = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"))
local mathUtils = shared.get("mathUtils")

local carFolder = game:GetService("ReplicatedStorage"):WaitForChild("Cars")
local function isCar(model)
    return carFolder:FindFirstChild(model.Name) ~= nil
end

local lastSeat
local function seated(active, seat)
    if seat and seat:IsA("VehicleSeat") and isCar(seat.Parent) then--at this time their should not be any object other then a car that has a VehicleSeat but to be future proof added this extra check (isCar)
        lastSeat = seat
        local car = seat.Parent
        if active then
            if not mathUtils.between(L.ClockTime, 6.001, 17.999) then
                car.EnableLight:FireServer(true)
            end
            input.bind("CarHeadLight", input.beginWrapper(function()
                car.EnableLight:FireServer()
            end), true, Enum.KeyCode.H, Enum.KeyCode.DPadUp)
        end
    elseif lastSeat then
        local car = lastSeat.Parent
        car.EnableLight:FireServer(false)
        input.safeUnbind("CarHeadLight")
        lastSeat = nil
    end
end

playerUtils.getHumanoid().Seated:Connect(seated)
playerUtils.onDead(function()
    playerUtils.getHumanoid().Seated:Connect(seated)
end)