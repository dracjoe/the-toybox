

function ToyboxMod:createLionSkull(seed)
    local rng = ToyboxMod:generateRng(seed)

    local id = ProceduralItemManager.CreateProceduralItem(rng:Next(), 2048)

    local data = ToyboxMod:getExtraDataTable()
    data.TMTAMER_IDS = data.TMTAMER_IDS or {}
    data.TMTAMER_IDS[tostring(id)] = 1

    print(ProceduralItemManager.GetProceduralItem(-id-1):GetItem().Type)

    for i=0, ToyboxMod.GAME:GetNumPlayers()-1 do
        local pl = Isaac.GetPlayer(i)
        pl:BlockCollectible(id)
    end
end

function ToyboxMod:didyTestStr(a, b)
    local str = "\1*"
    for i=a, b do
        str = str..string.char(i)
    end
    str = str.."*"
    Game():GetHUD():ShowItemText(str)
end

function ToyboxMod:didyTestStr2(arr)
    local str = "\1"
    for _, val in ipairs(arr) do
        str = str..string.char(val)
    end
    Game():GetHUD():ShowItemText("", str)
end