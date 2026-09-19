local sfx = SFXManager()

local DURATION = 30*60

local BASE_FIRERATE = 18
local BASE_DMG = 4
local BASE_VEL = 13
local VIRUS_INFO = {
    [ToyboxMod.FAMILIAR_VIRUS_RED] = {
        DMGMULT = 0.5, TEARSMULT = 1,
        COLOR = Color(1.25,0.75,0.5,1, 0.2,0.05,0, 2,1,0,1),
        FLAGS = {
            {TearFlags.TEAR_BURN, 0.5},
        },
        SHEET_SUFFIX = "red",
    },
    [ToyboxMod.FAMILIAR_VIRUS_YELLOW_1] = {
        DMGMULT = 1.5, TEARSMULT = 1,
        COLOR = Color(0.75,0.75,0.5,1, 0.12,0.12,0, 1,1,0,1),
        SPREAD = 15,
        SHEET_SUFFIX = "yellow",
    },
    [ToyboxMod.FAMILIAR_VIRUS_BLUE] = {
        DMGMULT = 1, TEARSMULT = 1,
        COLOR = Color(2,2,3,1, 0,0,0.15, 0.25,0.25,1,1),
        FLAGS = {
            {TearFlags.TEAR_ICE, 1},
        },
        SHEET_SUFFIX = "blue",
    },
    [ToyboxMod.FAMILIAR_VIRUS_MAGENTA] = {
        DMGMULT = 1.5, TEARSMULT = 0.75,
        COLOR = Color(2,1,2,1, 0.15,0,0.15, 2,0.25,2,1),
        FLAGS = {
            {TearFlags.TEAR_CONFUSION, 0.2},
        },
        SHEET_SUFFIX = "magenta",
    },
    [ToyboxMod.FAMILIAR_VIRUS_YELLOW_2] = {
        DMGMULT = 0.5, TEARSMULT = 2,
        RANGEMULT = 1.5, SHOTSPEEDMULT = 0.66,
        COLOR = Color(0.75,0.75,0.5,1, 0.2,0.2,0, 1,1,0,1),
        FLAGS = {
            {TearFlags.TEAR_FREEZE, 0.15},
        },
        SHEET_SUFFIX = "yellow2",
    },
    [ToyboxMod.FAMILIAR_VIRUS_CYAN] = {
        DMGMULT = 0.75, TEARSMULT = 1,
        COLOR = Color(1,2,2,1, 0,0,0, 0.25,1,1,1),
        FLAGS = {
            {TearFlags.TEAR_SLOW, 0.2},
            {TearFlags.TEAR_WIGGLE, 1},
        },
        SHEET_SUFFIX = "cyan",
    },
    [ToyboxMod.FAMILIAR_VIRUS_GREEN] = {
        DMGMULT = 1.5, TEARSMULT = 0.33,
        COLOR = Color(0,3,2,1, 0,0.15,0, 0.25,1,0.25,1),
        FLAGS = {
            {TearFlags.TEAR_POISON, 0.5},
        },
        SHEET_SUFFIX = "green",
    },
    [ToyboxMod.FAMILIAR_VIRUS_LIGHT_BLUE] = {
        DMGMULT = 0.15, TEARSMULT = 6,
        SPREAD = 5,
        FLAGS = {
            {TearFlags.TEAR_LIGHT_FROM_HEAVEN, 0.025},
        },
        SHEET_SUFFIX = "lightblue",
    },
    [ToyboxMod.FAMILIAR_VIRUS_PINK] = {
        DMGMULT = 1, TEARSMULT = 1,
        COLOR = Color(2,0.5,2,1, 0.15,0,0.15, 2,0.25,2,1),
        FLAGS = {
            {TearFlags.TEAR_CHARM, 0.2},
        },
        SHEET_SUFFIX = "pink",
    },
    [ToyboxMod.FAMILIAR_VIRUS_PURPLE] = {
        DMGMULT = 1.25, TEARSMULT = 0.66,
        COLOR = Color(1.5,0.5,2.5,1, 0.1,0,0.2, 1.5,0.25,3,1),
        FLAGS = {
            {TearFlags.TEAR_HOMING, 1},
        },
        SHEET_SUFFIX = "purple",
    },
}

local SUBTYPE_PICKER = WeightedOutcomePicker()
    SUBTYPE_PICKER:AddOutcomeWeight(ToyboxMod.FAMILIAR_VIRUS_RED, 1)
    SUBTYPE_PICKER:AddOutcomeWeight(ToyboxMod.FAMILIAR_VIRUS_YELLOW_1, 1)
    SUBTYPE_PICKER:AddOutcomeWeight(ToyboxMod.FAMILIAR_VIRUS_BLUE, 1)
    SUBTYPE_PICKER:AddOutcomeWeight(ToyboxMod.FAMILIAR_VIRUS_MAGENTA, 1)
    SUBTYPE_PICKER:AddOutcomeWeight(ToyboxMod.FAMILIAR_VIRUS_YELLOW_2, 1)
    SUBTYPE_PICKER:AddOutcomeWeight(ToyboxMod.FAMILIAR_VIRUS_CYAN, 1)
    SUBTYPE_PICKER:AddOutcomeWeight(ToyboxMod.FAMILIAR_VIRUS_GREEN, 1)
    SUBTYPE_PICKER:AddOutcomeWeight(ToyboxMod.FAMILIAR_VIRUS_LIGHT_BLUE, 1)
    SUBTYPE_PICKER:AddOutcomeWeight(ToyboxMod.FAMILIAR_VIRUS_PINK, 1)
    SUBTYPE_PICKER:AddOutcomeWeight(ToyboxMod.FAMILIAR_VIRUS_PURPLE, 1)


---@param player EntityPlayer
local function spawnVirus(player)
    local rng = player:GetCollectibleRNG(ToyboxMod.COLLECTIBLE_GIANT_CAPSULE)
        
    for _=1, player:GetCollectibleNum(ToyboxMod.COLLECTIBLE_GIANT_CAPSULE) do
        local var = SUBTYPE_PICKER:PickOutcome(rng)
        local virus = Isaac.Spawn(3,ToyboxMod.FAMILIAR_VIRUS,var,player.Position,player.Velocity,player):ToFamiliar()
        virus.Player = player
    end

    sfx:Play(ToyboxMod.SFX_VIRUS_SPAWN)
end

---@param player EntityPlayer
local function useConsumable(_, _, player)
    if(player:HasCollectible(ToyboxMod.COLLECTIBLE_GIANT_CAPSULE)) then
        spawnVirus(player)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_USE_PILL, useConsumable)
ToyboxMod:AddCallback(ModCallbacks.MC_USE_CARD, useConsumable)

---@param player EntityPlayer
local function evalViruses(_, player)
    player:CheckFamiliar(
        ToyboxMod.FAMILIAR_VIRUS,
        player:GetCollectibleNum(ToyboxMod.COLLECTIBLE_GIANT_CAPSULE)+player:GetEffects():GetCollectibleEffectNum(ToyboxMod.COLLECTIBLE_GIANT_CAPSULE),
        player:GetCollectibleRNG(ToyboxMod.COLLECTIBLE_GIANT_CAPSULE),
        Isaac.GetItemConfig():GetCollectible(ToyboxMod.COLLECTIBLE_GIANT_CAPSULE)
    )
end
--ToyboxMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evalViruses, CacheFlag.CACHE_FAMILIARS)

---@param familiar EntityFamiliar
local function virusInit(_, familiar)
    local sprite = familiar:GetSprite()
    sprite:Play("Float", true)

    local suff = tostring((VIRUS_INFO[familiar.SubType] or {}).SHEET_SUFFIX or "red")
    sprite:ReplaceSpritesheet(0, "gfx_tb/familiars/familiar_virus_"..suff..".png", true)

    familiar:AddToFollowers()

    familiar.Hearts = DURATION
end
ToyboxMod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, virusInit, ToyboxMod.FAMILIAR_VIRUS)

---@param tear EntityTear
local function familiarFireProj(_, tear)
    local virusData = VIRUS_INFO[tear.SpawnerEntity and tear.SpawnerEntity.SubType] or VIRUS_INFO[0]
    if(not virusData) then return end

    tear.CollisionDamage = BASE_DMG*(virusData.DMGMULT or 1)*(tear.SpawnerEntity and tear.SpawnerEntity:ToFamiliar() and tear.SpawnerEntity:ToFamiliar():GetMultiplier() or 1)
    tear.Velocity:Resize(BASE_VEL*(virusData.SHOTSPEEDMULT or 1))
    if(virusData.COLOR) then
        tear.Color = virusData.COLOR
    end

    local rng = tear.SpawnerEntity and tear.SpawnerEntity:GetDropRNG() or ToyboxMod:generateRng()
    for _, flagData in pairs(virusData.FLAGS or {}) do
        if(rng:RandomFloat()<(flagData[2] or 1)) then
            tear:AddTearFlags(flagData[1])
        end
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_POST_FAMILIAR_FIRE_PROJECTILE, CallbackPriority.IMPORTANT, familiarFireProj, ToyboxMod.FAMILIAR_VIRUS)

---@param familiar EntityFamiliar
local function virusUpdate(_, familiar)
    if(familiar.Hearts<0) then
        familiar:Remove()
        return
    end

    local sp = familiar:GetSprite()
    local rng = familiar:GetDropRNG()
    local pl = familiar.Player

    familiar:FollowParent()

    -- FIRE LOGIC
    local virusData = VIRUS_INFO[familiar.SubType] or VIRUS_INFO[0]
    local fireCool = math.floor(BASE_FIRERATE/(virusData.TEARSMULT or 1))

    if(familiar.FireCooldown<=0) then
        if(ToyboxMod:isPlayerShooting(pl)) then
            local dir = math.floor((pl:GetShootingInput():GetAngleDegrees()+225)%360/90)
            local fireVec = Isaac.GetAxisAlignedUnitVectorFromDir(dir)

            if(virusData.SPREAD) then
                fireVec = fireVec:Rotated((rng:RandomFloat()*2-1)*virusData.SPREAD)
            end

            sp:SetAnimation("FloatShoot", false)
            local tear = familiar:FireProjectile(fireVec)

            --tear:Update()
            sfx:Play(ToyboxMod.SFX_VIRUS_SHOOT, 0.5, 1, false, 0.95+rng:RandomFloat()*0.1, 0)

            familiar.FireCooldown = fireCool
        end
    else
        familiar.FireCooldown = familiar.FireCooldown-(pl:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) and 2 or 1)
        familiar.FireCooldown = math.max(familiar.FireCooldown, 0)

        if(sp:GetAnimation()=="FloatShoot" and familiar.FireCooldown<=fireCool/2) then
            sp:SetAnimation("Float", false)
        end
    end

    familiar.Hearts = familiar.Hearts-1
    if(familiar.Hearts<=0) then
        familiar.Hearts = -1
        familiar:Remove()
        familiar:Update()

        local imp = Isaac.Spawn(1000, EffectVariant.IMPACT, 0, familiar.Position, Vector.Zero, familiar):ToEffect()
        imp.SpriteOffset = Vector(0, -15)

        local col = (VIRUS_INFO[familiar.SubType] or VIRUS_INFO[0]).COLOR
        imp.Color = col or imp.Color
        sfx:Play(ToyboxMod.SFX_VIRUS_DIE)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, virusUpdate, ToyboxMod.FAMILIAR_VIRUS)
--im bored

local function familiarPriority(_, fam)
    return FollowerPriority.SHOOTER
end
ToyboxMod:AddCallback(ModCallbacks.MC_GET_FOLLOWER_PRIORITY, familiarPriority, ToyboxMod.FAMILIAR_VIRUS)

