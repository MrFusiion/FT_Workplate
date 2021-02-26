local SyntaxHighlighter = require(script.Parent.SyntaxHighlighter)
local ColorSync = require(script.Parent.ColorSync)

local module = {}

local front
function module.init(window)
	local frame = Instance.new('Frame')
	frame.Name = 'TextEditor'
	frame.AnchorPoint = Vector2.new(1, .5)
	frame.BackgroundTransparency = 1
	frame.Position = UDim2.fromScale(1, .5)
	frame.Size = UDim2.new(1, -200, 1, 0)
	frame.Parent = window
	
	local editor = Instance.new("TextBox")
	editor.Name = 'Back'
	editor.BorderSizePixel = 0
	editor.LineHeight = 1.1
	editor.AnchorPoint = Vector2.new(1, .5)
	editor.Size = UDim2.new(1, -45, 1, 0)
	editor.Position = UDim2.fromScale(1, .5)
	editor.ClearTextOnFocus = false
	editor.ZIndex = 1
	editor.TextEditable = false
	editor.Selectable = false
	editor.Active = false
	editor.RichText = true
	editor.MultiLine = true
	editor.TextSize = 12
	editor.TextColor3 = Color3.new(1, 1, 1)
	editor.Text = ''
	editor.TextXAlignment = Enum.TextXAlignment.Left
	editor.TextYAlignment = Enum.TextYAlignment.Top
	editor.Parent = frame
	local editor_element = ColorSync:add(editor)
	editor_element:addGuide('BackgroundColor3', Enum.StudioStyleGuideColor.ScriptBackground)
	editor_element:syncColor()

	local dark = Instance.new("TextBox")
	dark.Name = 'Dark'
	dark.LineHeight = 1.1
	dark.AnchorPoint = Vector2.new(1, .5)
	dark.BackgroundTransparency = 1
	dark.Position = UDim2.fromScale(1, .5)
	dark.Size = UDim2.new(1, -45, 1, 0)
	dark.ClearTextOnFocus = false
	dark.ZIndex = 2
	dark.MultiLine = true
	dark.TextSize = 12
	dark.Text = ''
	dark.TextColor3 = Color3.new(0, 0, 0)
	dark.TextTransparency = .75
	dark.TextStrokeTransparency = 1
	dark.TextXAlignment = Enum.TextXAlignment.Left
	dark.TextYAlignment = Enum.TextYAlignment.Top
	dark.Parent = frame--[[
	local front_element = ColorSync:add(front)
	front_element:addGuide('BackgroundColor3', Enum.StudioStyleGuideColor.ScriptBackground)
	front_element:syncColor()]]

	front = Instance.new("TextBox")
	front.Name = 'Front'
	front.LineHeight = 1.1
	front.AnchorPoint = Vector2.new(1, .5)
	front.BackgroundTransparency = 1
	front.Position = UDim2.fromScale(1, .5)
	front.Size = UDim2.new(1, -45, 1, 0)
	front.ClearTextOnFocus = false
	front.ZIndex = 3
	front.MultiLine = true
	front.TextSize = 12
	front.Text = ''
	front.TextColor3 = Color3.new(1, 1, 1)
	front.TextTransparency = .75
	front.TextStrokeTransparency = 1
	front.TextXAlignment = Enum.TextXAlignment.Left
	front.TextYAlignment = Enum.TextYAlignment.Top
	front.Parent = frame--[[
	local front_element = ColorSync:add(front)
	front_element:addGuide('BackgroundColor3', Enum.StudioStyleGuideColor.ScriptBackground)
	front_element:syncColor()]]

	front:GetPropertyChangedSignal('Text'):Connect(function()
		dark.Text = front.Text
	end)

	local padding = Instance.new('Frame')
	padding.Name = 'Padding'
	padding.AnchorPoint = Vector2.new(0, .5)
	padding.BorderSizePixel = 0
	padding.Position = UDim2.new(0, 40, .5, 0)
	padding.Size = UDim2.new(0, 5, 1, 0)
	padding.Parent = frame
	local padding_element = ColorSync:add(padding)
	padding_element:addGuide('BackgroundColor3', Enum.StudioStyleGuideColor.ScriptBackground)
	padding_element:syncColor()

	local lines = Instance.new("TextBox")
	lines.Name = 'Lines'
	lines.AnchorPoint = Vector2.new(0, .5)
	lines.BorderSizePixel = 0
	lines.Position = UDim2.fromScale(0, .5)
	lines.Size = UDim2.new(0, 40, 1, 0)
	lines.MultiLine = true
	lines.TextSize = 12
	lines.Text = '1'
	lines.TextXAlignment = Enum.TextXAlignment.Center
	lines.TextYAlignment = Enum.TextYAlignment.Top
	lines.Parent = frame
	local lines_element = ColorSync:add(lines)
	lines_element:addGuide('BackgroundColor3', Enum.StudioStyleGuideColor.ScriptBackground, function(color)
		return Color3.new(
			color.R * (1 - .1),
			color.G * (1 - .1),
			color.B * (1 - .1)
		)
	end)
	lines_element:addGuide('TextColor3', Enum.StudioStyleGuideColor.ScriptText)
	lines_element:syncColor()
	
	local function getLines(str)
		local l = '1'
		local count = 1
		for _ in str:gmatch("\n") do
			count += 1
			l = l .. '\n' .. count
		end
		return l
	end

	local connection
	local function listen(name : boolean)
		connection = front:GetPropertyChangedSignal('Text'):Connect(function()
			connection:Disconnect()
			lines.Text = getLines(front.Text)
			if front.Text:match('\t') then
				print('HA tab')
			end
			front.Text = string.gsub(front.Text, '\t', '')
			editor.Text = SyntaxHighlighter.scan(front.Text)
			listen()
		end)
	end
	listen()
	
	settings().Studio.ThemeChanged:Connect(function()
		editor.Text = SyntaxHighlighter.scan(front.Text)
	end)
	
	front.Text = 'print("Hello World")'
end

function module.getText()
	return front.Text
end

return module