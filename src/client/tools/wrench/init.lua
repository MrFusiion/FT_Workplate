local RS = game:GetService("RunService")
local wire = require(script:WaitForChild("wire"))

local player = game:GetService("Players").LocalPlayer

local GOOD_COLOR = BrickColor.new("Shamrock")
local BAD_COLOR = BrickColor.new("Crimson")
local MAX_LENGTH = 30

local wrench = {}
wrench.__index = wrench

function wrench.new(tool)
    local newWrench = setmetatable({}, wrench)
    newWrench.Tool = tool
    newWrench:init()
    return newWrench
end

function wrench:init()
    local mouse, result

    self.Tool.Equipped:Connect(function(m)
        mouse = m
        self.RSConnection = RS.Heartbeat:Connect(function()
            if result then
                self:setSelectionBox(result, false)
            end
            result = self:raycast(mouse)
            if result then
                self:setSelectionBox(result, true)
            end

            if self.PlaceHolder then
                self:movePlaceHolder(mouse, result)
                if result then
                    if self.Wire:getLength() <= MAX_LENGTH then
                        self.Wire:setColor(GOOD_COLOR)
                    else
                        self.Wire:setColor(BAD_COLOR)
                    end
                else
                    self.Wire:setColor(BAD_COLOR)
                end
            end
        end)
    end)

    self.Tool.Unequipped:Connect(function()
        if self.RSConnection then
            self.RSConnection:Disconnect()
        end

        if self.PlaceHolder then
            self.PlaceHolder:Destroy()
            self.PlaceHolder = nil
        end

        if self.Wire then
            self.Wire:destroy()
            self.Wire = nil
        end
    end)

    self.Tool.Activated:Connect(function()
        if not self.Connection0 and result then
            self.Connection0 = result.Instance.Parent.ConnectorPos
            self:createPlaceHolder(mouse)
            self.Wire = self:createWire()
        elseif self.Connection0 and result then
            self.PlaceHolder:Destroy()
            self.PlaceHolder = nil
            self.Wire:destroy()

            self.Connection1 = result.Instance.Parent.ConnectorPos

            --[[
                TODO add wire to undo table
            ]]--
            self:createWire()

            self.Connection0 = nil
            self.Connection1 = nil
        end
    end)
end

function wrench:createWire()
    if self.PlaceHolder then
        return wire.new(self.Connection0, self.PlaceHolder, BrickColor.new("Shamrock"))
    else
        return wire.new(self.Connection0, self.Connection1)
    end
end

function wrench:createPlaceHolder(mouse)
    local part = Instance.new("Part")
    part.Anchored = true
    part.Size = Vector3.new()
    part.Transparency = 1
    part.CanCollide = false
    part.Parent = self.Connection0
    self.PlaceHolder = part
    self:movePlaceHolder(mouse)
end

function wrench:movePlaceHolder(mouse, result)
    if result then
        self.PlaceHolder.Position = result.Instance.Parent.ConnectorPos.Position
    else
        self.PlaceHolder.Position = mouse.Hit.p
    end
end

function wrench:setSelectionBox(result, value)
    local connector = result.Instance
    local selectionBox = connector:FindFirstChildWhichIsA("SelectionBox")
    selectionBox.Transparency = value and 0 or 1
end

function wrench:raycast(mouse)
    local rayParams = RaycastParams.new()
    rayParams.CollisionGroup = "Connector"
	
    local unit = mouse.UnitRay
	
	return workspace:Raycast(unit.Origin, unit.Direction * 1000, rayParams)
end

return wrench