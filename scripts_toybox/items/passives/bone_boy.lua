
local sfx = SFXManager()

local BONE_BOY_HP = 5
local HOLY_BONE_HP = 20
local BONE_BOY_DEATHDUR = 15*30
local FIRE_FREQ = 15
local FIRE_DIST = 3*40
local FIRE_ANGLE = 60

local BONE_SPEED = 12
local BONE_DMG = 3

local BFFS_FIRE_FREQ = 45
local BFFS_FIRE_NUM = 3
local BFFS_EXPL_DMG = 30
local BFFS_BONE_SPEED = 14
local BFFS_BONE_DMG = 4

---@param player EntityPlayer
local function checkFamiliars(_, player, cacheFlag)
    player:CheckFamiliar(
        ToyboxMod.FAMILIAR_BONE_BOY,
        player:GetCollectibleNum(ToyboxMod.COLLECTIBLE_BONE_BOY)+player:GetEffects():GetCollectibleEffectNum(ToyboxMod.COLLECTIBLE_BONE_BOY),
        player:GetCollectibleRNG(ToyboxMod.COLLECTIBLE_BONE_BOY),
        Isaac.GetItemConfig():GetCollectible(ToyboxMod.COLLECTIBLE_BONE_BOY)
    )
end
ToyboxMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, checkFamiliars, CacheFlag.CACHE_FAMILIARS)

local function angle2Dir(x)
    return math.floor((x+225)%360/90)
end
local function dir2Angle(x)
    if(x==Direction.DOWN) then return 90
    elseif(x==Direction.LEFT) then return 180
    elseif(x==Direction.UP) then return 270
    else return 0 end
end
local function getGridAlignedPos(pos)
    local room = ToyboxMod.GAME:GetRoom()
    return room:GetGridPosition(room:GetGridIndex(pos))
end
local function switchAnim(newAnim, sprite)
    local f = sprite:GetFrame()
    sprite:Play(newAnim, true)
    sprite:SetFrame(f)
end

local function replaceSpriteSheets(familiar)
    local sp = familiar:GetSprite()

    if(familiar.SubType & 1<<0~=0 and familiar.SubType & 1<<1~=0) then
        sp:ReplaceSpritesheet(0, "gfx_tb/familiars/familiar_bone_boy_body_black.png")
        sp:ReplaceSpritesheet(1, "gfx_tb/familiars/familiar_bone_boy_black_holy.png")
        sp:ReplaceSpritesheet(2, "gfx_tb/familiars/familiar_bone_boy_black_holy.png")
        sp:LoadGraphics()
    elseif(familiar.SubType & 1<<0~=0) then
        sp:ReplaceSpritesheet(0, "gfx_tb/familiars/familiar_bone_boy_body_black.png")
        sp:ReplaceSpritesheet(1, "gfx_tb/familiars/familiar_bone_boy_black.png")
        sp:ReplaceSpritesheet(2, "gfx_tb/familiars/familiar_bone_boy_black_holy.png")
        sp:LoadGraphics()
    elseif(familiar.SubType & 1<<1~=0) then
        sp:ReplaceSpritesheet(0, "gfx_tb/familiars/familiar_bone_boy_body.png")
        sp:ReplaceSpritesheet(1, "gfx_tb/familiars/familiar_bone_boy_holy.png")
        sp:ReplaceSpritesheet(2, "gfx_tb/familiars/familiar_bone_boy_holy.png")
        sp:LoadGraphics()
    else
        sp:ReplaceSpritesheet(0, "gfx_tb/familiars/familiar_bone_boy_body.png")
        sp:ReplaceSpritesheet(1, "gfx_tb/familiars/familiar_bone_boy.png")
        sp:ReplaceSpritesheet(2, "gfx_tb/familiars/familiar_bone_boy_holy.png")
        sp:LoadGraphics()
    end
end

---@param tear EntityTear
local function familiarFireProj(_, tear)
    local familiar = tear.SpawnerEntity and tear.SpawnerEntity:ToFamiliar() ---@type EntityFamiliar
    if(not familiar) then return end

    tear:ChangeVariant(TearVariant.BONE)

    local vel = tear.Velocity-familiar.Player:GetTearMovementInheritance(tear.Velocity:Normalized())
    tear.Velocity = vel:Resized((familiar.SubType&(1<<0)~=0 and BFFS_BONE_SPEED or BONE_SPEED))
    tear.Scale = 1.2
    tear.Color = (familiar.SubType&(1<<0)~=0 and Color(0.3,0.3,0.3,1) or Color(1,1,1,1))

    if(familiar.SubType & 1<<1 ~= 0) then
        tear.FallingAcceleration = 1.6
        tear.FallingSpeed = -5*(tear.FallingAcceleration+0.1)
        ToyboxMod:setEntityData(tear, "BONEBOY_HOLY_BONE", true)
    end

    if(familiar.Player:HasTrinket(TrinketType.TRINKET_BABY_BENDER)) then
        tear:AddTearFlags(TearFlags.TEAR_HOMING)
        tear.Color = tear.Color*Color.TearHoming
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_POST_FAMILIAR_FIRE_PROJECTILE, CallbackPriority.IMPORTANT, familiarFireProj, ToyboxMod.FAMILIAR_BONE_BOY)


---@param familiar EntityFamiliar
local function boneBoyInit(_, familiar)
    familiar.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
    familiar.MaxHitPoints = ((familiar.SubType & 1<<1 ~= 0) and HOLY_BONE_HP or BONE_BOY_HP)+1
    familiar.HitPoints = familiar.MaxHitPoints
    familiar.State = 0

    replaceSpriteSheets(familiar)
end
ToyboxMod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, boneBoyInit, ToyboxMod.FAMILIAR_BONE_BOY)

---@param familiar EntityFamiliar
local function boneBoyUpdate(_, familiar)
    local data = ToyboxMod:getEntityDataTable(familiar)
    local sp = familiar:GetSprite()
    local rng = familiar:GetDropRNG()
    local mult = familiar:GetMultiplier()
    local boneColor = (familiar.SubType&(1<<0)~=0 and Color(0.3,0.3,0.3,1) or Color(1,1,1,1))

    if(sp:IsFinished("Appear")) then sp:Play("Idle") end

    if(mult>1 and familiar.SubType & 1<<0 == 0) then
        familiar.SubType = familiar.SubType | 1<<0
        replaceSpriteSheets(familiar)
    elseif(mult<=1 and familiar.SubType & 1<<0 ~= 0) then
        familiar.SubType = familiar.SubType & ~(1<<0)
        replaceSpriteSheets(familiar)
    end

    if(familiar.State==0) then
        if((data.BONEBOY_TIME_SINCE_LAST_TARGET or 0)<=0 or (not (familiar.Target and familiar.Target:Exists())) or familiar.Position:DistanceSquared(familiar.TargetPosition)<=40*40) then
            local target = ToyboxMod:closestEnemy(familiar.Position) or familiar.Player or Isaac.GetPlayer()
            familiar.Target = target
            familiar.TargetPosition = target.Position

            data.BONEBOY_TIME_SINCE_LAST_TARGET = 20
        else
            data.BONEBOY_TIME_SINCE_LAST_TARGET = (data.BONEBOY_TIME_SINCE_LAST_TARGET or 0)-1
        end

        local angleDif = (familiar.Target.Position-familiar.Position):GetAngleDegrees()%360
        local angleDir = angle2Dir(angleDif)
        local dist = familiar.Position:DistanceSquared(familiar.TargetPosition)
        if(GetPtrHash(familiar.Target)~=GetPtrHash(familiar.Player) and
        ((data.BONEBOY_TIME_SINCE_LAST_SHOT or 0)>0 or
        (dist<=FIRE_DIST*FIRE_DIST and math.abs(dir2Angle(angleDir)-angleDif)<=FIRE_ANGLE and ToyboxMod.GAME:GetRoom():CheckLine(familiar.Position, familiar.Target.Position, 3)))) then
            if((data.BONEBOY_TIME_SINCE_LAST_SHOT or 0)<=0) then
                local anim
                if(angleDir==Direction.DOWN) then anim="AttackDown"
                elseif(angleDir==Direction.UP) then anim="AttackUp"
                elseif(angleDir==Direction.RIGHT) then anim="AttackRight"
                else anim="AttackLeft" end

                sp:Play(anim)

                data.BONEBOY_TIME_SINCE_LAST_SHOT = (familiar.SubType&(1<<0)~=0 and BFFS_FIRE_FREQ or FIRE_FREQ)
                data.BONEBOY_TIME_SINCE_LAST_TARGET = data.BONEBOY_TIME_SINCE_LAST_SHOT+10
                data.BONEBOY_BONES_LEFT = (familiar.SubType&(1<<0)~=0 and (BFFS_FIRE_NUM-1) or 0)
            else
                local toRemove = 1
                local lullabyMult = familiar.Player:GetTrinketMultiplier(TrinketType.TRINKET_FORGOTTEN_LULLABY)
                if(lullabyMult>0) then
                    toRemove = toRemove+lullabyMult//2+(familiar.FrameCount%2<=lullabyMult%2 and 1 or 0)
                end
                data.BONEBOY_TIME_SINCE_LAST_SHOT = math.max(0, (data.BONEBOY_TIME_SINCE_LAST_SHOT or 0)-toRemove)

                if(data.BONEBOY_TIME_SINCE_LAST_SHOT<=0) then
                    data.BONEBOY_TIME_SINCE_LAST_TARGET = 0
                    switchAnim("WalkDown", sp)
                end
            end

            familiar.Velocity = Vector.Zero
        else
            local p = familiar:GetPathFinder()
            p:FindGridPath(familiar.TargetPosition, 0.67, 900, false)

            local vel = familiar.Velocity
            local anim = "WalkDown"
            if(vel:LengthSquared()<=4) then
                anim="Idle"
            else
                if(math.abs(vel.Y)>=math.abs(vel.X)) then
                    if(vel.Y>=0) then anim="WalkDown"
                    else anim="WalkUp" end
                else
                    if(vel.X>=0) then anim="WalkRight"
                    else anim="WalkLeft" end
                end
            end

            switchAnim(anim, sp)
        end

        if(sp:IsEventTriggered("Shoot")) then
            local dir, target
            if(familiar.Target and familiar.Target:Exists()) then
                dir=(familiar.Target.Position+familiar.Target.Velocity*3-familiar.Position)
                target = familiar.Target.Position+familiar.Target.Velocity*3
            else
                dir=(familiar.TargetPosition-familiar.Position)
                target = familiar.TargetPosition
            end

            local bone = familiar:FireProjectile(dir:Normalized())

            if((data.BONEBOY_BONES_LEFT or 0)>0) then
                data.BONEBOY_BONES_LEFT = (data.BONEBOY_BONES_LEFT or 0)-1
                sp:Play(sp:GetAnimation(),true)
            end
        end

        if(familiar.SubType & (1<<1)==0) then
            local isInHallowedAura = false
            for _, effect in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.HALLOWED_GROUND)) do
                local scale = ((effect.SpriteScale.X + effect.SpriteScale.Y) * 70 / 2) + familiar.Size
                if(familiar.Position:Distance(effect.Position) < scale) then
                    isInHallowedAura = true
                    break
                end
            end
    
            if(isInHallowedAura) then
                familiar.State=3
                data.BONEBOY_DAMAGE_COOLDOWN = 1*30
            end
        end
    elseif(familiar.State==1) then
        familiar.Velocity = familiar.Velocity*0.75
        if((data.BONEBOY_DEATH_COOLDOWN or 0)<=0) then
            familiar.State = 2
            sp:Play("GetUp", true)
        else
            data.BONEBOY_DEATH_COOLDOWN = math.max(0, (data.BONEBOY_DEATH_COOLDOWN or 0)-1)
        end

        if(sp:IsEventTriggered("Die")) then
            sfx:Play(SoundEffect.SOUND_DEATH_BURST_BONE)
            for _=1,5 do
                local bone = Isaac.Spawn(1000,35,0,familiar.Position,Vector.FromAngle(rng:RandomFloat()*360)*(3+rng:RandomFloat()*4-2),familiar):ToEffect()
                bone.Color = boneColor
            end
            for _=1,10 do
                local dust = Isaac.Spawn(1000,EffectVariant.DUST_CLOUD,0,familiar.Position,Vector.FromAngle(rng:RandomFloat()*360)*(8+rng:RandomFloat()*4-2),familiar):ToEffect()
                dust.Color=Color(1,1,1,0.25,0,0,0)
                dust:SetTimeout(10)
                dust.SpriteScale = Vector(0.005,0.005)
                dust:Update()

                dust.DepthOffset = 30
            end

            local poof = Isaac.Spawn(1000,16,2,familiar.Position,Vector.Zero,familiar):ToEffect()
            poof.Color = Color(boneColor.R,boneColor.G,boneColor.B,0.5)

            if(familiar.SubType&(1<<0)~=0) then
                ToyboxMod.GAME:ShakeScreen(10)

                local dmg = (familiar.SubType&(1<<1)~=0) and 185 or BFFS_EXPL_DMG
                local expl = Isaac.Explode(familiar.Position, familiar.Player, dmg)
            end
        end

        if(sp:IsFinished("Crumple") and familiar.SubType & (1<<1)~=0) then
            sp:Play("LevelDown", true)
            sfx:Play(ToyboxMod.SFX_POWERDOWN)
        end

        if(sp:IsEventTriggered("LevelDown")) then
            familiar.SubType = familiar.SubType & ~(1<<1)
            familiar.MaxHitPoints = BONE_BOY_HP+1
            replaceSpriteSheets(familiar)
        end
    elseif(familiar.State==2) then
        familiar.Velocity = familiar.Velocity*0.75
        if(sp:IsFinished("GetUp")) then
            familiar.State=0
            familiar.HitPoints = familiar.MaxHitPoints
            sp:Play("Idle", true)
        end

        if(sp:IsEventTriggered("Revive")) then
            sfx:Play(SoundEffect.SOUND_BONE_BREAK,0.6)
            for _=1,2 do
                local bone = Isaac.Spawn(1000,35,0,familiar.Position,Vector.FromAngle(rng:RandomFloat()*360)*(3+rng:RandomFloat()*4-2),familiar):ToEffect()
                bone.Color = boneColor
            end
            for _=1,4 do
                local dust = Isaac.Spawn(1000,EffectVariant.DUST_CLOUD,0,familiar.Position,Vector.FromAngle(rng:RandomFloat()*360)*(8+rng:RandomFloat()*4-2),familiar):ToEffect()
                dust.Color=Color(1,1,1,0.25,0,0,0)
                dust:SetTimeout(10)
                dust.SpriteScale = Vector(0.005,0.005)

                dust.DepthOffset = 30
            end
        end
    elseif(familiar.State==3) then
        if(sp:GetAnimation()~="LevelUp") then
            sp:Play("LevelUp", true)
            sfx:Play(ToyboxMod.SFX_POWERUP)
        end
        if(sp:IsEventTriggered("LevelUp")) then
            familiar.SubType = familiar.SubType | (1<<1)
            familiar.MaxHitPoints = HOLY_BONE_HP+1
            familiar.HitPoints = familiar.MaxHitPoints
            replaceSpriteSheets(familiar)

            familiar.State = 0
        end

        data.BONEBOY_DAMAGE_COOLDOWN = 1*30
        familiar.Velocity = familiar.Velocity*0.6
    end

    data.BONEBOY_DAMAGE_COOLDOWN = math.max(0, (data.BONEBOY_DAMAGE_COOLDOWN or 0)-1)
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_UPDATE, boneBoyUpdate, ToyboxMod.FAMILIAR_BONE_BOY)

---@param familiar EntityFamiliar
local function postBoneBoyUpdate(_, familiar)
    if(familiar.Player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS)) then
        familiar.SpriteScale = familiar.SpriteScale*0.8
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, postBoneBoyUpdate, ToyboxMod.FAMILIAR_BONE_BOY)

---@param ent EntityFamiliar
local function bonerTakeDmg(_, ent, am, flags, source, frames)
    if(ent.Variant~=ToyboxMod.FAMILIAR_BONE_BOY) then return end
    local data = ToyboxMod:getEntityDataTable(ent)
    if(ent.HitPoints<=1 or (data.BONEBOY_DAMAGE_COOLDOWN or 0)>0) then return false end

    ent.HitPoints = ent.HitPoints-1
    data.BONEBOY_DAMAGE_COOLDOWN = 15
    ent:SetColor(Color(1,0,0,1,0.5,0.1,0.1),5,1,true,false)
    sfx:Play(SoundEffect.SOUND_BONE_DROP)
    if(ent.HitPoints<=1) then
        ent:ToFamiliar().State=1
        ent:GetSprite():Play("Crumple", true)
        data.BONEBOY_DEATH_COOLDOWN = BONE_BOY_DEATHDUR
    end

    return { Damage=0, DamageCountdown=0 }
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, CallbackPriority.IMPORTANT, bonerTakeDmg, EntityType.ENTITY_FAMILIAR)

local function useBookOfTheDead(_, item, rng, player, flags, slot, vdata)
    for _, fam in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, ToyboxMod.FAMILIAR_BONE_BOY)) do
        fam = fam:ToFamiliar()

        if(fam.State==1) then
            fam.State=2
            fam:GetSprite():Play("GetUp", true)
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_USE_ITEM, useBookOfTheDead, CollectibleType.COLLECTIBLE_BOOK_OF_THE_DEAD)

---@param tear EntityTear
local function postBoneTearUpdate(_, tear)
    if(not ToyboxMod:getEntityData(tear, "BONEBOY_HOLY_BONE")) then return end

    local haemo = Isaac.Spawn(1000,111,0,tear.Position+Vector(0,tear.Height),Vector.Zero,tear):ToEffect()
    haemo.Scale = 0.5
    haemo.Color = Color(0,0,0,1,0.9,0.5,0)
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, postBoneTearUpdate, TearVariant.BONE)

---@param tear EntityTear
local function postBoneTearDeath(_, tear)
    if(not ToyboxMod:getEntityData(tear, "BONEBOY_HOLY_BONE")) then return end

    local fire = Isaac.Spawn(1000,52,0, tear.Position, Vector.Zero, tear.SpawnerEntity):ToEffect()

    fire.Scale = 0.75
    fire.SpriteScale = Vector(1,1)*fire.Scale
    fire.CollisionDamage = 2
    fire.Timeout = 2*30
    fire:Update()
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_TEAR_DEATH, postBoneTearDeath, TearVariant.BONE)