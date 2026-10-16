local function trinketAdded(_, player, id)
    local progress = (id & TrinketType.TRINKET_GOLDEN_FLAG ~= 0) and 2 or 1
    player:IncrementPlayerFormCounter(PlayerForm.PLAYERFORM_BABY, progress)
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, trinketAdded, ToyboxMod.TRINKET_PETRIFIED_BABY)
ToyboxMod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, trinketAdded, ToyboxMod.TRINKET_PETRIFIED_BABY | TrinketType.TRINKET_GOLDEN_FLAG)

local function trinketRemoved(_, player, id)
    local progress = (id & TrinketType.TRINKET_GOLDEN_FLAG ~= 0) and 2 or 1
    player:IncrementPlayerFormCounter(PlayerForm.PLAYERFORM_BABY, -progress)
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_REMOVED, trinketRemoved, ToyboxMod.TRINKET_PETRIFIED_BABY)
ToyboxMod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_REMOVED, trinketRemoved, ToyboxMod.TRINKET_PETRIFIED_BABY | TrinketType.TRINKET_GOLDEN_FLAG)

---@param pl EntityPlayer
local function evalCache(_, pl)
    pl:CheckFamiliar(
        ToyboxMod.FAMILIAR_PETRIFIED_BABY,
        pl:GetTrinketMultiplier(ToyboxMod.TRINKET_PETRIFIED_BABY)+pl:GetEffects():GetTrinketEffectNum(ToyboxMod.TRINKET_PETRIFIED_BABY),
        pl:GetTrinketRNG(ToyboxMod.TRINKET_PETRIFIED_BABY),
        Isaac.GetItemConfig():GetTrinket(ToyboxMod.TRINKET_PETRIFIED_BABY)
    )
end
ToyboxMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evalCache, CacheFlag.CACHE_FAMILIARS)

---@param familiar EntityFamiliar
local function rockBabyInit(_, familiar)
    familiar:AddToFollowers()
end
ToyboxMod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, rockBabyInit, ToyboxMod.FAMILIAR_PETRIFIED_BABY)

---@param familiar EntityFamiliar
local function rockBabyUpdate(_, familiar)
    familiar:FollowParent()

    familiar:GetSprite():Play("FloatDown")
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_FAMILIAR_UPDATE, CallbackPriority.IMPORTANT, rockBabyUpdate, ToyboxMod.FAMILIAR_PETRIFIED_BABY)

---@param familiar EntityFamiliar
local function rockBabyPriroty(_, familiar)
    return FollowerPriority.DEFENSIVE
end
ToyboxMod:AddCallback(ModCallbacks.MC_GET_FOLLOWER_PRIORITY, rockBabyPriroty, ToyboxMod.FAMILIAR_PETRIFIED_BABY)