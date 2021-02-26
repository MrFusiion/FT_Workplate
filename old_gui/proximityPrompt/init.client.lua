local PPS = game:GetService('ProximityPromptService')
local TS = game:GetService('TweenService')

local client = require(game:GetService('StarterPlayer'):WaitForChild('StarterPlayerScripts'):WaitForChild('modules'))
local input =       client.get('input')
local playerUtils = client.get('playerUtils')

local core = require(script.Parent:WaitForChild('gui'):WaitForChild('core'))

local gamepadButtonImage = {
    [Enum.KeyCode.ButtonX] = 'rbxassetid://4954053197',
    [Enum.KeyCode.ButtonY] = 'rbxassetid://5528142049',
    [Enum.KeyCode.ButtonA] = 'rbxassetid://5528141664',
    [Enum.KeyCode.ButtonB] = 'rbxassetid://4954313180'
}

local KeyboardKeyImage = 'rbxassetid://4952527150'

local KeyCodeTextMapping = {
    [Enum.KeyCode.E] = 'E'
}

local function getScreenGui()
    local gui
    while not gui do
        gui = playerUtils:getPlayerGui():FindFirstChild('InteractPrompts')
        wait()
    end

    local prompt
    while not prompt do
        prompt = gui:FindFirstChild('Prompt')
        wait()
    end
    --[[
    if not gui then
        gui = Instance.new('ScreenGui')
        gui.Name = 'InteractPrompts'
        gui.ResetOnSpawn = false
        gui.ZIndexBehavior = 'Global'
        gui.Parent = playerUtils:getPlayerGui()
    end]]
    return prompt
end

local function createPrompt(prompt, inputType, gui)

    local tweensHoldBegin = {}
    local tweensHoldEnd = {}
    local tweensFadeOut = {}
    local tweensFadeIn = {}
    local tweenInfoFast =       TweenInfo.new(.2,                   Enum.EasingStyle.Quad,     Enum.EasingDirection.Out)
    local tweenInfoQuick =      TweenInfo.new(.06,                  Enum.EasingStyle.Linear,   Enum.EasingDirection.Out)

    gui.Size = UDim2.fromOffset(core.scale:getOffset(100), core.scale:getOffset(100))
    gui.Enabled = true
    
    local inputFrame = Instance.new('Frame')
    inputFrame.Name = 'InputFrame'
    inputFrame.BackgroundTransparency = 1
    inputFrame.Size = UDim2.fromScale(1, 1)
    inputFrame.SizeConstraint = Enum.SizeConstraint.RelativeYY
    inputFrame.Parent = gui

    local resizeFrame = Instance.new('Frame')
    resizeFrame.AnchorPoint = Vector2.new(.5, .5)
    resizeFrame.BackgroundTransparency = 1
    resizeFrame.Position = UDim2.fromScale(.5, .5)
    resizeFrame.Size = UDim2.fromScale(1, 1)
    resizeFrame.Parent = inputFrame

    local inputFrameScaler = Instance.new('UIScale')
    inputFrameScaler.Parent = resizeFrame
    table.insert(tweensHoldBegin, TS:Create(inputFrameScaler, tweenInfoFast, { Scale = 1.3 }))
    table.insert(tweensHoldEnd, TS:Create(inputFrameScaler, tweenInfoFast, { Scale = 1 }))

    if inputType == Enum.ProximityPromptInputType.Gamepad then
        if gamepadButtonImage[prompt.GamepadKeyCode] then
            local icon = Instance.new('ImageLabel')
            icon.Name = 'ButtonImage'
            icon.AnchorPoint = Vector2.new(.5, .5)
            icon.BackgroundTransparency = 1
            icon.Position = UDim2.fromScale(.5, .5)
            icon.Size = UDim2.fromScale(1, 1)
            icon.ImageTransparency = 1
            icon.Image = gamepadButtonImage[prompt.GamepadKeyCode]
            icon.Parent = resizeFrame
            table.insert(tweensFadeOut, TS:Create(icon, tweenInfoQuick, { ImageTransparency = 1 }))
            table.insert(tweensFadeIn, TS:Create(icon, tweenInfoQuick, { ImageTransparency = 0 }))
        end
    elseif inputType == Enum.ProximityPromptInputType.Touch then
        local buttonImage = Instance.new('ImageLabel')
        buttonImage.Name = 'ButtonImage'
        buttonImage.AnchorPoint = Vector2.new(.5, .5)
        buttonImage.BackgroundTransparency = 1
        buttonImage.Position = UDim2.fromScale(.5, .5)
        buttonImage.Size = UDim2.fromScale(1, 1)
        buttonImage.ImageTransparency = 1
        buttonImage.Image = KeyboardKeyImage
        buttonImage.Parent = resizeFrame
        table.insert(tweensFadeOut, TS:Create(buttonImage, tweenInfoQuick, { ImageTransparency = 1 }))
        table.insert(tweensFadeIn, TS:Create(buttonImage, tweenInfoQuick, { ImageTransparency = 0 }))

        local touchImage = Instance.new('ImageLabel')
        touchImage.Name = 'ButtonImage'
        touchImage.AnchorPoint = Vector2.new(.5, .5)
        touchImage.BackgroundTransparency = 1
        touchImage.Position = UDim2.fromScale(.5, .5)
        touchImage.Size = UDim2.fromScale(.5, .5)
        touchImage.ImageTransparency = 1
        touchImage.Image = 'rbxassetid://6284521661'
        touchImage.Parent = resizeFrame
        table.insert(tweensFadeOut, TS:Create(touchImage, tweenInfoQuick, { ImageTransparency = 1 }))
        table.insert(tweensFadeIn, TS:Create(touchImage, tweenInfoQuick, { ImageTransparency = 0 }))
    else
        local buttonImage = Instance.new('ImageLabel')
        buttonImage.Name = 'ButtonImage'
        buttonImage.AnchorPoint = Vector2.new(.5, .5)
        buttonImage.BackgroundTransparency = 1
        buttonImage.Position = UDim2.fromScale(.5, .5)
        buttonImage.Size = UDim2.fromScale(1, 1)
        buttonImage.ImageTransparency = 1
        buttonImage.Image = KeyboardKeyImage
        buttonImage.Parent = resizeFrame
        table.insert(tweensFadeOut, TS:Create(buttonImage, tweenInfoQuick, { ImageTransparency = 1 }))
        table.insert(tweensFadeIn, TS:Create(buttonImage, tweenInfoQuick, { ImageTransparency = 0 }))

        local buttonText = Instance.new('TextLabel')
        buttonText.Name = 'ButtonText'
        buttonText.AnchorPoint = Vector2.new(.5, .5)
        buttonText.BackgroundTransparency = 1
        buttonText.Position = UDim2.fromScale(.5, .5)
        buttonText.Size = UDim2.fromScale(1, 1)
        buttonText.ZIndex = 2
        buttonText.Font = Enum.Font.GothamSemibold
        buttonText.Text = KeyCodeTextMapping[prompt.KeyboardKeyCode]
        buttonText.TextSize = string.len(buttonText.Text) > 2 and 20 or 30
        buttonText.TextTransparency = 1
        buttonText.TextColor3 = Color3.new(.8, .8, .8)
        buttonText.TextXAlignment = Enum.TextXAlignment.Center
        buttonText.Parent = resizeFrame
        table.insert(tweensFadeOut, TS:Create(buttonText, tweenInfoQuick, { TextTransparency = 1 }))
		table.insert(tweensFadeIn, TS:Create(buttonText, tweenInfoQuick, { TextTransparency = 0 }))
    end

    if inputType == Enum.ProximityPromptInputType.Touch or prompt.ClickablePrompt then
        local button = Instance.new("TextButton")
		button.BackgroundTransparency = 1
		button.TextTransparency = 1
		button.Size = UDim2.fromScale(1, 1)
        button.Parent = inputFrame

        local buttonDown = false
        button.InputBegan:Connect(function(input)
			if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) and
				input.UserInputState ~= Enum.UserInputState.Change then
				prompt:InputHoldBegin()
				buttonDown = true
			end
		end)
		button.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
				if buttonDown then
					buttonDown = false
					prompt:InputHoldEnd()
				end
			end
		end)

        gui.Active = true
    end

    local connections = {}
	table.insert(connections, prompt.Triggered:Connect(function()
		for _, tween in ipairs(tweensHoldBegin) do
			tween:Play()
		end
	end))
	table.insert(connections, prompt.TriggerEnded:Connect(function()
		for _, tween in ipairs(tweensHoldEnd) do
			tween:Play()
		end
    end))

    gui.Adornee = prompt.Parent

    for _, tween in ipairs(tweensFadeIn) do
		tween:Play()
    end

    return function()
        for _, conn in ipairs(connections) do
            conn:Disconnect()
        end

        for _, tween in ipairs(tweensFadeOut) do
			tween:Play()
        end

        wait(.2)

        inputFrame.Parent:Destroy()
    end
end

PPS.PromptShown:Connect(function(prompt, inputType)
    if prompt.Style ~= Enum.ProximityPromptStyle.Default then
        local cleanup = createPrompt(prompt, inputType, getScreenGui())
        prompt.PromptHidden:Wait()
        cleanup()
    end
end)