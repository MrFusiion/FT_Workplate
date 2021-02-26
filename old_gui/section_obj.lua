local Core = require(script.Parent.Parent.Parent.Parent.Parent:WaitForChild("Core"))
local Section = require(script.Parent.Parent:WaitForChild("Section"))

local Plot = Core.Roact.Component:extend("Plot")

function Plot:render()
	return Core.Roact.createElement(Section, {
		LayoutOrder = 2,
		Color = Color3.fromRGB(255, 170, 0),
		Title = "Plot",
		[Core.Roact.Ref] = self.props[Core.Roact.Ref]
	}, {
		Text = Core.Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = 4,
			Text = "Test",
			TextColor3 = Color3.new(1, 1, 1),
			TextSize = Core.Scale:GetTextSize(70)
		})
	})
end

return Plot
