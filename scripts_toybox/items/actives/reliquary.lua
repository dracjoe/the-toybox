--TODO: Make wisps not collide with fires

local sfx = SFXManager()

local ORBIT_LAYERS = {
    [8] =  {Dist=Vector(40,30), Limit=8},
    [9] =  {Dist=Vector(64,50), Limit=12},
    [10] = {Dist=Vector(92,75), Limit=16},
}

---@param player EntityPlayer
local function useReliquary(_, _, rng, player, flags)
    local pool = ToyboxMod.GAME:GetItemPool()
    local conf = Isaac.GetItemConfig()

    local removedBefore = {}
    for i=1, conf:GetTrinkets().Size-1 do
        if(conf:GetTrinket(i) and not pool:HasTrinket(i)) then
            table.insert(removedBefore, i)
        end
    end

    pool:ResetTrinkets()
    local trinket = pool:GetTrinket(false)
    pool:ResetTrinkets()

    for _, tr in ipairs(removedBefore) do
        pool:RemoveTrinket(tr)
    end

    ToyboxMod:addTrinketWisp(player, trinket, player.Position)
    ToyboxMod.GAME:GetHUD():ShowItemText(player, conf:GetTrinket(trinket))

    return {
        Discharge = true,
        Remove = false,
        ShowAnim = true,
    }
end
ToyboxMod:AddCallback(ModCallbacks.MC_USE_ITEM, useReliquary, ToyboxMod.COLLECTIBLE_RELIQUARY)

---@param pl EntityPlayer
---@param slot EntitySlot
local function renderReliquary(_, pl, slot)
    return {
        CropOffset = Vector(32*(pl:GetActiveCharge(slot)>=pl:GetActiveMaxCharge(slot) and 1 or 0),0),
    }
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_ACTIVE_ITEM, renderReliquary, ToyboxMod.COLLECTIBLE_RELIQUARY)

---@param player EntityPlayer
---@param id TrinketType
---@param position? Vector Default: player.Position
function ToyboxMod:addTrinketWisp(player, id, position)
    local wisp = Isaac.Spawn(3,ToyboxMod.FAMILIAR_TRINKET_WISP,id,position or player.Position,Vector.Zero,player):ToFamiliar()
end

---@param familiar EntityFamiliar
local function trinketWispInit(_, familiar)
    if(familiar.SpawnerEntity and familiar.SpawnerEntity:ToPlayer()) then
        familiar.Player = familiar.SpawnerEntity:ToPlayer()
        familiar.Parent = familiar.Player
    end

    familiar.CollisionDamage = familiar.Player.Damage*2

    local playerHash = GetPtrHash(familiar.Player)
    local layers = {}
    for i, _ in pairs(ORBIT_LAYERS) do layers[i] = 0 end

    local oldest
    for _, ent in ipairs(Isaac.FindByType(3,ToyboxMod.FAMILIAR_TRINKET_WISP)) do
        local otherFam = ent:ToFamiliar()
        if(GetPtrHash(otherFam.Player)==playerHash) then
            layers[otherFam.OrbitLayer] = (layers[otherFam.OrbitLayer] or 0)+1
            if(oldest==nil or (oldest and oldest.FrameCount<otherFam.FrameCount)) then
                oldest = otherFam
            end
        end
    end

    local smallestUnoccupied = 1111
    for i, data in pairs(ORBIT_LAYERS) do
        if(layers[i] and layers[i]<data.Limit) then
            smallestUnoccupied = math.min(smallestUnoccupied, i)
        end
    end
    if(smallestUnoccupied==1111 and oldest) then
        oldest:Die()
        familiar:AddToOrbit(oldest.OrbitLayer)
        familiar.OrbitDistance = oldest.OrbitDistance

        oldest:RemoveFromOrbit()
    else
        familiar:AddToOrbit(smallestUnoccupied)
        familiar.OrbitDistance = ORBIT_LAYERS[smallestUnoccupied].Dist
    end

    local sp = familiar:GetSprite()
    local conf = Isaac.GetItemConfig():GetTrinket(familiar.SubType)
    if(conf) then
        if(familiar.Player.FrameCount>0) then
            familiar.Player:AddInnateTrinket(familiar.SubType, 1, "Toybox_TrinketWisp")
        end

        local collectionSpr = ToyboxMod:getTrinketCollectionSprite(conf.ID)
        if(collectionSpr) then -- has custom made collection sprite
            sp:Play("Idle2", true)
            sp:ReplaceSpritesheet(2, collectionSpr:GetLayer(0):GetSpritesheetPath(), true)
            local layer = sp:GetLayer(2)
            if(layer) then
                local fr = collectionSpr:GetLayerFrameData(0)
                layer:SetCropOffset(fr:GetCrop())
                layer:SetPos(layer:GetPos()+Vector(0,0))

                layer:GetBlendMode():SetMode(BlendType.ADDITIVE)
                layer:SetColor(Color(1,1,1,0.9,0.5,0.5,0.5,73/255+1,231/255+1,62/255+1,2))
            end
        else -- doesnt
            sp:Play("Idle", true)
            sp:ReplaceSpritesheet(2, conf.GfxFileName, true)
            local layer = sp:GetLayer(2)
            if(layer) then
                layer:SetColor(Color((73/231)^0.8,1,(62/231)^0.8,0.9))
                layer:GetBlendMode():SetMode(BlendType.ADDITIVE)

                layer:SetCustomShader("shaders_tb/wisp")
            end
        end
    else
        familiar:Die()
        familiar:Remove()
    end

    sp:GetLayer(0):SetColor(Color(255/151,255/151,255/151))
    sp:GetLayer(1):SetColor(Color(12/151,198/151,0/151))
    familiar.SplatColor = Color(0,0,0,0)
end
ToyboxMod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, trinketWispInit, ToyboxMod.FAMILIAR_TRINKET_WISP)

---@param familiar EntityFamiliar
local function trinketWispUpdate(_, familiar)
    familiar.SpriteScale = Vector(1,1)*ToyboxMod:lerp(0.8,1,familiar.HitPoints/familiar.MaxHitPoints)

    if(ORBIT_LAYERS[familiar.OrbitLayer]) then
        familiar.OrbitDistance = ORBIT_LAYERS[familiar.OrbitLayer].Dist
    end

    local orbitTarget = familiar.Player

    local targetPosition = orbitTarget.Position
    local targetVelocity = orbitTarget.Velocity

    local orbitPosition = familiar:GetOrbitPosition(targetPosition)

    local orbitSteering
    local chaseVelocity
    do
        local targetDisplacement = targetPosition - familiar.Position
        local chaseStep = (targetPosition - familiar.Position) * 0.01
        if chaseStep:Length() > 8.0 then
            chaseStep:Resize(8.0)
        end

        local targetDistance = targetDisplacement:Length()
        local orbitRadii = familiar.OrbitDistance
        local maxOrbitDistance = math.max(orbitRadii.X, orbitRadii.Y)
        local distanceBeyondOrbit = targetDistance - (maxOrbitDistance + 10.0) -- pad by 10 so that target is considered close just outside of the orbit

        local normalizedFarness = ToyboxMod:clamp(distanceBeyondOrbit/160, 0, 1)
        local quadraticFalloff = (1.0 - normalizedFarness) ^ 2 -- smooth out transition between far and close
        local targetFarness = 1.0 - quadraticFalloff
        local targetCloseness = 2.0 * quadraticFalloff

        local targetVelInfluence = targetVelocity * targetCloseness / orbitTarget.Friction
        orbitSteering = (orbitPosition - (familiar.Position + targetVelInfluence)) * 0.5
        local orbitSteerSpeed = orbitSteering:Length()

        if orbitSteerSpeed > 5.0 and (familiar:GetEntityFlags() & EntityFlag.FLAG_SPIN) == 0 then
            orbitSteering:Resize(4.0) -- this caps the speed at 4.0 if > 5.0 (maybe a bug)
        end

        chaseVelocity = familiar.Velocity + chaseStep
        orbitSteering = (orbitSteering + targetVelInfluence) / familiar.Friction

        chaseVelocity = chaseVelocity * targetFarness -- chase dominates when target is far from orbit
        orbitSteering = orbitSteering - (orbitSteering * targetFarness) -- orbitSteer dominates when target is close to orbit
    end

    familiar.Velocity = chaseVelocity + orbitSteering
end
ToyboxMod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, trinketWispUpdate, ToyboxMod.FAMILIAR_TRINKET_WISP)

---@param ent Entity
local function trinketWispRemoveTrinket(_, ent)
    if(ent:ToFamiliar() and ent.Variant==ToyboxMod.FAMILIAR_TRINKET_WISP) then
        local fam = ent:ToFamiliar()
        local conf = Isaac.GetItemConfig():GetTrinket(fam.SubType)
        if(conf) then
            fam.Player:RemoveInnateTrinket(fam.SubType, 1, "Toybox_TrinketWisp")
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, trinketWispRemoveTrinket, EntityType.ENTITY_FAMILIAR)

---@param ent Entity
local function trinketWispDeath(_, ent)
    if(ent:ToFamiliar() and ent.Variant==ToyboxMod.FAMILIAR_TRINKET_WISP) then
        local fam = ent:ToFamiliar()
        local poof = Isaac.Spawn(1000,12,0,fam.Position,Vector.Zero,nil):ToEffect()
        poof.SpriteOffset = Vector(0,-14)
        poof.Color = Color(73/185,231/207,62/252)

        local evilEffect = Isaac.Spawn(1000,15,2,fam.Position,Vector.Zero,nil):ToEffect()
        evilEffect.Color = Color(73/185,231/207,62/252)

        sfx:Stop(SoundEffect.SOUND_DEATH_BURST_SMALL)
        sfx:Play(SoundEffect.SOUND_STEAM_HALFSEC)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, trinketWispDeath, EntityType.ENTITY_FAMILIAR)

---@param source EntityRef
local function trinketWispDealDmg(_, _, _, _, source)
    if(source.Type==3 and source.Variant==ToyboxMod.FAMILIAR_TRINKET_WISP) then
        sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, trinketWispDealDmg)

---@param ent Entity
---@param dmg number
---@param flags DamageFlag
---@param source EntityRef
---@param countdown integer
local function trinketWispTakeDmg(_, ent, dmg, flags, source, countdown)
    if(ent.Variant==ToyboxMod.FAMILIAR_TRINKET_WISP) then
        return {
            Damage = math.max(dmg,1),
            DamageFlags = flags,
            DamageCountdown = countdown,
        }
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, trinketWispTakeDmg, EntityType.ENTITY_FAMILIAR)