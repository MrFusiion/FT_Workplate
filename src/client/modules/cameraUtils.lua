--@initApi
--@Class: "cameraUtils"
local cameraUtils = {}

local TS = game:GetService("TweenService")

local player = game:GetService("Players").LocalPlayer

--===========/cache/===========--
local old_camera_type = nil

--[[@Function: {
    "class" : "cameraUtils",
    "name" : "getCamera",
    "args" : {},
    "info" : "Returns the currentCamera."
}]]
function cameraUtils.getCamera()
    return workspace.CurrentCamera
end

--[[@Function: {
    "class" : "cameraUtils",
    "name" : "scriptable",
    "args" : { "boolean" : "boolean" },
    "info" : "Sets the camera scriptable or not."
}]]
function cameraUtils.scriptable(boolean)
    assert(typeof(boolean)=="boolean", " `boolean` must be type of boolean!")
    local camera = workspace.CurrentCamera
    if boolean and old_camera_type == nil then
        old_camera_type = camera.CameraType
        camera.CameraType = Enum.CameraType.Scriptable
    elseif old_camera_type then
        camera.CameraType = old_camera_type
        old_camera_type = nil
    end
end

--[[@Function: {
    "class" : "cameraUtils",
    "name" : "tween",
    "args" : { "cf" : "CFrame", "tweeninfo" : "TweenInfo" },
    "return" : "Tween",
    "info" : "Creates a tween."
}]]
function cameraUtils.tween(cf, tweeninfo)
    assert(typeof(cf)=="CFrame", " `cf` must be type of CFrame!")
    assert(typeof(tweeninfo)=="TweenInfo", " `tweeninfo` must be type of TweenInfo!")
    local camera = workspace.CurrentCamera
    assert(camera.CameraType==Enum.CameraType.Scriptable, " Camera is not scriptable\npls ensure u call cameraUtils.scriptable(true) first!")
    return TS:Create(camera, tweeninfo, { CFrame = cf })
end

--[[@Function: {
    "class" : "cameraUtils",
    "name" : "get",
    "args" : { "propName" : "string" },
    "return" : "any",
    "info" : "Gets a property from camera."
}]]
function cameraUtils.get(propName)
    assert(typeof(propName)=="string", " `propName` must be type of string!")
    return workspace.CurrentCamera[propName]
end

--[[@Function: {
    "class" : "cameraUtils",
    "name" : "set",
    "args" : { "propName" : "string", "value" : "any" },
    "return" : "void",
    "info" : "Sets a property from camera."
}]]
function cameraUtils.set(propName, value)
    assert(typeof(propName)=="string", " `propName` must be type of string!")
    workspace.CurrentCamera[propName] = value
end

function cameraUtils.setZoomDistance(min, max)
    player.CameraMinZoomDistance = min or player.CameraMinZoomDistance
    player.CameraMaxZoomDistance = max or player.CameraMaxZoomDistance
end

function cameraUtils.getZoomDistance()
    return player.CameraMinZoomDistance, player.CameraMaxZoomDistance
end

return cameraUtils