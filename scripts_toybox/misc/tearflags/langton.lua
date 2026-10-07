local LOOP_INTERVAL = 40*3
local LOOP_INTERVAL_START = 40*1.5

local LOOP_DMGMULT = 0.8
local LOOP_SCALEMULT = 0.6

local INVALID_TEAR_EFFECTS =
    TearFlags.TEAR_TRACTOR_BEAM | TearFlags.TEAR_ORBIT | TearFlags.TEAR_ORBIT_ADVANCED | TearFlags.TEAR_LUDOVICO

local LUDO_ORBIT_DIST_TEARS = 30
local LUDO_ORBIT_DIST_LASER = 45

local DRFETUS_LOOP_VELMULT = 0.7

local EPICFETUS_TARGET_SCALEMULT = 0.8
local EPICFETUS_TARGET_LOOP_INTERVAL = 40*5
local EPICFETUS_TARGET_DELAY = 60

---@param ent Entity
---@return EntityPlayer?
local function getPlayerForEnt(ent)
    local check = {ent.SpawnerEntity, ent.Parent}

    for _, cEnt in ipairs(check) do
        if(cEnt) then
            if(cEnt:ToPlayer()) then
                return cEnt:ToPlayer()
            elseif(cEnt:ToFamiliar()) then
                if(ToyboxMod.TEAR_COPYING_FAMILIARS[cEnt.Variant] or cEnt.Variant==FamiliarVariant.FATES_REWARD) then
                    return cEnt:ToFamiliar().Player
                end
            end
        end
    end

    return nil
end

---@param entity Entity
local function postRemoveTearFlag(_, entity, _, _)
    local data = ToyboxMod:getEntityDataTable(entity)
    data.LANGTON_DISTTRAVELLED = nil
    if(data.LANGTON_LUDOTEARS) then
        for _, orbitTear in ipairs(data.LANGTON_LUDOTEARS) do
            orbitTear:Remove()
        end
        data.LANGTON_LUDOTEARS = nil
    end
    data.LANGTON_LIST = nil
end
ToyboxMod:AddCallback(TearFlagsLib.Callback.POST_REMOVE_TEARFLAG, postRemoveTearFlag, ToyboxMod.TEARFLAGS.LANGTON)



---@param entity Entity
---@param player EntityPlayer
local function cancelAddTearFlag(_, entity, player, _, _, tearFlag)
    --if(TearFlagsLib.HasTearFlags(entity, tearFlag)) then return true end

    if(ToyboxMod:getEntityData(entity, "LANGTON_BLACKLIST")) then
        return true
    end
end
ToyboxMod:AddCallback(TearFlagsLib.Callback.PRE_ADD_TEARFLAG, cancelAddTearFlag, ToyboxMod.TEARFLAGS.LANGTON)

---@param recipient Entity
---@param donor Entity
local function postCopyTearFlags(_, recipient, donor)
    ToyboxMod:setEntityData(recipient, "LANGTON_BLACKLIST", ToyboxMod:getEntityData(donor, "LANGTON_BLACKLIST"))
end
ToyboxMod:AddCallback(TearFlagsLib.Callback.POST_COPY_TEARFLAGS, postCopyTearFlags)

---@param entity Entity
local function postRemoveEntity(_, entity)
    if(TearFlagsLib.HasTearFlags(entity, ToyboxMod.TEARFLAGS.LANGTON)) then
        postRemoveTearFlag(_, entity)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, postRemoveEntity)


---@param tear EntityTear
local function langtonPostTearUpdate(_, tear)
    if(tear:HasTearFlags(TearFlags.TEAR_LUDOVICO) or not TearFlagsLib.HasTearFlags(tear, ToyboxMod.TEARFLAGS.LANGTON)) then return end

    local data = ToyboxMod:getEntityDataTable(tear)
    data.LANGTON_DISTTRAVELLED = (data.LANGTON_DISTTRAVELLED or LOOP_INTERVAL_START)+tear.Velocity:Length()

    local posToSpawn = tear.Position-tear.Velocity:Resized(data.LANGTON_DISTTRAVELLED%LOOP_INTERVAL)
    while(data.LANGTON_DISTTRAVELLED>=LOOP_INTERVAL) do
        for i=-1,1,2 do
            local newVel = tear.Velocity:Rotated(i*90)

            local newTear = Isaac.Spawn(EntityType.ENTITY_TEAR, tear.Variant, tear.SubType, posToSpawn, newVel, tear.SpawnerEntity):ToTear()
            newTear.Parent = tear.Parent

            ToyboxMod:copyEntityData(newTear, tear)
            ToyboxMod:setEntityData(newTear, "LANGTON_BLACKLIST", true)

            newTear.FallingSpeed = tear.FallingSpeed
            newTear.FallingAcceleration = tear.FallingAcceleration

            newTear.Scale = tear.Scale*LOOP_SCALEMULT
            newTear.CollisionDamage = tear.CollisionDamage*LOOP_DMGMULT

            newTear.TearFlags = tear.TearFlags--| TearFlags.TEAR_ACCELERATE
            newTear:ClearTearFlags(INVALID_TEAR_EFFECTS)
            
            TearFlagsLib.AddTearFlags(newTear, TearFlagsLib.GetTearFlags(tear))
            TearFlagsLib.ClearTearFlags(newTear, ToyboxMod.TEARFLAGS.LANGTON)

            newTear.CanTriggerStreakEnd = false
            newTear.KnockbackMultiplier = tear.KnockbackMultiplier
            newTear.Color = tear.Color

            newTear:Update()
        end

        posToSpawn = posToSpawn-tear.Velocity:Resized(LOOP_INTERVAL)

        data.LANGTON_DISTTRAVELLED = (data.LANGTON_DISTTRAVELLED or 0)-LOOP_INTERVAL
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, langtonPostTearUpdate)

---@param tear EntityTear
local function langtonPostTearUpdateLudovico(_, tear)
    if(not (tear:HasTearFlags(TearFlags.TEAR_LUDOVICO) and TearFlagsLib.HasTearFlags(tear, ToyboxMod.TEARFLAGS.LANGTON))) then return end
    if(tear:IsDead()) then return end

    local data = ToyboxMod:getEntityDataTable(tear)
    data.LANGTON_LUDOTEARS = data.LANGTON_LUDOTEARS or {}

    for i=#data.LANGTON_LUDOTEARS+1, 2 do
        local newTear = Isaac.Spawn(EntityType.ENTITY_TEAR, tear.Variant, tear.SubType, tear.Position, tear.Velocity, tear.SpawnerEntity):ToTear()
        newTear.Parent = tear.Parent

        ToyboxMod:copyEntityData(newTear, tear)
        ToyboxMod:setEntityData(newTear, "LANGTON_BLACKLIST", true)
        ToyboxMod:setEntityData(newTear, "LANGTON_LUDOANGLE", tear.Velocity:GetAngleDegrees())

        newTear.FallingSpeed = tear.FallingSpeed
        newTear.FallingAcceleration = tear.FallingAcceleration
        --newTear.Height = tear.Height

        newTear.Scale = tear.Scale*LOOP_SCALEMULT
        newTear.CollisionDamage = tear.CollisionDamage*LOOP_DMGMULT

        newTear.TearFlags = tear.TearFlags
        newTear:ClearTearFlags(INVALID_TEAR_EFFECTS | TearFlags.TEAR_LUDOVICO)

        TearFlagsLib.AddTearFlags(newTear, TearFlagsLib.GetTearFlags(tear))
        TearFlagsLib.ClearTearFlags(newTear, ToyboxMod.TEARFLAGS.LANGTON)

        newTear:AddTearFlags(TearFlags.TEAR_LUDOVICO)

        newTear.CanTriggerStreakEnd = false
        newTear.KnockbackMultiplier = tear.KnockbackMultiplier
        newTear.Color = tear.Color

        newTear:Update()

        data.LANGTON_LUDOTEARS[i] = newTear
    end

    local ludoAngle = (ToyboxMod:getEntityData(data.LANGTON_LUDOTEARS[1], "LANGTON_LUDOANGLE") or tear.Velocity:GetAngleDegrees())
    ludoAngle = ludoAngle+ToyboxMod:angleDifference(ludoAngle, tear.Velocity:GetAngleDegrees())*0.15

    for i, orbitTear in ipairs(data.LANGTON_LUDOTEARS) do
        local targetPos = tear.Position+Vector.FromAngle(ludoAngle+(i*2-3)*90):Resized(LUDO_ORBIT_DIST_TEARS)

        orbitTear.Velocity = ToyboxMod:lerp(orbitTear.Velocity, tear.Velocity+(targetPos-orbitTear.Position), 0.7)

        ToyboxMod:setEntityData(orbitTear, "LANGTON_LUDOANGLE", ludoAngle)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, langtonPostTearUpdateLudovico)

---@param tear EntityTear
---@param coll Entity
local function cancelLudovicoLangtonCollision(_, tear, coll)
    if(not (coll and coll:ToTear())) then return end
    coll = coll:ToTear() ---@cast coll EntityTear

    if(tear:HasTearFlags(TearFlags.TEAR_LUDOVICO) and coll:HasTearFlags(TearFlags.TEAR_LUDOVICO)) then
        if(ToyboxMod:getEntityData(tear, "LANGTON_BLACKLIST")~=nil or ToyboxMod:getEntityData(coll, "LANGTON_BLACKLIST")~=nil) then
            return true
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, cancelLudovicoLangtonCollision)



---@param laser EntityLaser
local function langtonPostLaserUpdateLinear(_, laser)
    if(laser.SubType~=LaserSubType.LASER_SUBTYPE_LINEAR) then return end
    if(laser:IsDead()) then return end
    if(not TearFlagsLib.HasTearFlags(laser, ToyboxMod.TEARFLAGS.LANGTON)) then return end

    local data = ToyboxMod:getEntityDataTable(laser)
    local preexistingLasers = data.LANGTON_LIST or {}
    local laserIdx = 0

    local distTravelled = LOOP_INTERVAL_START

    local samples = laser:GetSamples()
    for i=1, #samples-1 do
        distTravelled = distTravelled+samples:Get(i-1):Distance(samples:Get(i))
        local dir = (samples:Get(i)-samples:Get(i-1)):Normalized()
        local posToSpawn = samples:Get(i)-dir*(distTravelled%LOOP_INTERVAL)

        local lasersToSpawn = (distTravelled//LOOP_INTERVAL)
        local endIdx = laserIdx+2*lasersToSpawn
        if(lasersToSpawn==0) then endIdx = laserIdx end
        laserIdx = endIdx

        while(distTravelled>=LOOP_INTERVAL) do
            for r=-1,1,2 do
                local angle = dir:GetAngleDegrees()+r*90

                if(preexistingLasers[laserIdx] and preexistingLasers[laserIdx]:ToLaser()) then
                    local newLaser = preexistingLasers[laserIdx]:ToLaser()

                    newLaser:RotateToAngle(angle, 360)
                    newLaser.Position = posToSpawn
                    newLaser.ParentOffset = newLaser.ParentOffset+(posToSpawn-((newLaser.Parent or newLaser.SpawnerEntity or player).Position+newLaser.ParentOffset))
                    newLaser.Timeout = laser.Timeout
                else
                    local newLaser = EntityLaser.ShootAngle(laser.Variant,posToSpawn,angle,laser:GetTimeout()+1,laser.PositionOffset,laser.SpawnerEntity):ToLaser()
                    
                    ToyboxMod:copyEntityData(newLaser, laser)
                    ToyboxMod:setEntityData(newLaser, "LANGTON_BLACKLIST", laser)

                    newLaser.CurveStrength = laser.CurveStrength
                    newLaser.MaxDistance = laser.MaxDistance
                    newLaser.OneHit = laser.OneHit
                    newLaser.Radius = laser.Radius
                    newLaser.TearFlags = laser.TearFlags
                    TearFlagsLib.AddTearFlags(newLaser, TearFlagsLib.GetTearFlags(laser))
                    TearFlagsLib.ClearTearFlags(newLaser, ToyboxMod.TEARFLAGS.LANGTON)
                    newLaser.HomingType = laser.HomingType

                    newLaser:SetDisableFollowParent(laser.DisableFollowParent)
                    newLaser:SetBlackHpDropChance(laser.BlackHpDropChance)
                    newLaser:SetScale(laser:GetScale()*LOOP_SCALEMULT)
                    newLaser:SetDamageMultiplier(laser:GetDamageMultiplier()*LOOP_DMGMULT)
                    newLaser:SetShrink(laser:GetShrink())
                    newLaser:SetTimeout(laser:GetTimeout())

                    newLaser.Color = laser.Color

                    preexistingLasers[laserIdx] = newLaser
                end

                laserIdx = laserIdx-1
            end

            posToSpawn = posToSpawn-dir*LOOP_INTERVAL
            distTravelled = distTravelled-LOOP_INTERVAL
        end

        laserIdx = endIdx
    end

    local lasersLen = #preexistingLasers
    if(laserIdx<lasersLen) then
        for i=laserIdx+1, lasersLen do
            if(preexistingLasers[i]) then
                preexistingLasers[i]:Remove()
                preexistingLasers[i] = nil
            end
        end
    end
    data.LANGTON_LIST = preexistingLasers
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, langtonPostLaserUpdateLinear)

---@param laser EntityLaser
local function langtonPostLaserUpdateRing(_, laser)
    if(laser.SubType~=LaserSubType.LASER_SUBTYPE_RING_PROJECTILE) then return end
    if(laser:IsDead()) then return end
    if(not TearFlagsLib.HasTearFlags(laser, ToyboxMod.TEARFLAGS.LANGTON)) then return end

    local data = ToyboxMod:getEntityDataTable(laser)
    data.LANGTON_DISTTRAVELLED = (data.LANGTON_DISTTRAVELLED or LOOP_INTERVAL_START)+laser.Velocity:Length()

    local posToSpawn = laser.Position-laser.Velocity:Resized(data.LANGTON_DISTTRAVELLED%LOOP_INTERVAL)
    while(data.LANGTON_DISTTRAVELLED>=LOOP_INTERVAL) do
        for i=-1,1,2 do
            local newVel = laser.Velocity:Rotated(i*90)

            local newLaser = Isaac.Spawn(laser.Type,laser.Variant,laser.SubType,posToSpawn,newVel,laser.SpawnerEntity):ToLaser()
            ToyboxMod:copyEntityData(newLaser, laser)
            ToyboxMod:setEntityData(newLaser, "LANGTON_BLACKLIST", true)

            newLaser.Parent = laser.Parent
            newLaser.CurveStrength = laser.CurveStrength
            newLaser.MaxDistance = laser.MaxDistance
            newLaser.OneHit = laser.OneHit
            newLaser.Radius = laser.Radius*LOOP_SCALEMULT
            newLaser.TearFlags = laser.TearFlags & (~INVALID_TEAR_EFFECTS)
            TearFlagsLib.AddTearFlags(newLaser, TearFlagsLib.GetTearFlags(laser))
            TearFlagsLib.ClearTearFlags(newLaser, ToyboxMod.TEARFLAGS.LANGTON)
            newLaser.HomingType = laser.HomingType
            newLaser.PositionOffset = laser.PositionOffset

            newLaser:SetTimeout(laser:GetTimeout())
            newLaser:SetDisableFollowParent(laser.DisableFollowParent)
            newLaser:SetBlackHpDropChance(laser.BlackHpDropChance)
            newLaser:SetScale(laser:GetScale()*LOOP_SCALEMULT)
            newLaser:SetDamageMultiplier(laser:GetDamageMultiplier()*LOOP_DMGMULT)
            newLaser:SetShrink(laser:GetShrink())

            newLaser.Color = laser.Color
        end

        posToSpawn = posToSpawn-laser.Velocity:Resized(LOOP_INTERVAL)

        data.LANGTON_DISTTRAVELLED = (data.LANGTON_DISTTRAVELLED or 0)-LOOP_INTERVAL
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, langtonPostLaserUpdateRing)

---@param laser EntityLaser
local function langtonPostLaserUpdateLudovico(_, laser)
    if(laser.SubType~=LaserSubType.LASER_SUBTYPE_RING_LUDOVICO) then return end
    if(laser:IsDead()) then return end
    if(not TearFlagsLib.HasTearFlags(laser, ToyboxMod.TEARFLAGS.LANGTON)) then return end

    local data = ToyboxMod:getEntityDataTable(laser)
    data.LANGTON_LUDOLASERS = data.LANGTON_LUDOLASERS or {}

    if(#data.LANGTON_LUDOLASERS<2) then
        for i=#data.LANGTON_LUDOLASERS+1, 2 do
            local newLaser = Isaac.Spawn(laser.Type,laser.Variant,laser.SubType,laser.Position,laser.Velocity,laser.SpawnerEntity):ToLaser()
            ToyboxMod:copyEntityData(newLaser, laser)
            ToyboxMod:setEntityData(newLaser, "LANGTON_BLACKLIST", true)
            ToyboxMod:setEntityData(newLaser, "LANGTON_LUDOANGLE", laser.Velocity:GetAngleDegrees())

            newLaser.Parent = laser.Parent
            newLaser.CurveStrength = laser.CurveStrength
            newLaser.MaxDistance = laser.MaxDistance
            newLaser.OneHit = laser.OneHit
            newLaser.Radius = laser.Radius*LOOP_SCALEMULT
            newLaser.TearFlags = laser.TearFlags & (~INVALID_TEAR_EFFECTS) | TearFlags.TEAR_LUDOVICO
            TearFlagsLib.AddTearFlags(newLaser, TearFlagsLib.GetTearFlags(laser))
            TearFlagsLib.ClearTearFlags(newLaser, ToyboxMod.TEARFLAGS.LANGTON)
            newLaser.HomingType = laser.HomingType
            newLaser.PositionOffset = laser.PositionOffset

            newLaser:SetTimeout(laser:GetTimeout())
            newLaser:SetDisableFollowParent(laser.DisableFollowParent)
            newLaser:SetBlackHpDropChance(laser.BlackHpDropChance)
            newLaser:SetScale(laser:GetScale()*LOOP_SCALEMULT)
            newLaser:SetDamageMultiplier(laser:GetDamageMultiplier()*LOOP_DMGMULT)
            newLaser:SetShrink(laser:GetShrink())

            newLaser.Color = laser.Color

            data.LANGTON_LUDOLASERS[i] = newLaser
        end
    end

    local ludoAngle = (ToyboxMod:getEntityData(data.LANGTON_LUDOLASERS[1], "LANGTON_LUDOANGLE") or laser.Velocity:GetAngleDegrees())
    ludoAngle = ludoAngle+ToyboxMod:angleDifference(ludoAngle, laser.Velocity:GetAngleDegrees())*0.15

    for i, orbitLaser in ipairs(data.LANGTON_LUDOLASERS) do
        local targetPos = laser.Position+Vector.FromAngle(ludoAngle+(i*2-3)*90):Resized(LUDO_ORBIT_DIST_LASER)

        orbitLaser.Velocity = ToyboxMod:lerp(orbitLaser.Velocity, laser.Velocity+(targetPos-orbitLaser.Position), 0.7)

        ToyboxMod:setEntityData(orbitLaser, "LANGTON_LUDOANGLE", ludoAngle)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, langtonPostLaserUpdateLudovico)

---@param knife EntityKnife
local function langtonPostKnifeUpdate(_, knife)
    if(knife:HasTearFlags(TearFlags.TEAR_LUDOVICO) or not TearFlagsLib.HasTearFlags(knife, ToyboxMod.TEARFLAGS.LANGTON)) then return end
    if(knife:IsDead()) then return end

    local data = ToyboxMod:getEntityDataTable(knife)
    if(not knife:IsFlying()) then
        data.LANGTON_DISTTRAVELLED = LOOP_INTERVAL_START
        return
    end

    data.LANGTON_DISTTRAVELLED = (data.LANGTON_DISTTRAVELLED or LOOP_INTERVAL_START)+math.abs(knife:GetKnifeVelocity())/2

    if(data.LANGTON_LUDOTEARS) then
        for _, ent in ipairs(data.LANGTON_LUDOTEARS) do
            ent:Die()
        end
        data.LANGTON_LUDOTEARS = nil
    end

    local vel = Vector.FromAngle(knife.Rotation+knife.RotationOffset)
    local posToSpawn = knife.Position-vel:Resized(data.LANGTON_DISTTRAVELLED%LOOP_INTERVAL)
    local player = getPlayerForEnt(knife) or Isaac.GetPlayer()
    while(data.LANGTON_DISTTRAVELLED>=LOOP_INTERVAL) do
        for i=-1,1,2 do
            local newVel = Vector.FromAngle(knife.Rotation+knife.RotationOffset+i*90):Resized(player.ShotSpeed*9)

            local newTear = player:FireTear(posToSpawn, newVel, true, true, false, player, LOOP_DMGMULT)
            ToyboxMod:setEntityData(newTear, "LANGTON_BLACKLIST", knife)

            newTear.Scale = newTear.Scale*LOOP_SCALEMULT
            newTear:ClearTearFlags(INVALID_TEAR_EFFECTS)
            TearFlagsLib.ClearTearFlags(newTear, ToyboxMod.TEARFLAGS.LANGTON)

            newTear:Update()
        end

        posToSpawn = posToSpawn-vel:Resized(LOOP_INTERVAL)
        data.LANGTON_DISTTRAVELLED = (data.LANGTON_DISTTRAVELLED or 0)-LOOP_INTERVAL
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, langtonPostKnifeUpdate)

---@param knife EntityKnife
local function langtonPostKnifeUpdateLudovico(_, knife)
    if(not (knife:HasTearFlags(TearFlags.TEAR_LUDOVICO) and TearFlagsLib.HasTearFlags(knife, ToyboxMod.TEARFLAGS.LANGTON))) then return end
    if(knife:IsDead()) then return end

    local data = ToyboxMod:getEntityDataTable(knife)
    data.LANGTON_LUDOTEARS = data.LANGTON_LUDOTEARS or {}

    if(#data.LANGTON_LUDOTEARS<2) then
        local player = getPlayerForEnt(knife) or Isaac.GetPlayer()
        for i=#data.LANGTON_LUDOTEARS+1, 2 do

            local newTear = player:FireTear(knife.Position, knife.Velocity, true, true, false, player, LOOP_DMGMULT)
            ToyboxMod:setEntityData(newTear, "LANGTON_BLACKLIST", knife)
            ToyboxMod:setEntityData(newTear, "LANGTON_LUDOANGLE", knife.Velocity:GetAngleDegrees())

            newTear:ClearTearFlags(INVALID_TEAR_EFFECTS)
            newTear.TearFlags = newTear.TearFlags | TearFlags.TEAR_LUDOVICO | TearFlags.TEAR_SPECTRAL
            TearFlagsLib.ClearTearFlags(newTear, ToyboxMod.TEARFLAGS.LANGTON)

            newTear:Update()

            data.LANGTON_LUDOTEARS[i] = newTear
        end
    end

    local ludoAngle = (ToyboxMod:getEntityData(data.LANGTON_LUDOTEARS[1], "LANGTON_LUDOANGLE") or knife.Velocity:GetAngleDegrees())
    ludoAngle = ludoAngle+ToyboxMod:angleDifference(ludoAngle, knife.Velocity:GetAngleDegrees())*0.15

    for i, orbitTear in ipairs(data.LANGTON_LUDOTEARS) do
        local targetPos = knife.Position+Vector.FromAngle(ludoAngle+(i*2-3)*90):Resized(LUDO_ORBIT_DIST_TEARS)

        orbitTear.Velocity = ToyboxMod:lerp(orbitTear.Velocity, knife.Velocity+(targetPos-orbitTear.Position), 0.7)

        ToyboxMod:setEntityData(orbitTear, "LANGTON_LUDOANGLE", ludoAngle)
    end

    local len = #data.LANGTON_LUDOTEARS
    for i=1, len do
        if(data.LANGTON_LUDOTEARS[i] and not data.LANGTON_LUDOTEARS[i]:Exists()) then
            table.remove(data.LANGTON_LUDOTEARS, i)
            len = len-1
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, langtonPostKnifeUpdateLudovico)


---@param pl EntityPlayer
---@param bomb EntityBomb
local function invalidateUsedBomb(_, pl, bomb)
    if(pl:HasCollectible(ToyboxMod.COLLECTIBLE_LANGTON_LOOP)) then
        ToyboxMod:setEntityData(bomb, "LANGTON_BLACKLIST", true)
    end
end
--ToyboxMod:AddCallback(ModCallbacks.MC_POST_PLAYER_USE_BOMB, invalidateUsedBomb)

---@param bomb EntityBomb
---@param ogbomb EntityBomb
local function copyInvalidBombData(_, bomb, ogbomb)
    ToyboxMod:setEntityData(bomb, "LANGTON_BLACKLIST", ToyboxMod:getEntityData(ogbomb, "LANGTON_BLACKLIST"))
end
ToyboxMod:AddCallback(ToyboxMod.CUSTOM_CALLBACKS.COPY_SCATTER_BOMB_DATA, copyInvalidBombData)

---@param bomb EntityBomb
local function langtonPostBombUpdate(_, bomb)
    if(not TearFlagsLib.HasTearFlags(bomb, ToyboxMod.TEARFLAGS.LANGTON)) then return end
    if(bomb:IsDead()) then return end

    local data = ToyboxMod:getEntityDataTable(bomb)
    data.LANGTON_DISTTRAVELLED = (data.LANGTON_DISTTRAVELLED or LOOP_INTERVAL_START)+bomb.Velocity:Length()

    local posToSpawn = bomb.Position-bomb.Velocity:Resized(data.LANGTON_DISTTRAVELLED%LOOP_INTERVAL)
    while(data.LANGTON_DISTTRAVELLED>=LOOP_INTERVAL) do
        for i=-1,1,2 do
            local newVel = bomb.Velocity:Rotated(i*90)*DRFETUS_LOOP_VELMULT

            local newBomb = Isaac.Spawn(EntityType.ENTITY_BOMB, bomb.Variant, bomb.SubType, posToSpawn, newVel, bomb.SpawnerEntity):ToBomb()
            newBomb.Parent = bomb.Parent

            ToyboxMod:copyEntityData(newBomb, bomb)
            ToyboxMod:setEntityData(newBomb, "LANGTON_BLACKLIST", true)

            newBomb.ExplosionDamage = bomb.ExplosionDamage*LOOP_DMGMULT
            newBomb:SetScale(bomb:GetScale()*LOOP_SCALEMULT)
            newBomb.RadiusMultiplier = bomb.RadiusMultiplier*LOOP_SCALEMULT
            newBomb:SetRocketAngle(bomb:GetRocketAngle()+i*90)
            newBomb:AddTearFlags(bomb.Flags)
            TearFlagsLib.AddTearFlags(newBomb, TearFlagsLib.GetTearFlags(bomb))
            TearFlagsLib.ClearTearFlags(newBomb, ToyboxMod.TEARFLAGS.LANGTON)

            newBomb.Color = bomb.Color

            newBomb:SetLoadCostumes(true)

            newBomb:Update()
        end

        posToSpawn = posToSpawn-bomb.Velocity:Resized(LOOP_INTERVAL)

        data.LANGTON_DISTTRAVELLED = (data.LANGTON_DISTTRAVELLED or 0)-LOOP_INTERVAL
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, langtonPostBombUpdate)

---@param bomb EntityBomb   
---@param coll Entity
local function cancelBombLangstonCollision(_, bomb, coll)
    if(not (coll and coll:ToBomb())) then return end
    coll = coll:ToBomb() ---@cast coll EntityBomb

    if(ToyboxMod:getEntityData(bomb, "LANGTON_BLACKLIST") or ToyboxMod:getEntityData(coll, "LANGTON_BLACKLIST")) then
        return true
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_BOMB_COLLISION, cancelBombLangstonCollision)


---@param rocket EntityEffect
local function langtonPostTargetUpdate(_, rocket)
    if(not TearFlagsLib.HasTearFlags(rocket, ToyboxMod.TEARFLAGS.LANGTON)) then return end
    if(rocket:IsDead()) then return end

    if(player:GetMarkedTarget() and GetPtrHash(player:GetMarkedTarget())==GetPtrHash(rocket)) then return end

    local data = ToyboxMod:getEntityDataTable(rocket)
    data.LANGTON_DISTTRAVELLED = (data.LANGTON_DISTTRAVELLED or LOOP_INTERVAL_START)+rocket.Velocity:Length()

    local posToSpawn = rocket.Position-rocket.Velocity:Resized(data.LANGTON_DISTTRAVELLED%EPICFETUS_TARGET_LOOP_INTERVAL)
    while(data.LANGTON_DISTTRAVELLED>=EPICFETUS_TARGET_LOOP_INTERVAL) do
        local newRocket = Isaac.Spawn(EntityType.ENTITY_EFFECT, rocket.Variant, rocket.SubType, posToSpawn, Vector.Zero, rocket.SpawnerEntity):ToEffect()
        newRocket.Parent = rocket.Parent

        ToyboxMod:copyEntityData(newRocket, rocket)
        ToyboxMod:setEntityData(newRocket, "LANGTON_BLACKLIST", true)

        newRocket:SetTimeout(EPICFETUS_TARGET_DELAY)
        newRocket.State = 1
        newRocket.SpriteScale = rocket.SpriteScale*EPICFETUS_TARGET_SCALEMULT

        newRocket:AddTearFlags(rocket:GetTearFlags())
        TearFlagsLib.AddTearFlags(newBomb, TearFlagsLib.GetTearFlags(bomb))
        TearFlagsLib.ClearTearFlags(newBomb, ToyboxMod.TEARFLAGS.LANGTON)

        newRocket:Update()

        posToSpawn = posToSpawn-rocket.Velocity:Resized(EPICFETUS_TARGET_LOOP_INTERVAL)

        data.LANGTON_DISTTRAVELLED = (data.LANGTON_DISTTRAVELLED or 0)-EPICFETUS_TARGET_LOOP_INTERVAL
    end
end
--ToyboxMod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, langtonPostTargetUpdate, EffectVariant.TARGET)