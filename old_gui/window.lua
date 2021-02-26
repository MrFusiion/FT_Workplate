local Core = require(script.Parent.Parent:WaitForChild("Core"))
local TextButton = require(script.Parent.TextButton)

local TS = game:GetService("TweenService")

local DEFAULT_SIZE = Vector2.new(500, 300)

local element = Core.Roact.PureComponent:extend("__" .. script.Name .. "__")

function element:init()
	self.ExitButtonRef = Core.Roact.createRef()
	self.MainFrameRef = Core.Roact.createRef()
end

function element:render()
	return Core.Roact.createElement("Frame", {
		AnchorPoint = Vector2.new(.5, .5),
		BackgroundColor3= Color3.fromRGB(58, 59, 64),--Window border Color
		Position = UDim2.new(.5, 0, .5, 0),
		Size = self.props.Size and UDim2.fromOffset(self.props.Size.X.Offset, 0) or UDim2.fromOffset(Core.Scale:GetOffset(DEFAULT_SIZE.X), 0),
		Visible = false,
		[Core.Roact.Ref] = self.MainFrameRef
	}, {
		UICorner = Core.Roact.createElement("UICorner", { 
			CornerRadius = UDim.new(0, Core.Scale:GetOffset(10)) 
		}),
		Background = Core.Roact.createElement("Frame", {
			AnchorPoint = Vector2.new(.5, .5),
			BackgroundColor3 = Color3.fromRGB(200, 200, 200),--Window bg Color
			Position = UDim2.new(.5, 0, .5, 0),
			Size = UDim2.new(1, Core.Scale:GetOffset(-10), 1, Core.Scale:GetOffset(-10)),
			ZIndex = 2
		}, {
			UICorner = Core.Roact.createElement("UICorner", { 
				CornerRadius = UDim.new(0, Core.Scale:GetOffset(10)) 
			}),
			BackgroundImage = Core.Roact.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				ZIndex = 2,
				Image = "rbxassetid://5794241715",
				ImageColor3 = Color3.fromRGB(150, 150, 150),--Window bg patter color
				ScaleType = Enum.ScaleType.Tile,
				TileSize = UDim2.new(0, Core.Scale:GetOffset(100), 0, Core.Scale:GetOffset(100))
			}, {
				UICorner = Core.Roact.createElement("UICorner", { 
					CornerRadius = UDim.new(0, Core.Scale:GetOffset(10)) 
				})
			})
		}),
		Content = Core.Roact.createElement("Frame", {
			AnchorPoint = Vector2.new(.5, .5),
			BackgroundTransparency = 1,
			Position = UDim2.new(.5, 0, .5, 0),
			Size = UDim2.new(1, Core.Scale:GetOffset(-20), 1, Core.Scale:GetOffset(-20)),
			ZIndex = 2
		}, self.props[Core.Roact.Children] ),
		Title = Core.Roact.createElement("TextLabel", {
			AnchorPoint = Vector2.new(0, 1),
			BackgroundColor3 = Color3.fromRGB(58, 59, 64),--Title bg color
			Position = UDim2.new(0, 0, 0, Core.Scale:GetOffset(5)),
			Size = UDim2.new(1, 0, 0, Core.Scale:GetOffset(70)),
			Font = Enum.Font.SourceSansBold,
			Text = self.props.Title or "",
			TextColor3 = self.props.TitleColor3 or Color3.fromRGB(167,155,128),
			TextSize = Core.Scale:GetOffset(50),
			ZIndex = 2
		}, {
			UICorner = Core.Roact.createElement("UICorner", { 
				CornerRadius = UDim.new(0, Core.Scale:GetOffset(10)) 
			}),
			SpaceFilter = Core.Roact.createElement("Frame", {
				AnchorPoint = Vector2.new(.5, 1),
				BackgroundColor3 = Color3.fromRGB(58, 59, 64),
				BorderSizePixel = 0,
				Position = UDim2.new(.5, 0, 1, Core.Scale:GetOffset(2)),
				Size = UDim2.new(1, 0, .5, 0),
				ZIndex = 1
			}),
			ExitButton = Core.Roact.createElement(TextButton, {
				AnchorPoint = Vector2.new(1, 0),
				BackgroundColor3 = Color3.fromRGB(255, 65, 65),
				Modal = true,
				Position = UDim2.new(1, Core.Scale:GetOffset(-5), 0, Core.Scale:GetOffset(5)),
				Size = UDim2.new(1, Core.Scale:GetOffset(-10), 1, Core.Scale:GetOffset(-10)),
				SizeConstraint = Enum.SizeConstraint.RelativeYY,
				ZIndex = 3,
				Font = Enum.Font.GothamBlack,
				Text = "X",
				TextColor3 = Color3.fromRGB(127, 32, 32),
				TextSize = Core.Scale:GetOffset(50),
				[Core.Roact.Ref] = self.ExitButtonRef
			})
		})
	})
end

function element:didMount()
	assert(self.props.Name, "U forgot to Asign `Name` in `props`!")
	
	local EnabledV = Core.Gui:Add(self.props.Name, false)
	
	local ExitButton = self.ExitButtonRef.current
	local MainFrame = self.MainFrameRef.current
	
	ExitButton.Activated:Connect(function()
		EnabledV.Value = not EnabledV.Value
	end)
	
	local tweenOut = TS:Create(MainFrame, TweenInfo.new(.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
		Size = self.props.Size and UDim2.fromOffset(self.props.Size.X.Offset, 0) or UDim2.fromOffset(Core.Scale:GetOffset(DEFAULT_SIZE.X), 0),
	})
	
	tweenOut.Completed:Connect(function(state)
		if state == Enum.PlaybackState.Completed then
			MainFrame.Visible = false
			MainFrame.ClipsDescendants = false
		end
	end)
	
	local tweenIn= TS:Create(MainFrame, TweenInfo.new(.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
		Size = self.props.Size or UDim2.fromOffset(Core.Scale:GetOffset(DEFAULT_SIZE.X), Core.Scale:GetOffset(DEFAULT_SIZE.Y)),
	})
	
	EnabledV:GetPropertyChangedSignal("Value"):Connect(function()
		if EnabledV.Value then
			MainFrame.Visible = true
			tweenIn:Play()
		else
			MainFrame.ClipsDescendants = true
			tweenOut:Play()
		end
	end)
end
	
return element