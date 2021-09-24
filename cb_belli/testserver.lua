


exports.cb_belli:RegisterServerCallback("testcallback_S", function(src,...) -- ...  ----> https://www.lua.org/pil/5.2.html
    print("SRC: ",src,"ARGS: ",...)
    return "ok | return"
end)


RegisterCommand("testcbc", function(src,args)
    local data = exports.cb_belli:TriggerClientCallback(tonumber(args[1]), "testcallback_C","sono un argomento","ecc","ecc","ecc")
    print("Callback Result: ",data)
end)