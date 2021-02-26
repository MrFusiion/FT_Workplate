--rbxassetid://2347145012
local core = require(script.Parent.Parent)

local element = core.roact.Component:extend('BlueprintV2')

function element:init()
    self.Connections = {}
    self.Buttons = {}
end

local function NormalIdToText(normadId)
    return string.gsub(tostring(normadId), 'Enum.NormalId.', '')
end

local offset = 0
local maxDepth = 40
local minSize = 12
local function getPositionAndSize(normalId, part)
    local camera = workspace.CurrentCamera
    local normalVector = Vector3.fromNormalId(normalId)
    local partVector = camera:WorldToScreenPoint(part.CFrame.p)

    local pos = part.CFrame.p
        + part.CFrame.RightVector   * normalVector.X * (part.Size.X/2 + offset)
        + part.CFrame.UpVector      * normalVector.Y * (part.Size.Y/2 + offset)
        + part.CFrame.LookVector    * normalVector.Z * (part.Size.Z/2 + offset)

    local vector, onScreen = camera:WorldToScreenPoint(pos)
    return UDim2.fromOffset(vector.X, vector.Y),
        --UDim2.fromOffset(math.floor(60 - (partVector.Z / 60)), math.floor(60 - (partVector.Z / 60))),
        onScreen
end

function element:render()
    return core.roact.createElement(core.elements.global:getConsumer(), {
        render = function(global)
            local buttons = {}
            for _, normalId in ipairs(Enum.NormalId:GetEnumItems()) do
                buttons[NormalIdToText(normalId)] = core.roact.createElement('ImageButton', {
                    AnchorPoint = Vector2.new(.5, .5),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(),
                    Size = UDim2.fromOffset(60, 60),
                    Image = 'rbxassetid://2347145012',
                    ImageColor3 = Color3.fromRGB(85, 170, 255),
                    ImageTransparency = .5,
                    Visible = false,
                    [core.roact.Ref] = function(rbx) table.insert(self.Buttons, { button = rbx, normalId = normalId }) end
                })
            end

            buttons['Selected'] = core.roact.createElement('ObjectValue', {
                [core.roact.Ref] = function(rbx) self.ObjectV = rbx end
            })

            return core.roact.createFragment(buttons)
        end
    })
end

function element:didUpdate()
    
end

function element:didMount()
    self.ObjectV:GetPropertyChangedSignal('Value'):Connect(function()
        for _, conn in ipairs(self.Connections) do
            conn:Disconnect()
        end
        self.Connections = {}

        if self.ObjectV.Value then
            local camera = workspace.CurrentCamera
            table.insert(self.Connections, camera:GetPropertyChangedSignal('CFrame'):Connect(function()
                for _, btnData in ipairs(self.Buttons) do
                    local pos, size, onScreen = getPositionAndSize(btnData.normalId, self.ObjectV.Value)
                    btnData.button.Position = pos
                    --btnData.button.Size = size
                    btnData.button.Visible = onScreen
                end
            end))
        else
            for _, btnData in ipairs(self.Buttons) do
                btnData.button.Visible = false
            end
        end
    end)

    wait(5)
    self.ObjectV.Value = workspace:WaitForChild('TestBuildPart')
    print('Assigned')
end

return element