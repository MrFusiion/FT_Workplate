local core = require(script.Parent.Parent)
local tableUtils = core.shared.get("tableUtils")

local itemClass = require(script:WaitForChild("item"))
local element = core.roact.Component:extend("Blueprint")

function element:init()
    self.Connections = {}
    self:setState({
        selected = "",
        catogories = {},
    })
end

function element:render()
    return core.roact.createElement(core.elements.global:getConsumer(), {
        render = function(global)
            return core.roact.createElement("Frame", {
                AnchorPoint = Vector2.new(.5, .5),
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(.5, .5),
                Size = UDim2.fromOffset(core.scale:getOffset(1100), core.scale:getOffset(700)),
                Visible = false
            }, {
                ["Window"] = core.roact.createElement(core.elements.Window, {
                    Size = UDim2.fromScale(1, 1),
                    Title = "Blueprints",
                    CloseEnabled = false
                }, {
                    ["Layout"] = core.roact.createElement("UIListLayout", {
                        Padding = UDim.new(),
                        FillDirection = Enum.FillDirection.Horizontal,
                        SortOrder = Enum.SortOrder.LayoutOrder
                    }),
                    ["Left"] = core.roact.createElement("Frame", {
                        BackgroundTransparency = 1,
                        LayoutOrder = 0,
                        Size = UDim2.new(.15, core.scale:getOffset(-5), 1, 0),
                        ZIndex = 4
                    }, {
                        ["Scroll"] = core.roact.createElement("ScrollingFrame", {
                            AnchorPoint = Vector2.new(.5, .5),
                            BackgroundTransparency = 1,
                            BorderSizePixel = 0,
                            Position = UDim2.fromScale(.5, .5),
                            Size = UDim2.new(1, core.scale:getOffset(-25), 1, core.scale:getOffset(-25)),
                            ZIndex = 4,
                            BottomImage = "rbxassetid://5443758967",
                            MidImage = "rbxassetid://5443758967",
                            TopImage = "rbxassetid://5443758967",
                            AutomaticCanvasSize = Enum.AutomaticSize.Y,
                            ElasticBehavior = Enum.ElasticBehavior.Never,
                            ScrollBarImageColor3 = global.theme.BgClr,--Color3.fromRGB(160, 180, 255),
                            ScrollingDirection = Enum.ScrollingDirection.Y,
                            VerticalScrollBarInset = Enum.ScrollBarInset.Always,
                            [core.roact.Ref] = function(rbx) self.CatogoryScroll = rbx end
                        }, self:renderCatogories())
                    }),
                    ["Sep"] = core.roact.createElement("Frame", {
                        BackgroundColor3 = global.theme.BgClr,
                        BorderSizePixel = 0,
                        LayoutOrder = 1,
                        Size = UDim2.new(0, core.scale:getOffset(10), 1, 0),
                        ZIndex = 4
                    }),
                    ["Right"] = core.roact.createElement("Frame", {
                        BackgroundTransparency = 1,
                        LayoutOrder = 2,
                        Size = UDim2.new(.85, core.scale:getOffset(-5), 1, 0),
                        ZIndex = 4
                    }, self:renderItems(global))
                }),
                ["Selected"] = core.roact.createElement("StringValue", {
                    [core.roact.Ref] = function(rbx) self.Selected = rbx end
                }),
                ["Add"] = core.roact.createElement("BindableEvent", {
                    [core.roact.Ref] = function(rbx) self.Add = rbx end
                }),
                ["Remove"] = core.roact.createElement("BindableEvent", {
                    [core.roact.Ref] = function(rbx) self.Remove = rbx end
                }),
                ["BulkAdd"] = core.roact.createElement("BindableEvent", {
                    [core.roact.Ref] = function(rbx) self.BulkAdd = rbx end
                }),
                ["BulkRemove"] = core.roact.createElement("BindableEvent", {
                    [core.roact.Ref] = function(rbx) self.BulkRemove = rbx end
                }),
                ["Activated"] = core.roact.createElement("BindableEvent", {
                    [core.roact.Ref] = function(rbx) self.Activated = rbx end
                }),
                ["GetItemClass"] = core.roact.createElement("BindableFunction", {
                    [core.roact.Ref] = function(rbx) self.GetItemClass = rbx end
                })
            })
        end
    })
end

function element:renderCatogories()
    local catogories = {
        ["Layout"] = core.roact.createElement("UIGridLayout", {
            CellPadding = UDim2.fromOffset(core.scale:getOffset(15), core.scale:getOffset(15)),
            CellSize = UDim2.fromOffset(core.scale:getOffset(110), core.scale:getOffset(180)),
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center
        })
    }

    for _, catogory in pairs(self.state.catogories) do
        table.insert(catogories, catogory:render())
    end
    return catogories
end

function element:renderItems(global)
    self.Scrolls = {}
    local scrolls = {}
    for i, _, catogory in tableUtils.enumerate(self.state.catogories) do
        local items = catogory:renderSubItems()
        if #items == 0 then continue end

        items["Layout"] = core.roact.createElement("UIGridLayout", {
            CellPadding = UDim2.fromOffset(core.scale:getOffset(15), core.scale:getOffset(15)),
            CellSize = UDim2.fromOffset(core.scale:getOffset(110), core.scale:getOffset(180)),
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left
        })

        scrolls["Scroll["..catogory.Name.."]"] = core.roact.createElement("ScrollingFrame", {
            AnchorPoint = Vector2.new(.5, .5),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.fromScale(.5, .5),
            Size = UDim2.new(1, core.scale:getOffset(-25), 1, core.scale:getOffset(-25)),
            ZIndex = 4,
            BottomImage = "rbxassetid://5443758967",
            MidImage = "rbxassetid://5443758967",
            TopImage = "rbxassetid://5443758967",
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ElasticBehavior = Enum.ElasticBehavior.Never,
            ScrollBarImageColor3 = global.theme.BgClr,--Color3.fromRGB(160, 180, 255),
            ScrollingDirection = Enum.ScrollingDirection.Y,
            VerticalScrollBarInset = Enum.ScrollBarInset.Always,
            Visible = false,
            [core.roact.Ref] = function(rbx) self.Scrolls[catogory.Name] = rbx end,
        }, items)
    end
    return scrolls
end

function element:add(catogory, item)
    if not self.state.catogories[catogory.Name] then
        self.state.catogories[catogory.Name] = itemClass.new(catogory.Name, catogory.Image, item)
    end
    self.state.catogories[catogory.Name]:addSubItem(item)
end

function element:remove(catogoryName, itemName)
    if self.state.catogories[catogoryName] then
        self.state.catogories[catogoryName]:removeSubItem(itemName)
    end

    local count = 0
    for _ in pairs(self.state.catogories[catogoryName].Items) do
        count += 1
    end
    if count == 0 then
        self.state.catogories[catogoryName] = nil
    end
end

function element:update()
    self:setState({
        catogories = self.state.catogories
    })
end

function element:didUpdate()
    for _, conn in ipairs(self.Connections) do
        conn:Disconnect()
    end
    self.Connections = {}

    for _, catogory in pairs(self.state.catogories) do
        table.insert(self.Connections, catogory.Button.Activated:Connect(function()
            if self.Selected then
                if self.Scrolls[self.Selected.Value] then
                    self.Scrolls[self.Selected.Value].Visible = false
                end
                self.Scrolls[catogory.Name].Visible = true
                self.Selected.Value = catogory.Name
            end
        end))
        for _, item in pairs(catogory.Items) do
            if item.Button and item.Button.Parent then
                table.insert(self.Connections, item.Button.Activated:Connect(function()
                    self.Activated:Fire(item.Name)
                end))
            end
        end
    end

    self:updateScrollCanvasSizes()
end

function element:didMount()
    for _, catogory in pairs(self.state.catogories) do
        self.Selected.Value = catogory.Name
        break
    end

    self.Add.Event:Connect(function(catogory, item)
        item = setmetatable({}, itemClass)
        self:add(catogory, item)
        self:update()
    end)
    self.BulkAdd.Event:Connect(function(...)
        for _, catogory in ipairs{...} do
            for _, item in pairs(catogory.Items) do
                item = setmetatable(item, itemClass)
                self:add(catogory, item)
            end
        end
        self:update()
    end)

    self.Remove.Event:Connect(function(catogoryName, itemName)
        self:remove(catogoryName, itemName)
        self:update()
    end)
    self.BulkRemove.Event:Connect(function(catogoryName, ...)
        for _, itemName in ipairs{...} do
            self:remove(catogoryName, itemName)
        end
        self:update()
    end)

    self.GetItemClass.OnInvoke = function()
        return itemClass
    end

    self:test()
end

function element:updateScrollCanvasSizes()
    local function updateCanvasSize(scroll)
        local contentSize = scroll.Layout.AbsoluteContentSize
        scroll.CanvasSize = UDim2.fromOffset(contentSize.X, contentSize.Y)
    end

    updateCanvasSize(self.CatogoryScroll)
    for _, scroll in pairs(self.Scrolls) do
        updateCanvasSize(scroll)
    end
end

function element:test()
    local catogories = {}
    local blueprintFolder = game:GetService("ReplicatedStorage"):WaitForChild("BlueprintStructures")
    for _, catogoryFolder in ipairs(blueprintFolder:GetChildren()) do
        local catogory = itemClass.new(catogoryFolder.Name)
        for _, item in ipairs(catogoryFolder:GetChildren()) do
            local icon = item:WaitForChild("Image").Value
            catogory.Image = catogory.Image or icon
            catogory:addSubItem(itemClass.new(item.Name, icon))
        end
        table.insert(catogories, catogory)
    end
    self.BulkAdd:Fire(table.unpack(catogories))
end

return element