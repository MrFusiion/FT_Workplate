local modules = {}

function modules.get(name)
    assert(typeof(name)=="string", " `name` must be a string!")
    return require(script:WaitForChild(name))
end

return modules