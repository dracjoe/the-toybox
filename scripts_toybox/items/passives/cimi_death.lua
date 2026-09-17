local sfx = SFXManager()

ToyboxMod.ROOM_DEATHSACRIFICE_SUBTYPE = 10

local STAT_BONUSES = {
    SPEED = 0.2,
    TEARS = 0.7,
    DAMAGE = 0.7,
    RANGE = 1,
    SHOTSPEED = 0.1,
    LUCK = 1,
}
local PICKER_TO_STAT = {"SPEED", "TEARS", "DAMAGE", "RANGE", "SHOTSPEED", "LUCK"}

local REWARD_RESULTS = {
    [1] = {
        {2, {{PickupVariant.PICKUP_COIN}}},
        {1, {{PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL}}},
    },
    [2] = {
        {1, function(rng) -- 1-3 coins
            local tb = {};
            for _=1,rng:RandomInt(1,3) do
                table.insert(tb, {PickupVariant.PICKUP_COIN})
            end
            return tb
        end},
        {2, {{PickupVariant.PICKUP_BOMB}}},
        {2, {{PickupVariant.PICKUP_KEY}}},
    },
    [3] = {
        {1, {{PickupVariant.PICKUP_GRAB_BAG}}},
    },
    [4] = -1,
    [5] = {
        {1, {{0,NullPickupSubType.NO_COLLECTIBLE},{0,NullPickupSubType.NO_COLLECTIBLE},{0,NullPickupSubType.NO_COLLECTIBLE}}},
        {2, {{PickupVariant.PICKUP_CHEST}}},
    },
    [6] = {
        {1, function(rng) -- random card
            local sub = ToyboxMod.GAME:GetItemPool():GetCard(rng:Next(), true, false, false)
            return {{PickupVariant.PICKUP_TAROTCARD, sub}}
        end},
        {1, function(rng) -- random rune
            local sub = ToyboxMod.GAME:GetItemPool():GetCard(rng:Next(), false, true, true)
            return {{PickupVariant.PICKUP_TAROTCARD, sub}}
        end},
    },
    [7] = {
        {3, {{PickupVariant.PICKUP_LOCKEDCHEST}}},
        {1, {{PickupVariant.PICKUP_CHEST}}},
    },
    [8] = -1,
    [9] = {
        {1, {{PickupVariant.PICKUP_LOCKEDCHEST}}},
        {2, function(rng, pos)
            local room = ToyboxMod.GAME:GetRoom()
            for _=1, 3 do
                local fPos = room:FindFreePickupSpawnPosition(pos,39)
                local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, 0, NullPickupSubType.NO_COLLECTIBLE, fPos, Vector.Zero, nil):ToPickup()
                local failSafe = 50
                while(failSafe>0 and pickup.Variant==PickupVariant.PICKUP_HEART) do
                    pickup:Morph(EntityType.ENTITY_PICKUP, 0, NullPickupSubType.NO_COLLECTIBLE)
                end
            end
        end},
        {1, {{PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL}}}
    }
}

-- ITEM LOGIC

---@param slot LevelGeneratorRoom
---@param conf RoomConfigRoom
---@param seed integer
local function replaceSacrificeRoom(_, slot, conf, seed)
    if(not (conf.Type==RoomType.ROOM_SACRIFICE)) then return end

    local desSub = nil
    if(PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_CIMI_DEATH)) then
        if(conf.Subtype==0) then
            desSub = ToyboxMod.ROOM_DEATHSACRIFICE_SUBTYPE
        end
    else
        if(conf.Subtype==ToyboxMod.ROOM_DEATHSACRIFICE_SUBTYPE) then
            desSub = 0
        end
    end

    if(not desSub) then return end

    local newRoom = RoomConfig.GetRandomRoom(seed, true, StbType.SPECIAL_ROOMS, RoomType.ROOM_SACRIFICE, conf.Shape, nil, nil, nil, nil, slot:DoorMask(), desSub, conf.Mode)
    if(newRoom) then
        return newRoom
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_LEVEL_PLACE_ROOM, replaceSacrificeRoom)

---@param slot LevelGeneratorRoom
---@param conf RoomConfigRoom
---@param seed integer
local function tryPlaceNewSacrificeRoom(_, slot, conf, seed)
    if(not PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_CIMI_DEATH)) then return end

    local level = ToyboxMod.GAME:GetLevel()

    --[ [] ]
    local shouldGenerate = true
    for i=0, 13*13-1 do
        local desc = level:GetRoomByIdx(i)
        if(desc and desc.Data and desc.Data.Type==RoomType.ROOM_SACRIFICE) then
            shouldGenerate = false
        end
    end

    if(not shouldGenerate) then return end
    --]]

    local pl = PlayerManager.FirstCollectibleOwner(ToyboxMod.COLLECTIBLE_CIMI_DEATH)
    local rng = pl and pl:GetCollectibleRNG(ToyboxMod.COLLECTIBLE_CIMI_DEATH)
    if(not rng) then return end

    local finalRoom
    local failSafe = 4

    while(finalRoom==nil and failSafe>0) do
        local newBossRoom = RoomConfigHolder.GetRandomRoom(rng:Next(), true, StbType.SPECIAL_ROOMS, RoomType.ROOM_SACRIFICE, nil, nil, nil, nil, nil, nil, ToyboxMod.ROOM_DEATHSACRIFICE_SUBTYPE)
        if(not newBossRoom) then return end
        local possibleRooms = level:FindValidRoomPlacementLocations(newBossRoom, level:GetDimension(), false, false)

        failSafe = failSafe-1
        
        while(#possibleRooms>0 and not finalRoom) do
            local idx = rng:RandomInt(#possibleRooms)+1
        
            finalRoom = level:TryPlaceRoom(newBossRoom, possibleRooms[idx], level:GetDimension(), 0, true, true, false)
            table.remove(possibleRooms, idx)
        end
    end

    if(finalRoom) then
        level:UpdateVisibility()
        if(MinimapAPI) then
            MinimapAPI:CheckForNewRedRooms()
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, tryPlaceNewSacrificeRoom)

---@param num integer
---@param pos Vector
---@param rng RNG
local function spawnReward(num, pos, rng)
    if(num%4==0) then num = 4 end
    local chosen = REWARD_RESULTS[math.min(num, #REWARD_RESULTS)]

    if(chosen==-1) then
        for i=0, ToyboxMod.GAME:GetNumPlayers()-1 do
            local pl = Isaac.GetPlayer(i)
            if(pl:HasCollectible(ToyboxMod.COLLECTIBLE_CIMI_DEATH)) then
                local data = ToyboxMod:getEntityDataTable(pl)

                local stat = PICKER_TO_STAT[rng:RandomInt(1,#PICKER_TO_STAT)]
                data.CIMI_STATS = data.CIMI_STATS or {}
                data.CIMI_STATS[stat] = (data.CIMI_STATS[stat] or 0)+STAT_BONUSES[stat]

                pl:AddCacheFlags(CacheFlag.CACHE_ALL)
                pl:EvaluateItems()

                pl:CreateAfterimage(10, pl.Position)
            end
        end

        sfx:Play(SoundEffect.SOUND_THUMBSUP)

        return
    end

    local maxWeight = 0
    for _, outcome in ipairs(chosen) do
        maxWeight = maxWeight+outcome[1]
    end
    local chosenWeight = rng:RandomFloat()*maxWeight
    local cumulWeight = 0
    for _, outcome in ipairs(chosen) do
        cumulWeight = cumulWeight+outcome[1]
        if(cumulWeight>chosenWeight) then
            local res = outcome[2]
            if(type(outcome[2])=="function") then
                res = outcome[2](rng, pos)
            end

            local room = ToyboxMod.GAME:GetRoom()
            if(res and type(res)=="table") then
                for _, pickupdata in ipairs(res) do
                    local fpos = room:FindFreePickupSpawnPosition(pos)
                    local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, pickupdata[1] or 0, pickupdata[2] or 0,fpos,Vector.Zero,nil)
                end
            end

            break
        end
    end
end

---@param player EntityPlayer
---@param flag CacheFlag
local function evalCache(_, player, flag)
    if(not player:HasCollectible(ToyboxMod.COLLECTIBLE_CIMI_DEATH)) then return end

    local statTable = ToyboxMod:getEntityData(player, "CIMI_STATS") or {}

    if(flag==CacheFlag.CACHE_SPEED) then
        player.MoveSpeed = player.MoveSpeed+(statTable.SPEED or 0)
    elseif(flag==CacheFlag.CACHE_RANGE) then
        player.TearRange = player.TearRange+(statTable.RANGE or 0)*40
    elseif(flag==CacheFlag.CACHE_SHOTSPEED) then
        player.ShotSpeed = player.ShotSpeed+(statTable.SHOTSPEED or 0)
    elseif(flag==CacheFlag.CACHE_LUCK) then
        player.Luck = player.Luck+(statTable.LUCK or 0)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evalCache)

---@param pl EntityPlayer
---@param val number
local function evalStat(_, pl, stat, val)
    if(not (stat==EvaluateStatStage.TEARS_UP or stat==EvaluateStatStage.DAMAGE_UP)) then return end
    if(not pl:HasCollectible(ToyboxMod.COLLECTIBLE_CIMI_DEATH)) then return end
    local statTable = ToyboxMod:getEntityData(pl, "CIMI_STATS") or {}

    if(stat==EvaluateStatStage.TEARS_UP) then
        return val+(statTable.TEARS or 0)
    elseif(stat==EvaluateStatStage.DAMAGE_UP) then
        return val+(statTable.DAMAGE or 0)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_EVALUATE_STAT, evalStat)

local function replaceSpikesOnEntry(_, type, var, vardata, idx, seed)
    if(not (PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_CIMI_DEATH) and Game():GetRoom():GetType()==RoomType.ROOM_SACRIFICE)) then return end

    return {GridEntityType.GRID_SPIKES_ONOFF, 0, 0, seed}
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_ROOM_GRID_ENTITY_SPAWN, replaceSpikesOnEntry, GridEntityType.GRID_SPIKES)

---@param gridEnt GridEntity
---@param ent Entity
---@param amount integer
---@param flags DamageFlag
---@param amount2 number
---@param ignoreClass boolean
local function markForTookDamage(_, gridEnt, ent, amount, flags, amount2, ignoreClass)
    if(not (PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_CIMI_DEATH) and Game():GetRoom():GetType()==RoomType.ROOM_SACRIFICE)) then return end

    local pl = ent and ent:ToPlayer()
    if(pl and pl:GetDamageCooldown()==0 and not pl:IsInvincible()) then
        local worked = pl:TakeDamage(amount, flags | DamageFlag.DAMAGE_RED_HEARTS, EntityRef(nil), 0)
        if(worked) then
            gridEnt.VarData = gridEnt.VarData+1

            local randPl = PlayerManager.GetRandomCollectibleOwner(ToyboxMod.COLLECTIBLE_CIMI_DEATH, gridEnt:GetSaveState().VariableSeed)
            spawnReward(gridEnt.VarData, gridEnt.Position, randPl:GetCollectibleRNG(ToyboxMod.COLLECTIBLE_CIMI_DEATH))
        end

        return false
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_GRID_HURT_DAMAGE, CallbackPriority.LATE+100, markForTookDamage, GridEntityType.GRID_SPIKES_ONOFF)

---@param spike GridEntitySpikes
local function spikesUpdate(_, spike)
    if(not (PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_CIMI_DEATH) and Game():GetRoom():GetType()==RoomType.ROOM_SACRIFICE)) then return end

    spike.State = 0
    spike:GetSprite():SetFrame("Summon", spike:GetSprite():GetAnimationData("Summon"):GetLength()-1)
    spike:SetVariant(0)
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_POST_GRID_ENTITY_SPIKES_UPDATE, CallbackPriority.IMPORTANT, spikesUpdate, GridEntityType.GRID_SPIKES_ONOFF)


-- ROOM VARIANT SPECIFIC STUFF

local DEATHSACRIFICE_COLOR_MOD = ColorModifier(2,0.5,0.5,0.25,0,1.05)

-- replace backdrop
local function replaceBackdrop()
    local desc = ToyboxMod.GAME:GetLevel():GetCurrentRoomDesc()
    if(desc.Data and desc.Data.Type==RoomType.ROOM_SACRIFICE and desc.Data.Subtype==ToyboxMod.ROOM_DEATHSACRIFICE_SUBTYPE) then
        return ToyboxMod.BACKDROP_DEATH_SACRIFICE
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_PRE_BACKDROP_CHANGE, CallbackPriority.IMPORTANT, replaceBackdrop)

local function setColorModifier(_)
    local desc = ToyboxMod.GAME:GetLevel():GetCurrentRoomDesc()
    if(not (desc.Data and desc.Data.Type==RoomType.ROOM_SACRIFICE and desc.Data.Subtype==ToyboxMod.ROOM_DEATHSACRIFICE_SUBTYPE)) then return end

    ToyboxMod.GAME:SetColorModifier(DEATHSACRIFICE_COLOR_MOD,true,0.1)
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_ROOM, CallbackPriority.IMPORTANT, setColorModifier)

---@param spike GridEntitySpikes
local function spikesUpdate(_, spike)
    local desc = ToyboxMod.GAME:GetLevel():GetCurrentRoomDesc()
    if(not (desc.Data and desc.Data.Type==RoomType.ROOM_SACRIFICE and desc.Data.Subtype==ToyboxMod.ROOM_DEATHSACRIFICE_SUBTYPE)) then return end

    if(ToyboxMod.GAME:GetRoom():GetFrameCount()%4==0 and math.random()<0.85) then
        local pos = spike.Position+Vector(math.random()*2-1, math.random()*2-1)*40
        local drop = Isaac.Spawn(1000,135,0,pos,Vector.Zero,nil):ToEffect()
        drop.Color = Color(0,0,0,1,0.75,0.1,0.15)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_GRID_ENTITY_SPIKES_UPDATE, spikesUpdate)