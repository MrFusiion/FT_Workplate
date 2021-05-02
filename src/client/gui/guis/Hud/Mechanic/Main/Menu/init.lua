local mt = {}
local menu = { __index = mt }

local __tabs = require(script.tabs)

local function safeCall(t, name, ...)
    if t[name] then
        t[name](...)
    end
end

function menu.new()
    local self = setmetatable({}, menu)
    self.Tabs = __tabs.provider()
    self.Last = nil
    self.Current = nil
    self.Index = 1
    return self
end

function mt:reset()
    self.Index = 1
    self.Current = self.Tabs[self.Index]
end

function mt:cycleUp()
    self.Index = self.Index % #self.Tabs + 1
    self.Current = self.Tabs[self.Index]
end

function mt:cycleDown()
    self.Index = (self.Index - 2) % #self.Tabs + 1
    self.Current = self.Tabs[self.Index]
end

function mt:select(key, ...)
    if self.Last then
        safeCall(self.Last, "close", ...)
    end
    if key then
        self.Last = self.Tabs[key]
        if self.Last then
            safeCall(self.Last, "open", ...)
        end
    else
        self.Last = nil
    end
end

function mt:selectCurrent(...)
    self:select(self.Index, ...)
end

function mt:init(...)
    for tabName, tab in self.Tabs:iter() do
        safeCall(tab, "init", ...)
    end
end

function mt:exit(...)
    for tabName, tab in self.Tabs:iter() do
        safeCall(tab, "close", ...)
        safeCall(tab, "exit", ...)
    end
end

return menu