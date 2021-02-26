local core = {}

--Main Modules
core.shared = require(game:GetService('ReplicatedStorage')
    :WaitForChild('modules')
)
core.client = require(game:GetService('StarterPlayer')
    :WaitForChild('StarterPlayerScripts')
    :WaitForChild('modules')
)
core.roact = core.shared.get('roact')
core.color = require(script:WaitForChild("color"))
core.elements = require(script:WaitForChild("elements"))
core.subfix = require(script:WaitForChild("gui"))
core.scale = require(script:WaitForChild("scale"))
core.soundlist = require(script:WaitForChild("soundlist"))
core.subfix = require(script:WaitForChild("subfix"))

--usefull functions
function core.deepCopyTable(original)
    local copy = {}
    for k, v in pairs(original) do
        --[[
        if typeof(v)=='table' then
            v = core.deepCopyTable(v)
        end]]
        copy[k] = v
	end
	return copy
end

local roact_binding = require(game:GetService('ReplicatedStorage')
    :WaitForChild('modules')
    :WaitForChild('roact')
    :WaitForChild("Binding")
)
function core.updateRef(ref, rbx)
    roact_binding.update(ref, rbx)
end

function core.cloneRef(ref, targetRef)
    return function (rbx)
        if typeof(targetRef) == 'function' then
            targetRef(rbx)
        elseif typeof(targetRef) == 'table' then
            roact_binding.update(targetRef, rbx)
        end

        if typeof(ref) == 'function' then
            ref(rbx)
        elseif typeof(ref) == 'table' then
            roact_binding.update(ref, rbx)
        end
    end
end

--Main Services
core.TS = game:GetService("TweenService")
return core