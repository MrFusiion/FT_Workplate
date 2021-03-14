--[[
local server = require(script.Parent:WaitForChild("Modules"))
local blueprint = server.get("blueprint")

local objects = require(script.Parent:WaitForChild("Objects"))

local gen_01 = objects.machines.generators.bioGenerator.new(workspace, CFrame.new())
local gen_02 = objects.machines.generators.bioGenerator.new(workspace, CFrame.new(8, 0, 0))

local tank_01 = objects.machines.tanks.tank.new(workspace, CFrame.new(16, 0, 0), "solid")

tank_01.Content.BrickColor = BrickColor.new(Color3.fromRGB(255, 0, 255))

local tank_02 = objects.machines.tanks.tank.new(workspace, CFrame.new(22, 0, 0), "fluid", "water")
local tank_03 = objects.machines.tanks.tank.new(workspace, CFrame.new(28, 0, 0), "fluid", "lava")
local tank_04 = objects.machines.tanks.tank.new(workspace, CFrame.new(34, 0, 0), "gas")

local waterWheel = objects.machines.generators.waterWheel.new(workspace, CFrame.new(41, 0, 0))

local function createBlueprint()
    local bp = blueprint.new(objects.machines.generators.bioGenerator)

    local cf = CFrame.new(-8, 0, 0)
    bp:SetPrimaryPartCFrame(cf + cf.UpVector * bp.PrimaryPart.Size.Y / 2)
    bp.Parent = workspace
    return bp
end

local values = {
    {gen_01, .2},
    {gen_02, 1},
    {tank_01, .5},
    {tank_02, 5},
    {tank_03, 1},
    {tank_04, 1}
}

spawn(function()
    while wait() do
        for _, v in ipairs(values) do
            v[1].Content:add(v[2])
        end
        wait(.5)
    end
end)

spawn(function()
    local count = 0
    local bp
    while true do
        bp = createBlueprint()
        if count >= 2 then
            break
        end
        wait(5)
        bp:Destroy()
        wait(2)
        count += 1
    end
    bp:Place()
    bp:Destroy()
end)
]]