local core = require(script.Parent)

local DFLT_BG_IMAGE = 'rbxassetid://6093172294'

local element = core.roact.PureComponent:extend("__" .. script.Name .. "__")

function element:init()
    self.running = true
    self.ImageRef = function(rbx) self.Image = rbx end
end

function element:render()
    return core.roact.createElement(core.theme:getConsumer(), {
        render = function(theme)
            local props = core.deepCopyTable(self.props)

            --transfer custom props
            self.Time = props.Time
            props.Time = nil
            self.TileSize = props.TileSize or UDim2.new(0, core.scale:getOffset(400), 0, core.scale:getOffset(400))
            props.TileSize = nil
        
            props.BorderSizePixel = 0
            props.BackgroundTransparency = 1
            props.ClipsDescendants = true
        
            --////[children]////--
            local children = props[core.roact.Children] or {}
            props[core.roact.Children] = nil
        
            children.Image = core.roact.createElement("ImageLabel", {
                BorderSizePixel = 0,
                Size = UDim2.new(1.5, 0, 1.5, 0),
                Image = DFLT_BG_IMAGE,
                ImageColor3 = core.color.getLuma(theme.BgClr) >= .5 and core.color.shade(theme.BgClr, .25) or core.color.tint(theme.BgClr, .25),
                ScaleType = Enum.ScaleType.Tile,
                TileSize = self.TileSize,
                [core.roact.Ref] = self.ImageRef
            })
        
            return core.roact.createElement("Frame", props, children)
        end
    })
end

function element:didMount()
    local tween = core.TS:Create(self.Image, TweenInfo.new(self.Time or 1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, core.scale:getOffset((-57/400)*self.TileSize.X.Offset), 0, core.scale:getOffset((-57/400)*self.TileSize.X.Offset))
    })
    spawn(function()
        tween:Play()
        tween.Completed:Connect(function()
            self.Image.Position = UDim2.new()
            if self.running then
                tween:Play()
            end
        end)
    end)
end

function element:willUnmount()
    self.running = false
end

return element
