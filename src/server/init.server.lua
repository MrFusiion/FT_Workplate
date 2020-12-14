local random = require(script:WaitForChild("modules"):WaitForChild("Random"))

local rand = random.new()

spawn(function() 
    while wait() do
        print(rand:nextInt(20, 50))
    end
end)