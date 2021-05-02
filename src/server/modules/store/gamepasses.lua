--Only Use strings as keys integer indexes are reserved for gamepass ids lookup
local gamepasses = {}

gamepasses["CarColors"] = { id = 17408021, event = "carColors" }


-- Return
local out = {}
for name, gamepass in pairs(gamepasses) do
    out[name] = gamepass
    out[gamepass.id] = { name = name, event = gamepass.event }
end
return out