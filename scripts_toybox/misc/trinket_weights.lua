local function getParasiteTrinketWeight()
    return ToyboxMod.CONFIG.PARASITE_TRINKET_WEIGHT
end

local TRINKET_WEIGHTS = {}

for id, reduceWeight in pairs(ToyboxMod.PARASITE_TRINKETS) do
    if(reduceWeight) then
        TRINKET_WEIGHTS[id] = getParasiteTrinketWeight
    end
end

local function getTrinket(_, trinket, rng)
    if(TRINKET_WEIGHTS[trinket]) then
        local weight = (type(TRINKET_WEIGHTS[trinket])=="function" and TRINKET_WEIGHTS[trinket]() or TRINKET_WEIGHTS[trinket])
        if(rng:RandomFloat()>=weight) then
            return ToyboxMod.GAME:GetItemPool():GetTrinket(false)
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_GET_TRINKET, getTrinket)