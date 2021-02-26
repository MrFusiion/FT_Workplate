return function (ChatService)
    ChatService:RegisterProcessCommandsFunction('help_command', function(speakerName, message, channelName)
        return false
	end)
end