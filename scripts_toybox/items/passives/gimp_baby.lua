local FIRE_COOLDOWN = 12
local TEAR_DMG = 2.5

---@param pl EntityPlayer
local function evalCache(_, pl)
    pl:CheckFamiliar(
        ToyboxMod.FAMILIAR_GIMP_BABY,
        pl:GetCollectibleNum(ToyboxMod.COLLECTIBLE_GIMP_BABY)+pl:GetEffects():GetCollectibleEffectNum(ToyboxMod.COLLECTIBLE_GIMP_BABY),
        pl:GetCollectibleRNG(ToyboxMod.COLLECTIBLE_GIMP_BABY),
        Isaac.GetItemConfig():GetCollectible(ToyboxMod.COLLECTIBLE_GIMP_BABY)
    )
end
ToyboxMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evalCache, CacheFlag.CACHE_FAMILIARS)

---@param tear EntityTear
local function familiarFireProj(_, tear)
    local fam = tear.SpawnerEntity and tear.SpawnerEntity:ToFamiliar() ---@type EntityFamiliar

    tear.CollisionDamage = TEAR_DMG*(fam and fam:GetMultiplier() or 1)
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_POST_FAMILIAR_FIRE_PROJECTILE, CallbackPriority.IMPORTANT, familiarFireProj, ToyboxMod.FAMILIAR_GIMP_BABY)

---@param familiar EntityFamiliar
local function gimpBabyInit(_, familiar)
    familiar:AddToFollowers()
end
ToyboxMod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, gimpBabyInit, ToyboxMod.FAMILIAR_GIMP_BABY)

---@param familiar EntityFamiliar
local function gimpBabyUpdate(_, familiar)
    familiar:FollowParent()

    local oldCooldown = familiar.FireCooldown
    familiar:Shoot()

    if(oldCooldown<familiar.FireCooldown) then
        familiar.FireCooldown = FIRE_COOLDOWN
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_FAMILIAR_UPDATE, CallbackPriority.IMPORTANT, gimpBabyUpdate, ToyboxMod.FAMILIAR_GIMP_BABY)

---@param familiar EntityFamiliar
local function gimpBabyPriroty(_, familiar)
    return FollowerPriority.DEFENSIVE
end
ToyboxMod:AddCallback(ModCallbacks.MC_GET_FOLLOWER_PRIORITY, gimpBabyPriroty, ToyboxMod.FAMILIAR_GIMP_BABY)

---@param familiar EntityFamiliar
local function gimpyBabyPreRender(_, familiar)
    local sp = familiar:GetSprite()
    if(sp.FlipX and string.find(sp:GetAnimation(), "Side") and not string.find(sp:GetAnimation(), "Side2")) then
        sp.FlipX = false
        sp:SetAnimation(sp:GetAnimation().."2", false)
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_PRE_FAMILIAR_RENDER, CallbackPriority.LATE, gimpyBabyPreRender, ToyboxMod.FAMILIAR_GIMP_BABY)

---@param familiar EntityFamiliar
local function gimpyBabyPostRender(_, familiar)
    local sp = familiar:GetSprite()
    if((not sp.FlipX) and string.find(sp:GetAnimation(), "Side2")) then
        sp.FlipX = true
        sp:SetAnimation(string.sub(sp:GetAnimation(), 1, -2), false)
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_POST_FAMILIAR_RENDER, CallbackPriority.IMPORTANT, gimpyBabyPostRender, ToyboxMod.FAMILIAR_GIMP_BABY)

local function familiarPriority(_, fam)
    return FollowerPriority.SHOOTER
end
ToyboxMod:AddCallback(ModCallbacks.MC_GET_FOLLOWER_PRIORITY, familiarPriority, ToyboxMod.FAMILIAR_GIMP_BABY)