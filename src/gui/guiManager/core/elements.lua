local elements = {}

for _, element in pairs(script.Parent.Parent:WaitForChild("elements"):GetChildren()) do
    table.insert(elements, require(element))
end

return elements