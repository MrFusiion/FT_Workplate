--local AS = game:GetService("AnalyticsService")
--AS.ApiKey = "519A9"
local forms = require(script:WaitForChild('forms'))

local analytics = {}

function analytics.purchase(itemName, itemID, itemPrice)
    forms.purchase:post(itemName, itemID, itemPrice, 1)
end

return analytics