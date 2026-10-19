local sfx = SFXManager()

---@param rng RNG
---@return CollectibleType
local function getRandomItem(rng)
    local poolType = ToyboxMod.GAME:GetRoom():GetItemPool(rng:Next(), false)
    if(poolType==-1) then poolType = ItemPoolType.POOL_TREASURE end

    local pool = ToyboxMod.GAME:GetItemPool()

    local conf = Isaac.GetItemConfig()
    local id = CollectibleType.COLLECTIBLE_NULL
    local failsafe = 150
    while(id==CollectibleType.COLLECTIBLE_NULL and failsafe>0) do
        id = pool:GetCollectible(poolType, false, nil, CollectibleType.COLLECTIBLE_MEAT, GetCollectibleFlag.BAN_ACTIVES)
        local iconf = conf:GetCollectible(id)
        if(not (iconf and iconf:HasTags(ItemConfig.TAG_SUMMONABLE))) then
            id = CollectibleType.COLLECTIBLE_NULL
        end

        failsafe = failsafe-1
    end

    return id
end

---@param pl EntityPlayer
local function checkItemLogic(_, pl)
    local data = ToyboxMod:getEntityDataTable(pl)

    local numHearts = pl:GetHearts() + (pl:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) and pl:GetSoulHearts() or 0)
    local shouldGiveItem = (numHearts >= pl:GetEffectiveMaxHearts())

    if(shouldGiveItem and (data.HOMUNCULUS_A_ITEM or -1)==-1) then
        data.HOMUNCULUS_A_ITEM = getRandomItem(pl:GetDropRNG())
        pl:SetInnateCollectibleGroup("ToyboxHomunculusAItems", {[data.HOMUNCULUS_A_ITEM]=1}, true)

        sfx:Play(SoundEffect.SOUND_THUMBSUP)
        pl:AnimateCollectible(data.HOMUNCULUS_A_ITEM, "UseItem")
        ToyboxMod.GAME:GetHUD():ShowItemText(pl, Isaac.GetItemConfig():GetCollectible(data.HOMUNCULUS_A_ITEM), false)
    elseif((not shouldGiveItem) and (data.HOMUNCULUS_A_ITEM or -1)~=-1) then
        data.HOMUNCULUS_A_ITEM = -1
        pl:ClearInnateItemGroup("ToyboxHomunculusAItems")

        sfx:Play(SoundEffect.SOUND_THUMBS_DOWN)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, checkItemLogic, ToyboxMod.PLAYER_HOMUNCULUS_A)

---@param pickup EntityPickup
---@param pl Entity
local function consumeHeart(_, pickup, pl)
    if(not ToyboxMod.RED_HEART_SUBTYPES[pickup.SubType]) then return end
    if(pickup:IsShopItem()) then return end
    if(not (pl and pl:ToPlayer() and pl:ToPlayer():GetPlayerType()==ToyboxMod.PLAYER_HOMUNCULUS_A)) then return end
    pl = pl:ToPlayer() ---@cast pl EntityPlayer

    if(pl:GetHearts()<pl:GetEffectiveMaxHearts()) then return end

    local data = ToyboxMod:getEntityDataTable(pl)
    data.HOMUNCULUS_A_ITEM = getRandomItem(pl:GetDropRNG())
    pl:SetInnateCollectibleGroup("ToyboxHomunculusAItems", {[data.HOMUNCULUS_A_ITEM]=1}, true)

    sfx:Play(SoundEffect.SOUND_THUMBSUP)
    pl:AnimateCollectible(data.HOMUNCULUS_A_ITEM, "UseItem")
    ToyboxMod.GAME:GetHUD():ShowItemText(pl, Isaac.GetItemConfig():GetCollectible(data.HOMUNCULUS_A_ITEM), false)

    pickup:GetSprite():Play("Collect", true)
    pickup:Die()

    sfx:Play(SoundEffect.SOUND_VAMP_GULP)

    return true
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, CallbackPriority.IMPORTANT+1, consumeHeart, PickupVariant.PICKUP_HEART)