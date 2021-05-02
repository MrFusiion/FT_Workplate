local propetyRemote = game:GetService("ReplicatedStorage")
    :WaitForChild("remote")
    :WaitForChild("property")

local client = require(game:GetService("StarterPlayer").StarterPlayerScripts.Modules)
local backpackUtils = client.get("backpackUtils")

local claimProperty = require(script:WaitForChild("claimProperty"))
local re_ClaimProperty = propetyRemote:WaitForChild("ClaimProperty")
re_ClaimProperty.OnClientEvent:Connect(function(properties)
    if not claimProperty.Running then
        wait(1)
        backpackUtils.hide()
        claimProperty.start(properties)
    end
end)

local buyProperty = require(script:WaitForChild("buyProperty"))
local re_BuyProperty = propetyRemote:WaitForChild("BuyProperty")
re_BuyProperty.OnClientEvent:Connect(function(properties)
    if not buyProperty.Running then
        backpackUtils.hide()
        buyProperty.start(properties)
    end
end)

local expandProperty = require(script:WaitForChild("expandProperty"))
local re_ExpandProperty = propetyRemote:WaitForChild("ExpandProperty")
re_ExpandProperty.OnClientEvent:Connect(function()
    if not expandProperty.Running then
        backpackUtils.hide()
        expandProperty.start()
    end
end)

claimProperty.Stopped:Connect(backpackUtils.show)
buyProperty.Stopped:Connect(backpackUtils.show)
expandProperty.Stopped:Connect(backpackUtils.show)