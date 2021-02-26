local Core = require(script.Parent.Parent:WaitForChild("Core"))

local TS = game:GetService("TweenService")


local element = Core.Roact.PureComponent:extend("__" .. script.Name .. "__")

function element:init()
	self:setState({
		anim = true,
		sound = true
	})
	
	--self.Button = Core.Roact.createRef
	self.AnimFrameRef = Core.Roact.createRef()
end

function element:SetState(key, bool)
	if key == "anim" or key == "sound" then
		self:setState({ [key] = bool })
	end
end

function element:render()
	--Steal ref for a sec
	local ref = self.props[Core.Roact.Ref]
	
	self.props[Core.Roact.Ref] = function(rbx)
		self.Button = rbx
		
		if ref then
			if typeof(ref) == "function" then
				ref(rbx)
			else
				local m = getmetatable(ref)
				local oldIndex = m.__index
				m.__index = function(self, key)
					if key == "current" or key == "getValue" then
						return rbx
					else
						return oldIndex(self, key)
					end
				end
				setmetatable(ref, m)
			end
		end
	end
	
	local children = self.props[Core.Roact.Children] or {}
	self.props[Core.Roact.Children] = nil
	
	children["AnimFrame"] = Core.Roact.createElement("Frame", {
		AnchorPoint = Vector2.new(.5, .5),
		BackgroundColor3 = self.props.BackgroundColor3,
		Position = UDim2.new(.5, 0, .5, 0),
		Size = UDim2.new(1, 0, 1, 0),
		[Core.Roact.Ref] = self.AnimFrameRef,
		ZIndex = self.props.ZIndex or 0
	}, {
		UICorner = Core.Roact.createElement("UICorner", { 
			CornerRadius = UDim.new(0, Core.Scale:GetOffset(10)) 
		})
	})
	
	self.props.ZIndex = (self.props.ZIndex or 0) + 1
	
	children["UICorner"] = Core.Roact.createElement("UICorner", { 
		CornerRadius = UDim.new(0, Core.Scale:GetOffset(10)) 
	})
	
	return Core.Roact.createElement(script.Name, self.props, children)
end

function element:didMount()
	local SoundList =  Core.Sound.NewList({
		Click = 452267918,
		Hover = 421058925
	}) 
	
	local button = self.Button
	local animFrame = self.AnimFrameRef.current
	
	if self.state.anim then
		local AnimTween = TS:Create(animFrame, TweenInfo.new(.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
			Size = UDim2.new(2, 0, 2, 0),
			BackgroundTransparency = 1
		})
		
		local function CleanUp()
			AnimTween:Cancel()
			animFrame.Size = UDim2.new(1, 0, 1, 0)
			animFrame.BackgroundTransparency = 0
		end
		
		button.Activated:Connect(function()
			CleanUp()
			AnimTween:Play()
		end)
	end
	
	if self.state.sound then
		button.Activated:Connect(function()
			SoundList:PlayLocal("Click")
		end)
		
		button.MouseEnter:Connect(function()
			SoundList:PlayLocal("Hover")
		end)
	end
	
end

return element