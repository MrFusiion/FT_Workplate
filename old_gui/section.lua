local Core = require(script.Parent.Parent.Parent.Parent:WaitForChild("Core"))

local Section = Core.Roact.Component:extend("Section")

function Section:init()
	self:setState({
		open = true
	})
	self.DropDownButtonRef = Core.Roact.createRef()
end

function Section:render()	
	return Core.Roact.createElement("Frame", {
		BackgroundColor3 = Color3.fromRGB(58, 59, 64),--self.props.Color,
		LayoutOrder = self.props.LayoutOrder or 0,
		Size = UDim2.new(1, Core.Scale:GetOffset(-20), 0, Core.Scale:GetOffset(self.state.open and (self.props.Size or 250) + 50 or 50)),
		ZIndex = 2,
		[Core.Roact.Ref] = self.props[Core.Roact.Ref]
	}, {
		UICorner = Core.Roact.createElement("UICorner", { 
			CornerRadius = UDim.new(0, Core.Scale:GetOffset(10)) 
		}),
		Title = Core.Roact.createElement("TextLabel", {
			AnchorPoint = Vector2.new(.5, 0),
			BackgroundTransparency = 1,
			Position = UDim2.new(.5, 0, 0, 0),
			Size = UDim2.new(1, 0, 0, Core.Scale:GetOffset(50)),
			ZIndex = 2,
			Font = Enum.Font.SourceSansBold,
			Text = self.props.Title,
			TextColor3 = Color3.fromRGB(167,155,128), --Color3.new(1, 1, 1),
			TextSize = Core.Scale:GetTextSize(40)
		}, {
			DropDownButton = Core.Roact.createElement(Core.Elements:Get("ImageButton"), {
				AnchorPoint = Vector2.new(1, .5),
				BackgroundColor3 = Core.Color.Shade(Color3.fromRGB(58, 59, 64), .75),--Core.Color.Shade(self.props.Color, .75),
				Position = UDim2.new(1, Core.Scale:GetOffset(-10), .5, 0),
				Size = UDim2.new(1, Core.Scale:GetOffset(-10), 1, Core.Scale:GetOffset(-10)),
				SizeConstraint = Enum.SizeConstraint.RelativeYY,
				ZIndex = 2,
				Image = self.state.open and "rbxassetid://5799809399" or "rbxassetid://5795345504",
				ImageColor3 = Core.Color.Shade(Color3.fromRGB(58, 59, 64), .6),--Core.Color.Shade(self.props.Color, .50),
				[Core.Roact.Ref] = self.DropDownButtonRef
			}, {
				UICorner = Core.Roact.createElement("UICorner", { 
					CornerRadius = UDim.new(0, Core.Scale:GetOffset(10)) 
				})
			})
		}),
		Background = Core.Roact.createElement("Frame", {
			AnchorPoint = Vector2.new(.5, 1),
			BackgroundColor3 = Core.Color.Shade(Color3.fromRGB(58, 59, 64), .75),--Core.Color.Shade(self.props.Color, .75),
			Position = UDim2.new(.5, 0, 1, Core.Scale:GetOffset(-10)),
			Size = UDim2.new(1, Core.Scale:GetOffset(-20), 1, Core.Scale:GetOffset(-60)),
			Visible = self.state.open,
			ZIndex = 2
		}, {
			UICorner = Core.Roact.createElement("UICorner", { 
				CornerRadius = UDim.new(0, Core.Scale:GetOffset(10)) 
			}),
			BackgroundImage = Core.Roact.createElement("ImageLabel", {
				AnchorPoint = Vector2.new(.5, .5),
				BackgroundTransparency = 1,
				Position = UDim2.new(.5, 0, .5, 0),
				Size = UDim2.new(1, 0, 1, 0),
				ZIndex = 3,
				Image = "rbxassetid://5794241715",
				ImageColor3 = Core.Color.Shade(Color3.fromRGB(58, 59, 64), .6),--Core.Color.Shade(self.props.Color, .50),
				ScaleType = Enum.ScaleType.Tile,
				TileSize = UDim2.new(0, Core.Scale:GetOffset(100), 0, Core.Scale:GetOffset(100))
			}, {
				UICorner = Core.Roact.createElement("UICorner", { 
					CornerRadius = UDim.new(0, Core.Scale:GetOffset(10)) 
				})
			})
		}),
		Content = Core.Roact.createElement("Frame", {
			AnchorPoint = Vector2.new(.5, 1),
			BackgroundTransparency = 1,
			Position = UDim2.new(.5, 0, 1, Core.Scale:GetOffset(-20)),
			Size = UDim2.new(1, Core.Scale:GetOffset(-40), 1, Core.Scale:GetOffset(-80)),
			Visible = self.state.open
		}, self.props[Core.Roact.Children])
	})
end

function Section:didMount()	
	local dropDownButton = self.DropDownButtonRef.current
	
	dropDownButton.Activated:Connect(function()
		self:setState({
			open = not self.state.open
		})
	end)
end

function Section:didUpdate()
	print(("Section did Update %s"):format(self.props.Title))
end

return Section
