local SLOW_DURATION = 30*1
local SLOW_INTENSITY = 0.8
local SLOW_COLOR = Color(1.2,1,1.3,1,0.2,0.157,0.2)

local AURA_COLOR = Color(1,0.7,1,0.66,0.1,0,0.1)
local AURA_SIZE_MULT = 3

local LASER_AURA_RENDERS = 12
local LASER_AURA_ALPHA = 0.08
local LASER_AURA_COLOR = Color(1,1,1,0.7,0.2,0.2,0.2,2,1,2,1)

---@param ent Entity
---@param ref EntityRef
local function applyEffect(ent, ref)
    local countdown = ent:GetSlowingCountdown()
    --if(countdown<SLOW_DURATION) then
        ent:AddSlowing(ref, math.max(0, SLOW_DURATION-countdown), SLOW_INTENSITY, SLOW_COLOR)
    --end
end

---@param tear EntityTear
local function tearPoisonAura(_, tear)
    if(not TearFlagsLib.HasTearFlags(tear, ToyboxMod.TEARFLAGS.SLOWING_AURA)) then return end

    local auraSize = 7*tear.Scale*AURA_SIZE_MULT

    local pl = ToyboxMod:getPlayerFromEnt(tear)
    local plRef = EntityRef(pl)

    for _, ent in ipairs(Isaac.FindInRadius(tear.Position, auraSize, EntityPartition.ENEMY)) do
        if(ToyboxMod:isValidEnemy(ent)) then
            applyEffect(ent, plRef)
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, tearPoisonAura)

---@param tear EntityTear
---@param offset Vector
local function renderTearAura(_, tear, offset)
    if(not TearFlagsLib.HasTearFlags(tear, ToyboxMod.TEARFLAGS.SLOWING_AURA)) then return end

    local sp = ToyboxMod:getEntityData(tear, "GARLIC_AURA")
    if(not sp) then
        sp = Sprite("gfx_tb/effects/effect_tear_aura.anm2", true)
        sp:Play("Idle", true)
        sp.Color = AURA_COLOR

        ToyboxMod:setEntityData(tear, "GARLIC_AURA", sp)
    end

    sp.Scale = tear.Scale*7*AURA_SIZE_MULT/60*Vector(1,1)
    sp:Render(Isaac.WorldToRenderPosition(tear.Position+tear.PositionOffset)+offset)

    if(not ToyboxMod.GAME:IsPaused()) then
        sp:Update()
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_TEAR_RENDER, renderTearAura)

---@param bomb EntityBomb
local function bombPoisonAura(_, bomb)
    if(not TearFlagsLib.HasTearFlags(bomb, ToyboxMod.TEARFLAGS.SLOWING_AURA)) then return end

    local auraSize = 10*bomb:GetScale()*AURA_SIZE_MULT

    local pl = ToyboxMod:getPlayerFromEnt(bomb)
    local plRef = EntityRef(pl)

    for _, ent in ipairs(Isaac.FindInRadius(bomb.Position, auraSize, EntityPartition.ENEMY)) do
        if(ToyboxMod:isValidEnemy(ent)) then
            applyEffect(ent, plRef)
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, bombPoisonAura)

---@param bomb EntityBomb
---@param offset Vector
local function renderBombAura(_, bomb, offset)
    if(not TearFlagsLib.HasTearFlags(bomb, ToyboxMod.TEARFLAGS.SLOWING_AURA)) then return end

    local sp = ToyboxMod:getEntityData(bomb, "GARLIC_AURA")
    if(not sp) then
        sp = Sprite("gfx_tb/effects/effect_tear_aura.anm2", true)
        sp:Play("Idle", true)
        sp.Color = AURA_COLOR

        ToyboxMod:setEntityData(bomb, "GARLIC_AURA", sp)
    end

    sp.Scale = bomb:GetScale()*10*AURA_SIZE_MULT/60*Vector(1,1)
    sp:Render(Isaac.WorldToRenderPosition(bomb.Position+bomb.PositionOffset)+offset)

    if(not ToyboxMod.GAME:IsPaused()) then
        sp:Update()
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_BOMB_RENDER, renderBombAura)

---@param knife EntityKnife
local function knifePoisonAura(_, knife)
    if(not TearFlagsLib.HasTearFlags(knife, ToyboxMod.TEARFLAGS.SLOWING_AURA)) then return end

    if(knife:IsFlying() or knife:HasTearFlags(TearFlags.TEAR_LUDOVICO) or knife.SubType==KnifeSubType.PROJECTILE) then
        local auraSize = 10*knife.Scale*AURA_SIZE_MULT

        local pl = ToyboxMod:getPlayerFromEnt(knife)
        local plRef = EntityRef(pl)

        for _, ent in ipairs(Isaac.FindInRadius(knife.Position, auraSize, EntityPartition.ENEMY)) do
            if(ToyboxMod:isValidEnemy(ent)) then
                applyEffect(ent, plRef)
            end
        end
    else
        local sp = ToyboxMod:getEntityData(knife, "GARLIC_AURA")
        if(sp) then
            sp.Scale = Vector.Zero
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, knifePoisonAura)

---@param knife EntityKnife
---@param offset Vector
local function renderKnifeAura(_, knife, offset)
    if(not (knife:IsFlying() or knife:HasTearFlags(TearFlags.TEAR_LUDOVICO) or knife.SubType==KnifeSubType.PROJECTILE)) then return end
    if(not TearFlagsLib.HasTearFlags(knife, ToyboxMod.TEARFLAGS.SLOWING_AURA)) then return end

    local sp = ToyboxMod:getEntityData(knife, "GARLIC_AURA")
    if(not sp) then
        sp = Sprite("gfx_tb/effects/effect_tear_aura.anm2", true)
        sp:Play("Idle", true)
        sp.Color = AURA_COLOR
        sp.Scale = Vector.Zero

        ToyboxMod:setEntityData(knife, "GARLIC_AURA", sp)
    end

    sp.Scale = ToyboxMod:lerp(sp.Scale, 10*knife.Scale*AURA_SIZE_MULT/60*Vector(1,1), 0.33)
    sp:Render(Isaac.WorldToRenderPosition(knife.Position)+offset)

    if(not ToyboxMod.GAME:IsPaused()) then
        sp:Update()
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_KNIFE_RENDER, renderKnifeAura)

---@param rocket EntityEffect
local function epicFetusPoisonAura(_, rocket)
    if(not TearFlagsLib.HasTearFlags(rocket, ToyboxMod.TEARFLAGS.SLOWING_AURA)) then return end

    rocket.Color = Color.TearScorpio

    local auraSize = 10*rocket.Scale*AURA_SIZE_MULT

    local pl = ToyboxMod:getPlayerFromEnt(rocket)
    local plRef = EntityRef(pl)

    for _, ent in ipairs(Isaac.FindInRadius(rocket.Position, auraSize, EntityPartition.ENEMY)) do
        if(ToyboxMod:isValidEnemy(ent)) then
            applyEffect(ent, plRef)
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, epicFetusPoisonAura, EffectVariant.TARGET)

---@param rocket EntityEffect
---@param offset Vector
local function renderEpicFetusAura(_, rocket, offset)
    if(not TearFlagsLib.HasTearFlags(rocket, ToyboxMod.TEARFLAGS.SLOWING_AURA)) then return end

    local sp = ToyboxMod:getEntityData(rocket, "GARLIC_AURA")
    if(not sp) then
        sp = Sprite("gfx_tb/effects/effect_tear_aura.anm2", true)
        sp:Play("Idle", true)
        sp.Color = AURA_COLOR
        sp.Scale = Vector.Zero

        ToyboxMod:setEntityData(rocket, "GARLIC_AURA", sp)
    end

    sp.Scale = 10*rocket.Scale*AURA_SIZE_MULT/60*Vector(1,1)
    sp:Render(Isaac.WorldToRenderPosition(rocket.Position)+offset)

    if(not ToyboxMod.GAME:IsPaused()) then
        sp:Update()
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_EFFECT_RENDER, renderEpicFetusAura, EffectVariant.TARGET)

---@param laser EntityLaser
local function laserPoisonAura(_, laser)
    if(not TearFlagsLib.HasTearFlags(laser, ToyboxMod.TEARFLAGS.SLOWING_AURA)) then return end

    local samples = laser:GetSamples()

    local auraSize = laser:GetScale()*laser.Size*AURA_SIZE_MULT

    local hitlist = {}

    local pl = ToyboxMod:getPlayerFromEnt(laser)
    local plRef = EntityRef(pl)

    for i=1, #samples-1 do
        local point = samples:Get(i)
        local prevPoint = samples:Get(i-1)
        local c = Capsule(prevPoint, point, auraSize)
        for _, ent in ipairs(Isaac.FindInCapsule(c, EntityPartition.ENEMY)) do
            local hash = GetPtrHash(ent)
            if(ToyboxMod:isValidEnemy(ent) and not hitlist[hash]) then
                hitlist[hash] = true

                applyEffect(ent, plRef)
            end
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, laserPoisonAura)

local alreadyRendering = false
---@param laser EntityLaser
---@param offset Vector
local function renderLaserAura(_, laser, offset)
    if(alreadyRendering) then return end
    if(not TearFlagsLib.HasTearFlags(laser, ToyboxMod.TEARFLAGS.SLOWING_AURA)) then return end

    alreadyRendering = true

    local ogColor = laser.Color
    local ogScale = laser.SpriteScale

    local newCol = ToyboxMod:cloneColor(LASER_AURA_COLOR)
    newCol.A = newCol.A*LASER_AURA_ALPHA
    laser.Color = newCol

    local maxscale = AURA_SIZE_MULT*1.2
    local numrenders = LASER_AURA_RENDERS
    for i=numrenders,1,-1 do
        local scl = maxscale*i/numrenders
        laser.SpriteScale = laser.SpriteScale*scl

        laser:Render(offset+Vector((math.random()*2-1)*1, (math.random()*2-1)*1))

        laser.SpriteScale = laser.SpriteScale/scl
    end

    laser.SpriteScale = ogScale

    ogColor.A = ogColor.A*0.5
    laser.Color = ogColor

    laser:Render(offset)

    ogColor.A = ogColor.A/0.5
    laser.Color = ogColor

    alreadyRendering = false
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_LASER_RENDER, renderLaserAura)