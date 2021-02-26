local Core = require(script:FindFirstAncestorWhichIsA("LocalScript"):WaitForChild("Core"))
local TS = game:GetService("TweenService")

local SideButtons = Core.Roact.Component:extend("SideButtons")
local Buttons = require(script:WaitForChild("Buttons"))

function SideButtons:CreateButtons()	
	
	local buttons = {
		Layout = Core.Roact.createElement("UIListLayout", { 
			Padding = UDim.new(0, Core.Scale:GetOffset(8)),
			SortOrder = Enum.SortOrder.LayoutOrder
		})
	}
	
	for name, buttonInfo in pairs(Buttons) do
		buttons[name.."_Frame"] = Core.Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = buttonInfo.LayoutOrder,
			SizeConstraint = Enum.SizeConstraint.RelativeXX,
			Size = UDim2.new(1, 0, 1, 0),
		}, {
			[name.."Button"] = Core.Roact.createElement(Core.Elements:Get("ImageButton"), {
				AutoButtonColor = false,
				BackgroundColor3 = buttonInfo.Color,
				Size = UDim2.new(1, 0, 1, 0),
				ZIndex = 2,
				Image = buttonInfo.Icon,
				ImageColor3 = Color3.fromRGB(60, 60, 60),
				[Core.Roact.Event.Activated] = function() buttonInfo.Func() end
			}, {
				UICorner = Core.Roact.createElement("UICorner", { 
					CornerRadius = UDim.new(0, Core.Scale:GetOffset(10)) 
				}),
				Border = Core.Roact.createElement("Frame", {
					BackgroundColor3 = Color3.fromRGB(120, 120, 120),
					Position = UDim2.new(0, 0, 0, Core.Scale:GetOffset(5)),
					Size = UDim2.new(1, 0, 1, 0),
				}, {
					UICorner = Core.Roact.createElement("UICorner", { 
						CornerRadius = UDim.new(0, Core.Scale:GetOffset(10)) 
					})
				}),
				NewText = Core.Roact.createElement("TextLabel", {
                    AnchorPoint = Vector2.new(1, 1),
					BackgroundColor3 = Color3.fromRGB(255, 58, 58),
					Position = UDim2.new(1, 0, 1, 0),
					Size = UDim2.new(.8, 0, .4, 0),
					Visible = buttonInfo.New or false,
					ZIndex = 10,
					Font = Enum.Font.GothamBold,
					Text = "New",
					TextColor3 = Color3.new(1, 1, 1),
					TextSize = Core.Scale:GetTextSize(30)
				}, {
					UICorner = Core.Roact.createElement("UICorner", { 
						CornerRadius = UDim.new(0, Core.Scale:GetOffset(10)) 
					})
				}),
				InfoFrame = Core.Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					Position = UDim2.new(1, 0, 0, 0),
					Size = UDim2.new(0, Core.Scale:GetOffset(200), 1, 0),
					ClipsDescendants = true
				}, {
					Contents = Core.Roact.createElement("Frame", {
						AnchorPoint = Vector2.new(1, 0),
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 1, 0)
					}, {
						Text = Core.Roact.createElement("TextLabel", {
							BackgroundTransparency = 1,
							Position = UDim2.new(0, Core.Scale:GetOffset(5), 0, 0),
							Size = UDim2.new(1, 0, .6, 0),
							ZIndex = 2,
							Font = Enum.Font.GothamBold,
							Text = name,
							TextColor3 = buttonInfo.Color,
							TextSize = Core.Scale:GetTextSize(45),
							TextStrokeColor3 = Color3.fromRGB(54, 54, 54),
							TextStrokeTransparency = 0,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextYAlignment = Enum.TextYAlignment.Top
						}, {
							Sub = Core.Roact.createElement("TextLabel", {
								BackgroundTransparency = 1,
								Position = UDim2.new(0, 0, 1, Core.Scale:GetOffset(5)),
								Size = UDim2.new(1, 0, .4, 0),
								Font = Enum.Font.SourceSans,
								Text = "Hotkey:["..(self.state["key_"..name] or "None").."]",
								TextColor3 = Color3.new(1, 1, 1),
								TextSize = Core.Scale:GetTextSize(30),
								TextStrokeTransparency = 0,
								TextXAlignment = Enum.TextXAlignment.Left
							})
						}),
						Under = Core.Roact.createElement("TextLabel", {
							BackgroundTransparency = 1,
							Position = UDim2.new(0, Core.Scale:GetOffset(5), 0, 0),
							Size = UDim2.new(1, 0, .6, 0),
							Font = Enum.Font.GothamBold,
							Text = name,
							TextColor3 = Color3.fromRGB(54, 54, 54),
							TextSize = Core.Scale:GetTextSize(45),
							TextStrokeColor3 = Color3.fromRGB(54, 54, 54),
							TextStrokeTransparency = 0,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextYAlignment = Enum.TextYAlignment.Top
						}),
					})
				})
			})
		})
	end
	
	--Frame		
	return {
		Buttons = Core.Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = 2,
			--ClipsDescendants = true,
			[Core.Roact.Ref] = self.ButtonsFrameRef
		}, buttons)
	}
end

function SideButtons:init()
	self:setState({
		key_Build = "B",
		key_Store = "K",
		key_Daily = "P",
		key_Redeem = "L",
		key_Settings = "U"
	})
	self.ButtonsFrameRef = Core.Roact.createRef()
end

function SideButtons:render()
	return Core.Roact.createElement("Frame", {
		AnchorPoint = Vector2.new(0, .5),
		BackgroundTransparency = 1,
		Position = UDim2.new(0, Core.Scale:GetOffset(5), .5, 0),
		Size = UDim2.new(0, Core.Scale:GetOffset(90), 0, Core.Scale:GetOffset(486))
	}, self:CreateButtons())
end

function SideButtons:didMount()
	local buttonsFrame = self.ButtonsFrameRef.current
	local buttonsFrames = buttonsFrame:GetChildren()
	
	--Buttons animations
	for _, buttonFrame in pairs(buttonsFrames) do
		if buttonFrame:IsA("Frame") then
			
			local button = buttonFrame:FindFirstChildWhichIsA("ImageButton") or buttonFrame:FindFirstChildWhichIsA("TextButton")
			
			--Getting InfoFrame
			local infoFrame = button:FindFirstChild("InfoFrame")
			local contentsFrame = infoFrame and infoFrame:FindFirstChild("Contents")
			
			--Info Frame
			if contentsFrame then
				local InfoTweenOut = TS:Create(contentsFrame, TweenInfo.new(.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
					AnchorPoint = Vector2.new(0, 0)
				})
				local InfoTweenIn = TS:Create(contentsFrame, TweenInfo.new(.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
					AnchorPoint = Vector2.new(1, 0)
				})
				
				button.MouseEnter:Connect(function()
					if Core.Platform:GetCurrentInputType() ~= "TOUCH" then
						InfoTweenOut:Play()
					end
				end)
				
				button.MouseLeave:Connect(function()
					if Core.Platform:GetCurrentInputType() ~= "TOUCH" then
						InfoTweenIn:Play()
					end
				end)
			end
			
			--Offset
			local OffsetOut = TS:Create(button, TweenInfo.new(.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
				Position = UDim2.new(.1, 0, 0, 0)
			})
			local OffsetIn = TS:Create(button, TweenInfo.new(.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
				Position = UDim2.new()
			})
			
			button.MouseEnter:Connect(function()
				if Core.Platform:GetCurrentInputType() ~= "TOUCH" then
					OffsetOut:Play()
				end
			end)
			
			button.MouseLeave:Connect(function()
				if Core.Platform:GetCurrentInputType() ~= "TOUCH" then
					OffsetIn:Play()
				end
			end)
		end
	end
end

return SideButtons