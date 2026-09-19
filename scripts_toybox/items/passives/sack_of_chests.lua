local ROOM_FREQ = 10

---@param pl EntityPlayer
local function evalCache(_, pl)
    pl:CheckFamiliar(
        ToyboxMod.FAMILIAR_SACK_OF_CHESTS,
        pl:GetCollectibleNum(ToyboxMod.COLLECTIBLE_SACK_OF_CHESTS),
        pl:GetCollectibleRNG(ToyboxMod.COLLECTIBLE_SACK_OF_CHESTS),
        Isaac.GetItemConfig():GetCollectible(ToyboxMod.COLLECTIBLE_SACK_OF_CHESTS)
    )
end
ToyboxMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evalCache, CacheFlag.CACHE_FAMILIARS)

---@param fam EntityFamiliar
local function familiarInit(_, fam)
    fam:AddToFollowers()
end
ToyboxMod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, familiarInit, ToyboxMod.FAMILIAR_SACK_OF_CHESTS)

---@param fam EntityFamiliar
local function familiarUpdate(_, fam)
    local sp = fam:GetSprite()
    fam:FollowParent()
    if(sp:IsFinished()) then
        sp:Play("FloatDown", true)
    end

    if(fam.RoomClearCount==ROOM_FREQ) then
        local rng = fam:GetDropRNG()

        local picked = ToyboxMod.CHEST_PICKER:PickOutcome(fam:GetDropRNG())
        local pos = ToyboxMod.GAME:GetRoom():FindFreePickupSpawnPosition(fam.Position)
        local chest = Isaac.Spawn(EntityType.ENTITY_PICKUP,picked,0,pos,Vector.Zero,nil):ToPickup()

        fam.RoomClearCount = rng:RandomInt(2)+(fam:GetMultiplier()-1)*2
        sp:Play("Spawn", true)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, familiarUpdate, ToyboxMod.FAMILIAR_SACK_OF_CHESTS)