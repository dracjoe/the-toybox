local FIRE_COOLDOWN = 18
local TEAR_DMG = 5

local FEAR_CHANCE = 0.25

---@param pl EntityPlayer
local function evalCache(_, pl)
    pl:CheckFamiliar(
        ToyboxMod.FAMILIAR_CRAZED_BOBBY,
        pl:GetCollectibleNum(ToyboxMod.COLLECTIBLE_CRAZED_BOBBY)+pl:GetEffects():GetCollectibleEffectNum(ToyboxMod.COLLECTIBLE_CRAZED_BOBBY),
        pl:GetCollectibleRNG(ToyboxMod.COLLECTIBLE_CRAZED_BOBBY),
        Isaac.GetItemConfig():GetCollectible(ToyboxMod.COLLECTIBLE_CRAZED_BOBBY)
    )
end
ToyboxMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evalCache, CacheFlag.CACHE_FAMILIARS)

---@param tear EntityTear
local function familiarFireProj(_, tear)
    local fam = tear.SpawnerEntity and tear.SpawnerEntity:ToFamiliar() ---@type EntityFamiliar
    if(not fam) then return end

    tear.CollisionDamage = TEAR_DMG*(fam and fam:GetMultiplier() or 1)
    tear.Scale = tear.Scale*1.1
    if(fam:GetDropRNG():RandomFloat()<FEAR_CHANCE) then
        tear:AddTearFlags(TearFlags.TEAR_FEAR)
        tear:ChangeVariant(TearVariant.DARK_MATTER)
        tear.Color = tear.Color*Color(1.1,0.8,1.1,1,0.1,0,0.1)
        tear.Scale = tear.Scale*1.25
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_POST_FAMILIAR_FIRE_PROJECTILE, CallbackPriority.IMPORTANT, familiarFireProj, ToyboxMod.FAMILIAR_CRAZED_BOBBY)

---@param familiar EntityFamiliar
local function psychoBabyInit(_, familiar)
    familiar:AddToFollowers()
end
ToyboxMod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, psychoBabyInit, ToyboxMod.FAMILIAR_CRAZED_BOBBY)

---@param familiar EntityFamiliar
local function psychoBabyUpdate(_, familiar)
    familiar:FollowParent()

    local oldCooldown = familiar.FireCooldown
    familiar:Shoot()

    if(oldCooldown<familiar.FireCooldown) then
        familiar.FireCooldown = FIRE_COOLDOWN
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_FAMILIAR_UPDATE, CallbackPriority.IMPORTANT, psychoBabyUpdate, ToyboxMod.FAMILIAR_CRAZED_BOBBY)
