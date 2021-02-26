local Core = require(script:FindFirstAncestorWhichIsA("LocalScript"):WaitForChild("Core"))

local Settings = Core.Roact.Component:extend("Settings")

function Settings:GetSections()
	self.SectionsRef = {}
	self.LayoutRef = Core.Roact.createRef()
	local sections = {
		Layout = Core.Roact.createElement("UIListLayout", {
			Padding = UDim.new(0, Core.Scale:GetOffset(20)),
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			[Core.Roact.Ref] = self.LayoutRef
		})
	}
	local sectionsFolder = script:WaitForChild("Sections")
	for _, section in pairs(sectionsFolder:GetChildren()) do
		self.SectionsRef[section.Name] = Core.Roact.createRef()
		local suc, component = pcall(function()
			return require(section)
		end)
		if not suc then
			warn(("Couldn't load %s Module!"):format(section.Name))
		else
			sections[section.Name] = Core.Roact.createElement(component, {
				[Core.Roact.Ref] = self.SectionsRef[section.Name]
			})
		end
	end
	return sections
end

function Settings:init()
	self.ScrollRef = Core.Roact.createRef()
end

function Settings:render()
	return Core.Roact.createElement(Core.Elements:Get("Window"), {
		Name = "Settings",
		Size = UDim2.new(0, Core.Scale:GetOffset(1100), 0, Core.Scale:GetOffset(700)),
		Title = "Settings"
	}, {
		Scroll = Core.Roact.createElement("ScrollingFrame", {
			AnchorPoint = Vector2.new(.5, .5),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.new(.5, 0, .5, 0),
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = 3,
			--AutomaticCanvasSize = Enum.AutomaticSize.Y,
			--CanvasSize = UDim2.new(0, 0, 4, 0),
			ScrollBarImageColor3 = Color3.fromRGB(24, 24, 24),
			ScrollBarThickness = Core.Platform:GetCurrentInputType() == "TOUCH" and 0 or 24,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			VerticalScrollBarInset = Enum.ScrollBarInset.Always,
			VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right,
			[Core.Roact.Ref] = self.ScrollRef
		}, self:GetSections())
	})
end

function Settings:didMount()
	--ScrollFrame Sizeing
	local updateScroll
	updateScroll = function(connectSignal)
		local scrollFrame = self.ScrollRef.current
		local layout = self.LayoutRef.current
		
		local padding = layout.Padding.Offset
		
		local totalYSize = 0
		for _, sectionRef in pairs(self.SectionsRef) do
			local section = sectionRef.current
			
			if connectSignal then
				section:GetPropertyChangedSignal("Size"):Connect(function()
					updateScroll()
				end)
			end
			
			totalYSize += section.AbsoluteSize.Y + padding
		end
		totalYSize -= padding
		
		scrollFrame.CanvasSize = UDim2.new(0, 0, 0, totalYSize)
	end
	updateScroll(true)
end

return Settings
