local HOMUNCULUS_COLOR = Color(245/255, 245/255, 215/255, 1, 0, 0, 0, 1, 1, 1, 0.15)

---@param pl EntityPlayer
---@param params TearParams
local function getTearParams(_, pl, params)
    params.TearVariant = (ToyboxMod:getBloodTearVariant(params.TearVariant) or params.TearVariant)
end
--ToyboxMod:AddCallback(ModCallbacks.MC_EVALUATE_TEAR_HIT_PARAMS, getTearParams, ToyboxMod.PLAYER_HOMUNCULUS_A)

---@param ent Entity
---@param amount number
---@param flags DamageFlag
---@param frames integer
local function tryAddNoPenalties(_, ent, amount, flags, _, frames)
    local pl = ent:ToPlayer()
    if(not (pl and pl:GetPlayerType()==ToyboxMod.PLAYER_HOMUNCULUS_A and pl:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT))) then return end

    return {
        Damage= amount,
        DamageFlags= flags | DamageFlag.DAMAGE_NO_PENALTIES,
        DamageCountdown= frames,
    }
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, CallbackPriority.IMPORTANT, tryAddNoPenalties, EntityType.ENTITY_PLAYER)

---@param pl EntityPlayer
local function evalColorCache(_, pl)
    if(pl:GetPlayerType()~=ToyboxMod.PLAYER_HOMUNCULUS_A) then return end

    pl.Color = pl.Color*HOMUNCULUS_COLOR
end
ToyboxMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evalColorCache, CacheFlag.CACHE_COLOR)