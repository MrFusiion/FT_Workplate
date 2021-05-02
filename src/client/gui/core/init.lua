local core = {}

--Main Modules
core.shared = require(game:GetService("ReplicatedStorage")
    :WaitForChild("Modules")
)
core.client = require(game:GetService("StarterPlayer")
    :WaitForChild("StarterPlayerScripts")
    :WaitForChild("Modules")
)
core.roact = core.shared.get("roact")
core.color = require(script.color)
core.elements = require(script.elements)
core.subfix = require(script.subfix)
core.scale = require(script.scale)
core.soundlist = require(script.soundlist)
core.subfix = require(script.subfix)
core.anchor = require(script.anchor)

--usefull functions
function core.shallowCopyTable(original)
    local copy = {}
    for k, v in pairs(original) do
        copy[k] = v
	end
	return copy
end

function core.transfer(t1, t2, key, defaultValue)
    t2[key] = t1[key] or defaultValue
    t1[key] = nil
    return t1, t2
end

local roact_binding = require(game:GetService("ReplicatedStorage")
    :WaitForChild("Modules")
    :WaitForChild("roact")
    :WaitForChild("Binding")
)
function core.updateRef(ref, rbx)
    roact_binding.update(ref, rbx)
end

function core.cloneRef(ref, targetRef)
    return function (rbx)
        if typeof(targetRef) == "function" then
            targetRef(rbx)
        elseif typeof(targetRef) == "table" then
            roact_binding.update(targetRef, rbx)
        end

        if typeof(ref) == "function" then
            ref(rbx)
        elseif typeof(ref) == "table" then
            roact_binding.update(ref, rbx)
        end
    end
end

--Same function as above but much cleaner to work with :)
function core.distRef(props, ref)--Distribute Ref
    local oldRef = props[core.roact.Ref]
    props[core.roact.Ref] = function(rbx)
        if typeof(oldRef) == "function" then
            oldRef(rbx)
        elseif typeof(oldRef) == "table" then
            roact_binding.update(oldRef, rbx)
        end

        if typeof(ref) == "function" then
            ref(rbx)
        elseif typeof(ref) == "table" then
            roact_binding.update(ref, rbx)
        end
    end
end

--Main Services
core.TS = game:GetService("TweenService")
return core