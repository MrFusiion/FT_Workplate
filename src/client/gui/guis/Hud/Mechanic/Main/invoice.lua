local core = require(script.Parent.Parent.Parent.Parent)

local invoice = core.roact.Component:extend("Mechanic_Invoice")

function invoice:init()
    self.TotalPrice = 0
    self.Count = 0
end

function invoice:render()
    return core.roact.createElement(core.elements.global:getConsumer(), {
        render = function(global)
            self.DefaultColor = global.theme.BgClr
            return core.roact.createElement("Frame", {
                AnchorPoint = core.anchor.tr,
                BackgroundTransparency = 1,
                Position = core.scale.udim2.new(1, -50, 0, 50),
                Size = core.scale.udim2.new(0, 350, 1, -50),
                ClipsDescendants = true,
                [core.roact.Ref] = self.props[core.roact.Ref]
            }, {
                ["Templates"] = core.roact.createElement("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.fromScale(1, 1),
                    Visible = false
                }, {
                    ["InvoiceButton"] = core.roact.createElement("Frame", {
                        BackgroundTransparency = 1,
                        Size = core.scale.udim2.new(1, 0, 0, 60),
                        [core.roact.Ref] = function(rbx) self.InvoiceButton = rbx end
                    }, {
                        ["Layout"] = core.roact.createElement("UIListLayout", {
                            Padding = core.scale.udim.new(0, 5),
                            SortOrder = Enum.SortOrder.LayoutOrder,
                            FillDirection = Enum.FillDirection.Horizontal
                        }),
                        ["Label"] = core.roact.createElement(core.elements.TextLabel, {
                            Size = core.scale.udim2.new(1, -120, 1, -5),
                            LayoutOrder = 0,
                            TextColor3 = Color3.fromRGB(0, 170, 0),
                            Text = "",
                            TextSize = core.scale:getTextSize(30)
                        }),
                        ["Icon"] = core.roact.createElement(core.elements.ImageLabel, {
                            Size = core.scale.udim2.new(1, -5, 1, -5),
                            LayoutOrder = 1,
                            SizeConstraint = Enum.SizeConstraint.RelativeYY
                        }),
                        ["RemoveItem"] = core.roact.createElement(core.elements.ImageButton, {
                            Size = core.scale.udim2.new(1, -5, 1, -5),
                            BackgroundColor3 = global.theme.ExitBgClr,
                            SizeConstraint = Enum.SizeConstraint.RelativeYY,
                            LayoutOrder = 2,
                            Image = "rbxassetid://6299709738",
                            ImageColor3 = global.theme.ExitTextClr
                        }),
                        ["Apply"] = core.roact.createElement("BindableEvent")
                    }),
                    ["Total"] = core.roact.createElement("Frame", {
                        BackgroundTransparency = 1,
                        Size = core.scale.udim2.new(1, 0, 0, 60),
                        LayoutOrder = 1,
                        [core.roact.Ref] = function(rbx) self.InvoiceTotal = rbx end
                    }, {
                        ["Layout"] = core.roact.createElement("UIListLayout", {
                            Padding = core.scale.udim.new(0, 5),
                            SortOrder = Enum.SortOrder.LayoutOrder,
                            FillDirection = Enum.FillDirection.Horizontal
                        }),
                        ["Label"] = core.roact.createElement(core.elements.TextLabel, {
                            Size = core.scale.udim2.new(1, -85, 1, -5),
                            LayoutOrder = 0,
                            Text = "",
                            TextSize = core.scale:getTextSize(30),
                            TextColor3 = Color3.fromRGB(0, 170, 0)
                        }),
                        ["Button"] = core.roact.createElement(core.elements.TextButton, {
                            Size = core.scale.udim2.new(0, 80, 1, -5),
                            LayoutOrder = 1,
                            Text = "Pay",
                            TextSize = core.scale:getTextSize(30),
                            TextColor3 = Color3.fromRGB(0, 170, 0)
                        })
                    })
                }),
                ["Content"] = core.roact.createElement(core.elements.AnimatedList, {
                    Padding = core.scale.udim.new(0, 5),
                    BackgroundTransparency = 1,
                    Size = UDim2.fromScale(1, 1),
                    [core.roact.Ref] = function(rbx) self.List = rbx end
                }),
                ["Add"] = core.roact.createElement("BindableFunction", { [core.roact.Ref] = function(rbx) self.Add = rbx end })
            })
        end
    })
end

function invoice:setTotal(total)
    total = total or self.List.GetItem:Invoke("Total")
    total.Label.Text = ("= $%s"):format(core.subfix.addSubfix(self.TotalPrice, 1))
end

function invoice:update(button, price, color, icon)
    local oldPrice = button:GetAttribute("Price") or 0
    self.TotalPrice = self.TotalPrice - oldPrice + price

    button.Label.Text = ("+ $%s"):format(core.subfix.addSubfix(price, 1))
    button.Icon.Image = icon
    button.Icon.BackgroundColor3 = color
    button.Icon.Shadow.BackgroundColor3 = core.color.shade(color, .5)
    button:SetAttribute("Price", price)
end

function invoice:add(name, price, color, icon)
    color = color or self.DefaultColor
    local button = self.List.GetItem:Invoke(name)
    if button then
        self:update(button, price, color, icon)
        self:setTotal()
    else
        self.Count += 1
        local total = self.List.GetItem:Invoke("Total")
        if not total then
            total = self.InvoiceTotal:Clone()
            total.Name = "Total"
        end

        button = self.InvoiceButton:Clone()
        button.Name = name

        button.RemoveItem.Activated:Connect(function()
            self.Count -= 1
            self.TotalPrice -= button:GetAttribute("Price")
            self:setTotal(total)
            self.List.RemoveItem:Fire(name, self.Count == 0 and "Total" or nil)
        end)

        self:update(button, price, color, icon)
        self:setTotal(total)

        if self.Count == 1 then
            self.List.AddItem:Fire(button, total)
        else
            self.List.InsertItem:Fire(-1, button)
        end
    end

    return button.RemoveItem.Activated
end
function invoice:didMount()
    function self.Add.OnInvoke(...)
        return self:add(...)
    end
end

return invoice