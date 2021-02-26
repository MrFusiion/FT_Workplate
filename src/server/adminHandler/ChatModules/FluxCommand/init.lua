return function (ChatService)
	ChatService:RegisterProcessCommandsFunction('flux_command', function(speakerName, message, channelName)
		local speaker = ChatService:GetSpeaker(speakerName)
		local player = speaker:GetPlayer()
		return script.RunCommand:Invoke(player, message)
	end)
end