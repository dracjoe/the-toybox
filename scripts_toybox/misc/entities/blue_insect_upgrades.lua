

local FLY_SUB_BITSHIFT = 5
local FLY_SUB_BITMASK = (1<<0 | 1<<1 | 1<<2)
-- 1: dummy fly, for morphing into a regular fly 
-- 2: moter fly
-- 3: sucker
-- 4: pooter
-- 5: lvl2 fly

local FLY_SUB_PICKER = WeightedOutcomePicker()
FLY_SUB_PICKER:AddOutcomeFloat(2, 1) -- moter
FLY_SUB_PICKER:AddOutcomeFloat(3, 1) -- sucker
FLY_SUB_PICKER:AddOutcomeFloat(4, 1) -- poter
FLY_SUB_PICKER:AddOutcomeFloat(5, 1) -- lvl.2 fly


local SPIDER_SUB_BITSHIFT = 5
local SPIDER_SUB_BITMASK = (1<<0 | 1<<1 | 1<<2)
-- 1: dummy spider, for morphing into a regular spider
-- 2: big spider
-- 3: lvl2 spider
-- 4: swarm spider (spawns in groups of 1-4)
-- 5: small crazy long legs

local SPIDER_SUB_PICKER = WeightedOutcomePicker()
SPIDER_SUB_PICKER:AddOutcomeFloat(2, 1) -- big spider
SPIDER_SUB_PICKER:AddOutcomeFloat(3, 1) -- lvl.2 spider
SPIDER_SUB_PICKER:AddOutcomeFloat(4, 1) -- 1-4 swarm spiders
SPIDER_SUB_PICKER:AddOutcomeFloat(5, 1) -- small crazy long legs


local LOCUST_SUB_BITMASK = (1<<0 | 1<<1 | 1<<2)
local LOCUST_SUB_COLORS = {
    [0] = Color.Default,
    [1] = Color(1,1,0,1,0.49),
    [2] = Color(1,1,0,1,0,0.314),
    [3] = Color(0.61,0.61,0,1,0.39,0.235),
    [4] = Color(0,0,0,1),
    [5] = Color(1,1,1,1,0.785,0.785,0.785),
}
local LOCUST_SUB_NAMES = {
    [0] = "",
    [1] = "Wrath",
    [2] = "Pestilence",
    [3] = "Famine",
    [4] = "Death",
    [5] = "Conquest",
}

---@param fam EntityFamiliar
---@param upgrType integer
---@param upgrCol integer?
function ToyboxMod:getUpgradedBlueInsectSub(fam, upgrType, upgrCol)
    if(fam.Variant==FamiliarVariant.BLUE_SPIDER) then
        return ((upgrType & SPIDER_SUB_BITMASK) << SPIDER_SUB_BITSHIFT)-- | ((upgrCol or 0) & LOCUST_SUB_BITMASK)
    end
    return ((upgrType & FLY_SUB_BITMASK) << FLY_SUB_BITSHIFT) | ((upgrCol or 0) & LOCUST_SUB_BITMASK)
end

---@param ent Entity
function ToyboxMod:getBlueInsectTypeCol(ent)
    if(ent.Type==EntityType.ENTITY_FAMILIAR) then
        if(ent.Variant==FamiliarVariant.BLUE_FLY) then
            return (ent.SubType>>FLY_SUB_BITSHIFT) & FLY_SUB_BITMASK, (ent.SubType & LOCUST_SUB_BITMASK)
        elseif(ent.Variant==FamiliarVariant.BLUE_SPIDER) then
            return (ent.SubType>>SPIDER_SUB_BITSHIFT) & SPIDER_SUB_BITMASK, 0--ent.SubType & LOCUST_SUB_BITMASK
        end
    end

    return 0, 0
end

---@param fam EntityFamiliar
local function turnDummyIntoRegular(fam)
    local type, loc = ToyboxMod:getBlueInsectTypeCol(fam)
    if(type~=1) then return end

    --if(loc~=0) then
        fam.SubType = loc
        fam.Color = LOCUST_SUB_NAMES[loc] and LOCUST_SUB_COLORS[0] or LOCUST_SUB_COLORS[loc]
        fam:GetSprite():Play(LOCUST_SUB_NAMES[loc] and ("Locust"..LOCUST_SUB_NAMES[loc]) or "Idle", true)
    --end
end

---@param familiar EntityFamiliar
local function specialInsectInit(_, familiar)
    local type, loc = ToyboxMod:getBlueInsectTypeCol(familiar)
    if(type==0) then return end

    familiar.Color = LOCUST_SUB_COLORS[loc] or LOCUST_SUB_COLORS[0]
    turnDummyIntoRegular(familiar)
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_FAMILIAR_INIT, CallbackPriority.LATE-1, specialInsectInit, FamiliarVariant.BLUE_FLY)
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_FAMILIAR_INIT, CallbackPriority.LATE-1, specialInsectInit, FamiliarVariant.BLUE_SPIDER)

--#region flies

---@param fam EntityFamiliar
local function specialFlyInit(_, fam)
    local type, loc = ToyboxMod:getBlueInsectTypeCol(fam)
    if(type<=1) then return end

    local sp = fam:GetSprite()
    if(type==2) then -- moter
        sp:Load("gfx_tb/familiars/blue bugs/moter.anm2", true)
        sp:Play("Idle", true)
    elseif(type==3) then -- sucker
        sp:Load("gfx_tb/familiars/blue bugs/sucker.anm2", true)
        sp:Play("Idle", true)
    elseif(type==4) then -- pooter
        sp:Load("gfx_tb/familiars/blue bugs/pooter.anm2", true)
        sp:Play("Idle", true)
    elseif(type==5) then -- lvl2 fly
        sp:Load("gfx_tb/familiars/blue bugs/lvl2 fly.anm2", true)
        sp:Play("Idle", true)

        Isaac.CreateTimer(function()
            fam.CollisionDamage = fam.CollisionDamage*0.75
        end,1,1,true)

        if(fam.Hearts==0) then
            fam.Hearts = 2
        end
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_FAMILIAR_INIT, CallbackPriority.LATE-1, specialFlyInit, FamiliarVariant.BLUE_FLY)

---@param fam EntityFamiliar
---@param color integer
---@param ent Entity
---@param flags DamageFlag
---@param amt number
---@param countdown integer
local function triggerLocustEffects(fam, color, ent, flags, amt, countdown)
    local mult = fam:GetMultiplier()
    if(color==1) then
        local bombFlags = fam.Player:GetBombFlags()
        ToyboxMod.GAME:BombExplosionEffects(fam.Position, (mult>1 and 85 or 60), bombFlags, nil, fam.Player, 0.5)
    elseif(color==2) then
        ent:AddPoison(EntityRef(fam), 40, fam.Player.Damage)
    elseif(color==3) then
        ent:AddSlowing(EntityRef(fam), 300, 0.5, Color(1,1,1.3,1,0.156863,0.156863,0.156863))
    elseif(color==4) then
        ent:TakeDamage(amt, flags | DamageFlag.DAMAGE_CLONES, EntityRef(fam), countdown)
    end
end

local flyFunctions = {
    [2] = { -- Moter
        ---@param fam EntityFamiliar
        ---@param locustColor integer
        OnHit = function(fam, locustColor)
            for i=1, 2 do
                local vel = fam.Velocity:Rotated(90*(2*i-3)):Resized(8)
                local newFam = Isaac.Spawn(3,FamiliarVariant.BLUE_FLY,ToyboxMod:getUpgradedBlueInsectSub(fam,1,locustColor),fam.Position,vel,fam.Player):ToFamiliar()
                newFam.Player = fam.Player
                newFam:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

                ToyboxMod:setEntityData(newFam, "CANCEL_FAMILIAR_LOGIC", 9)
            end
        end,
    },
    [3] = { -- Sucker
        ---@param fam EntityFamiliar
        ---@param locustColor integer
        Update = function(fam, locustColor)
            fam.FlipX = ((fam.OrbitLayer==-1) and fam.Velocity.X<0)
        end,
        ---@param fam EntityFamiliar
        ---@param locustColor integer
        OnHit = function(fam, locustColor)
            for i=1, 4 do
                local vel = Vector.FromAngle(i*90)

                if(locustColor==1) then
                    local bomb = Isaac.Spawn(4,BombVariant.BOMB_SMALL,0,fam.Position-fam.Velocity:Resized(15)+vel*15,vel,fam):ToBomb()
                    bomb.RadiusMultiplier = bomb.RadiusMultiplier*0.5
                    bomb.ExplosionDamage = (fam.Player.Damage+10)*fam:GetMultiplier()
                    bomb:SetLoadCostumes(true)
                    bomb:SetExplosionCountdown(12)
                    bomb.Velocity = vel*10
                else
                    local tear = fam:FireProjectile(vel)
                    tear.Velocity = vel*12.5
                    tear.CollisionDamage = fam.Player.Damage*fam:GetMultiplier()

                    if(locustColor==2) then
                        tear:AddTearFlags(TearFlags.TEAR_POISON)
                        tear.Color = Color(0.4,0.97,0.5,1,0,0,0)
                    elseif(locustColor==3) then
                        tear:AddTearFlags(TearFlags.TEAR_SLOW)
                        tear.Color = Color(2,2,2,1,0.196,0.196,0.196)
                    elseif(locustColor==4) then
                        tear.CollisionDamage = tear.CollisionDamage*2
                        tear:ChangeVariant(TearVariant.DARK_MATTER)
                        tear.Scale = tear.Scale*1.5
                    end
                end
            end
        end,
    },
    [4] = { -- Pooter
        ---@param fam EntityFamiliar
        ---@param locustColor integer
        Update = function(fam, locustColor)
            fam.FireCooldown = fam.FireCooldown - (fam.Player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) and 2 or 1)

            local shootDist = 30*4.5

            local startSlowDist = 30*6
            local endSlowDist = 30*2.5
            local maxSlow = 0.5

            local sp = fam:GetSprite()
            if(sp:IsFinished("Attack")) then
                sp:Play("Idle", true)
            end

            local data = ToyboxMod:getEntityDataTable(fam)

            local slowing = 1
            if(fam.Target) then
                local dist = fam.Position:Distance(fam.Target.Position)
                if(dist<=startSlowDist) then
                    local clampedDist = ToyboxMod:clamp(dist, endSlowDist, startSlowDist)
                    clampedDist = (clampedDist-endSlowDist)/(startSlowDist-endSlowDist)

                    slowing = ToyboxMod:lerp(maxSlow, 1, clampedDist)
                end

                if(dist<=shootDist and fam.FireCooldown<=0) then
                    sp:Play("Attack", true)

                    fam.FireCooldown = 40
                end

                if(sp:IsEventTriggered("Shoot")) then
                    local vel = (fam.Target.Position+fam.Target.Velocity*4-fam.Position):Resized(1)

                    if(locustColor==1) then
                        local bomb = Isaac.Spawn(4,BombVariant.BOMB_SMALL,0,fam.Position,vel,fam):ToBomb()
                        bomb.RadiusMultiplier = bomb.RadiusMultiplier*0.5
                        bomb.ExplosionDamage = (fam.Player.Damage+10)*fam:GetMultiplier()
                        bomb:SetLoadCostumes(true)
                        bomb:SetExplosionCountdown(12)
                        bomb.Velocity = vel*8.5
                    else
                        local tear = fam:FireProjectile(vel)
                        tear.Velocity = vel*12.5
                        tear.CollisionDamage = fam.Player.Damage*fam:GetMultiplier()

                        if(locustColor==2) then
                            tear:AddTearFlags(TearFlags.TEAR_POISON)
                            tear.Color = Color(0.4,0.97,0.5,1,0,0,0)
                        elseif(locustColor==3) then
                            tear:AddTearFlags(TearFlags.TEAR_SLOW)
                            tear.Color = Color(2,2,2,1,0.196,0.196,0.196)
                        elseif(locustColor==4) then
                            tear.CollisionDamage = tear.CollisionDamage*2
                            tear:ChangeVariant(TearVariant.DARK_MATTER)
                            tear.Scale = tear.Scale*1.5
                        end
                    end
                end
            end

            fam.FlipX = ((fam.OrbitLayer==-1) and fam.Velocity.X<0)

            data.POOTER_SLOW = ToyboxMod:lerp((data.POOTER_SLOW or 1), slowing, 0.3)
            fam.Velocity = fam.Velocity*data.POOTER_SLOW
        end,
    },
    [5] = { -- Lvl.2 Fly
        ---@param fam EntityFamiliar
        ---@param locustColor integer
        OnHit = function(fam, locustColor)
            if(fam.Hearts>0) then
                local newFam = Isaac.Spawn(3,fam.Variant,fam.SubType,fam.Position,fam.Velocity,fam.Player):ToFamiliar()
                newFam.Player = fam.Player
                newFam.Hearts = (fam.Hearts==1 and -1 or (fam.Hearts-1))
                newFam:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

                local color = newFam.Color
                newFam:SetColor(Color(color.R+0.1,color.G,color.B,1,color.RO+0.1,color.GO,color.BO),2,0,false,false)

                ToyboxMod:setEntityData(newFam, "CANCEL_FAMILIAR_LOGIC", 15)
            end
        end,
    },
}

---@param fam EntityFamiliar
local function specialFlyUpdate(_, fam)
    local type, loc = ToyboxMod:getBlueInsectTypeCol(fam)
    if(type<=1) then return end

    if(flyFunctions[type] and flyFunctions[type].Update) then
        flyFunctions[type].Update(fam, loc)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, specialFlyUpdate, FamiliarVariant.BLUE_FLY)

---@param ent Entity
---@param amt number
---@param flags DamageFlag
---@param sourceRef EntityRef
---@param cooldown integer
local function specialFlyDamage(_, ent, amt, flags, sourceRef, cooldown)
    if(flags & DamageFlag.DAMAGE_CLONES ~= 0) then return end

    local source = sourceRef.Entity and sourceRef.Entity:ToFamiliar()
    if(not (source and source.Variant==FamiliarVariant.BLUE_FLY)) then return end

    local type, loc = ToyboxMod:getBlueInsectTypeCol(source)
    if(type>1) then
        if(flyFunctions[type] and flyFunctions[type].OnHit) then
            flyFunctions[type].OnHit(source, loc, ent, flags, amt, cooldown)
        end

        return triggerLocustEffects(source, loc, ent, flags, amt, cooldown)
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, CallbackPriority.LATE, specialFlyDamage)

--#endregion

--#region spiders

local spawnMoreSpiders = false

---@param fam EntityFamiliar
local function specialSpiderInit(_, fam)
    local type, loc = ToyboxMod:getBlueInsectTypeCol(fam)
    if(type<=1) then return end

    local sp = fam:GetSprite()
    if(type==2) then -- big spider
        sp:Load("gfx_tb/familiars/blue bugs/big spider.anm2", true)
        sp:Play("Idle", true)
    elseif(type==3) then -- lvl2 spider
        sp:Load("gfx_tb/familiars/blue bugs/lvl2 spider.anm2", true)
        sp:Play("Idle", true)

        Isaac.CreateTimer(function()
            fam.CollisionDamage = fam.CollisionDamage*0.75
        end,1,1,true)

        fam:SetShadowSize(fam:GetShadowSize()*1.5)
        if(fam.Hearts==0) then
            fam.Hearts = 2
        end
    elseif(type==4) then -- swarm spider
        sp:Load("gfx_tb/familiars/blue bugs/swarm spider.anm2", true)
        sp:Play("Idle", true)

        Isaac.CreateTimer(function()
            fam.CollisionDamage = fam.CollisionDamage*0.75
        end,1,1,true)
    elseif(type==5) then -- crazy long legs
        sp:Load("gfx_tb/familiars/blue bugs/crazy long legs.anm2", true)
        sp:Play("Idle", true)

        fam:SetShadowSize(fam:GetShadowSize()*1.1)
        if(fam.Hearts==0) then
            fam.Hearts = 1
        end
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_FAMILIAR_INIT, CallbackPriority.LATE-1, specialSpiderInit, FamiliarVariant.BLUE_SPIDER)

local spiderFunctions = {
    [2] = { -- Big Spider
        ---@param fam EntityFamiliar
        ---@param locustColor integer
        OnHit = function(fam, locustColor)
            for i=1, 2 do
                local vel = fam.Velocity:Rotated(90*(2*i-3)):Resized(8)
                local newFam = Isaac.Spawn(3,fam.Variant,ToyboxMod:getUpgradedBlueInsectSub(fam,1,locustColor),fam.Position,Vector.Zero,fam.Player):ToFamiliar()
                newFam.Player = fam.Player
                newFam.TargetPosition = fam.Player.Position+RandomVector()*30
                newFam:GetSprite():Play("Walk", true)

                newFam:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

                ToyboxMod:setEntityData(newFam, "CANCEL_FAMILIAR_COLLISION", 30)
            end
        end,
    },
    [3] = { -- Lvl.2 Spider
        ---@param fam EntityFamiliar
        ---@param locustColor integer
        Update = function(fam, locustColor)
            if(fam.TargetPosition:Length()>0.01) then -- has target
                local rng = fam:GetDropRNG()
                local sp = fam:GetSprite()

                if(fam.State==0) then
                    if(rng:RandomInt(4)==0 and fam.FrameCount>1) then
                        sp:Play("Jump", true)

                        ToyboxMod:setEntityData(fam, "DESIRED_VELOCITY", (fam.TargetPosition-fam.Position))
                        fam.State = 1
                    else
                        fam.State = 2
                    end
                end
                if(fam.State==1) then
                    if(sp:IsFinished("Jump")) then
                        sp:Play("Idle", true)
                        fam.State = 0

                        fam.TargetPosition = Vector.Zero
                    else
                        if(sp:WasEventTriggered("Jump") and not sp:WasEventTriggered("Land")) then
                            local desiredVel = (ToyboxMod:getEntityData(fam, "DESIRED_VELOCITY") or Vector.Zero)*0.1
                            fam.Velocity = ToyboxMod:lerp(fam.Velocity, desiredVel, 0.5)
                        else
                            fam.Velocity = fam.Velocity*0.8
                        end

                        return true
                    end
                end
            else
                fam.State = 0
            end
        end,
        ---@param fam EntityFamiliar
        ---@param locustColor integer
        OnHit = function(fam, locustColor)
            if(fam.Hearts>0) then
                local newFam = Isaac.Spawn(3,fam.Variant,fam.SubType,fam.Position+RandomVector(),fam.Velocity,fam.Player):ToFamiliar()
                newFam.Player = fam.Player
                newFam.Hearts = (fam.Hearts==1 and -1 or (fam.Hearts-1))

                local ogSp = fam:GetSprite()
                local newSp = newFam:GetSprite()
                newSp:Play(ogSp:GetAnimation(), true)
                newSp:SetFrame(ogSp:GetFrame())
                newFam.TargetPosition = fam.TargetPosition
                newFam.State = fam.State

                newFam:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

                local color = newFam.Color
                newFam:SetColor(Color(color.R+0.1,color.G,color.B,1,color.RO+0.1,color.GO,color.BO),2,0,false,false)

                --ToyboxMod:setEntityData(newFam, "CANCEL_FAMILIAR_LOGIC", 15)
                ToyboxMod:setEntityData(newFam, "CANCEL_FAMILIAR_COLLISION", 25)
            end
        end,
    },
    [4] = { -- Swarm Spider
        ---@param fam EntityFamiliar
        ---@param locustColor integer
        Update = function(fam, locustColor)
            if(fam.State==0 and fam.TargetPosition:Length()>0.01) then return end

            if(fam.State==0) then
                fam.State = 1

                if(not (fam.SpawnerEntity and fam.SpawnerEntity.Type==fam.Type and fam.SpawnerEntity.Variant==fam.Variant)) then
                    local rng = fam:GetDropRNG()
                    for _=1, rng:RandomInt(4) do
                        local newFam = Isaac.Spawn(3,fam.Variant,fam.SubType,fam.Position+RandomVector(),fam.Velocity,fam):ToFamiliar()
                        newFam.Player = fam.Player
                        newFam:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                    end
                end
            end

            local sp = fam:GetSprite()
            if(fam.State==1) then
                fam:PickEnemyTarget(40*4.5, 0, EnemyTargetFlags.CAN_CHANGE_TARGET | EnemyTargetFlags.DEPRIORITIZE_CURRENT_TARGET)
                local target = fam.Target or (fam.Player.Position:Distance(fam.Position)<40*6 and fam.Player)

                local rng = fam:GetDropRNG()
                if(target) then
                    fam.TargetPosition = target.Position+rng:RandomVector()*20
                else
                    fam.TargetPosition = fam.Position+rng:RandomVector()*55
                end

                local maxvel = (fam.TargetPosition-fam.Position):Length()*0.17
                maxvel = maxvel*(rng:RandomFloat())

                maxvel = ToyboxMod:clamp(maxvel, 2, 8)

                local animSuffix = "Long"
                if(maxvel<2.5) then
                    animSuffix="Short"
                elseif(maxvel<5.5) then
                    animSuffix=""
                else
                    animSuffix="Long"
                end

                ToyboxMod:setEntityData(fam, "DESIRED_VELOCITY", (fam.TargetPosition-fam.Position):Resized(maxvel))

                sp:Play("Hop"..animSuffix, true)
                fam.State = 2

                fam.Velocity = fam.Velocity*0.7
            elseif(fam.State==2) then
                if(sp:IsFinished()) then
                    sp:Play("Idle", true)
                    fam.State = 1
                else
                    if(sp:WasEventTriggered("Jump") and not sp:WasEventTriggered("Land")) then
                        local desiredVel = (ToyboxMod:getEntityData(fam, "DESIRED_VELOCITY") or Vector.Zero)
                        fam.Velocity = ToyboxMod:lerp(fam.Velocity, desiredVel, 0.6)
                    else
                        fam.Velocity = fam.Velocity*0.7
                    end

                    return true
                end
            end

            return true
        end,
    },
    [5] = { -- Small Crazy Long Legs
        ---@param fam EntityFamiliar
        ---@param locustColor integer
        Update = function(fam, locustColor)
            if(fam.TargetPosition:Length()>0.01) then return end

            fam:PickEnemyTarget(40*8, 13, EnemyTargetFlags.CAN_CHANGE_TARGET)
            local target = fam.Target or fam.Player

            if(fam.State==1 or (fam.FireCooldown<=0 and fam.Target and fam.Position:Distance(target.Position)<40*3.5)) then
                local sp = fam:GetSprite()
                if(fam.FireCooldown==0) then
                    sp:Play("Attack", true)
                    fam.State = 1
                    fam.FireCooldown = 40
                end

                fam.Velocity = fam.Velocity*0.8

                if(sp:IsEventTriggered("Shoot")) then
                    for i=1, 4 do
                        local vel = Vector.FromAngle(i*90+45)

                        if(locustColor==1) then
                            local bomb = Isaac.Spawn(4,BombVariant.BOMB_SMALL,0,fam.Position-fam.Velocity:Resized(15)+vel*15,vel,fam):ToBomb()
                            bomb.RadiusMultiplier = bomb.RadiusMultiplier*0.5
                            bomb.ExplosionDamage = (fam.Player.Damage+10)*fam:GetMultiplier()
                            bomb:SetLoadCostumes(true)
                            bomb:SetExplosionCountdown(12)
                            bomb.Velocity = vel*10
                        else
                            local tear = fam:FireProjectile(vel)
                            tear.Velocity = vel*12.5
                            tear.CollisionDamage = fam.Player.Damage*2*fam:GetMultiplier()
                            tear.Scale = tear.Scale*1.25

                            if(locustColor==2) then
                                tear:AddTearFlags(TearFlags.TEAR_POISON)
                                tear.Color = Color(0.4,0.97,0.5,1,0,0,0)
                            elseif(locustColor==3) then
                                tear:AddTearFlags(TearFlags.TEAR_SLOW)
                                tear.Color = Color(2,2,2,1,0.196,0.196,0.196)
                            elseif(locustColor==4) then
                                tear.CollisionDamage = tear.CollisionDamage*2
                                tear:ChangeVariant(TearVariant.DARK_MATTER)
                                tear.Scale = tear.Scale*1.5
                            end
                        end
                    end
                end
                if(sp:IsEventTriggered("poof02")) then
                    local eff = Isaac.Spawn(1000,16,0,fam.Position,Vector.Zero,nil):ToEffect()
                    eff.Color = Color(0,0,0,0.5,0.1,0.1,1)
                    eff.SpriteOffset = Vector(0,-7)
                    eff.SpriteScale = Vector(0.33,0.33)
                    eff.DepthOffset = fam.DepthOffset+10
                end

                if(sp:IsFinished("Attack")) then
                    sp:Play("Idle", true)
                    fam.State = 0
                end
            else
                if(fam.FireCooldown>0) then
                    fam.FireCooldown = fam.FireCooldown-1
                end

                local ogvel = fam.Velocity
                fam:GetPathFinder():FindGridPath(target.Position, 1.8, 0, true)
                fam.Velocity = ToyboxMod:lerp(ogvel, fam.Velocity, 0.5)

                local sp = fam:GetSprite()
                if(fam.Velocity:Length()>0.5) then
                    sp:SetAnimation("Walk", false)
                else
                    sp:SetAnimation("Idle", false)
                end
            end

            return true
        end,
        ---@param fam EntityFamiliar
        ---@param locustColor integer
        OnHit = function(fam, locustColor)
            if(fam.Hearts>0) then
                local newFam = Isaac.Spawn(3,fam.Variant,fam.SubType,fam.Position+RandomVector(),fam.Velocity,fam.Player):ToFamiliar()
                newFam.Player = fam.Player
                newFam.Hearts = (fam.Hearts==1 and -1 or (fam.Hearts-1))

                newFam:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

                local color = newFam.Color
                newFam:SetColor(Color(color.R+0.1,color.G,color.B,1,color.RO+0.1,color.GO,color.BO),2,0,false,false)

                ToyboxMod:setEntityData(newFam, "CANCEL_FAMILIAR_LOGIC", 25)
                --ToyboxMod:setEntityData(newFam, "CANCEL_FAMILIAR_COLLISION", 25)
            end
        end,
    },
}

---@param fam EntityFamiliar
local function specialSpiderUpdate(_, fam)
    local type, loc = ToyboxMod:getBlueInsectTypeCol(fam)
    if(type==0 and loc>0) then
        fam.Color = LOCUST_SUB_COLORS[loc]
    elseif(type>1 and spiderFunctions[type] and spiderFunctions[type].Update) then
        local ret = spiderFunctions[type].Update(fam, loc)
        if(ret~=nil) then
            return ret
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_UPDATE, specialSpiderUpdate, FamiliarVariant.BLUE_SPIDER)

---@param ent Entity
---@param amt number
---@param flags DamageFlag
---@param sourceRef EntityRef
---@param cooldown integer
local function specialSpiderDamage(_, ent, amt, flags, sourceRef, cooldown)
    if(flags & DamageFlag.DAMAGE_CLONES ~= 0) then return end

    local source = sourceRef.Entity and sourceRef.Entity:ToFamiliar()
    if(not (source and source.Variant==FamiliarVariant.BLUE_SPIDER)) then return end

    local type, loc = ToyboxMod:getBlueInsectTypeCol(source)
    if(type>0 or loc>0) then
        if(spiderFunctions[type] and spiderFunctions[type].OnHit) then
            spiderFunctions[type].OnHit(source, loc, ent, flags, amt, cooldown)
        end

        return triggerLocustEffects(source, loc, ent, flags, amt, cooldown)
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, CallbackPriority.LATE, specialSpiderDamage)

--#endregion


---@param fam EntityFamiliar
local function familiarUpdate(_, fam)
    if(ToyboxMod:getEntityData(fam, "CANCEL_FAMILIAR_LOGIC")) then
        fam.Target = nil
        fam.TargetPosition = Vector.Zero

        local data = ToyboxMod:getEntityDataTable(fam)
        data.CANCEL_FAMILIAR_LOGIC = (data.CANCEL_FAMILIAR_LOGIC or 0)-1
        if(data.CANCEL_FAMILIAR_LOGIC==0) then
            data.CANCEL_FAMILIAR_LOGIC = nil
        end
    end
    if(ToyboxMod:getEntityData(fam, "CANCEL_FAMILIAR_COLLISION")) then
        local data = ToyboxMod:getEntityDataTable(fam)
        data.CANCEL_FAMILIAR_COLLISION = (data.CANCEL_FAMILIAR_COLLISION or 0)-1
        if(data.CANCEL_FAMILIAR_COLLISION==0) then
            data.CANCEL_FAMILIAR_COLLISION = nil
        end
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_PRE_FAMILIAR_UPDATE, CallbackPriority.IMPORTANT, familiarUpdate)

---@param fam EntityFamiliar
local function familiarCollision(_, fam)
    if(ToyboxMod:getEntityData(fam, "CANCEL_FAMILIAR_LOGIC") or ToyboxMod:getEntityData(fam, "CANCEL_FAMILIAR_COLLISION")) then
        return true
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, familiarCollision)

---@param fam EntityFamiliar
---@param init boolean?
function ToyboxMod:makeRandomUpgradedInsect(fam, init)
    if(ToyboxMod:getBlueInsectTypeCol(fam)~=0) then return end

    local rng = fam:GetDropRNG()
    if(fam.Variant==FamiliarVariant.BLUE_FLY) then
        fam.SubType = ToyboxMod:getUpgradedBlueInsectSub(fam, FLY_SUB_PICKER:PickOutcome(rng), fam.SubType)

        if(init or fam.FrameCount>0) then
            specialInsectInit(_, fam)
            specialFlyInit(_, fam)
        end
    elseif(fam.Variant==FamiliarVariant.BLUE_SPIDER) then
        fam.SubType = ToyboxMod:getUpgradedBlueInsectSub(fam, SPIDER_SUB_PICKER:PickOutcome(rng), fam.SubType)

        if(init or fam.FrameCount>0) then
            specialInsectInit(_, fam)
            specialSpiderInit(_, fam)
        end
    end
end