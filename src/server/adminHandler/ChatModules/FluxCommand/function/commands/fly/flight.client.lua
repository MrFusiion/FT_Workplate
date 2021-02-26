local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumaoidRP = Character:WaitForChild('HumanoidRootPart')
local CAS = game:GetService('ContextActionService')

local FlyForce = 150

--==============/init jump start/==============--
local Jump = Instance.new("BodyVelocity", HumaoidRP)
Jump.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
Jump.Velocity = Vector3.new(0, 50, 0)
game.Debris:AddItem(Jump, .5)
wait(.5)
HumaoidRP.Anchored = true
--==============/init jump start/==============--

local function destoryVelocityAndGyro(name)
    if HumaoidRP:FindFirstChild(name..'Velocity') then
        HumaoidRP:FindFirstChild(name..'Velocity'):Destroy()
        if HumaoidRP:FindFirstChild(name..'Gyro') then
            HumaoidRP:FindFirstChild(name..'Gyro'):Destroy()
        end
    end
    HumaoidRP.Anchored = true
end

local function createVelocityAndGyro(name, axisName, force)
    
    for _, child in ipairs(HumaoidRP:GetChildren()) do
        if child:IsA('BodyVelocity') or child:IsA('BodyGyro') then
            child:Destroy()
        end
    end

    local body = Instance.new('BodyVelocity')
    body.Name = name..'Velocity'
    body.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
    
    local gyro = Instance.new("BodyGyro")
    gyro.MaxTorque = Vector3.new(math.huge,math.huge,math.huge)
    gyro.Name = name..'Gyro'
    gyro.D = 500
    gyro.P = 10000
    gyro.Parent = HumaoidRP
    
    body.Parent = HumaoidRP
    while body.Parent and wait() do
        HumaoidRP.Anchored = false
        body.Velocity = workspace.CurrentCamera.CFrame[axisName] * force
        gyro.CFrame = workspace.CurrentCamera.CFrame
    end
    HumaoidRP.Anchored = true
end

for direction, props in pairs{
    Forward =   { keycode = Enum.KeyCode.W, axis = 'LookVector',  force =  FlyForce },
    Back =      { keycode = Enum.KeyCode.S, axis = 'LookVector',  force = -FlyForce },
    Right =     { keycode = Enum.KeyCode.D, axis = 'RightVector', force =  FlyForce },
    Left =      { keycode = Enum.KeyCode.A, axis = 'RightVector', force = -FlyForce }} do
    CAS:BindAction('Fly'..direction, function(_, state)
        if state == Enum.UserInputState.Begin then
            createVelocityAndGyro(direction, props.axis, props.force)
        elseif state == Enum.UserInputState.End then
            destoryVelocityAndGyro(direction)
        end
    end, false, props.keycode)
    print(props.keycode)
end