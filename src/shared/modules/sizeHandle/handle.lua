local UIS = game:GetService('UserInputService')

local shared = require(game:GetService('ReplicatedStorage'):WaitForChild('modules'))
local event = shared.get('event')

local handle = {}
handle.__index = handle

local function asignEvents(self)
	local player = game:GetService('Players').LocalPlayer
	local mouse = player:GetMouse()
	local MouseEnterSignal, MouseLeaveSignal, MouseButton1DownSignal, MouseButton1UpSignal, MouseDragSignal

	MouseEnterSignal, self.MouseEnter = event.new()
	MouseLeaveSignal, self.MouseLeave = event.new()
	MouseButton1DownSignal, self.MouseButton1Down = event.new()
	MouseButton1UpSignal, self.MouseButton1Up = event.new()
	MouseDragSignal, self.MouseDrag = event.new()

	local down = false
	self.Handle.MouseEnter:Connect(function()
		self.Handle.Transparency = 0
		MouseEnterSignal:Fire()
    end)

	self.Handle.MouseLeave:Connect(function()
		if not down then
			self.Handle.Transparency = .5
		end
		MouseLeaveSignal:Fire()
	end)

	self.Handle.MouseButton1Down:Connect(function()
		down = true
		MouseButton1DownSignal:Fire()
	end)

	local startDist
	self.InputConnection = UIS.InputEnded:Connect(function(inputObj)
		if inputObj.UserInputType == Enum.UserInputType.MouseButton1
			or inputObj.UserInputType == Enum.UserInputType.Touch
			or inputObj.KeyCode == Enum.KeyCode.ButtonR2 then
			if down then
				MouseButton1UpSignal:Fire()
				down = false
			end
			self.Handle.Transparency = .5
		end
		startDist = nil
	end)

	self.MoveConnection = UIS.InputChanged:Connect(function(input)
		local pos = Vector2.new(mouse.X, mouse.Y)
		if down then
			if not startDist then
				startDist = pos
			end
			MouseDragSignal:Fire((pos - startDist).Magnitude)
			wait()
		end
	end)
end

function handle.new(normalId, part, offset)
	local newHandle = setmetatable({}, handle)
	newHandle.Handle = Instance.new('SphereHandleAdornment')
	newHandle.Handle.Color3 = Color3.fromRGB(85, 170, 255)
	newHandle.Handle.Transparency = .5
	newHandle.Handle.Adornee = part
	newHandle.Handle.AlwaysOnTop = true
	newHandle.Handle.Radius = .5
	newHandle.Handle.ZIndex = 1
    newHandle.Handle.Parent = game:GetService('Players').LocalPlayer.PlayerGui.Handles

	newHandle.Offset = offset
	newHandle.Part = part
	newHandle.NormalId = normalId
	
	newHandle:updateSizeOffset()

	asignEvents(newHandle)
	
	return newHandle
end

function handle:updateSizeOffset()
	local size = self.Part.Size * Vector3.FromNormalId(self.NormalId)
	size = math.abs(size.X + size.Y + size.Z)

	local offset = 1 + (self.Offset + self.Handle.Radius) * (1 / (size / 2))
	self.Handle.SizeRelativeOffset = Vector3.FromNormalId(self.NormalId) * offset
end

function handle:destroy()
	self.Handle:Destroy()
	self.MoveConnection:Disconnect()
	self.InputConnection:Diconnect()
end

return handle