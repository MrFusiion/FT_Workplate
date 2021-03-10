local core = require(script:WaitForChild("core"))

--Player
local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

function loadChildModule(child)
    if child:IsA("ModuleScript") then
        local suc, contents = pcall(function()
            return core.roact.createElement(require(child))
        end)
        if not suc then
            warn(string.format("Couldn't load child module: %s", child.Name))
            warn(contents)
        end
        return contents
    end
end

function getTrees()
    local trees = {}
    for _, gui in ipairs(script:WaitForChild("guis"):GetChildren()) do
        if gui:IsA("ModuleScript") then
            local childs = {}
            for _, child in ipairs(gui:GetChildren()) do
                childs[child.Name] = loadChildModule(child)
            end
            local suc, err = pcall(function()
                trees[gui.Name] = core.roact.createElement("ScreenGui", require(gui), {
                    ["gloabl"] = core.roact.createElement(core.elements.global, {}, childs)
                })
            end)
            if not suc then
                warn(string.format("Couldn't load ScreenGui module: %s", gui.Name))
                warn(err)
            end
        end
    end
    return trees
end

function mount()
	local handles = {}
    for name, tree in pairs(getTrees()) do
		handles[name] = core.roact.mount(tree, playerGui, name)
	end
    return function()
		local trees = getTrees()
		for name, handle in pairs(handles) do
			core.roact.update(handle, trees[name])
		end
	end
end

--/////[init]/////--
for _, element in ipairs(script:WaitForChild("elements"):GetChildren()) do
    core.elements.add(element.Name, element)
end
local update = mount()

--UpdateGui
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(update)
playerGui:GetPropertyChangedSignal("CurrentScreenOrientation"):Connect(update)