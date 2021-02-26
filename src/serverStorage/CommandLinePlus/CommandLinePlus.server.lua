local toolbar = plugin:CreateToolbar('Command Line +')
local button = toolbar:CreateButton('Editor', 'Opens the Command Line + Editor.', 'rbxassetid://6318920371')
--rbxassetid://6318920371

local window = plugin:CreateDockWidgetPluginGui('Editor', DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Float, false, false, 200, 200, 150, 150))
window.Name = 'CommandLinePlus'
window.Title = 'CommandLinePlus'
button:SetActive(window.Enabled)

button.Click:Connect(function()
	window.Enabled = not window.Enabled
	button:SetActive(window.Enabled)
end)

local TextEditor = require(script.Parent.TextEditorGui)
TextEditor.init(window)

local Saves = require(script.Parent.SavesGui)
Saves.init(window)

Saves.Save:Connect(function()
	print('save')
end)

Saves.Run:Connect(function()
	loadstring(TextEditor:getText())()
end)