local sfx = SFXManager()

local FIRE_COOLDOWN = 30*1.5
local EXTRA_SHOT_DELAY = 3

local SHOT_DMG = 4.5

---@param pl EntityPlayer
local function evalCache(_, pl)
    pl:CheckFamiliar(
        ToyboxMod.FAMILIAR_YES_BABY,
        pl:GetCollectibleNum(ToyboxMod.COLLECTIBLE_YES_BABY)+pl:GetEffects():GetCollectibleEffectNum(ToyboxMod.COLLECTIBLE_YES_BABY),
        pl:GetCollectibleRNG(ToyboxMod.COLLECTIBLE_YES_BABY),
        Isaac.GetItemConfig():GetCollectible(ToyboxMod.COLLECTIBLE_YES_BABY)
    )
end
ToyboxMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evalCache, CacheFlag.CACHE_FAMILIARS)

---@param familiar EntityFamiliar
local function yesBabyInit(_, familiar)
    familiar:AddToFollowers()
end
ToyboxMod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, yesBabyInit, ToyboxMod.FAMILIAR_YES_BABY)

local CANCEL_INIT = false
local NEXT_SUB = nil

local function cmpTearData(a, b)
    return a.Time<b.Time
end

---@param tear EntityTear
local function familiarFireProj(_, tear)
    local fam = tear.SpawnerEntity and tear.SpawnerEntity:ToFamiliar() ---@type EntityFamiliar
    local isBffs = (fam and fam:GetMultiplier()>1.5)

    local inverse = (tear.Velocity:Normalized():Dot(Vector(-1,0))>0.5 or tear.Velocity:Normalized():Dot(Vector(0,-1))>0.7)

    tear.CollisionDamage = SHOT_DMG*fam:GetMultiplier()
    tear.Scale = 1
    tear:ResetSpriteScale(true)
    tear:ChangeVariant(ToyboxMod.TEAR_YES)
    tear.SubType = (inverse and ((isBffs and 4 or 3)-(NEXT_SUB or 0)-1) or (NEXT_SUB or 0))+(isBffs and 4 or 0)

    if(NEXT_SUB or CANCEL_INIT) then return end
    local shotsNum = (isBffs and 4 or 3)
    local data = ToyboxMod:getEntityDataTable(fam)
    data.YES_BABY_QUEUE = data.YES_BABY_QUEUE or {}
    for i=1, shotsNum-1 do
        local tearData = {
            Sub = i,
            Dir = tear.Velocity,
            Time = fam.FrameCount+i*EXTRA_SHOT_DELAY
        }
        table.insert(data.YES_BABY_QUEUE, tearData)
    end
    table.sort(data.YES_BABY_QUEUE, cmpTearData)
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_POST_FAMILIAR_FIRE_PROJECTILE, CallbackPriority.IMPORTANT, familiarFireProj, ToyboxMod.FAMILIAR_YES_BABY)

---@param familiar EntityFamiliar
local function yesBabyUpdate(_, familiar)
    local sp = familiar:GetSprite()
    local rng = familiar:GetDropRNG()
    local pl = familiar.Player

    familiar:FollowParent()

    local oldCooldown = familiar.FireCooldown
    familiar:Shoot()

    if(oldCooldown<familiar.FireCooldown) then
        familiar.FireCooldown = FIRE_COOLDOWN
    end

    local data = ToyboxMod:getEntityDataTable(familiar)
    if(data.YES_BABY_QUEUE) then
        local toRemove = -1
        for i=1, #data.YES_BABY_QUEUE do
            if(data.YES_BABY_QUEUE[i].Time<=familiar.FrameCount) then
                toRemove = i

                CANCEL_INIT = true
                NEXT_SUB = data.YES_BABY_QUEUE[i].Sub
                local dir = data.YES_BABY_QUEUE[i].Dir
                dir = (dir-familiar.Player:GetTearMovementInheritance(dir)):Normalized()
                familiar:FireProjectile(dir)
                NEXT_SUB = nil
                CANCEL_INIT = nil
            end
        end
        for _=1, toRemove do
            table.remove(data.YES_BABY_QUEUE, 1)
        end
        table.sort(data.YES_BABY_QUEUE, cmpTearData)
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_FAMILIAR_UPDATE, CallbackPriority.IMPORTANT, yesBabyUpdate, ToyboxMod.FAMILIAR_YES_BABY)

local YES_TEAR_ANIMS = {
    [1] = "S",
    [2] = "E",
    [3] = "Y",
    [4] = nil,
    [5] = "H",
    [6] = "A",
    [7] = "E",
    [8] = "Y",
}

---@param tear EntityTear
local function playYesTearAnim(tear, forcePlay)
    local sp = tear:GetSprite()

    local desAnim = "Tear_"..(YES_TEAR_ANIMS[tear.SubType+1] or "A")

    if(sp:GetAnimation()~=desAnim) then
        if(forcePlay) then
            sp:Play(desAnim, true)
        else
            sp:SetAnimation(desAnim, false)
        end
    end
end

---@param tear EntityTear
local function yesTearInit(_, tear)
    playYesTearAnim(tear, true)
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, yesTearInit, ToyboxMod.TEAR_YES)

---@param tear EntityTear
local function yesTearUpdate(_, tear)
    playYesTearAnim(tear, true)
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, yesTearUpdate, ToyboxMod.TEAR_YES)

---@param tear EntityTear
local function aidsTearDeath(_, tear)
    sfx:Play(SoundEffect.SOUND_SPLATTER, 1, 0, false, 1.0)

	if(tear.TearFlags & TearFlags.TEAR_EXPLOSIVE == TearFlags.TEAR_EXPLOSIVE) then return end

    local poof = Isaac.Spawn(1000, ToyboxMod:getTearPoofVariantFromTear(tear), 0, tear.Position, Vector.Zero, tear):ToEffect()

    poof:GetSprite().Color = tear:GetSprite().Color*Color(255/185,236/207,135/255,1)
    if(tear.Scale > 0.8) then
        poof.SpriteScale = Vector(1, 1)*(tear.Scale*0.8)
    end
    poof.PositionOffset = tear.PositionOffset
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_TEAR_DEATH, aidsTearDeath, ToyboxMod.TEAR_YES)

local function familiarPriority(_, fam)
    return FollowerPriority.SHOOTER
end
ToyboxMod:AddCallback(ModCallbacks.MC_GET_FOLLOWER_PRIORITY, familiarPriority, ToyboxMod.FAMILIAR_YES_BABY)