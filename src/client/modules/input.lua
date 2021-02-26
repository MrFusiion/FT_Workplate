local UIS = game:GetService('UserInputService')
local CAS = game:GetService('ContextActionService')

local input = {}

function input.beginWrapper(callback)
    return function(action, state, inputObj)
        if state == Enum.UserInputState.Begin then
            callback(action, state, inputObj)
        end
    end
end

function input.endWrapper(callback)
    return function(action, state, inputObj)
        if state == Enum.UserInputState.End then
            callback(action, state, inputObj)
        end
    end
end

function input.bind(actionName, callback, createTouchButton, ...)
    CAS:BindAction(actionName, callback, createTouchButton, ...)
end

function input.bindPriority(actionName, callback, createTouchButton, priorty, ...)
    CAS:BindActionAtPriority(actionName, callback, createTouchButton, priorty, ...)
end

function input.getboundActionInfo(actionName)
    return CAS:GetBoundActionInfo(actionName)
end

function input.unbind(actionName, ...)
    local actionNames = {...}
    table.insert(actionNames, actionName)
    for _, action in ipairs(actionNames) do
        CAS:UnbindAction(action)
    end
end

function input.safeUnbind(actionName, ...)
    local actionNames = {...}
    table.insert(actionNames, actionName)
    for _, action in ipairs(actionNames) do
        if input.getboundActionInfo(action) then
            input.unbind(action, ...)
        end
    end
end

function input.enableCore(boolean)
    local name = 'DISABLE_CORE'
    if not boolean then
        input.bind(name, function() end, false, table.unpack(Enum.KeyCode:GetEnumItems()), table.unpack(Enum.UserInputType:GetEnumItems()))
    else
        input.safeUnbind(name)
    end
end

return input