local subfix = {}
subfix.Symbols = { "", "K", "M", "B", "T", "qD"}
subfix.symbolsLen = #subfix.Symbols

function subfix.addSubfix(n)
    assert(typeof(n)=="number", " `n` must be a number!")
    local count = 1
    while wait() do
        if count == subfix.symbolsLen or n / 1e3^count < 1 then 
            break 
        end
        count+=1
    end
    --[[
        TODO fix rounding point
    ]]--
    return string.format("%.3f", n / 1e3^(count-1)):gsub("%.?0+$", "")..
        (subfix.Symbols[count] == "" and "" or " "..subfix.Symbols[count])
end

return subfix