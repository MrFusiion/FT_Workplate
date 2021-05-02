local core = require(script.Parent)

local element = core.roact.Component:extend("ColorPicker")
local palleteButton = require(script.PalleteButton)

function element:init()
    self.Pallets = {}
end

function element:createRow(i, sizeOffset, count, colors)
    local buttons = {
        ['Layout'] = core.roact.createElement("UIListLayout", {
            Padding = UDim.new(0, 2),
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder
        })
    }

    for j=1, count do
        local bColor = colors[j]
        buttons[("Pallete_%d"):format(bColor.Number)] = core.roact.createElement(palleteButton, {
            ImageColor3 = bColor.Color,
            LayoutOrder = j,
            [core.roact.Ref] = function(rbx) table.insert(self.Pallets, { button = rbx, color = bColor }) end
        })
    end

    return core.roact.createElement("Frame", {
        BackgroundTransparency = 1,
        Size = core.scale.udim2.new(1, 0, 0, 29 + sizeOffset),
        LayoutOrder = i
    }, buttons)
end

function element:render()
    --Get Colors
    local colors = {}
    for i=0, 127 do
        local color = BrickColor.palette(i)
        table.insert(colors, color)
    end

    local greyScaleColors = {}
    for _, i in ipairs{ 128, 123, 124, 109, 50, 98, 4, 11, 30, 51, 76, 87 } do
        table.insert(greyScaleColors, colors[i])
    end

    local rows = {
        ['Chosen'] = core.roact.createElement("BindableEvent", {
            [core.roact.Ref] = function(rbx)
                self.__ChosenSignal = rbx
                self.Chosen = rbx.Event
            end
        }),
        ['Layout'] = core.roact.createElement("UIListLayout", {
            Padding = UDim.new(0, 2),
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder
        })
    }
    local index = 1
    for i=-6, 6 do
        local count = 13 - math.abs(i)
        rows[("row_%d"):format(i + 7)] = self:createRow(i + 7, 0, count, {select(index, table.unpack(colors))})
        index += count
    end
    rows["row_greyscale"] = self:createRow(14, 6, #greyScaleColors, greyScaleColors)

    return core.roact.createElement("Frame", {
        AnchorPoint = self.props.AnchorPoint or Vector2.new(.5, .5),
        BackgroundTransparency = 1,
        Position = self.props.Position or UDim2.new(),
        Size = self.props.Size or core.scale.udim2.fromOffset(500, 500),
        --Visible = self.props.Visible,
        [core.roact.Ref] = self.props[core.roact.Ref]
    }, rows)
end

function element:didMount()
    for _, pallete in ipairs(self.Pallets) do
        pallete.button.Activated:Connect(function()
            self.__ChosenSignal:Fire(pallete.color)
        end)
    end
end

return element