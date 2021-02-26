--@initApi
--@Class: 'Producer'
local producer = {}
producer.__index = producer

producer.__tostring = function(self)
    return string.format("Producer: [%.3f/%f]", self.Buffer, self.MaxBuffer)
end

--[[@Function: {
    'class' : 'Producer',
    'name' : 'new',
    'args' : { 'produceAmount' : 'number', 'maxBuffer' : 'number', 'speed' : 'number' },
    'return' : 'Producer',
    'info' : "Creates a new Producer."
}
@Properties: {
    'class' : 'Producer',
    'props' : [{
        'name' : 'ProduceAmount',
        'type' : 'number'
    }, {
        'name' : 'Buffer',
        'type' : 'number'
    }, {
        'name' : 'MaxBuffer',
        'type' : 'number'
    }, {
        'name' : 'Speed',
        'type' : 'number'
    }, {
        'name' : 'Running',
        'type' : 'boolean'
    }]
}]]
function producer.new(produceAmount, maxBuffer, speed)
    local newProducer = setmetatable({}, producer)
    newProducer.ProduceAmount = produceAmount
    newProducer.Buffer = 0
    newProducer.MaxBuffer = maxBuffer
    newProducer.Speed = speed
    return newProducer
end

--[[@Function: {
    'class' : 'Producer',
    'name' : 'generate',
    'args' : { 'self' : 'Producer' },
    'info' : "Adds the produceAmount to the buffer."
}]]
function producer.generate(self)
    self.Buffer = math.min(self.MaxBuffer, self.Buffer + self.ProduceAmount)
end

--[[@Function: {
    'class' : 'Producer',
    'name' : 'setProduceAmount',
    'args' : { 'self' : 'Producer', 'amount' : 'number' },
    'info' : "Sets the produceAmount to amount."
}]]
function producer.setProduceAmount(self, amount)
    self.ProduceAmount = math.max(0, amount)
end

--[[@Function: {
    'class' : 'Producer',
    'name' : 'take',
    'args' : { 'self' : 'Producer', 'amount' : 'number' },
    'return' : 'boolean',
    'info' : "Takes the amount of the buffer."
}]]
function producer.take(self, amount)
    if self.Buffer >= amount then
        self.Buffer -= amount
        return true
    end
    return false
end

--[[@Function: {
    'class' : 'Producer',
    'name' : 'get',
    'args' : { 'self' : 'Producer' },
    'return' : 'number',
    'info' : "Returns the buffer amount."
}]]
function producer.get(self)
    return self.Buffer
end

--[[@Function: {
    'class' : 'Producer',
    'name' : 'getFullness',
    'args' : { 'self' : 'Producer' },
    'return' : 'number',
    'info' : "Returns a value between 0 and 1 that describes the current used maxBuffer."
}]]
function producer.getFullness(self)
    return self.Buffer / self.MaxBuffer
end

--[[@Function: {
    'class' : 'Producer',
    'name' : 'startLoop',
    'args' : { 'self' : 'Producer' },
    'info' : "Starts the generate loop."
}]]
function producer.startLoop(self)
    if self.Running then return end
    self.Running = true
    spawn(function()
        while true do
            self:generate()
            wait(1 / self.Speed)
        end
    end)
end

--[[@Function: {
    'class' : 'Producer',
    'name' : 'stopLoop',
    'args' : { 'self' : 'Producer' },
    'info' : "Stops the generate loop."
}]]
function producer.stopLoop(self)
    self.Running = false
end

return producer