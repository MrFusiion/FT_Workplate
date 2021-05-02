local subfix = {}
subfix.Symbols = { "", "K", "M", "B", "T", "qD"}
subfix.symbolsLen = #subfix.Symbols

function subfix.addSubfix(n, decimals)
    decimals = decimals or 3
    assert(typeof(n)=="number", " `n` must be a number!")
    local count = 1
    local divider = 1e3
    while not (count == subfix.symbolsLen or n / divider < 1) do
        count += 1
        divider *= 1e3
    end

    return ("%s%s"):format(("%%.%df"):format(decimals)
        :format(n / (divider / 1e3)):gsub("[.]0+$", ""), subfix.Symbols[count] == "" and "" or (" %s"):format(subfix.Symbols[count]))
end
--
return subfix