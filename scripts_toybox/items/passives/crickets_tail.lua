local MULT_DMG_POW = 0.5

local DAMAGE_PER_CHARGE = 0.5
local DAMAGE_BASE = 0.5
local DAMAGE_PER_SECONDTIMED = 0.1

local DAMAGE_DECAY = 0.05
local DAMAGE_DECAY_FREQ = 20
local DAMAGE_DECAYFAST_THRESHOLD = 2
local DAMAGE_DECAYFAST_MULT = 0.0333

---@param id CollectibleType
---@param removed boolean
---@param player EntityPlayer
---@param slot ActiveSlot
local function dischargeActive(_, id, removed, player, slot)
    if(not player:HasCollectible(ToyboxMod.COLLECTIBLE_CRICKETS_TAIL)) then return end

    local conf = Isaac.GetItemConfig():GetCollectible(id)
    if(conf and conf.ChargeType~=ItemConfig.CHARGE_SPECIAL) then
        local isTimed = conf.ChargeType==ItemConfig.CHARGE_TIMED
        local charges = (isTimed and conf.MaxCharges/30 or conf.MaxCharges)
        local damageToGive = (isTimed and (charges*DAMAGE_PER_SECONDTIMED) or (charges*DAMAGE_PER_CHARGE))+DAMAGE_BASE
        damageToGive = damageToGive*(1+MULT_DMG_POW*(player:GetCollectibleNum(ToyboxMod.COLLECTIBLE_CRICKETS_TAIL)-1))

        local data = ToyboxMod:getEntityDataTable(player)
        data.CRICKETS_TAIL_DAMAGE = math.max(data.CRICKETS_TAIL_DAMAGE or 0, damageToGive)
        data.CRICKETS_TAIL_FRAME = 0

        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        player:EvaluateItems()
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_DISCHARGE_ACTIVE_ITEM, dischargeActive)

---@param pl EntityPlayer
local function postPeffectUpdate(_, pl)
    if(not pl:HasCollectible(ToyboxMod.COLLECTIBLE_CRICKETS_TAIL)) then return end

    local data = ToyboxMod:getEntityDataTable(pl)
    data.CRICKETS_TAIL_FRAME = data.CRICKETS_TAIL_FRAME or 0
    if(data.CRICKETS_TAIL_FRAME>=DAMAGE_DECAY_FREQ and (data.CRICKETS_TAIL_DAMAGE or 0)>0) then
        local dmg = data.CRICKETS_TAIL_DAMAGE or 0

        if(dmg>DAMAGE_DECAYFAST_THRESHOLD) then
            dmg = math.max(dmg-DAMAGE_DECAY-dmg*DAMAGE_DECAYFAST_MULT, 0)
        else
            dmg = math.max(dmg-DAMAGE_DECAY, 0)
        end

        data.CRICKETS_TAIL_DAMAGE = dmg
        pl:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        pl:EvaluateItems()

        data.CRICKETS_TAIL_FRAME = 0
    end

    data.CRICKETS_TAIL_FRAME = data.CRICKETS_TAIL_FRAME+1
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, postPeffectUpdate)

---@param pl EntityPlayer
---@param val number
local function evalStat(_, pl, stat, val)
    if(not pl:HasCollectible(ToyboxMod.COLLECTIBLE_CRICKETS_TAIL)) then return end

    return val+(ToyboxMod:getEntityData(pl, "CRICKETS_TAIL_DAMAGE") or 0)
end
ToyboxMod:AddCallback(ModCallbacks.MC_EVALUATE_STAT, evalStat, EvaluateStatStage.FLAT_DAMAGE)