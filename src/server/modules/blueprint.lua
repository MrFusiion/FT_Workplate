--@initApi
--@Class: 'Blueprint'
local cache = {}

local blueprintFolder = game:GetService("ReplicatedStorage"):FindFirstChild("Blueprints")
if not blueprintFolder then
    blueprintFolder = Instance.new("Folder")
    blueprintFolder.Name = "Blueprints"
    blueprintFolder.Parent = game:GetService("ReplicatedStorage")
end

local blueprint = {}
blueprint.__index = function(self, key)
    if blueprint[key] then
        return blueprint[key]
    else
        return rawget(self, "Model")[key]
    end
end

blueprint.__newindex = function(self, key, value)
    self.Model[key] = value
end

--[[@Function: {
    'class' : 'Blueprint',
    'name' : 'new',
    'args' : { 'object' : 'table' },
    'info' : "Creates a new blueprint for this specific object."
}
@Properties: {
    'class' : 'Blueprint',
    'props' : [{   
        'name' : 'Object',
        'type' : 'table'
    }, {
        'name' : 'Args',
        'type' : 'table'
    }, {
        'name' : 'Model',
        'type' : 'Model'
    }]
}]]
function blueprint.new(object, ...)
    local newBlueprint = {}
    newBlueprint.Object = object
    newBlueprint.Args = {...}
    newBlueprint.Model = blueprint.createModel(object)
    return setmetatable(newBlueprint, blueprint)
end

--[[@Function: {
    'class' : 'Blueprint',
    'name' : 'createModel',
    'args' : { 'object' : 'table' },
    'info' : "Creates a blueprint Model for this specific object."
}]]
function blueprint.createModel(object)
    if not cache[object.Name] then
        --print("Created Model")
        local model = object.MODEL:Clone()
        local destroy = {}
        for _, descendant in ipairs(model:GetDescendants()) do
            if descendant:IsA("BasePart") then
                if descendant.CanCollide then
                    descendant.Material = 'SmoothPlastic'
                    descendant.CanCollide = false
                    descendant.Transparency = .5
                    descendant.BrickColor = BrickColor.Black()
                    descendant.Parent = model
                    continue
                end
            end
            if descendant ~= model.PrimaryPart then
                table.insert(destroy, descendant)
            end
        end
        for _, child in ipairs(destroy) do
            child:Destroy()
        end
        cache[object.Name] = model
    else
        --print("Used cache Model")
    end
    return cache[object.Name]
end

--[[@Function: {
    'class' : 'Blueprint',
    'name' : 'Place',
    'args' : { 'self' : 'Blueprint' },
    'info' : "Places the object this Blueprint coresponds to."
}]]
function blueprint.Place(self)
    local cf = self:GetPrimaryPartCFrame()
    return self.Object.new(self.Model.Parent, cf - cf.UpVector * self.PrimaryPart.Size.Y / 2, table.unpack(self.Args))
end

--[[@Function: {
    'class' : 'Blueprint',
    'name' : 'Destroy',
    'args' : { 'self' : 'Blueprint' },
    'info' : "Destroys the this Blueprint."
}]]
function blueprint.Destroy(self)
    self.Model.Parent = blueprintFolder
end

--[[@Function: {
    'class' : 'Blueprint',
    'name' : 'SetPrimaryPartCFrame',
    'args' : { 'self' : 'Blueprint' },
    'info' : "Sets the CFrame of the Model this Blueprint coresponds to."
}]]
function blueprint.SetPrimaryPartCFrame(self, cf)
    self.Model:SetPrimaryPartCFrame(cf)
end

--[[@Function: {
    'class' : 'Blueprint',
    'name' : 'GetPrimaryPartCFrame',
    'args' : { 'self' : 'Blueprint' },
    'info' : "Gets the CFrame of the Model this Blueprint coresponds to."
}]]
function blueprint.GetPrimaryPartCFrame(self)
    return self.Model:GetPrimaryPartCFrame()
end

return blueprint