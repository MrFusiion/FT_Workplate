local elements = {}

function elements.add(name, element)
    assert(typeof(name)=='string', " `name` must be a string!")
    assert(not elements[name], string.format(" `%s` Name allready exist in elements!", name))
    elements[name] = require(element)
end

return elements