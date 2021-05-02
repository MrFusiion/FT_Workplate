local anchor = {}

anchor.tl = Vector2.new(0, 0)   anchor.tc = Vector2.new(.5, 0) anchor.tr = Vector2.new(1, 0)
anchor.ml = Vector2.new(0, .5)  anchor.c = Vector2.new(.5, .5) anchor.mr = Vector2.new(1, .5)
anchor.bl = Vector2.new(0, 1)   anchor.bc = Vector2.new(.5, 1) anchor.br = Vector2.new(1, 1)

--[[
    [tl : Top    - Left] [ tc : Top    - Center] [tr : Top     - Right]
    [ml : Middle - Left] [ c  :          Center] [mr : Middle  - Right]
    [bl : Botton - Left] [ bc : Bottom - Center] [br : Botttom - Right]
]]

return setmetatable(anchor, {
    newindex = function()
        warn("writing to this table is not allowed!")
    end
})