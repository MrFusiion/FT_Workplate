local submodule = {}

--Wrapper function just for a shorter name
function submodule.get(name)
    return require(script:WaitForChild(name))
end

return submodule