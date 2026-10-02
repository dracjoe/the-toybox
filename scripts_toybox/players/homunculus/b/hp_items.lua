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
    data.HOMUNCULUS_B_ITEMS = data.HOMUNCULUS_B_ITEMS or {}

    local numHearts = math[pl:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) and "ceil" or "floor"](pl:GetHearts()/2)
    if(numHearts==#data.HOMUNCULUS_B_ITEMS) then return end

    if(numHearts<#data.HOMUNCULUS_B_ITEMS) then
        for i=#data.HOMUNCULUS_B_ITEMS, numHearts+1, -1 do
            table.remove(data.HOMUNCULUS_B_ITEMS, i)
        end
        if(pl.FrameCount>1) then
            ToyboxMod.SFX:Play(SoundEffect.SOUND_THUMBS_DOWN)
        end
    else
        local rng = pl:GetDropRNG()
        for _=#data.HOMUNCULUS_B_ITEMS+1, numHearts do
            table.insert(data.HOMUNCULUS_B_ITEMS, getRandomItem(rng))
        end
        if(pl.FrameCount>1) then
            local finalId = data.HOMUNCULUS_B_ITEMS[#data.HOMUNCULUS_B_ITEMS]
            pl:AnimateCollectible(finalId, "UseItem")
            ToyboxMod.GAME:GetHUD():ShowItemText(pl, Isaac.GetItemConfig():GetCollectible(finalId), false)

            ToyboxMod.SFX:Play(SoundEffect.SOUND_VAMP_GULP)
        end
    end

    local items = {}
    for _, id in ipairs(data.HOMUNCULUS_B_ITEMS) do
        items[id] = (items[id] or 0)+1
    end

    pl:SetInnateCollectibleGroup("ToyboxHomunculusBItems", items, true)
    if(#data.HOMUNCULUS_B_ITEMS<=0) then
        pl:ClearInnateItemGroup("ToyboxHomunculusBItems")
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, checkItemLogic, ToyboxMod.PLAYER_HOMUNCULUS_B)