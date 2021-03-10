local lexer = require(script.Parent.Lexer)

local lastFunction = false
local lastText = false
local colors = {}

local function getColor(token, src)
	if token == "keyword" then
		if src == "self" then
			return colors["selfKeyword"]
		elseif src == "nil" then
			return colors["nilKeyword"]
		elseif src == "function" then
			lastFunction = true
		end
	elseif token == "space" then
		if lastText then
			lastFunction = false
			lastText = false
		end
	elseif token == "iden" then
		if lastFunction then
			lastText = true
			return colors["functionName"]
		end
	end
	return colors[token]
end

local function getIDEColors()
	local function getColors()
		for token, color in pairs{
			iden = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.ScriptText),
			builtin = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.ScriptBuiltInFunction),
			string = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.ScriptString),
			number  = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.ScriptNumber),
			comment = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.ScriptComment),
			operator = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.ScriptOperator),
			keyword = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.ScriptKeyword),
			selfKeyword = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.ScriptSelf),
			nilKeyword = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.ScriptNil),
			functionName = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.ScriptFunctionName)
			} do
			colors[token] = string.format("#%02x%02x%02x", color.R * 255, color.G * 255, color.B * 255)
		end
	end
	getColors()
	settings().Studio.ThemeChanged:Connect(getColors)
end
getIDEColors()

local module = {}

function module.scan(s)
	lastFunction = false
	lastText = false
	
	local newText = ""
	for token, src in lexer.scan(s) do
		newText = string.format("%s<font color="%s">%s</font>", newText, getColor(token, string.gsub(src, "</br>", "")) or "#ffffff", src)
	end
	return newText
end

return module
