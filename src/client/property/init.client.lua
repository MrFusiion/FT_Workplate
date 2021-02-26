local propetyRemote = game:GetService('ReplicatedStorage')
    :WaitForChild('remote')
    :WaitForChild('property')

local claimProperty = require(script:WaitForChild('claimProperty'))
local re_ClaimProperty = propetyRemote:WaitForChild('ClaimProperty')
re_ClaimProperty.OnClientEvent:Connect(function(properties)
    if not claimProperty.Running then
        wait(1)
        claimProperty.start(properties)
    end
end)

local buyProperty = require(script:WaitForChild('buyProperty'))
local re_BuyProperty = propetyRemote:WaitForChild('BuyProperty')
re_BuyProperty.OnClientEvent:Connect(function(properties)
    if not buyProperty.Running then
        buyProperty.start(properties)
    end
end)

local expandProperty = require(script:WaitForChild('expandProperty'))
local re_ExpandProperty = propetyRemote:WaitForChild('ExpandProperty')
re_ExpandProperty.OnClientEvent:Connect(function()
    if not expandProperty.Running then
        expandProperty.start()
    end
end)