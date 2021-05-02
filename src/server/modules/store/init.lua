local MS = game:GetService("MarketplaceService")

local server = require(game:GetService("ServerScriptService"):WaitForChild("Modules"))
local datastore = server.get("datastore")

local store = {}
store.__index = store

function newStore()
    local self = setmetatable({}, store)
    self.ProductLookup = require(script.products)

    self.GamepassLookup = require(script.gamepasses)
    self.GamepassCache = {}
    self.Remote = game:GetService("ReplicatedStorage"):WaitForChild("remote"):WaitForChild("store"):WaitForChild("gamepass")

    game:GetService("Players").PlayerAdded:Connect(function(player)
        self.GamepassCache[player.UserId] = {}
    end)

    game:GetService("Players").PlayerRemoving:Connect(function(player)
        self.GamepassCache[player.UserId] = nil
    end)

    return self
end

function store:fireEvent(player : Player, name : string)
    local rEvent = self.Remote:FindFirstChild(name)
    if rEvent then
        rEvent:FireClient(player)
    else
        warn(("Event with name %s is not a valid store event!"))
    end
end

function store:hasGamepass(player : Player, asset : any)
    local assetID = typeof(asset) == "number" or asset and self.GamepassLookup[asset]
    local has = self.GamepassCache[player.UserId][assetID] ~= nil and 
        self.GamepassCache[player.UserId][assetID] or
        MS:UserOwnsGamePassAsync(player.UserId, assetID)

    self.GamepassCache[player.UserId][assetID] = has
    return has
end

function store:promptGamepass(player : Player, asset : any)
    local assetID = typeof(asset) == "number" or asset and self.GamepassLookup[asset].id

    --local data = datastore.combined.global("Gamepasses", player.UserId, assetID)
    if not self:hasGamepass(player, assetID) then
        local conn
        conn = MS.PromptGamePassPurchaseFinished:Connect(function(plr, id, wasPurchased)
            if plr == player and id == assetID then
                self.GamepassCache[player.UserId][assetID] = wasPurchased
                self:fireEvent(player, self.GamepassLookup[assetID].event)
                conn:Disconnect()
            end
        end)

        MS:PromptGamePassPurchase(player, assetID)
    else
        warn(("Player %s owns allready the gamepass with id %d!"):format(player.Name, assetID))
    end

end

local s = newStore()
return s