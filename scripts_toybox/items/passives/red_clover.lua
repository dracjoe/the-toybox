local LUCK_UP = 1
local DMG_PER_LUCK = 0.4
local DMG_MULT_STACK = 1.25

local alreadyUpdating = false

---@param pl EntityPlayer
---@param flag CacheFlag
local function evalCache(_, pl, flag)
    if(not pl:HasCollectible(ToyboxMod.COLLECTIBLE_RED_CLOVER)) then return end

    local mult = pl:GetCollectibleNum(ToyboxMod.COLLECTIBLE_RED_CLOVER)

    if(flag==CacheFlag.CACHE_LUCK and alreadyUpdating~="LUCK") then
        pl.Luck = pl.Luck+LUCK_UP*mult

        if(not alreadyUpdating) then
            alreadyUpdating = "LUCK"
            pl:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            pl:EvaluateItems()
            alreadyUpdating = false
        end
    elseif(flag==CacheFlag.CACHE_DAMAGE and alreadyUpdating~="DAMAGE") then
        if(not alreadyUpdating) then
            alreadyUpdating = "DAMAGE"
            pl:AddCacheFlags(CacheFlag.CACHE_LUCK)
            pl:EvaluateItems()
            alreadyUpdating = false
        end
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE, CallbackPriority.LATE, evalCache)

---@param pl EntityPlayer
---@param val number
local function evalStat(_, pl, stat, val)
    if(not pl:HasCollectible(ToyboxMod.COLLECTIBLE_RED_CLOVER)) then return end

    return val+pl.Luck*DMG_PER_LUCK
end
ToyboxMod:AddCallback(ModCallbacks.MC_EVALUATE_STAT, evalStat, EvaluateStatStage.DAMAGE_UP)