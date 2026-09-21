local sfx = SFXManager()
local font = Font()
font:Load("font/teammeatfont10.fnt")

local HP_FOR_JUICE = 1
local FINAL_JUICE_EXPO = 1

local JUICE_REQ_BASE = 50
local JUICE_REQ_PER_FLOOR = 25

local JUICE_OUTCOME_PICKER = WeightedOutcomePicker()
JUICE_OUTCOME_PICKER:AddOutcomeWeight(1, 5) -- random pickup
JUICE_OUTCOME_PICKER:AddOutcomeWeight(2, 1) -- random stat

local STAT_UPS = {
    SPEED = 0.1,
    TEARS = 0.35,
    DAMAGE = 0.5,
    RANGE = 0.5,
    SHOTSPEED = 0.1,
    LUCK = 1,
}

local JUICE_PARTICLE_SPEED = 35
local JUICE_PARTICLE_INITSPEED = 25
local JUICE_PARTICLE_INITARC = 25

local juiceFrameThresholds = {
    [0] = 7,
    [1] = 6,
    [5] = 5,
    [10] = 4,
    [25] = 3,
    [50] = 2,
    [100] = 1,
    [200] = 0,
}
local MAX_JUICE_SIZE = 200

local juiceSprite = Sprite("gfx_tb/effects/effect_juice.anm2")
juiceSprite:Play("Idle", true)
juiceSprite:GetLayer("main"):SetCustomShader("shaders_tb/rainbow")

---@param num number
local function addJuice(num)
    local data = ToyboxMod:getExtraDataTable()
    data.GOOD_JUICE_NUM = math.max((data.GOOD_JUICE_NUM or 0)+num, 0)
end

---@param num number
function ToyboxMod:addJuice(num)
    addJuice(num)
end

---@param pos Vector
---@param sub number
---@param coll Entity
local function evaluateJuiceCollision(pos, sub, coll)
    if(coll:ToPlayer()) then
        addJuice(sub)
    elseif(coll:ToSlot() and coll.Variant==ToyboxMod.SLOT_JUICE_FOUNTAIN) then
        local rng = coll:GetDropRNG()
        local outcome = JUICE_OUTCOME_PICKER:PickOutcome(rng)
        if(outcome==1) then --pickup
            local vel = (coll.Position-pos):Resized(8)
            local pickup = Isaac.Spawn(5,0,NullPickupSubType.NO_COLLECTIBLE,coll.Position+vel,vel,nil)

            if(pickup.Variant==PickupVariant.PICKUP_BOMB) then
                if(pickup.SubType==BombSubType.BOMB_TROLL or pickup.SubType==BombSubType.BOMB_SUPERTROLL or pickup.SubType==BombSubType.BOMB_GOLDENTROLL) then
                    pickup.Position = pickup.Position+vel*5
                end
            end

            pickup:AddKnockback(EntityRef(nil), vel, 15, false)
        elseif(outcome==2) then
            local stat = ({"SPEED","TEARS","DAMAGE","RANGE","SHOTSPEED","LUCK"})[rng:RandomInt(1,6)]
            for i=0, ToyboxMod.GAME:GetNumPlayers()-1 do
                local pl = Isaac.GetPlayer(i)
                if(pl:HasCollectible(ToyboxMod.COLLECTIBLE_GOOD_JUICE)) then
                    local data = ToyboxMod:getEntityDataTable(pl)
                    data.GOOD_JUICE_STATS = data.GOOD_JUICE_STATS or {}
                    data.GOOD_JUICE_STATS[stat] = (data.GOOD_JUICE_STATS[stat] or 0)+STAT_UPS[stat]
                    pl:AddCacheFlags(CacheFlag.CACHE_ALL, true)
                    pl:AnimateHappy()
                end
            end

            sfx:Play(SoundEffect.SOUND_THUMBSUP)
        end
    end

    sfx:Play(SoundEffect.SOUND_MEAT_JUMPS)
end

---@param pos Vector
---@param num number
---@param sp Entity
local function spawnJuiceParticle(pos, num, sp)
    num = math.ceil(num or 1)

    if(ToyboxMod.CONFIG.GOOD_JUICE_LESSLAG==2) then
        evaluateJuiceCollision(pos, num, sp)
    else
        local rng
        if(sp:ToPlayer()) then
            rng = sp:ToPlayer():GetCollectibleRNG(ToyboxMod.COLLECTIBLE_GOOD_JUICE)
        else
            rng = sp:GetDropRNG()
        end

        local juice = Isaac.Spawn(EntityType.ENTITY_EFFECT,ToyboxMod.EFFECT_JUICE_TRAIL,math.min(num, MAX_JUICE_SIZE),pos,Vector.Zero,sp):ToEffect()
        juice.State = num
        juice.Velocity = (pos-sp.Position):Resized(JUICE_PARTICLE_INITSPEED):Rotated(ToyboxMod:randomRange(rng, -1, 1)*JUICE_PARTICLE_INITARC)
        juice:GetSprite():Stop()

        if(sp:ToSlot()) then
            juice.Velocity = -juice.Velocity
        end
    end
end

---@param npc EntityNPC
local function giveJuiceOnKill(_, npc)
    local pl = PlayerManager.FirstCollectibleOwner(ToyboxMod.COLLECTIBLE_GOOD_JUICE)
    if(not pl) then return end

    local numParticles = (npc.MaxHitPoints/HP_FOR_JUICE)^FINAL_JUICE_EXPO
    spawnJuiceParticle(npc.Position, numParticles, pl)
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, giveJuiceOnKill)

---@param effect EntityEffect
local function juiceParticleInit(_, effect)
    effect.DepthOffset = 10000

    local sp = effect:GetSprite()

    local selFrame = 0
    local minFrame = nil
    for i, val in pairs(juiceFrameThresholds) do
        if(effect.SubType>=i and val<=(minFrame or val)) then
            selFrame = val
            minFrame = val
        end
    end

    effect.State = effect.SubType
    effect.SubType = 0

    sp:Play("IdleOutline", true)
    sp:SetFrame(selFrame)

    if(effect.SpawnerEntity) then
        sp:Stop()
    else
        if(ToyboxMod.CONFIG.GOOD_JUICE_LESSLAG==1) then
            sp.PlaybackSpeed = ToyboxMod:randomRange(effect:GetDropRNG(), 0.5, 0.9)
        else
            sp.PlaybackSpeed = ToyboxMod:randomRange(effect:GetDropRNG(), 0.25, 0.8)
        end
        
    end

    sp.Color = Color(1,1,1,1,1,1,1)
    sp.Offset = Vector(0,-15)
    effect:SetShadowSize(2*(8-selFrame)/100)
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, juiceParticleInit, ToyboxMod.EFFECT_JUICE_TRAIL)

local maxJuiceY = -2^30
local maxJuiceEnt = nil

---@param effect EntityEffect
local function juiceParticleUpdate(_, effect)
    if(effect.SpawnerEntity) then
        local lerpVal = 0.05
        lerpVal = lerpVal+math.max(0, (effect.FrameCount-60)*0.025/60)

        effect.Velocity = ToyboxMod:lerp(effect.Velocity, (effect.SpawnerEntity.Position-effect.Position):Resized(JUICE_PARTICLE_SPEED), lerpVal)
        effect.SpriteRotation = effect.SpriteRotation+(effect.Velocity:LengthSquared()/20)*3

        if(effect.FrameCount%(ToyboxMod.CONFIG.GOOD_JUICE_LESSLAG==1 and 3 or 2)==0) then
            local rng = effect:GetDropRNG()
            for _=1, (ToyboxMod.CONFIG.GOOD_JUICE_LESSLAG==1 and 1 or 2) do
                local newSub = math.min(math.ceil(ToyboxMod:randomRange(rng, 0.2, 0.7)*effect.State), MAX_JUICE_SIZE)
                local vel = (-effect.Velocity):Resized(4):Rotated(rng:RandomInt(360))

                local newParticle = Isaac.Spawn(EntityType.ENTITY_EFFECT,ToyboxMod.EFFECT_JUICE_TRAIL,newSub,effect.Position,vel,nil):ToEffect()
                newParticle.SpriteRotation = effect.SpriteRotation
            end
        end

        if(effect.FrameCount>10 and effect.Position:DistanceSquared(effect.SpawnerEntity.Position)<(effect.SpawnerEntity.Size+8)^2) then
            local rng = effect:GetDropRNG()
            for _=1, (ToyboxMod.CONFIG.GOOD_JUICE_LESSLAG==1 and 2 or 4) do
                local newSub = math.min(math.ceil(ToyboxMod:randomRange(rng, 0.3, 0.8)*effect.State), MAX_JUICE_SIZE)
                local vel = (effect.Velocity):Resized(15):Rotated(rng:RandomInt(-25, 25))

                local newParticle = Isaac.Spawn(EntityType.ENTITY_EFFECT,ToyboxMod.EFFECT_JUICE_TRAIL,newSub,effect.Position,vel,nil):ToEffect()
                newParticle.SpriteRotation = effect.SpriteRotation
            end

            evaluateJuiceCollision(effect.Position-effect.Velocity*3, effect.State, effect.SpawnerEntity)

            sfx:Play(SoundEffect.SOUND_MEAT_JUMPS, 1, 0, false, 1)
            effect:Remove()
        end
    else
        effect.Velocity = effect.Velocity*0.9
        effect.SpriteRotation = effect.SpriteRotation+2*3
        effect:SetShadowSize(2*(8-effect:GetSprite():GetFrame())/100)

        if(effect:GetSprite():IsFinished()) then
            effect:Remove()
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, juiceParticleUpdate, ToyboxMod.EFFECT_JUICE_TRAIL)

---@param newLevel boolean
local function turnToJuiceOnRoomChange(_, _, newLevel)
    local data = ToyboxMod:getExtraDataTable()

    for _, ent in ipairs(Isaac.FindByType(1000, ToyboxMod.EFFECT_JUICE_TRAIL)) do
        if(ent.SpawnerEntity) then
            evaluateJuiceCollision(ent.Position-ent.Velocity, ent:ToEffect().State, ent.SpawnerEntity)
        end
    end

    if(newLevel) then
        data.GOOD_JUICE_LERP_COUNTER = data.GOOD_JUICE_NUM
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_ROOM_EXIT, turnToJuiceOnRoomChange)

local toRenderHash = {}
local weirdOffsets = {}
local numToRender = 0

local function renderJuiceParticles(_, effect, offset)
    if(numToRender==nil) then
        numToRender = 0
        toRenderHash = {}
        for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, ToyboxMod.EFFECT_JUICE_TRAIL)) do
            toRenderHash[GetPtrHash(ent)] = true
            numToRender = numToRender+1
        end
    end

    if(numToRender) then
        local hash = GetPtrHash(effect)

        if(toRenderHash[hash]) then
            numToRender = numToRender-1
        end
        toRenderHash[hash] = nil
        weirdOffsets[hash] = offset

        if(numToRender==0) then
            numToRender = nil

            local scrollOffset = ToyboxMod.GAME:GetRoom():GetRenderScrollOffset()
            local reflect = not ToyboxMod:renderingAboveWater()
            for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, ToyboxMod.EFFECT_JUICE_TRAIL)) do
                local entHash = GetPtrHash(ent)
                if(weirdOffsets[entHash]) then
                    local sp = ent:GetSprite()
                    local rpos = Isaac.WorldToRenderPosition(ent.Position)+ent.SpriteOffset+scrollOffset
                    if(reflect) then
                        rpos = rpos+Vector(2,0)*ent.SpriteOffset+Vector(2,-2)*ent.SpriteOffset:Rotated(ent.SpriteRotation)
                    end

                    juiceSprite:SetFrame(sp:GetFrame())
                    juiceSprite.Rotation = sp.Rotation

                    juiceSprite.Color = Color(1,1,1,1,0,0,0,rpos.X/40+rpos.Y/40+ToyboxMod.GAME:GetFrameCount()/15)
                    juiceSprite:Render(rpos+weirdOffsets[entHash])
                end
            end
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, renderJuiceParticles, ToyboxMod.EFFECT_JUICE_TRAIL)

local function ihatethisgamesomuch(_, effect, offset)
    if(ToyboxMod:renderingAboveWater()) then return end

    return 2*(Vector(-1,1)*effect.SpriteOffset:Rotated(effect.SpriteRotation)-effect.SpriteOffset)
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_EFFECT_RENDER, ihatethisgamesomuch, ToyboxMod.EFFECT_JUICE_TRAIL)

local function resetRenders(_)
    numToRender = nil
    toRenderHash = {}
    weirdOffsets = {}
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_RENDER, resetRenders)

--[[] ]
local cancelRenders = false
local function renderJuiceParticles(_)
    if(cancelRenders) then return end
    cancelRenders = true

    local effectsToRender = Isaac.FindByType(1000, ToyboxMod.EFFECT_JUICE_TRAIL)

    local offset = ToyboxMod.GAME:GetRoom():GetRenderScrollOffset()

    juiceSprite:Play("IdleOutline", true)
    for _, ent in ipairs(effectsToRender) do
        local sp = ent:GetSprite()
        local rpos = Isaac.WorldToRenderPosition(ent.Position)+ent.SpriteOffset+offset
        juiceSprite:SetFrame(sp:GetFrame())
        juiceSprite.Rotation = sp.Rotation+ent.SpriteRotation

        juiceSprite.Color = Color(1,1,1,1,1,1,1)
        juiceSprite:Render(rpos)
    end

    juiceSprite:Play("Idle", true)
    for _, ent in ipairs(effectsToRender) do
        local sp = ent:GetSprite()
        local rpos = Isaac.WorldToRenderPosition(ent.Position)+ent.SpriteOffset+offset
        juiceSprite:SetFrame(sp:GetFrame())
        juiceSprite.Rotation = sp.Rotation+ent.SpriteRotation

        juiceSprite.Color = Color(1,1,1,1,0,0,0,rpos.X/40+rpos.Y/40+ToyboxMod.GAME:GetFrameCount()/15)
        juiceSprite:Render(rpos)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, renderJuiceParticles, ToyboxMod.EFFECT_JUICE_TRAIL)

local function resetRenders(_)
    cancelRenders = false
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_RENDER, resetRenders)
--]]

local function renderParticleOverlay(_)
    --print(ToyboxMod.GAME:GetRoom():GetRenderMode())
    local offset = ToyboxMod.GAME:GetRoom():GetRenderScrollOffset()

    --juiceSprite:GetLayer("main"):SetCustomShader("shaders_tb/rainbow")
    for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, ToyboxMod.EFFECT_JUICE_TRAIL)) do
        local sp = ent:GetSprite()
        local rpos = Isaac.WorldToRenderPosition(ent.Position)+ent.SpriteOffset+offset
        juiceSprite:SetFrame(sp:GetFrame())
        juiceSprite.Rotation = sp.Rotation

        juiceSprite.Color = Color(1,1,1,1,0,0,0,rpos.X/40+rpos.Y/40+ToyboxMod.GAME:GetFrameCount()/15)
        juiceSprite:Render(rpos)
    end
    --juiceSprite:GetLayer("main"):ClearCustomShader()
end
--ToyboxMod:AddCallback(ModCallbacks.MC_POST_ROOM_RENDER_ENTITIES, renderParticleOverlay)

local function spawnSlotInStartRoom()
    if(not PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_GOOD_JUICE)) then return end

    local level = ToyboxMod.GAME:GetLevel()
    local isGreed = ToyboxMod.GAME:IsGreedMode() and level:GetStage()~=LevelStage.STAGE7_GREED
    local isInCorrectRoom = (level:GetCurrentRoomIndex()==level:GetStartingRoomIndex())
    if(isGreed) then
        local shopIndex = level:GetStartingRoomIndex()-13

        isInCorrectRoom = (level:GetCurrentRoomIndex()==shopIndex) or (level:GetCurrentRoomIndex()==shopIndex-1)
    end

    if(not isInCorrectRoom) then return end

    if(#Isaac.FindByType(EntityType.ENTITY_SLOT,ToyboxMod.SLOT_JUICE_FOUNTAIN)==0) then
        local pos
        if(isGreed) then
            pos = ToyboxMod.GAME:GetRoom():FindFreePickupSpawnPosition(Vector(560,280))+Vector(20,0)
        else
            pos = ToyboxMod.GAME:GetRoom():FindFreePickupSpawnPosition(Vector(200,200))
        end

        local slot = Isaac.Spawn(EntityType.ENTITY_SLOT,ToyboxMod.SLOT_JUICE_FOUNTAIN,0,pos,Vector.Zero,nil)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, spawnSlotInStartRoom)

---@param slot EntitySlot
local function postSlotInit(_, slot)
    slot:SetSize(slot.Size, Vector(2,1)*slot.SizeMulti, 24)

    local sp = slot:GetSprite()
    sp:GetLayer("juice"):SetCustomShader("shaders_tb/rainbow")
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_SLOT_INIT, postSlotInit, ToyboxMod.SLOT_JUICE_FOUNTAIN)

---@param slot EntitySlot
local function postSlotUpdate(_, slot)
    if(slot:GetTouch()%4==1) then
        local pl = PlayerManager.FirstCollectibleOwner(ToyboxMod.COLLECTIBLE_GOOD_JUICE) or Isaac.GetPlayer()
        if(pl) then
            local neededJuice = JUICE_REQ_BASE+JUICE_REQ_PER_FLOOR*ToyboxMod.GAME:GetLevel():GetAbsoluteStage()

            if((ToyboxMod:getExtraData("GOOD_JUICE_NUM") or 0)>=neededJuice) then
                addJuice(-neededJuice)
                spawnJuiceParticle(pl.Position, neededJuice*0.5, slot)
            end
        end
    end

    slot:SetState(1)
    slot:GetSprite():GetLayer("juice"):SetColor(Color(1,1,1,1,0,0,0,slot.Position.X/40+slot.Position.Y/40+ToyboxMod.GAME:GetFrameCount()/90))
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, postSlotUpdate, ToyboxMod.SLOT_JUICE_FOUNTAIN)

---@param slot EntitySlot
local function slotExplosionDrops(_, slot)
    return false
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_SLOT_CREATE_EXPLOSION_DROPS, slotExplosionDrops, ToyboxMod.SLOT_JUICE_FOUNTAIN)

---@param pl EntityPlayer
---@param flags CacheFlag
local function evalJuiceStats(_, pl, flags)
    if(not pl:HasCollectible(ToyboxMod.COLLECTIBLE_GOOD_JUICE)) then return end

    local data = ToyboxMod:getEntityData(pl, "GOOD_JUICE_STATS") or {}
    if(flags==CacheFlag.CACHE_SPEED) then
        pl.MoveSpeed = pl.MoveSpeed+(data.SPEED or 0)
    elseif(flags==CacheFlag.CACHE_RANGE) then
        pl.TearRange = pl.TearRange+(data.RANGE or 0)*40
    elseif(flags==CacheFlag.CACHE_SHOTSPEED) then
        pl.ShotSpeed = pl.ShotSpeed+(data.SHOTSPEED or 0)
    elseif(flags==CacheFlag.CACHE_LUCK) then
        pl.Luck = pl.Luck+(data.LUCK or 0)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evalJuiceStats)

---@param pl EntityPlayer
---@param val number
local function evalStat(_, pl, stat, val)
    if(not pl:HasCollectible(ToyboxMod.COLLECTIBLE_GOOD_JUICE)) then return end
    if(not (stat==EvaluateStatStage.TEARS_UP or stat==EvaluateStatStage.DAMAGE_UP)) then return end
    
    local data = ToyboxMod:getEntityData(pl, "GOOD_JUICE_STATS") or {}

    if(stat==EvaluateStatStage.TEARS_UP) then
        return val+(data.TEARS or 0)
    elseif(stat==EvaluateStatStage.DAMAGE_UP) then
        return val+(data.DAMAGE or 0)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_EVALUATE_STAT, evalStat)


local MAP_HELD = 0
local MAP_MAX = 15
local CURRENT_TRANSPARENCY = 0

local SQRT3 = math.sqrt(3)

---@param hue number
---@return KColor
local function kcolorFromHue(hue)
    local hcos = math.cos(math.rad(hue))
    local hsin = math.sin(math.rad(hue))

    return KColor(hcos*2/3+1/3, 1/3+hsin*SQRT3-hcos*1/3, 1/3-hsin*SQRT3-hcos*1/3, 1)
end
---@param a KColor
---@param b KColor
---@param f number
local function lerpKcolor(a, b, f)
    return KColor(ToyboxMod:lerp(a.Red,b.Red,f),ToyboxMod:lerp(a.Blue,b.Blue,f),ToyboxMod:lerp(a.Green,b.Green,f),ToyboxMod:lerp(a.Alpha,b.Alpha,f))
end

local function hudRender(_)
    if(not PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_GOOD_JUICE)) then return end

    local data = ToyboxMod:getExtraDataTable()
    if(not ToyboxMod.GAME:IsPaused()) then
        local trueVal = (data.GOOD_JUICE_NUM or 0)

        data.GOOD_JUICE_LERP_COUNTER = data.GOOD_JUICE_LERP_COUNTER or trueVal
        local fakeVal = data.GOOD_JUICE_LERP_COUNTER or trueVal

        local dif = trueVal-fakeVal
        local adif = math.abs(dif)
        if(not ToyboxMod.GAME:IsPaused() and adif>0) then
            local toAdd = 0
            if(adif>25000) then toAdd = 271
            elseif(adif>3000) then toAdd = 27
            elseif(adif>250) then toAdd = 7
            else
                toAdd = adif*0.03
                if(adif<0.2) then
                    toAdd = adif
                end
            end

            data.GOOD_JUICE_LERP_COUNTER = fakeVal+toAdd*dif/adif
        end
    end

    --figure ts out later
    if(not ToyboxMod.GAME:IsPaused()) then
        if(Input.IsActionPressed(ButtonAction.ACTION_MAP, Isaac.GetPlayer().ControllerIndex)) then
            if(MAP_HELD<MAP_MAX) then
                MAP_HELD = MAP_HELD+1
            end
        elseif(MAP_HELD>0) then
            MAP_HELD = math.max(0, math.floor(MAP_HELD*0.85))
        end

        CURRENT_TRANSPARENCY = ToyboxMod:lerp(CURRENT_TRANSPARENCY, MAP_HELD/MAP_MAX, 0.25)
    end

    local trueTransparency = CURRENT_TRANSPARENCY
    if(Options.ExtraHUDStyle == 1) then
        trueTransparency = math.max(trueTransparency, 0.5)
    end

    if(trueTransparency<0.01) then return end
    if(isBossIntro) then return end
    if(ToyboxMod.GAME:GetLevel():GetStage()==LevelStage.STAGE8 and ToyboxMod.GAME:GetRoom():GetType()==RoomType.ROOM_DUNGEON and ToyboxMod.GAME:GetLevel():GetCurrentRoomDesc().Data.Variant==666) then return end

    local color = lerpKcolor(KColor(1,1,1,1), kcolorFromHue((ToyboxMod.GAME:GetFrameCount()*5)%360), 0.33)
    color.Alpha = trueTransparency

    local renderPos = Vector(Isaac.GetScreenWidth()/2, 6)+Vector(0,24)*Options.HUDOffset+Vector(0,16)
    if(not ToyboxMod.GAME:IsGreedMode()) then renderPos = renderPos+Vector(0,16) end

    font:DrawString("Juice:", renderPos.X-40, renderPos.Y, color)
    font:DrawString(tostring(math.floor(data.GOOD_JUICE_LERP_COUNTER or 0)), renderPos.X, renderPos.Y, color, 40, false)
end
ToyboxMod:AddCallback(ModCallbacks.MC_HUD_RENDER, hudRender)


local function unloadSprite(_)
    juiceSprite:GetLayer("main"):ClearCustomShader()
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, unloadSprite)

local function loadSprite(_, mod, shuttingDown)
    juiceSprite:GetLayer("main"):SetCustomShader("shaders_tb/rainbow")
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, loadSprite)