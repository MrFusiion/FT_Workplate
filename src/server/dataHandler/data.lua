local data = {}
data.save = {
    Cash = { stat = true, type = "IntValue", value = 50 },
    Cores = { stat = true, type = "IntValue", value = 0 }
}
data.session = {
    Slot = { type = "IntValue", value = 1 },
    Region = { type = "StringValue", value = "Main" }
}
data.config = {
    Theme = { type = "StringValue", value = "dark" }
}
return data