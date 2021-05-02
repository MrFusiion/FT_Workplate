local core = require(script.Parent)

local list = require(script.List)

local element = core.roact.Component:extend(("__%s__"):format(script.Name))

function element:render()
    local props = core.shallowCopyTable(self.props)

    core.distRef(props, function(rbx)
        self.Frame = rbx
    end)

    if next(props[core.roact.Children] or {}) ~= nil then
        warn("AnimatedList does not accept child elements!")
        props[core.roact.Children] = nil
    end

    core.transfer(props, self, "EntryHeight", core.scale:getOffset(50))

    local layoutProps = {
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder
    }
    core.transfer(props, layoutProps, "Padding")

    --Default props
    props.ClipsDescendants = true

    return core.roact.createElement("Frame", props, {
        ["Layout"] = core.roact.createElement("UIListLayout", layoutProps),
        ["AddItem"] = core.roact.createElement("BindableEvent", {
            [core.roact.Ref] = function(rbx) self.AddItem = rbx end
        }),
        ["InsertItem"] = core.roact.createElement("BindableEvent", {
            [core.roact.Ref] = function(rbx) self.InsertItem = rbx end
        }),
        ["RemoveItem"] = core.roact.createElement("BindableEvent", {
            [core.roact.Ref] = function(rbx) self.RemoveItem = rbx end
        }),
        ["GetItem"] = core.roact.createElement("BindableFunction", {
            [core.roact.Ref] = function(rbx) self.GetItem = rbx end
        })
    })
end

local function createEntries(height, ...)
    local entries = {}
    for _, frame in ipairs{...} do
        table.insert(entries, list.entry.new(frame.Name, frame, height))
    end
    return table.unpack(entries)
end

function element:didMount()
    self.List = list.new(self.Frame)

    self.AddItem.Event:Connect(function(...)
        self.List:add(createEntries(self.EntryHeight, ...))
    end)

    self.InsertItem.Event:Connect(function(index, ...)
        self.List:insert(index, createEntries(self.EntryHeight, ...))
    end)

    self.RemoveItem.Event:Connect(function(...)
        self.List:remove(...)
    end)

    function self.GetItem.OnInvoke(name)
        local entry = self.Frame:FindFirstChild(name)
        return entry and entry.Content or nil
    end
end

return element