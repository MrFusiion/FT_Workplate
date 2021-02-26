function GetMousePoint(X, Y)
	local cameraMag = (workspace.CurrentCamera.CFrame.Position - game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude
	local ray = workspace.CurrentCamera:ScreenPointToRay(X, Y) --Hence the var name, the magnitude of this is 1.
	local pos = ray.Origin + ray.Direction * cameraMag + ray.Direction * 6
	return pos
end

function Grab()
	local mouse = game.Players.LocalPlayer:GetMouse();
	if not (mouse.Target == nil) then
		local mag = (mouse.Hit.p - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude
		if not (mouse.Target:FindFirstChild("Owner") == nil) and mag <= 10 then
			local ownerObj = mouse.Target:FindFirstChild("Owner")
			local owner = ownerObj.Value
			----Checks if it has a owner if not make localPlayer owner
			if owner == 0 then
				local rEvent = repStorage:WaitForChild("RemoteEvents").setOwner
				rEvent:FireServer(ownerObj)
				owner = game.Players.LocalPlayer.UserId
			end
			--Checks if player is owner if he is drag object
			if owner == game.Players.LocalPlayer.UserId then
				local dragObject = ownerObj.Parent
				------Creating Grab objects
				local Posmover = CreatePosMover(dragObject)
				local Rotmover = CreateRotMover(dragObject)
				local pivot = CreatePivot(dragObject, mouse)
				
				------Welds Dragobject and pivot
				local weld = weldBetween(dragObject, pivot)
				
				local playerBody = workspace:FindFirstChild(game.Players.LocalPlayer.Name)
				local ray = Ray.new(playerBody.HumanoidRootPart.Position, -playerBody.HumanoidRootPart.CFrame.UpVector * 50)
				local part = workspace:FindPartOnRayWithWhitelist(ray, {dragObject})
				if part == dragObject then bodyPartHit = true
				else bodyPartHit = false end
				while userInput:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) and (not bodyPartHit) do
					wait(0.01)
					local pos = GetMousePoint(mouse.X, mouse.Y)
					ray = Ray.new(playerBody.HumanoidRootPart.Position, -playerBody.HumanoidRootPart.CFrame.UpVector * 50)
					part = workspace:FindPartOnRayWithWhitelist(ray, {dragObject})
					if part == dragObject then bodyPartHit = true
					else bodyPartHit = false end
					Posmover.Position = pos
				end
				Posmover.Position = dragObject.Position
				CleanUp(dragObject)
			end
		end
	end
end