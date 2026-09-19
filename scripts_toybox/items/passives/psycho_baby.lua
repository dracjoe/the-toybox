local sfx = SFXManager()

local FIRE_COOLDOWN = 37
local FIRE_COOLDOWN_BUFFED = 23
local TEAR_DMG = 7
local TEAR_DMG_BUFFED = 9

---@param pl EntityPlayer
local function evalCache(_, pl)
    pl:CheckFamiliar(
        ToyboxMod.FAMILIAR_PSYCHO_BABY,
        pl:GetCollectibleNum(ToyboxMod.COLLECTIBLE_PSYCHO_BABY)+pl:GetEffects():GetCollectibleEffectNum(ToyboxMod.COLLECTIBLE_PSYCHO_BABY),
        pl:GetCollectibleRNG(ToyboxMod.COLLECTIBLE_PSYCHO_BABY),
        Isaac.GetItemConfig():GetCollectible(ToyboxMod.COLLECTIBLE_PSYCHO_BABY)
    )
end
ToyboxMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evalCache, CacheFlag.CACHE_FAMILIARS)

---@param tear EntityTear
local function familiarFireProj(_, tear)
    local fam = tear.SpawnerEntity and tear.SpawnerEntity:ToFamiliar() ---@type EntityFamiliar

    tear.CollisionDamage = ((fam and fam.State>0) and TEAR_DMG_BUFFED or TEAR_DMG)*(fam and fam:GetMultiplier() or 1)
    if(fam and fam.State>0) then
        local bloody = ToyboxMod:getBloodTearVariant(tear)
        if(bloody) then
            tear:ChangeVariant(bloody)
        end
        tear.Scale = 1.1
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_POST_FAMILIAR_FIRE_PROJECTILE, CallbackPriority.IMPORTANT, familiarFireProj, ToyboxMod.FAMILIAR_PSYCHO_BABY)

---@param fam EntityFamiliar
---@param state integer
local function updatePsychoState(fam, state)
    if(state==0) then
        fam:GetSprite():ReplaceSpritesheet(0, "gfx_tb/familiars/familiar_psycho_baby.png", true)
    elseif(state>0) then
        fam:GetSprite():ReplaceSpritesheet(0, "gfx_tb/familiars/familiar_psycho_baby_2.png", true)
    end

    if(fam.State==0 and state>0) then
        sfx:Play(SoundEffect.SOUND_DEATH_BURST_LARGE)

        local poof = Isaac.Spawn(1000,16,5,fam.Position,Vector.Zero,nil)
        poof.SpriteScale = Vector(1,1)*0.5
        poof.SpriteOffset = Vector(0,-10)
        poof.Color = Color(0,0,0,1,200/255,0,0,2)
        poof:GetSprite().PlaybackSpeed = 1.25
        poof:GetSprite():SetCustomShader("shaders_tb/pixelate")
    end
    fam.State = state
end

---@param familiar EntityFamiliar
local function psychoBabyInit(_, familiar)
    familiar:AddToFollowers()

    updatePsychoState(familiar, 0)
end
ToyboxMod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, psychoBabyInit, ToyboxMod.FAMILIAR_PSYCHO_BABY)

local function psychoBabyNewRoom(_)
    for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, ToyboxMod.FAMILIAR_PSYCHO_BABY)) do
        updatePsychoState(ent:ToFamiliar(), 0)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, psychoBabyNewRoom)

---@param familiar EntityFamiliar
local function psychoBabyUpdate(_, familiar)
    familiar:FollowParent()

    local oldCooldown = familiar.FireCooldown
    familiar:Shoot()

    if(oldCooldown<familiar.FireCooldown) then
        familiar.FireCooldown = (familiar.State>0 and FIRE_COOLDOWN_BUFFED or FIRE_COOLDOWN)
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_FAMILIAR_UPDATE, CallbackPriority.IMPORTANT, psychoBabyUpdate, ToyboxMod.FAMILIAR_PSYCHO_BABY)

---@param familiar EntityFamiliar
local function psychoBabyPreRender(_, familiar)
    local sp = familiar:GetSprite()
    if(sp.FlipX and string.find(sp:GetAnimation(), "Side") and not string.find(sp:GetAnimation(), "Side2")) then
        sp.FlipX = false
        sp:SetAnimation(sp:GetAnimation().."2", false)
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_PRE_FAMILIAR_RENDER, CallbackPriority.LATE, psychoBabyPreRender, ToyboxMod.FAMILIAR_PSYCHO_BABY)

---@param familiar EntityFamiliar
local function psychoBabyPostRender(_, familiar)
    local sp = familiar:GetSprite()
    if((not sp.FlipX) and string.find(sp:GetAnimation(), "Side2")) then
        sp.FlipX = true
        sp:SetAnimation(string.sub(sp:GetAnimation(), 1, -2), false)
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_POST_FAMILIAR_RENDER, CallbackPriority.IMPORTANT, psychoBabyPostRender, ToyboxMod.FAMILIAR_PSYCHO_BABY)

---@param ent Entity
---@param source EntityRef
local function tryCheckIfKill(_, ent, dmg, flags, source, countdown)
    if(not (source and source.Entity)) then return end
    if(not (ent:IsDead() or ent:HasMortalDamage())) then return end

    local s = source.Entity

    local fam = s:ToFamiliar() or (s.SpawnerEntity and s.SpawnerEntity:ToFamiliar()) or (s.Parent and s.Parent:ToFamiliar())
    if(fam and fam.Variant==ToyboxMod.FAMILIAR_PSYCHO_BABY) then
        if(fam.State==0) then
            updatePsychoState(fam, 1)
        end

        --ent:AddEntityFlags(EntityFlag.FLAG_EXTRA_GORE)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_TAKE_DMG, tryCheckIfKill)

local function familiarPriority(_, fam)
    return FollowerPriority.SHOOTER
end
ToyboxMod:AddCallback(ModCallbacks.MC_GET_FOLLOWER_PRIORITY, familiarPriority, ToyboxMod.FAMILIAR_PSYCHO_BABY)