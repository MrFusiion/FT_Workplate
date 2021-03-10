local TS = game:GetService("TweenService")

local core = require(script.Parent.Parent)
local playerUtils = core.client.get("playerUtils")

local WIDTH = 320
local HEIGHT = 60

local element = core.roact.Component:extend("RegionText")

function element:render()
    return core.roact.createElement("Frame", {
        AnchorPoint = Vector2.new(.5, .2),
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        Position = UDim2.fromScale(.5, .2),
        Size = UDim2.fromScale(0, 0),
        Visible = false,
        [core.roact.Ref] = function(rbx) self.Frame = rbx end
    }, {
        ["Gradient"] = core.roact.createElement("UIGradient", {
            Transparency = NumberSequence.new{
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(.5, 0),
                NumberSequenceKeypoint.new(1, 1)
            }
        }),
        ["Label"] = core.roact.createElement("TextLabel", {
            AnchorPoint = Vector2.new(.5, 0),
            BackgroundTransparency = 1,
            Position = UDim2.fromScale(.5, 0),
            Size = UDim2.fromScale(1, 1),
            ZIndex = 2,
            Font = Enum.Font.Legacy,
            Text = "",
            TextColor3 = Color3.fromRGB(202, 202, 202),
            TextSize = core.scale:getTextSize(25),
            TextTransparency = 0,
            [core.roact.Ref] = function(rbx) self.Label = rbx end
        })
    })
end

function element:addQueue(text)
	local newQueueItem = {}
	newQueueItem.Active = true

	spawn(function()
		self.Frame.Visible = true
        self.Label.Text = text
		self.Frame.Size = UDim2.fromOffset(0, core.scale:getTextSize(HEIGHT))
        for _, tween in pairs(self.TweensFadeIn) do
            tween:Play()
        end
		wait(1)
		if newQueueItem.Active then
            for _, tween in pairs(self.TweensFadeIn) do
                tween:Play()
            end
			wait(.5)
			if newQueueItem.Active then
				self.Frame.Visible = false
			end
		end
	end)

	self.QueueItem = newQueueItem
end

function element:reset()
    self.Frame.Size = UDim2.fromOffset(0, core.scale:getTextSize(HEIGHT))
	self.Frame.Visible = false
	self.Frame.BackgroundTransparency = 0
	self.Label.TextTransparency = 0
end

function element:popup(text)
    if self.QueueItem then
		self.QueueItem.Active = false
	end
    self:reset()
	self:addQueue(text)
end

function element:didMount()
    local player = playerUtils.getPlayer()

    self.TweensFadeIn = {
        TS:Create(self.Frame, TweenInfo.new(.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), { 
            Size = UDim2.fromOffset(core.scale:getTextSize(WIDTH), core.scale:getTextSize(HEIGHT)),
            BackgroundTransparency = 0
        }),
        TS:Create(self.Label, TweenInfo.new(.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), { 
            TextTransparency = 0
        })
    }
    self.TweensFadeOut = {
        TS:Create(self.Frame, TweenInfo.new(.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), { 
            Size = UDim2.fromOffset(0, core.scale:getTextSize(HEIGHT)),
            BackgroundTransparency = 1
        }),
        TS:Create(self.Label, TweenInfo.new(.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), { 
            TextTransparency = 1
        })
    }

    spawn(function()
        while not self.regionV do self.regionV = player:WaitForChild("Region") wait() end
        self.regionV:GetPropertyChangedSignal("Value"):Connect(function()
            self:popup(self.regionV.Value)
        end)
    end)
end

return element