local TWEENTIME = .15
local TWEENSTYLE = Enum.EasingStyle.Sine
local TWEENDIRECTION = Enum.EasingDirection.InOut

local queue = require(script.Queue)

local list = {}
list.__index = list

list.entry = require(script.Entry)
list.entry.TWEENINFO = TweenInfo.new(TWEENTIME, TWEENSTYLE, TWEENDIRECTION)

--===============================================================================================--
--=========================================[List Object]=========================================--

function list.new(parent)
    local newList = setmetatable({}, list)

    newList.Parent = parent
    newList.Entries = {}
    newList.LayoutOrder = {}
    newList.Count = 0
    newList.Queue = queue.new()

    return newList
end

local function list_add(self, index, ...)
    self.Queue:add(function(...)
        local entries = {...}
        local shiftEntries, insertEntries = {}, {}

        --shift the list and create a shift tween for later use
        for _, entry in pairs({select(index, table.unpack(self.LayoutOrder))}) do
            entry.LayoutOrder += #entries
            self.LayoutOrder[entry.LayoutOrder] = entry
            table.insert(shiftEntries, entry)
        end

        for entryI, entry in ipairs(entries) do
            local oldEntry = self.Entries[entry.Name]
            if oldEntry then
                oldEntry:update(entry)
            else
                self.Entries[entry.Name] = entry
                entry.LayoutOrder = index + (entryI - 1)
                self.LayoutOrder[entry.LayoutOrder] = entry
                table.insert(insertEntries, entry)
            end
        end

        --Animation--
        --__Shift__--
        for _, entry in ipairs(shiftEntries) do
            entry:shiftDownTween():Play()
        end
        wait(TWEENTIME + .01)

        --__Insert__--
        for _, entry in ipairs(insertEntries) do
            entry.Parent = self.Parent
            entry:insertTween():Play()
        end
        for _, entry in ipairs(shiftEntries) do
            entry.Position = UDim2.new()
        end

        self.Count += #entries
    end, ...)
end

function list:insert(index, ...)
    if index > #self.Entries + 1 then
        warn(("Insert index [%d] is out of range, index has been set to [%d] if this was not intended you should take a look at your insert functions!"):format(index, #self.Entries))
        index = #self.Entries
    end
    list_add(self, index < 0 and #self.LayoutOrder + index or index, ...)
end

function list:add(...)
    list_add(self, #self.Entries + 1, ...)
end

function list:remove(...)
    self.Queue:add(function(...)
        local removeEntries, shiftEntries = {}, {}

        local entries = {}
        for _, entryName in pairs{...} do
            local entry = self.Entries[entryName]
            if entry then
                entries[entry.Name] = entry
                self.Entries[entryName] = nil
                self.LayoutOrder[entry.LayoutOrder] = nil
                table.insert(removeEntries, entry)
            else
                warn(("Tried do destroy Entry with the name %s but the Entry was not found and!"):format(entryName))
            end
        end

        for _, entry in pairs(entries) do
            for i = entry.LayoutOrder + 1, #self.LayoutOrder do
                local after = self.LayoutOrder[i]
                if after and not entries[after.Name] then
                    if shiftEntries[after.Name] then
                        shiftEntries[after.Name].count += 1
                    else
                        shiftEntries[after.Name] = { count = 1, entry = after }
                        self.LayoutOrder[after.LayoutOrder] = nil
                    end
                end
            end
        end
        for _, entryT in pairs(shiftEntries) do
            entryT.order = entryT.entry.LayoutOrder - entryT.count
            self.LayoutOrder[entryT.order] = entryT.entry
        end

        --Animation--
        --__Remove__--
        for _, entry in ipairs(removeEntries) do
            entry:removeTween():Play()
        end
        --__Shift__--
        for _, entryT in pairs(shiftEntries) do
            entryT.entry:shiftUpTween(entryT.count):Play()
        end
        wait(TWEENTIME + .01)

        for _, entryT in pairs(shiftEntries) do
            entryT.entry.LayoutOrder = entryT.order
            entryT.entry.Position = UDim2.new()
        end
        for _, entry in ipairs(removeEntries) do
            entry:destroy()
        end

        self.Count -= #removeEntries

        print(self.LayoutOrder)
    end, ...)
end

return list