local core = require(script.Parent)
local platform = core.client.get('platform')
local playerUtils = core.client.get('playerUtils')

local themes = require(script:WaitForChild('themes'))

local globalContext = core.roact.createContext({
    theme = themes['dark'],
    platform = platform:getPlatform()
})
local global = core.roact.Component:extend('__' .. script.Name .. '__')

function global:init()
    self.themeV = playerUtils:getPlayer():WaitForChild('config'):WaitForChild('Theme')
    self:setState({
        theme = themes[self.themeV.Value],
        platform = platform:getPlatform()
    })
end

function global:render()
    return core.roact.createElement(globalContext.Provider, {
        value = self.state
    }, self.props[core.roact.Children])
end

function global:didMount()
    self.themeConnection = self.themeV:GetPropertyChangedSignal('Value'):Connect(function()
        self:setState({
            theme = themes[self.themeV.Value]
        })
    end)
    self.InputTypeConnection = platform.PlafromChange:Connect(function(plat)
        self:setState({
            platform = plat
        })
    end)
end

function global:willUnmount()
    self.themeConnection:Disconnect()
    self.InputTypeConnection:Disconnect()
end

function global:getConsumer()
    return globalContext.Consumer
end

return global