--[[@initApi
@Class: 'Event'
@Function: {
    'class' : 'Event',
    'name' : 'new',
    'args' : { },
    'return' : 'Tuple(BindableEvent, RBXScriptSignal)',
    'info' : 'Creates a new Event object.'
}]]
local event = {}

function event.new()
    local signal = Instance.new('BindableEvent')
    return signal, signal.Event
end

return event