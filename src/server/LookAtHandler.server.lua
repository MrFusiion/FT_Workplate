local shared = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"))
local lookAt = shared.get("lookAt")

local lookAts = {};
lookAt:connect(
	function(player, character, horizontalRange, verticalRange, maxHorizontalWaist, maxHorizonalHead)
		lookAt[player.UserId] = lookAt.new(character, horizontalRange, verticalRange, maxHorizontalWaist, maxHorizonalHead);

		local hb = game:GetService("RunService").Heartbeat:Connect(function(dt)
			lookAt[player.UserId]:update(dt)
		end)

		character:WaitForChild("Humanoid").Died:Connect(function()
			hb:Disconnect();
		end)
	end,

	function(player, target)
		if (lookAt[player.UserId]) then
			lookAt[player.UserId]:calcGoal(target);
		end
	end
)