local sfx = SFXManager()

local BASE_DAMAGE = 40
local BASE_DURATION = 45
local BASE_ANGLE = 50

local BURN_RADIUS = 40*1.5
local BURN_DURATION = 30*3

local SHADOW_SIZE = 42
local OFFSET_DIST = 1400

local NUM_SMOKE_TRAIL_PER_FRAME = 3
local SMOKE_RANDOM_NUM = 5

local START_COLOR = Color(1,0.85,0.56)
local DEFAULT_COLOR = Color(0.5,0.25,0.2,1.0)
local SMOKE_COLOR_CYCLE = {
    --{START_COLOR, 1},
    {Color(255/255, 167/255, 0/255), 5},
    {Color(220/255, 119/255, 42/255), 6},
    {Color(209/255, 54/255, 19/255), 10},
    {Color(209/255*0.8, 54/255*0.7, 19/255*0.7), 20},
    {DEFAULT_COLOR, 0},
}

---@param eff EntityEffect
---@param frames int
function ToyboxMod:setMeteorTimeout(eff, frames)
    eff.Timeout = frames
    eff.LifeSpan = frames
end

---@param eff EntityEffect
local function meteorInit(_, eff)
    eff.CollisionDamage = BASE_DAMAGE
    ToyboxMod:setMeteorTimeout(eff, BASE_DURATION)
    eff.Rotation = BASE_ANGLE

    eff:GetSprite().PlaybackSpeed = 2.5

    eff.SpriteOffset = -OFFSET_DIST*Vector.FromAngle(eff.Rotation)
    eff:SetShadowSize(0)
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, meteorInit, ToyboxMod.EFFECT_METEOR)

---@param eff EntityEffect
local function meteorUpdate(_, eff)
    local frac = eff.Timeout/eff.LifeSpan
    local baseOffset = -OFFSET_DIST*Vector.FromAngle(eff.Rotation)

    eff.SpriteOffset = frac*baseOffset

    local numSmoke = (NUM_SMOKE_TRAIL_PER_FRAME+math.random(1,SMOKE_RANDOM_NUM))*(1-frac)//1
    for i=1, numSmoke do
        local randFrac = frac+(i==1 and 0 or math.random())*1/eff.LifeSpan
        local offset = baseOffset*randFrac*1.5

        local smoke = Isaac.Spawn(EntityType.ENTITY_EFFECT, ToyboxMod.EFFECT_SMOKE_TRAIL, 0, eff.Position+offset, Vector.Zero, eff):ToEffect()
        --smoke.SpriteOffset = smoke.SpriteOffset+baseOffset*randFrac
        smoke.DepthOffset = smoke.DepthOffset-offset.Y

        smoke.State = offset.Y//1
    end

    eff:SetShadowSize((1-frac)*SHADOW_SIZE*eff.Scale/100)

    if(eff.Timeout==0) then
        ToyboxMod.GAME:ShakeScreen(9)

        Isaac.Explode(eff.Position, eff, eff.CollisionDamage)
        for _, npc in ipairs(Isaac.FindInRadius(eff.Position, BURN_RADIUS, EntityPartition.ENEMY)) do
            if(ToyboxMod:isValidEnemy(npc)) then
                npc:AddBurn(EntityRef(eff.SpawnerEntity), BURN_DURATION, 4)
            end
        end

        for i=1, 3+math.random(0,2) do
            local vel = Vector.FromAngle(math.random(1,360))*(1+math.random(0,2))
            local gib = Isaac.Spawn(1000, EffectVariant.ROCK_PARTICLE, 0, eff.Position, vel, nil):ToEffect()
            gib.Color = Color(53/89, 44/64, 33/59)

            gib:Update()
        end

        sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE)

        eff:Die()
        eff:Remove()
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, meteorUpdate, ToyboxMod.EFFECT_METEOR)


---@param eff EntityEffect
local function smokeTrailInit(_, eff)
    local sp = eff:GetSprite()

    sp:Play("Idle"..tostring(math.random(1,3)), true)
    sp.PlaybackSpeed = math.random()*0.5+0.2
    sp.Rotation = math.random(1,360)
    sp:SetFrame(math.random(0,2))

    eff.Velocity = Vector.FromAngle(math.random(-30,30)+BASE_ANGLE+180)*7
    eff.Color = START_COLOR
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, smokeTrailInit, ToyboxMod.EFFECT_SMOKE_TRAIL)

---@param eff EntityEffect
local function smokeTrailUpdate(_, eff)
    eff.Velocity = eff.Velocity*0.9

    local s = 0
    local selIdx
    for i, data in ipairs(SMOKE_COLOR_CYCLE) do
        if(eff.FrameCount<=s+data[2]) then
            selIdx = i
            break
        end
        s = s+data[2]
    end

    local finalColor = DEFAULT_COLOR
    if(selIdx) then
        finalColor = Color.Lerp(SMOKE_COLOR_CYCLE[selIdx][1], SMOKE_COLOR_CYCLE[selIdx+1][1], (eff.FrameCount-s)/SMOKE_COLOR_CYCLE[selIdx][2])
    end
    eff.Color = finalColor

    local sp = eff:GetSprite()
    if(sp:GetFrame()==0) then
        sp:SetFrame(1)
    end
    if(sp:IsFinished()) then
        eff:Remove()
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, smokeTrailUpdate, ToyboxMod.EFFECT_SMOKE_TRAIL)

local function ihatethisgamesomuch2(_, effect, offset)
    if(ToyboxMod:renderingAboveWater()) then return end

    return -1.3*Vector(0,effect.State)
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_EFFECT_RENDER, ihatethisgamesomuch2, ToyboxMod.EFFECT_SMOKE_TRAIL)