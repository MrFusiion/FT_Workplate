local shared = require(game:GetService('ReplicatedStorage'):WaitForChild('modules'))
local random = shared.get('random').new(nil, false)
local stringUtils = shared.get('stringUtils')

local region = require(script.region)
local regions = {}

local colorCache = {}
local function generateRandomColor()
    local function randomColor()
        local red = (random:nextInt(0, 255) + 255) * .5
        local green = (random:nextInt(0, 255) + 255) * .5
        local blue = (random:nextInt(0, 255) + 255) * .5
        return Color3.fromRGB(red, green, blue);
    end
    local function colorHex(color)
       return string.format('%02x%02x%02x', color.R*255, color.G*255, color.B*255)
    end
    local color
    repeat
        color = randomColor()
        wait()
    until color and not colorCache[colorHex(color)]
    colorCache[colorHex(color)] = color
    return color
end

local function getRegionParts(model)
    local regionParts = {}
    for _, child in ipairs(model:GetChildren()) do
        if child:IsA('Part') then
            table.insert(regionParts, child)
        end
    end
    return regionParts
end

local RegionFolder = workspace:WaitForChild('Regions')
if RegionFolder then
    for _, regionModel in ipairs(RegionFolder:GetChildren()) do
        if regionModel:IsA('Model') then
            local reg = region.new(regionModel.Name, getRegionParts(regionModel), generateRandomColor())
            regions[regionModel.Name] = reg
            reg.OnEnter:Connect(function(player)
                if player then
                    print('enter', stringUtils.sepUppercase(reg.Name), player.Name)
                    player.Region.Value = stringUtils.sepUppercase(reg.Name)
                end
            end)
            reg.OnLeave:Connect(function(player)
                if player then
                    print('leave', stringUtils.sepUppercase(reg.Name), player.Name)
                end
            end)
        end
    end
end