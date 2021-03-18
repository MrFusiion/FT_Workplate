local toolbar = plugin:CreateToolbar("Flux Tools")

local order = {
    "LightEditor",
    "PartOnCamera",
    "BoundingBox",
    "CFrameToCFrame",
    "ChangeShape"
}

for _, name in ipairs(order) do
    local module = script.Parent.sub:FindFirstChild(name)
    if module then
        require(module)(toolbar, plugin)
    end
end