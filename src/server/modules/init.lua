local modules = {}

--timeOut dflt: 5
--maxTries dflt: 1
function modules.get(name, timeOut, maxTries)
    timeOut = timeOut or 5
    maxTries = maxTries or 1
    assert(typeof(name)=="string", " `name` must be a string!")
    assert(typeof(timeOut)=="number", " `timeOut` must be a number or nil!")
    assert(typeof(maxTries)=="number", " `tries` must be a number or nil!")

    --searching for module
    local tries = 0
    local module = nil
    while (tries < maxTries) do
        local suc, err = pcall(function()
            module = script:WaitForChild(name)
        end)
        print("Err: ", err)
        if suc then break end
    end
    --requiring module if one is found
    if not module then 
        warn("Infinity")
    else
        local contents
        local suc = pcall(function()
            contents = require(module)
        end)
        
        if not contents then
            assert(false, "Error")
        else
            return contents
        end    
    end
end

return modules