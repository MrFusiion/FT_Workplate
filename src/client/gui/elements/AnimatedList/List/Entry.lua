local TS = game:GetService("TweenService")

local entry = {}
entry.TWEENINFO = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)--Defualt TweenInfo if not set
entry.__type = "ListEntry"

entry.__index = function(self, key)
    if typeof(entry[key]) == "function" then
        return entry[key]
    else
        for allowedKey, frame in pairs{
            ["Parent"] = self.Frame, ["Position"] = self.Content, ["LayoutOrder"] = self.Frame
        } do
            if key == allowedKey then
                return frame[allowedKey]
            end
        end
    end
    warn(("%s is not a valid propety of %s!"):format(key, entry.__type))
end

entry.__newindex = function(self, key, value)
    for allowedKey, frame in pairs{
        ["Parent"] = self.Frame, ["Position"] = self.Content, ["LayoutOrder"] = self.Frame
    } do
        if key == allowedKey then
            frame[allowedKey] = value
            return
        end
    end
    warn(("Cannot asign value to %s because %s is not a valid propety of %s!"):format(key, key, self.__type))
end

function entry.new(name, content, height)
    local newEntry = {}

    newEntry.Name = name
    newEntry.Content = content

    newEntry.Frame = Instance.new("Frame")
    newEntry.Frame.Name = name
    newEntry.Frame.BackgroundTransparency = 1
    newEntry.Frame.Size = UDim2.new(UDim.new(1, 0), content.Size.Y)

    content.Name = "Content"
    content.Position = UDim2.fromScale(1, 0)
    content.Parent = newEntry.Frame

    return setmetatable(newEntry, entry)
end

function entry.update(self, newEntry)
    newEntry.Frame.LayoutOrder = self.Frame.LayoutOrder
    newEntry.Frame.Parent = self.Frame.Parent
    self.Frame:Destroy()
    self.Frame = newEntry.Frame
end

function entry.destroy(self)
    self.Frame:Destroy()
    --self.Content:Destroy()
end

function entry.insertTween(self)
    return TS:Create(self.Content, entry.TWEENINFO, {
        Position = UDim2.new()
    })
end

function entry.removeTween(self)
    return TS:Create(self.Content, entry.TWEENINFO, {
        Position = UDim2.fromScale(1, 0)
    })
end

function entry.shiftDownTween(self, scale)
    return TS:Create(self.Content, entry.TWEENINFO, {
        Position = UDim2.fromScale(0, scale or 1)
    })
end

function entry.shiftUpTween(self, scale)
    return TS:Create(self.Content, entry.TWEENINFO, {
        Position = UDim2.fromScale(0, -(scale or 1))
    })
end

return entry