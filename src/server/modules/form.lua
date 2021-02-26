local HS = game:GetService("HttpService")

local Form = {}
Form.__index = Form
Form._HOST = "https://docs.google.com/"

function Form.new(hsForm, hsEntries)
	assert(typeof(hsForm) == "string", "hsForm must be a string!")
	assert(typeof(hsEntries) == "table", "entries must be a string!")
	
	local newForm = setmetatable({}, Form)
	newForm.hsForm = hsForm
	newForm.hsEntries = hsEntries or {}
	
	return newForm
end

function Form.post(self, ...)
	local vars = {...} or {}
	
	assert(#vars == #self.hsEntries, "Vars and hsEntries need to be the same length")
	
	local urlData = ""
	for i = 1, #self.hsEntries do
		urlData = urlData .. "&entry." .. self.hsEntries[i] .. "=" .. HS:UrlEncode(vars[i])
	end
	
	local url = self:getResponseUrl() .. "?" .. urlData
	HS:PostAsync(url, "", 2)
end

function Form.getResponseUrl(self)
	return self._HOST.."forms/u/0/d/e/"..self.hsForm.."/formResponse"
end

return Form
