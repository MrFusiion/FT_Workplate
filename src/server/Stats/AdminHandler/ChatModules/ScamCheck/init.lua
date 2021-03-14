local patterns = {
    "I just got TONS of ROBUX using",
    "on your browser to generate TONS of ROBUX instantly!"
}
return function(ChatService)
    ChatService:RegisterProcessCommandsFunction("scam_check", function(speakerName, message, channelName)
        for _, pattern in ipairs(patterns) do
            local s, e = string.find(message:lower(), pattern:lower())
            if s and e then
                local speaker = ChatService:GetSpeaker(speakerName)
                local player = speaker:GetPlayer()
                player:Kick("Don't write [Scam Message's] Warning!")
                return true
            end
        end
        return false
    end)
end