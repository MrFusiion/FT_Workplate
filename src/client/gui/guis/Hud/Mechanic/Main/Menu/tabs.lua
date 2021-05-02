local tab = {}
tab.__index = tab

function tab:open()
    if self.Verbose then
        warn("open function has not been set for the Tab[%s]!")
    end
end

function tab:close()
    if self.Verbose then
        warn("close function has not been set for the Tab[%s]!")
    end
end

function tab:init()
    if self.Verbose then
        warn("init function has not been set for the Tab[%s]!")
        end
end

function tab:exit()
    if self.Verbose then
        warn("exit function has not been set for the Tab[%s]!")
    end
end

return {
    provider = function(verbose)
        local self = setmetatable({}, {
            __index = {
                new = function(self, index, name)
                    local newTab = setmetatable({ Name = name, Verbose = verbose == true or false }, tab)
                    self[name] = newTab
                    if index then
                        self[index] = newTab
                    else
                        table.insert(self, newTab)
                    end
                    return newTab
                end,
                iter = function(self)
                    return ipairs(self)
                end
            }
        })
        return self
    end
}