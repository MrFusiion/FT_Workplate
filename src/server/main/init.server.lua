local server = require(script.Parent:WaitForChild("Modules"))
local blueprint = server.get("blueprint")

local machines = require(script.Parent.Objects.machines)

local refPart = workspace:WaitForChild("BlueprintTest")
local function getCFrame(cf)
    return refPart.CFrame * cf
end

local gen_01 = machines.generators.bioGenerator.new(workspace, getCFrame(CFrame.new()))
local gen_02 = machines.generators.bioGenerator.new(workspace, getCFrame(CFrame.new(8, 0, 0)))

local tank_01 = machines.tanks.tank.new(workspace, getCFrame(CFrame.new(16, 0, 0)), "solid")

tank_01.Content.BrickColor = BrickColor.new(Color3.fromRGB(255, 0, 255))

local tank_02 = machines.tanks.tank.new(workspace, getCFrame(CFrame.new(22, 0, 0)), "fluid", "water")
local tank_03 = machines.tanks.tank.new(workspace, getCFrame(CFrame.new(28, 0, 0)), "fluid", "lava")
local tank_04 = machines.tanks.tank.new(workspace, getCFrame(CFrame.new(34, 0, 0)), "gas")

local waterWheel = machines.generators.waterWheel.new(workspace, getCFrame(CFrame.new(41, 0, 0)))

local function createBlueprint()
    local bp = blueprint.new(machines.generators.bioGenerator)

    local cf = getCFrame(CFrame.new(-8, 0, 0))
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
    local bp
    while true do
        bp = createBlueprint()
        wait(5)
        bp:Destroy()
        wait(2)
    end
end)
