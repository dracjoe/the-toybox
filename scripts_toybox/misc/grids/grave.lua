local POSSIBLE_ENEMIES = {
    {EntityType.ENTITY_HOST,0,0, 20}, -- host
    {EntityType.ENTITY_BONY,0,0, 20}, -- bony
    {EntityType.ENTITY_NECRO,0,0, 1}, -- necro
    {EntityType.ENTITY_WIZOOB,0,0, 10}, -- wizoob
    {EntityType.ENTITY_THE_HAUNT,10,0, 5}, -- lil haunt
    {EntityType.ENTITY_POLTY,0,0, 1}, -- polty
    {EntityType.ENTITY_DUST,0,0, 1}, -- dust
    {EntityType.ENTITY_GAPER,3,0, 5}, -- rotten gaper
    {EntityType.ENTITY_CHARGER,0,0, 10}, -- charger
    {EntityType.ENTITY_SPITTY,0,0, 1}, -- spitty
    {EntityType.ENTITY_BIG_BONY,0,0, 1}, -- big bony
    {EntityType.ENTITY_FLOATING_KNIGHT,0,0, 1}, -- floating knight
    {EntityType.ENTITY_KNIGHT,0,0, 5}, -- knight
    {EntityType.ENTITY_SMALL_MAGGOT,0,0, 10}, -- small maggot
}
local RANDOM_ENEMY_PICKER = WeightedOutcomePicker()
for i, data in ipairs(POSSIBLE_ENEMIES) do
    RANDOM_ENEMY_PICKER:AddOutcomeWeight(i, data[4] or 1)
end

local PICKUP_PICKER = WeightedOutcomePicker()
PICKUP_PICKER:AddOutcomeWeight(1, 15) -- nothing
PICKUP_PICKER:AddOutcomeWeight(2, 3)  -- bone heart
PICKUP_PICKER:AddOutcomeWeight(3, 4)  -- blue spiders
PICKUP_PICKER:AddOutcomeWeight(4, 1)  -- maggots
PICKUP_PICKER:AddOutcomeWeight(5, 3)  -- bone spurs

---@param effect EntityEffect
local function replaceHelper(_, effect)
    if(effect.SubType>=ToyboxMod.GRID_GRAVE_EMPTY and effect.SubType<=ToyboxMod.GRID_GRAVE_RANDOM+#POSSIBLE_ENEMIES) then
        effect.Visible = false
        local room = ToyboxMod.GAME:GetRoom()
        local idx = room:GetGridIndex(effect.Position)

        room:RemoveGridEntityImmediate(idx, 0, false)
        local worked = room:SpawnGridEntity(idx, GridEntityType.GRID_ROCK, 0, effect.InitSeed)
        if(worked) then
            local rock = room:GetGridEntity(idx)
            if(rock) then
                local data = ToyboxMod:getGridEntityDataTable(rock)
                data.GRAVE_SUB = effect.SubType
                rock:Init(rock.Desc.SpawnSeed)
            end
        end
        effect:Remove()
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, replaceHelper, ToyboxMod.EFFECT_GRID_HELPER)

local didShutDoors = true
local function postNewRoom(_)
    didShutDoors = false
    for _, ent in ipairs(Isaac.GetRoomEntities()) do
        if(ent:CanShutDoors()) then
            didShutDoors = true
            return
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, postNewRoom)

local function keepDoorsClosed(_)
    local room = ToyboxMod.GAME:GetRoom()
    local enemyShutDoors = false
    for _, ent in ipairs(Isaac.GetRoomEntities()) do
        if(ent:CanShutDoors()) then
            enemyShutDoors = true
        end
    end

    local shouldCloseDoors = false

    for i=0, room:GetGridSize() do
        local ent = room:GetGridEntity(i)
        if(ent and ent:IsBreakableRock() and ent.State~=2 and ToyboxMod:getGridEntityData(ent, "GRAVE_SUB") and ToyboxMod:getGridEntityData(ent, "GRAVE_SUB")>ToyboxMod.GRID_GRAVE_EMPTY) then
            if(didShutDoors and not enemyShutDoors and not ToyboxMod:getGridEntityData(ent, "ALREADY_QUEUE_FOR_DESTROY")) then
                ToyboxMod:setGridEntityData(ent, "ALREADY_QUEUE_FOR_DESTROY", true)
                Isaac.CreateTimer(function ()
                    if(ent) then
                        ToyboxMod:setGridEntityData(ent, "GRAVE_NO_PICKUPS", true)
                        ent:Destroy(true)
                    end
                end, math.random(1,7)*2, 1, false)
            end

            if(ToyboxMod:getGridEntityData(ent, "ALREADY_QUEUE_FOR_DESTROY") and ToyboxMod:getGridEntityData(ent, "GRAVE_SUB")>ToyboxMod.GRID_GRAVE_EMPTY) then
                shouldCloseDoors = true
            end
        end
    end

    if(shouldCloseDoors and not enemyShutDoors) then
        room:KeepDoorsClosed()
    end

    didShutDoors = enemyShutDoors
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_UPDATE, keepDoorsClosed)

---@param ent GridEntity
local function switchBlockInit(_, ent, _, _)
    if(not ToyboxMod:getGridEntityData(ent, "GRAVE_SUB")) then return end

    local sp = ent:GetSprite()
    sp:Load("gfx_tb/grid/grid_tombstone.anm2", true)
    if(ToyboxMod:getGridEntityData(ent, "GRAVE_SUB")>ToyboxMod.GRID_GRAVE_EMPTY) then
        sp:ReplaceSpritesheet(0, "gfx_tb/grid/grid_tombstone_danger.png", true)
    end
    sp:Play("normal", true)
    sp:SetFrame(ent:GetSaveState().SpawnSeed%sp:GetCurrentAnimationData():GetLength())

    if(ent:ToRock()) then
        ent:ToRock():UpdateCollision()
        ent:ToRock():UpdateNeighbors()
    end
end
ToyboxMod:AddCallback(ToyboxMod.CUSTOM_CALLBACKS.POST_GRID_INIT, switchBlockInit, GridEntityType.GRID_ROCK)

---@param ent GridEntityPressurePlate
local function graveUpdate(_, ent)
    if(not ToyboxMod:getGridEntityData(ent, "GRAVE_SUB")) then return end

    return false
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_GRID_ENTITY_ROCK_UPDATE, graveUpdate, GridEntityType.GRID_ROCK)

---@param rock GridEntityRock
---@param type GridEntityType
---@param immediate boolean
local function graveDestroy(_, rock, type, immediate)
    if(not ToyboxMod:getGridEntityData(rock, "GRAVE_SUB")) then return end

    local sub = ToyboxMod:getGridEntityData(rock, "GRAVE_SUB")
    local rng = ToyboxMod:generateRng(rock:GetSaveState().SpawnSeed) ---@type RNG

    if(sub~=ToyboxMod.GRID_GRAVE_EMPTY) then
        local enemyToSpawn = sub-ToyboxMod.GRID_GRAVE_RANDOM
        if(sub==ToyboxMod.GRID_GRAVE_RANDOM) then
            enemyToSpawn = RANDOM_ENEMY_PICKER:PickOutcome(rng)
        end
        enemyToSpawn = POSSIBLE_ENEMIES[enemyToSpawn]

        if(enemyToSpawn[1]==EntityType.ENTITY_SMALL_MAGGOT) then
            local vel = rng:RandomVector()
            local ent = EntityNPC.ThrowMaggot(rock.Position, vel*4*(0.25+math.random()*0.75), rng:RandomFloat()*3-1)
            ent:Update()
        else
            local ent = Isaac.Spawn(enemyToSpawn[1], enemyToSpawn[2], enemyToSpawn[3], rock.Position, Vector.Zero, nil)
            ent:Update()
        end
    end

    if(ToyboxMod:getGridEntityData(rock, "GRAVE_NO_PICKUPS")) then return end

    local res = PICKUP_PICKER:PickOutcome(rng)
    if(res==2) then
        local vel = rng:RandomVector()
        local heart = Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_HEART,HeartSubType.HEART_BONE,rock.Position,vel*2,nil)
    elseif(res==3) then
        local numtospawn = rng:RandomInt(1,2)
        for _=1,numtospawn do
            local vel = rng:RandomVector()
            Isaac.GetPlayer():ThrowBlueSpider(rock.Position, rock.Position+vel*40*(0.7+math.random()*0.3))
        end
    elseif(res==4) then
        local numtospawn = rng:RandomInt(1,3)
        for _=1,numtospawn do
            local vel = rng:RandomVector()
            EntityNPC.ThrowMaggot(rock.Position, vel*4*(0.25+math.random()*0.75), rng:RandomFloat()*3-1)
        end
    elseif(res==5) then
        local numtospawn = rng:RandomInt(1,2)
        for _=1,numtospawn do
            Isaac.GetPlayer():AddBoneOrbital(rock.Position)
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_GRID_ROCK_DESTROY, graveDestroy, GridEntityType.GRID_ROCK)

local function triggerGraveAmbush()
    local roomdat = ToyboxMod.GAME:GetLevel():GetCurrentRoomDesc().Data
    if(roomdat and roomdat.Type==ToyboxMod.SPECIAL_ROOM_TYPE_TEMPLATE and roomdat.Subtype==ToyboxMod.ROOM_TYPE_DATA.GRAVEYARD_ROOM.Id) then
        local room = ToyboxMod.GAME:GetRoom()
        local shouldCloseDoors = false

        for i=0, room:GetGridSize() do
            local ent = room:GetGridEntity(i)
            if(ent and ent:IsBreakableRock() and ent.State~=2 and ToyboxMod:getGridEntityData(ent, "GRAVE_SUB") and ToyboxMod:getGridEntityData(ent, "GRAVE_SUB")>ToyboxMod.GRID_GRAVE_EMPTY) then
                ToyboxMod:setGridEntityData(ent, "GRAVE_NO_PICKUPS", true)
                if(not ToyboxMod:getGridEntityData(ent, "ALREADY_QUEUE_FOR_DESTROY")) then
                    ToyboxMod:setGridEntityData(ent, "ALREADY_QUEUE_FOR_DESTROY", true)
                    Isaac.CreateTimer(function ()
                        if(ent) then
                            ent:Destroy(true)
                        end
                    end, math.random(1, 7)*2+15, 1, false)
                end

                if(ToyboxMod:getGridEntityData(ent, "GRAVE_SUB")>ToyboxMod.GRID_GRAVE_EMPTY) then
                    shouldCloseDoors = true
                end
            end
        end

        if(shouldCloseDoors) then
            ToyboxMod.GAME:ShakeScreen(20)

            room:SetClear(false)
            for _, i in pairs(DoorSlot) do
                if(room:GetDoor(i)) then
                    room:GetDoor(i):Close(true)
                end
            end
            room:KeepDoorsClosed()
        end
    end
end

local function getItemInGraveyard(_, _, _, firstTime)
    if(not firstTime) then return end

    triggerGraveAmbush()
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, getItemInGraveyard)

---@param pickup EntityPickup
---@param coll Entity
local function prePedestalCollection(_, pickup, coll, low)
    if(coll and coll:ToPlayer()) then
        local pl = coll:ToPlayer()
        if(pl:IsItemQueueEmpty() and pickup.SubType~=0) then
            ToyboxMod:setEntityData(pickup, "WAIT_FOR_QUEUE", true)
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, prePedestalCollection, PickupVariant.PICKUP_COLLECTIBLE)

---@param pickup EntityPickup
---@param coll Entity
local function postPedestalCollection(_, pickup, coll, low)
    if(coll and coll:ToPlayer()) then
        local pl = coll:ToPlayer()
        if(ToyboxMod:getEntityData(pickup, "WAIT_FOR_QUEUE") and not pl:IsItemQueueEmpty()) then
            triggerGraveAmbush()
        end
        ToyboxMod:setEntityData(pickup, "WAIT_FOR_QUEUE", nil)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, postPedestalCollection, PickupVariant.PICKUP_COLLECTIBLE)

local previousData = {}

---@param pickup EntityPickup
local function transferMorphData(_, pickup, t,v,s, keepPrice, keepSeed, keepModifiers)
    if(pickup.Variant~=PickupVariant.PICKUP_COLLECTIBLE) then return end
    previousData[tostring(t)..tostring(v)..tostring(s)] = ToyboxMod:getEntityData(pickup, "WAIT_FOR_QUEUE")
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_PRE_PICKUP_MORPH, CallbackPriority.LATE+1, transferMorphData)

---@param pickup EntityPickup
local function receiveMorphData(_, pickup, t,v,s, keepPrice, keepSeed, keepModifiers)
    if(pickup.Variant~=PickupVariant.PICKUP_COLLECTIBLE) then return end
    local str = tostring(pickup.Type)..tostring(pickup.Variant)..tostring(pickup.SubType)
    if(previousData[str]) then
        ToyboxMod:setEntityData(pickup, "WAIT_FOR_QUEUE", previousData[str])
    end
    previousData[str] = nil
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_POST_PICKUP_MORPH, CallbackPriority.LATE+1, receiveMorphData)