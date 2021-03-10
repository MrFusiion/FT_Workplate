local remoteLookAt = game:GetService("ReplicatedStorage"):WaitForChild("remote"):WaitForChild("lookAt")
local initEvent = remoteLookAt:WaitForChild("Init")
local updateEvent = remoteLookAt:WaitForChild("Update")

local spring = require(script.spring)

local lookAt = {}
lookAt.__index = lookAt

function lookAt.new(character, horizontalRange, verticalRange, maxHorizontalWaist, maxHorizonalHead)
	local newLookAt = setmetatable({}, lookAt)

	newLookAt.Character = character
	newLookAt.Humanoid = character:WaitForChild("Humanoid")
	newLookAt.Hrp = character:WaitForChild("HumanoidRootPart")
	newLookAt.Neck = character:WaitForChild("Head"):WaitForChild("Neck")
	newLookAt.Waist = character:WaitForChild("UpperTorso"):WaitForChild("Waist")
	newLookAt.NeckC0 = newLookAt.Neck.C0
	newLookAt.WaistC0 = newLookAt.Waist.C0

	newLookAt.HorizontalRange = horizontalRange
	newLookAt.VerticalRange = verticalRange
	newLookAt.MaxHorizontalWaist = maxHorizontalWaist
	newLookAt.MaxHorizontalHead = maxHorizonalHead

	newLookAt.Spring = spring.new(Vector3.new(), Vector3.new(), Vector3.new(), 20, 1)

	return newLookAt
end

function lookAt:calcGoal(target)
	local goal = Vector3.new(0, 0, 0)

	local eye = (self.Hrp.CFrame * CFrame.new(0, 3, 0)):pointToObjectSpace(target).unit
	local horizontal = -math.atan2(eye.X, -eye.Z)
	local vertical = math.asin(eye.Y)

	if not (math.abs(horizontal) > self.HorizontalRange or math.abs(vertical) > self.VerticalRange) then
		local hsign, habs = math.sign(horizontal), math.abs(horizontal)
		local hneck, hwaist = habs, habs

		if (hwaist > self.MaxHorizontalWaist) then
			local remainder = hwaist - self.MaxHorizontalWaist
			hwaist = self.MaxHorizontalWaist
			hneck = math.clamp(hneck + remainder, 0, self.MaxHorizontalHead)
		end

		goal = Vector3.new(hsign*hneck, hsign*hwaist, vertical)
	end

	self.Spring.target = goal
end

function lookAt:update(dt)
	self.Spring:update(dt)
	local set = self.Spring.p
	self.Waist.C0 = self.NeckC0 * (self.Humanoid.Sit and CFrame.new() or CFrame.fromEulerAnglesYXZ(set.Z, set.X, 0))
	self.Waist.C0 = self.WaistC0 * (self.Humanoid.Sit and CFrame.new() or CFrame.fromEulerAnglesYXZ(set.Z, set.Y, 0))
end

function lookAt:initFire()
	if game:GetService("RunService"):IsClient() then
		initEvent:FireServer(self.Character, self.HorizontalRange, self.VerticalRange, self.MaxHorizontalWaist, self.MaxHorizontalHead)
	else
		warn("This function is client only")
	end
end

function lookAt:updateFire()
	if game:GetService("RunService"):IsClient() then
		updateEvent:FireServer(self.Spring.target)
	else
		warn("This function is client only")
	end
end

function lookAt:connect(initF, updateF)
	print("connect")
	if game:GetService("RunService"):IsServer() then
		initEvent.OnServerEvent:Connect(initF)
		updateEvent.OnServerEvent:Connect(updateF)
	else
		warn("This function is server only")
	end
end

return lookAt;