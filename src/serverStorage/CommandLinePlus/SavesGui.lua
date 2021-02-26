local TS = game:GetService('TweenService')
local ColorSync = require(script.Parent.ColorSync)

local saveSignal = Instance.new('BindableEvent')
local runSignal = Instance.new('BindableEvent')

local module = {}

module.Save = saveSignal.Event
module.Run = runSignal.Event

function module.init(window)
	local frame = Instance.new('Frame')
	frame.Name = 'Saves'
	frame.AnchorPoint = Vector2.new(0, 0)
	frame.BorderSizePixel = 0
	frame.Position = UDim2.fromScale(0, 0)
	frame.Size = UDim2.new(0, 200, 1, -30)
	frame.Parent = window
	local frame_element = ColorSync:add(frame)
	frame_element:addGuide('BackgroundColor3', Enum.StudioStyleGuideColor.MainBackground)
	frame_element:syncColor()
	
	local buttons = Instance.new('Frame')
	buttons.Name = 'Buttons'
	buttons.AnchorPoint = Vector2.new(0, 1)
	buttons.BorderSizePixel = 0
	buttons.Position = UDim2.fromScale(0, 1)
	buttons.Size = UDim2.new(0, 200, 0, 30)
	buttons.Parent = window
	local buttons_element = ColorSync:add(buttons)
	buttons_element:addGuide('BackgroundColor3', Enum.StudioStyleGuideColor.MainBackground)
	buttons_element:syncColor()
	
	local saveButton = Instance.new('ImageButton')
	saveButton.Name = 'Save'
	saveButton.AnchorPoint = Vector2.new(0, .5)
	saveButton.BackgroundTransparency = 1
	saveButton.BorderSizePixel = 0
	saveButton.Position = UDim2.new(0, 5, .5, -10)
	saveButton.Size = UDim2.new(.5, -8, 1, 0)
	saveButton.ZIndex = 2
	saveButton.Parent = buttons
	
	local saveButtonBackground = Instance.new('ImageLabel')
	saveButtonBackground.Name = 'Background'
	saveButtonBackground.BackgroundTransparency = 1
	saveButtonBackground.Size = UDim2.fromScale(1, 1)
	saveButtonBackground.ZIndex = 3
	saveButtonBackground.Image = 'rbxassetid://5981360137'
	saveButtonBackground.ScaleType = Enum.ScaleType.Slice
	saveButtonBackground.SliceCenter = Rect.new(10, 10, 10, 10)
	saveButtonBackground.SliceScale = .5
	saveButtonBackground.Parent = saveButton
	local saveButtonBackground_element = ColorSync:add(saveButtonBackground)
	saveButtonBackground_element:addGuide('ImageColor3', Enum.StudioStyleGuideColor.MainBackground, function(color)
		return Color3.new(
			color.R + (1 - color.R) * .5,
			color.G + (1 - color.G) * .5,
			color.B + (1 - color.B) * .5
		)
	end)
	saveButtonBackground_element:syncColor()
	
	local saveButtonHover = Instance.new('ImageLabel')
	saveButtonHover.Name = 'Hover'
	saveButtonHover.BackgroundTransparency = 1
	saveButtonHover.Size = UDim2.fromScale(1, 1)
	saveButtonHover.ZIndex = 4
	saveButtonHover.Image = 'rbxassetid://5981360418'
	saveButtonHover.ImageColor3 = Color3.new(1, 1, 1)
	saveButtonHover.ImageTransparency = 1
	saveButtonHover.ScaleType = Enum.ScaleType.Slice
	saveButtonHover.SliceCenter = Rect.new(10, 10, 10, 10)
	saveButtonHover.SliceScale = .5
	saveButtonHover.Parent = saveButton
	
	local saveButtonText = Instance.new('TextLabel')
	saveButtonText.Name = 'Text'
	saveButtonText.BackgroundTransparency = 1
	saveButtonText.Size = UDim2.fromScale(1, 1)
	saveButtonText.ZIndex = 6
	saveButtonText.Font = Enum.Font.GothamSemibold
	saveButtonText.Text = 'Save'
	saveButtonText.TextSize = 18
	saveButtonText.Parent = saveButton
	local saveButtonText_element = ColorSync:add(saveButtonText)
	saveButtonText_element:addGuide('TextColor3', Enum.StudioStyleGuideColor.ButtonText)
	saveButtonText_element:syncColor()
	
	saveButton.Activated:Connect(function()
		saveSignal:Fire()
	end)
	
	saveButton.MouseEnter:Connect(function()
		TS:Create(saveButtonHover, TweenInfo.new(.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), { ImageTransparency = .8 }):Play()
	end)

	saveButton.MouseLeave:Connect(function()
		TS:Create(saveButtonHover, TweenInfo.new(.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), { ImageTransparency = 1 }):Play()
	end)
	
	local RunButton = Instance.new('ImageButton')
	RunButton.Name = 'Run'
	RunButton.AnchorPoint = Vector2.new(1, .5)
	RunButton.BackgroundTransparency = 1
	RunButton.BorderSizePixel = 0
	RunButton.Position = UDim2.new(1, -5, .5, -10)
	RunButton.Size = UDim2.new(.5, -8, 1, 0)
	RunButton.ZIndex = 2
	RunButton.Parent = buttons
	
	local RunButtonBackground = Instance.new('ImageLabel')
	RunButtonBackground.Name = 'Background'
	RunButtonBackground.BackgroundTransparency = 1
	RunButtonBackground.Size = UDim2.fromScale(1, 1)
	RunButtonBackground.ZIndex = 3
	RunButtonBackground.Image = 'rbxassetid://5981360418'
	RunButtonBackground.ImageColor3 = Color3.new(0.0941176, 0.74902, 0.137255)
	RunButtonBackground.ScaleType = Enum.ScaleType.Slice
	RunButtonBackground.SliceCenter = Rect.new(10, 10, 10, 10)
	RunButtonBackground.SliceScale = .5
	RunButtonBackground.Parent = RunButton
	local saveButtonBackground_element = ColorSync:add(RunButtonBackground)
	
	local RunButtonHover = Instance.new('ImageLabel')
	RunButtonHover.Name = 'Hover'
	RunButtonHover.BackgroundTransparency = 1
	RunButtonHover.Size = UDim2.fromScale(1, 1)
	RunButtonHover.ZIndex = 4
	RunButtonHover.Image = 'rbxassetid://5981360418'
	RunButtonHover.ImageColor3 = Color3.new(1, 1, 1)
	RunButtonHover.ScaleType = Enum.ScaleType.Slice
	RunButtonHover.SliceCenter = Rect.new(10, 10, 10, 10)
	RunButtonHover.SliceScale = .5
	RunButtonHover.ImageTransparency = 1
	RunButtonHover.Parent = RunButton
	
	local RunButtonText = Instance.new('TextLabel')
	RunButtonText.Name = 'Text'
	RunButtonText.BackgroundTransparency = 1
	RunButtonText.Size = UDim2.fromScale(1, 1)
	RunButtonText.ZIndex = 6
	RunButtonText.Font = Enum.Font.GothamSemibold
	RunButtonText.Text = 'Run'
	RunButtonText.TextSize = 18
	RunButtonText.Parent = RunButton
	local RunButtonText_element = ColorSync:add(RunButtonText)
	RunButtonText_element:addGuide('TextColor3', Enum.StudioStyleGuideColor.ButtonText)
	RunButtonText_element:syncColor()
	
	RunButton.Activated:Connect(function()
		runSignal:Fire()
	end)
	
	RunButton.MouseEnter:Connect(function()
		TS:Create(RunButtonHover, TweenInfo.new(.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), { ImageTransparency = .8 }):Play()
	end)
	
	RunButton.MouseLeave:Connect(function()
		TS:Create(RunButtonHover, TweenInfo.new(.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), { ImageTransparency = 1 }):Play()
	end)
end

return module
