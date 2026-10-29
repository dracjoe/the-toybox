local DRAIN_CHARGE_FREQ = 7

local RANDOM_LASERS = 2
local RANDOM_LASERS_SMALL = 3
local ENEMY_LASERS = 4
local LASER_MAX_DIST = 40*20
local LASER_FREQ = 5
local LASER_DURATION = 5

local EXPLOSION_LASERS = 17

local EXPLOSION_DAMAGE = 85
local LASER_DAMAGE = 6

local function spawnSpark(pos, angle, dist, tear, dmg, scale)
    local player = tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer() or Isaac.GetPlayer()

    local arc = EntityLaser.ShootAngle(LaserVariant.THIN_RED, pos, angle, LASER_DURATION, Vector(0, tear.Height), player)
    --arc.DisableFollowParent = false
    arc:SetDisableFollowParent(false)
    arc.Parent = tear
    arc.CollisionDamage = dmg

    local room = ToyboxMod.GAME:GetRoom()
    local testdist = dist or 1200
    local endpos = pos+Vector.FromAngle(angle)*testdist

    local res, hit = room:CheckLine(pos, endpos, LineCheckMode.PROJECTILE, 1000, false, false)
    testdist = (hit-pos):Length()

    if(dist and dist==testdist) then
        arc.MaxDistance = dist
        arc.SubType = LaserSubType.LASER_SUBTYPE_NO_IMPACT
    else
        arc.MaxDistance = testdist+40
        --arc.SubType = LaserSubType.LASER_SUBTYPE_LINEAR
    end

    arc.OneHit = true
    arc.Mass = 0
    arc.DepthOffset = 50

    local color = Color.Lerp(Color(0,0,0,1,0.435,0.937,0.404), Color(0,0,0,1,1,1,0.137), math.random())
    color.A = 1
    arc:SetScale(scale or 0.75)

    arc.Color = color

    ToyboxMod:setEntityData(arc, "PLASMA_BLACKLIST", true)
    TearFlagsLib.ClearTearFlags(arc, ToyboxMod.TEARFLAGS.PLASMA)

    return arc
end

ToyboxMod:registerTearVariant(
    ToyboxMod.TEAR_PLASMA,
    function(tear) ---@param tear EntityTear
        local scaleMod = 1.5
    
        tear.Scale = scaleMod
        tear.SpriteScale = Vector(1,1)/scaleMod
        tear:GetSprite():Play("ThisStillLooksBad", true)

        ToyboxMod.SFX:Play(ToyboxMod.SFX_BFG_IDLE, 2, 2, true)
    end,
    function(tear) ---@param tear EntityTear
        if(tear.FrameCount % LASER_FREQ == 0) then
            ToyboxMod.SFX:Play(SoundEffect.SOUND_REDLIGHTNING_ZAP, 0, 2)
            ToyboxMod.SFX:Play(SoundEffect.SOUND_REDLIGHTNING_ZAP_WEAK, 0, 2)
            ToyboxMod.SFX:Play(ToyboxMod.SFX_BFG_ARC, 0.5)

            local nearbyEnemies = {}
            for _, ent in ipairs(Isaac.FindInRadius(tear.Position, LASER_MAX_DIST, EntityPartition.ENEMY)) do
                if(ToyboxMod:isValidEnemy(ent)) then
                    table.insert(nearbyEnemies, ent:ToNPC())
                end
            end

            local rng = tear:GetDropRNG()
            local player = tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer() or Isaac.GetPlayer()

            local lasersLeft = ENEMY_LASERS
            for _=1, ENEMY_LASERS do
                if(#nearbyEnemies==0) then break end

                local idx = rng:RandomInt(1, #nearbyEnemies)
                local npc = nearbyEnemies[idx]

                local dir = (npc.Position-tear.Position)
                local distToFire = dir:Length()+5
                local angleToFire = dir:GetAngleDegrees()
                spawnSpark(tear.Position, angleToFire, distToFire, tear, LASER_DAMAGE)
                lasersLeft = lasersLeft-1

                table.remove(nearbyEnemies, idx)
            end

            for i=1, lasersLeft+RANDOM_LASERS+RANDOM_LASERS_SMALL do
                local angle = rng:RandomInt(1, 360)

                spawnSpark(tear.Position, angle, nil, tear, LASER_DAMAGE*(i<=RANDOM_LASERS_SMALL and 1 or 1), (i<=RANDOM_LASERS_SMALL and 0.4))
            end

            --ToyboxMod.SFX:Stop(SoundEffect.SOUND_REDLIGHTNING_ZAP)
        end
    end,
    function(tear, splat) ---@param splat EntityEffect
        splat.Scale = splat.Scale * 0.1
        splat.SpriteScale = splat.SpriteScale * 0.9
        splat:GetSprite().Color = splat:GetSprite().Color*Color(111/185,239/207,103/255,1)

        local pos = ToyboxMod.GAME:GetRoom():GetClampedPosition(tear.Position, 20)
        ToyboxMod.GAME:BombExplosionEffects(
            pos, EXPLOSION_DAMAGE, TearFlags.TEAR_NORMAL, Color(0.435,0.937,0.404,1,0.15,0.3,0.1),
            tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer() or Isaac.GetPlayer(), 1.2
        )

        local rng = tear:GetDropRNG()
        for i=1, EXPLOSION_LASERS do
            local angle = (i+rng:RandomFloat()-0.5)/EXPLOSION_LASERS*360

            spawnSpark(pos, angle, nil, tear, LASER_DAMAGE)
        end

        ToyboxMod.SFX:Stop(ToyboxMod.SFX_BFG_IDLE)
        ToyboxMod.SFX:AdjustVolume(ToyboxMod.SFX_BFG_ARC, 0.1)
    end,
    true, false, nil
)

---@param player EntityPlayer
local function useMeltedCandle(_, _, rng, player, flags, slot)
    if(player:GetItemState()==ToyboxMod.COLLECTIBLE_TECH10K) then
        player:SetItemState(0)
        player:AnimateCollectible(ToyboxMod.COLLECTIBLE_TECH10K, "HideItem")
    else
        ToyboxMod.SFX:Play(ToyboxMod.SFX_BFG_RAISE)

        local charges = player:GetActiveCharge(slot)
        Isaac.CreateTimer(function()
            if(player) then
                charges = charges-1
                player:AddActiveCharge(-1, slot)

                if(charges<=0) then
                    player:SetItemState(ToyboxMod.COLLECTIBLE_TECH10K)
                    player:AnimateCollectible(ToyboxMod.COLLECTIBLE_TECH10K, "LiftItem")

                    ToyboxMod.SFX:Play(ToyboxMod.SFX_TOY_GUN_RELOAD)
                end

                ToyboxMod.SFX:Play(SoundEffect.SOUND_BEEP)
            end
        end, DRAIN_CHARGE_FREQ, charges, false)
    end

    return {
        Discharge = false,
        Remove = false,
        ShowAnim = false,
    }
end
ToyboxMod:AddCallback(ModCallbacks.MC_USE_ITEM, useMeltedCandle, ToyboxMod.COLLECTIBLE_TECH10K)

---@param player EntityPlayer
local function tryUseHeldCandle(_, player)
    if(player:GetItemState()~=ToyboxMod.COLLECTIBLE_TECH10K) then return end

    if(player:GetAimDirection():Length()>0) then
        local dir = (player:GetAimDirection():Length()<0.01 and player.Velocity or player:GetAimDirection())
        dir = (dir:Resized(5)+player:GetTearMovementInheritance(dir:Normalized())):Resized(5)

        local tear = Isaac.Spawn(2, ToyboxMod.TEAR_PLASMA, 0, player.Position, dir, player):ToTear()
        tear.FallingAcceleration = -0.1
        --tear:AddTearFlags(TearFlags.TEAR_PIERCING)

        if(player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)==ToyboxMod.COLLECTIBLE_TECH10K) then
            player:AddActiveCharge(player:GetActiveMaxCharge(ActiveSlot.SLOT_PRIMARY), ActiveSlot.SLOT_PRIMARY)
        end
        player:DischargeActiveItem(ActiveSlot.SLOT_PRIMARY)
        player:AnimateCollectible(ToyboxMod.COLLECTIBLE_TECH10K, "HideItem")
        player:SetItemState(0)

        ToyboxMod.SFX:Play(ToyboxMod.SFX_BFG_FIRE)
        ToyboxMod.SFX:Play(SoundEffect.SOUND_BULLET_SHOT)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, tryUseHeldCandle)