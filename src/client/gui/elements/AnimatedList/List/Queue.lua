local queue = {}
queue.__index = queue

function queue.new()
    local newQueue = {}
    newQueue.List = {}
    return setmetatable(newQueue, queue)
end

function queue:add(cb, ...)
    local args = {...}
    local index = #self.List + 1
    table.insert(self.List, function()
        cb(table.unpack(args))
    end)
    if not self.Running then
        self:__start()
    end
end

function queue:__start()
    self.Running = true
    spawn(function()
        while wait() and self.Running do
            local i, cb = next(self.List)
            if cb then
                cb()
                table.remove(self.List, i)
            else
                self:__end()
            end
        end
    end)
end

function queue:__end()
    self.Running = false
end

--Debug
function queue:getStatus()
    return self.Running and "running" or "paused"
end

return queue