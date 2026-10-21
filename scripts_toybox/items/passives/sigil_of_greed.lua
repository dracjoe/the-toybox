local GILD_FREQ = 7*30
local GILD_FREQ_OFFSET = GILD_FREQ-30

local GILD_DURATION = 4*30

local function gildEnemies(_)
    if(not PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_SIGIL_OF_GREED)) then return end

    if(ToyboxMod.GAME:GetRoom():GetFrameCount() % GILD_FREQ ~= GILD_FREQ_OFFSET) then return end

    local mult = PlayerManager.GetNumCollectibles(ToyboxMod.COLLECTIBLE_SIGIL_OF_GREED)
    local validEnemies = {}
    local alreadyGilded = {}

    for _, ent in ipairs(Isaac.GetRoomEntities()) do
        if(ToyboxMod:isValidEnemy(ent)) then
            if(ToyboxMod:hasStatusEffect(ent, "Gilded")) then
                table.insert(alreadyGilded, ent)
            else
                table.insert(validEnemies, ent)
            end
        end
    end

    if(#validEnemies+#alreadyGilded == 0) then return end

    local pl = PlayerManager.GetRandomCollectibleOwner(ToyboxMod.COLLECTIBLE_SIGIL_OF_GREED, ToyboxMod.GAME:GetRoom():GetSpawnSeed())
    local rng = pl:GetCollectibleRNG(ToyboxMod.COLLECTIBLE_SIGIL_OF_GREED)
    for _=1, mult do
        local isValid = (#validEnemies>0)
        local idx = isValid and rng:RandomInt(1, #validEnemies) or rng:RandomInt(1, #alreadyGilded)

        local ent = isValid and validEnemies[idx] or alreadyGilded[idx]
        ToyboxMod:applyGilded(ent, -GILD_DURATION, EntityRef(pl), false)

        table.remove(isValid and validEnemies or alreadyGilded, idx)
        if(#validEnemies+#alreadyGilded == 0) then break end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_UPDATE, gildEnemies)