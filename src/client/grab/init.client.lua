local UIS = game:GetService('UserInputService')

local player = game:GetService('Players').LocalPlayer
local mouse = player:GetMouse()

local function isGrabObject(instance)
    return typeof(instance) == 'Instance' and instance:GetAttribute('Grab')
end

function getMousePoint(X, Y)
	local cameraMag = (workspace.CurrentCamera.CFrame.Position - game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude
	local ray = workspace.CurrentCamera:ScreenPointToRay(X, Y) --Hence the var name, the magnitude of this is 1.
	local pos = ray.Origin + ray.Direction * cameraMag + ray.Direction * 6
	return pos
end

local conn
local grabObject
UIS.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if isGrabObject(mouse.Target) then
            grabObject = mouse.Target
                
            local bodyPosition = Instance.new('BodyPosition')
            bodyPosition.D = 2500
            bodyPosition.MaxForce = Vector3.new(1, 1, 1) * 4e4
            bodyPosition.P = 2e4
            bodyPosition.Parent = grabObject

            local bodyGyro = Instance.new('BodyGyro')
            bodyGyro.Parent = grabObject
            
            conn = game:GetService('RunService').RenderStepped:Connect(function()
                bodyPosition.Position =  getMousePoint(mouse.X, mouse.Y)
                grabObject.Locked = not grabObject.Locked     
            end)
        end
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if conn then
            conn:Disconnect()
            conn = nil
        end
        if grabObject then
            local pos = grabObject:FindFirstChildWhichIsA('BodyPosition')
            if pos then pos:Destroy() end

            local rot = grabObject:FindFirstChildWhichIsA('BodyGyro')
            if rot then rot:Destroy() end
        end
    end
end)