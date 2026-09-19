local ROOM_FREQ = 9
local ALT_TAROT_CHANCE = 0.25

---@param pl EntityPlayer
local function evalCache(_, pl)
    pl:CheckFamiliar(
        ToyboxMod.FAMILIAR_LIL_POT,
        pl:GetCollectibleNum(ToyboxMod.COLLECTIBLE_GREEDY_POT),
        pl:GetCollectibleRNG(ToyboxMod.COLLECTIBLE_GREEDY_POT),
        Isaac.GetItemConfig():GetCollectible(ToyboxMod.COLLECTIBLE_GREEDY_POT)
    )
end
ToyboxMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evalCache, CacheFlag.CACHE_FAMILIARS)

---@param fam EntityFamiliar
local function familiarInit(_, fam)
    fam:AddToFollowers()
end
ToyboxMod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, familiarInit, ToyboxMod.FAMILIAR_LIL_POT)

---@param fam EntityFamiliar
local function familiarUpdate(_, fam)
    local sp = fam:GetSprite()
    fam:FollowParent()
    if(sp:IsFinished()) then
        sp:Play("FloatDown", true)
    end

    if(fam.RoomClearCount==ROOM_FREQ) then
        local rng = fam:GetDropRNG()
        local pos = ToyboxMod.GAME:GetRoom():FindFreePickupSpawnPosition(fam.Position)

        local numCardsToSpawn = 2
        local pool = ToyboxMod.GAME:GetItemPool()
        for i=1, numCardsToSpawn do
            local sub
            if(rng:RandomFloat()<ALT_TAROT_CHANCE) then
                sub = ToyboxMod:getRandomPickup(rng, ToyboxMod.PICKUP_RANDOM_ALT_TAROT)[3]
            else
                local oldConf = ToyboxMod.CONFIG.CUSTOM_CARD_POOL_CHANCE
                ToyboxMod.CONFIG.CUSTOM_CARD_POOL_CHANCE = 0

                sub = pool:GetCardEx(rng:Next(), 0, 0, 0, false)

                ToyboxMod.CONFIG.CUSTOM_CARD_POOL_CHANCE = oldConf
            end

            local card = Isaac.Spawn(5,300,sub,pos+Vector.FromAngle(360*i/numCardsToSpawn+45)*15, Vector.Zero, nil):ToPickup()
            card:SetDropDelay(i*1)
        end

        fam.RoomClearCount = rng:RandomInt(2)+(fam:GetMultiplier()-1)*2
        sp:Play("Spawn", true)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, familiarUpdate, ToyboxMod.FAMILIAR_LIL_POT)