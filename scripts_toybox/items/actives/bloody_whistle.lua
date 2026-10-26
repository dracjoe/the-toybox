
local sfx = SFXManager()

local CREEP_DURATION = 30*30
local CREEP_SCALE = 0.5
local CREEP_COLOR = Color(1,1,1,1,0,0,0,0.75,0,0.1,1)

local CREEP_DMG = 7

local PROJ_FREQ = 3
local PROJ_FREQ_DECREASING = 6
local PROJ_FREQ_DECREASING_2 = 12

local PROJ_DMG = 7
local PROJ_SPEED = 7

local BUBBLE_FREQ = 6
local BUBBLE_COLOR = Color(1,1,1,0.55,0.2,0,0.02,1,0,0,1)

local function getPointInEllipse(ellipseSize, rng)
    local pos = ellipseSize*5

    while((pos.X/ellipseSize.X)^2+(pos.Y/ellipseSize.Y)^2>1) do
        pos = Vector(rng:RandomFloat()*2-1,rng:RandomFloat()*2-1)*ellipseSize
    end

    return pos, ((pos.X/ellipseSize.X)^2+(pos.Y/ellipseSize.Y)^2)
end

---@param player EntityPlayer
local function useBloodyWhistle(_, _, rng, player, flags)
    local pos = ToyboxMod.GAME:GetRoom():GetGridPosition(0)+Vector(20,20)
    local creep = Isaac.Spawn(1000, EffectVariant.PLAYER_CREEP_LEMON_PARTY, 0, player.Position, Vector.Zero, player):ToEffect()
    creep.Scale = CREEP_SCALE
    creep.Color = CREEP_COLOR
    creep.CollisionDamage = CREEP_DMG
    creep:SetTimeout(CREEP_DURATION)
    creep:Update()

    ToyboxMod:setEntityData(creep, "BLOODYWHISTLE_BLOOD_CREEP", true)

    sfx:Play(ToyboxMod.SFX_BLOODY_WHISTLE)

    return {
        Discharge = true,
        Remove = false,
        ShowAnim = true,
    }
end
ToyboxMod:AddCallback(ModCallbacks.MC_USE_ITEM, useBloodyWhistle, ToyboxMod.COLLECTIBLE_BLOODY_WHISTLE)

---@param effect EntityEffect
local function updateBloodCreep(_, effect)
    if(not ToyboxMod:getEntityData(effect, "BLOODYWHISTLE_BLOOD_CREEP")) then return end

    effect.Color = CREEP_COLOR
    effect.SpriteScale = effect.SpriteScale
    effect.Timeout = math.max(effect.Timeout, effect.LifeSpan-60)

    local rng = effect:GetDropRNG()
    local size = Vector(180, 100)*effect.SpriteScale

    if(effect.FrameCount%BUBBLE_FREQ==0) then
        local bubblePos = getPointInEllipse(size*0.75, rng)

        local bubble = Isaac.Spawn(1000,EffectVariant.TAR_BUBBLE,0,bubblePos+effect.Position,Vector.Zero,effect):ToEffect()
        bubble.Color = BUBBLE_COLOR
    end

    if(effect.Timeout<=30 and effect.FrameCount%PROJ_FREQ_DECREASING_2~=0) then return end
    if(effect.Timeout<=65 and effect.FrameCount%PROJ_FREQ_DECREASING~=0) then return end
    if(effect.FrameCount%PROJ_FREQ~=0) then return end
    
    local pos, dist = getPointInEllipse(size*0.8, rng)

    local pl = Isaac.GetPlayer()
    if(effect.SpawnerEntity and effect.SpawnerEntity:ToPlayer()) then
        pl = effect.SpawnerEntity:ToPlayer()
    end

    local dir = pos:Resized(PROJ_SPEED*(dist^0.25))
    dir = dir:Rotated((rng:RandomFloat()*2-1)*10)
    local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLOOD, 0, pos+effect.Position, dir, nil):ToTear()
    --SFXManager():Stop(SoundEffect.SOUND_TEARS_FIRE)

    tear.CollisionDamage = PROJ_DMG

    tear.FallingAcceleration = 2+0.1
    tear.FallingSpeed = -10
    tear.Height = -5
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, updateBloodCreep, EffectVariant.PLAYER_CREEP_LEMON_PARTY)

-- < BOOK OF VIRTUES > --

local EYESORE_CHANCE = 0.5
local EYESORE_MAX_NUM = 3

---@param baseTear EntityTear?
local function virtuesWispFire(_, baseTear)
    if(not baseTear) then return end

    local fam = baseTear.SpawnerEntity and baseTear.SpawnerEntity:ToFamiliar()
    if(not (fam.Variant==FamiliarVariant.WISP and fam.SubType==ToyboxMod.COLLECTIBLE_BLOODY_WHISTLE)) then return end

    local rng = fam:GetDropRNG()
    if(rng:RandomFloat()<EYESORE_CHANCE) then
        local num = rng:RandomInt(1, EYESORE_MAX_NUM)
        for _=1, num do
            local vel = baseTear.Velocity:Rotated(rng:RandomInt(1,360))
            local pos = baseTear.Position-baseTear.Velocity+vel

            local newTear = Isaac.Spawn(baseTear.Type, baseTear.Variant, baseTear.SubType, pos, vel, baseTear.SpawnerEntity):ToTear()
            if(newTear) then
                newTear.Scale = baseTear.Scale
                newTear.CollisionDamage = baseTear.CollisionDamage

                newTear:ClearTearFlags(newTear.TearFlags)
                newTear:AddTearFlags(baseTear.TearFlags)
            end
        end
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_POST_FAMILIAR_FIRE_PROJECTILE, CallbackPriority.IMPORTANT, virtuesWispFire, FamiliarVariant.WISP)

---@param fam EntityFamiliar
local function virtuesWispUpdate(_, fam)
    if(not (fam.Variant==FamiliarVariant.WISP and fam.SubType==ToyboxMod.COLLECTIBLE_BLOODY_WHISTLE)) then return end

    if(fam:GetSprite():GetFrame()%8==4) then
        local splat = Isaac.Spawn(1000, 7, 0, fam.Position, Vector.Zero, nil)
        splat.SpriteScale = Vector(1,1)*0.2
        splat:Update()
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_FAMILIAR_UPDATE, CallbackPriority.EARLY, virtuesWispUpdate, FamiliarVariant.WISP)