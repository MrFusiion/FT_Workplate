local interaction = {}
interaction.prompt = {}

function interaction.prompt.new()
    local prompt = setmetatable({}, interaction.prompt)
    prompt = Instance.new("ProximityPrompt")
    prompt.GamepadKeyCode = Enum.KeyCode.ButtonX
    prompt.KeyboardKeyCode = Enum.KeyCode.E
    prompt.Style = Enum.ProximityPromptStyle.Custom
    return prompt
end

return interaction