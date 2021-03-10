local tag = {}
tag.__index = tag
tag.__chatService = nil

--[[
    props: [
        NameColor : Color3
        TextColor : Color3
        Font : Enum.font
        TextSize : number
    ]
]]
function tag.new(name, color, props)
    if not tag.__chatService then
        tag.__chatService = require(game:GetService("ServerScriptService"):WaitForChild("ChatServiceRunner"):WaitForChild("ChatService"))
    end

    local newTag = setmetatable({}, tag)
    newTag.Name = name
    newTag.Color = color
    newTag.Props = props or {}
    return newTag
end

function tag.apply(self, player)
    spawn(function()
        local speaker
        repeat
            speaker = tag.__chatService:GetSpeaker(player.Name)
            wait()
        until speaker

        speaker:SetExtraData("Tags", {{TagText = self.Name,TagColor = self.Color}} )
        if typeof(self.Props["NameColor"]) == "Color3" then
            speaker:SetExtraData("NameColor", self.Props["NameColor"])
        end
        if typeof(self.Props["ChatColor"]) == "Color3" then
            speaker:SetExtraData("ChatColor", self.Props["ChatColor"])
        end
        if typeof(self.Props["Font"]) == "EnumItem" then
            speaker:SetExtraData("Font", self.Props["Font"])
        end
        if typeof(self.Props["TextSize"]) == "number" then
            speaker:SetExtraData("TextSize", self.Props["TextSize"])
        end
    end)
end

function tag.condition()
    return true
end

return tag