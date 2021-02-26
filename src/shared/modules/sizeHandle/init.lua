local handle = require(script.handle)
local sizeHandle = {}
sizeHandle.__index = sizeHandle

function sizeHandle.new(part)
    local newSizeHandle = setmetatable({}, sizeHandle)
    newSizeHandle.Handles = {}
    for i, normalId in ipairs(Enum.NormalId:GetEnumItems()) do
        local hand = handle.new(normalId, part, 1)

        hand.MouseButton1Down:Connect(function()
            for j, hand in ipairs(newSizeHandle.Handles) do
                if i ~= j then
                    hand.Handle.Radius = .1
                end
            end
        end)

        hand.MouseButton1Up:Connect(function()
            for _, hand in ipairs(newSizeHandle.Handles) do
                hand.Handle.Radius = .5
            end
        end)

        local camera = workspace.CurrentCamera
        hand.MouseDrag:Connect(function(dist)
            print(math.floor(dist))
        end)

        newSizeHandle.Handles[i] = hand
    end

    newSizeHandle.SizeConnection = part:GetPropertyChangedSignal('Size'):Connect(function()
        for _, hand in ipairs(newSizeHandle.Handles) do
            hand:updateSizeOffset()
        end
    end)
    print('new Handle')
    return newSizeHandle
end

function sizeHandle:destroy()
    for _, hand in ipairs(self.Handles) do
        hand:destroy()
    end
end

return sizeHandle