local UPGRADED_VARIANTS = {
    [RoomType.ROOM_TREASURE] = function(sub, rng)
        if(sub==0) then
            return rng:RandomInt(1,2)
        elseif(sub<3) then
            return 3
        end
    end,
    [RoomType.ROOM_SHOP] = function(sub, rng)
        if(sub>=100) then return end

        if(sub==11) then sub = rng:RandomInt(0,4) end
        if(sub<=4 or sub==10) then
            return sub+100
        end
    end,
    [RoomType.ROOM_CURSE] = 1,
    [RoomType.ROOM_ARCADE] = 1,
    [RoomType.ROOM_DEVIL] = 1,
    [RoomType.ROOM_MINIBOSS] = function(sub, rng)
        if(sub>=0 and sub<7) then
            return sub+7
        end
    end,
    [RoomType.ROOM_SACRIFICE] = 10,
    --[RoomType.ROOM_ANGEL] = 1, -- makes angel stairways but idk
}

ToyboxMod:addCustomRoomIcon("ToyboxAhauFlowerUpgrade",
    function(room)
        if(not UPGRADED_VARIANTS[room.Type]) then return end

        local desc = room.Descriptor
        if((ToyboxMod:getExtraData("AHAU_ROOM_UPGR") or {})[tostring(desc.SafeGridIndex)]) then
            return true
        else
            local maxNum = PlayerManager.GetNumCollectibles(ToyboxMod.COLLECTIBLE_AHAU_FLOWER)
            if((ToyboxMod:getExtraData("AHAU_TRIGGERED") or 0)<maxNum and (desc.VisitedCount==0)) then
                if(((ToyboxMod:getExtraData("AHAU_ROOM_SUBS") or {})[tostring(desc.SafeGridIndex)] or {}).SubType~=-1) then
                    return true
                end
            end
        end

        return false
    end,
    true
)

---@param roomIdx integer
---@param rng RNG
local function getRoomSubtype(roomIdx, rng)
    local desc = ToyboxMod.GAME:GetLevel():GetRoomByIdx(roomIdx, Dimension.NORMAL)
    if(not desc.Data) then return end
    if(desc.VisitedCount>0) then return -1 end

    if(((ToyboxMod:getExtraData("AHAU_ROOM_SUBS") or {})[tostring(roomIdx)] or {}).Type==desc.Data.Type) then return end

    if(UPGRADED_VARIANTS[desc.Data.Type]) then
        local upgrIdx = -1
        if(type(UPGRADED_VARIANTS[desc.Data.Type])=="function") then
            upgrIdx = UPGRADED_VARIANTS[desc.Data.Type](desc.Data.Subtype, rng) or -1
        else
            if(desc.Data.Subtype<UPGRADED_VARIANTS[desc.Data.Type]) then
                upgrIdx = UPGRADED_VARIANTS[desc.Data.Type]
            end
        end

        if(upgrIdx~=-1) then
            local roomset = RoomConfig.GetStage(StbType.SPECIAL_ROOMS):GetRoomSet(desc.Data.Mode)
            for i=0, #roomset-1 do
                local checkroom = roomset:Get(i)
                if(checkroom.Type==desc.Data.Type and checkroom.Subtype==upgrIdx) then
                    if(checkroom.Shape==desc.Data.Shape and (checkroom.Doors & desc.AllowedDoors == desc.AllowedDoors)) then
                        return upgrIdx, desc.Data.Type
                    end
                end
            end
        end
    end

    return -1, -1
end

local function markRoomSubtypes(_)
    if(not ToyboxMod.GAME:GetRoom():IsFirstVisit()) then return end
    --if(ToyboxMod:getExtraData("AHAU_LEVEL_CHECK")==ToyboxMod.GAME:GetLevel():GetDungeonPlacementSeed()) then return end

    local data = ToyboxMod:getExtraDataTable()

    data.AHAU_TRIGGERED = 0
    data.AHAU_ROOM_SUBS = {}
    data.AHAU_ROOM_UPGR = {}

    if(not PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_AHAU_FLOWER)) then return end
    data.AHAU_LEVEL_CHECK = ToyboxMod.GAME:GetLevel():GetDungeonPlacementSeed()

    local pl = PlayerManager.GetRandomCollectibleOwner(ToyboxMod.COLLECTIBLE_AHAU_FLOWER, ToyboxMod.GAME:GetLevel():GetDungeonPlacementSeed())
    local rng = pl:GetCollectibleRNG(ToyboxMod.COLLECTIBLE_AHAU_FLOWER)

    for i=0, 13^2-1 do
        local sub, type = getRoomSubtype(i, rng)
        if(sub) then
            data.AHAU_ROOM_SUBS[tostring(i)] = {SubType=sub, Type=type}
        end
    end

    ToyboxMod.GAME:GetLevel():UpdateVisibility()
    if(MinimapAPI) then
        MinimapAPI:CheckForNewRedRooms()
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_LEVEL, CallbackPriority.LATE, markRoomSubtypes)

---@param door GridEntityDoor
local function trySpawnFlowersAtDoor(door)
    if(not door) then return end

    local data = ToyboxMod:getExtraDataTable()

    local shouldSpawnFlowers = false
    if((data.AHAU_ROOM_UPGR or {})[tostring(door.TargetRoomIndex)]) then
        shouldSpawnFlowers = true
    else
        local maxNum = PlayerManager.GetNumCollectibles(ToyboxMod.COLLECTIBLE_AHAU_FLOWER)
        if((data.AHAU_TRIGGERED or 0)<maxNum and (ToyboxMod.GAME:GetLevel():GetRoomByIdx(door.TargetRoomIndex).VisitedCount==0)) then
            if((((data.AHAU_ROOM_SUBS or {})[tostring(door.TargetRoomIndex)] or {}).SubType or -1)~=-1) then
                shouldSpawnFlowers = true
            end
        end
    end

    if(shouldSpawnFlowers) then
        local pos = ToyboxMod.GAME:GetRoom():GetClampedPosition(door.Position, 20)
        local flowers = Isaac.Spawn(1000, ToyboxMod.EFFECT_FLOWER_PATCH, 0, pos, Vector.Zero, nil):ToEffect()
    else
        local flowers = Isaac.FindByType(1000, ToyboxMod.EFFECT_FLOWER_PATCH, 0)[1]
        if(flowers) then
            flowers:Remove()
        end
    end
end

---@param first boolean
---@param pl EntityPlayer
local function onPickupStuff(_, _, _, first, _, _, pl)
    if(first and pl:GetCollectibleNum(ToyboxMod.COLLECTIBLE_AHAU_FLOWER)==1) then
        markRoomSubtypes()

        local room = ToyboxMod.GAME:GetRoom()
        for _, slot in pairs(DoorSlot) do
            local door = room:GetDoor(slot)
            trySpawnFlowersAtDoor(door)
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, onPickupStuff, ToyboxMod.COLLECTIBLE_AHAU_FLOWER)

---@param ent GridEntity
local function tryGetSubtype(_, ent)
    local door = ent:ToDoor()

    local data = ToyboxMod:getExtraDataTable()

    markRoomSubtypes()

    local idx, type = getRoomSubtype(door.TargetRoomIndex, door:GetRNG())
    if(idx) then
        data.AHAU_ROOM_SUBS = data.AHAU_ROOM_SUBS or {}
        data.AHAU_ROOM_SUBS[tostring(door.TargetRoomIndex)] = {SubType=idx, Type=type}
    end

    trySpawnFlowersAtDoor(door)
end
ToyboxMod:AddCallback(ToyboxMod.CUSTOM_CALLBACKS.POST_GRID_INIT, tryGetSubtype, GridEntityType.GRID_DOOR)

local function tryUpgradeRoom(_, roomidx, dim)
    if(not PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_AHAU_FLOWER)) then return end

    local data = ToyboxMod:getExtraDataTable()
    local desc = ToyboxMod.GAME:GetLevel():GetRoomByIdx(roomidx, dim)

    local pl = PlayerManager.GetRandomCollectibleOwner(ToyboxMod.COLLECTIBLE_AHAU_FLOWER, desc.SpawnSeed)
    local rng = pl:GetCollectibleRNG(ToyboxMod.COLLECTIBLE_AHAU_FLOWER)

    data.AHAU_ROOM_SUBS = data.AHAU_ROOM_SUBS or {}
    local subData = data.AHAU_ROOM_SUBS[tostring(roomidx)] or {SubType=-1, Type=-1}
    if(subData==nil) then
        subData, type = getRoomSubtype(roomidx, rng)
        data.AHAU_ROOM_SUBS[tostring(roomidx)] = {SubType=subData, Type=type}
    end

    if((subData.SubType or -1)~=-1) then
        local maxNum = PlayerManager.GetNumCollectibles(ToyboxMod.COLLECTIBLE_AHAU_FLOWER)
        if(desc.VisitedCount==0 and (data.AHAU_TRIGGERED or 0)<maxNum) then
            local newRoom = RoomConfig.GetRandomRoom(rng:Next(), false, StbType.SPECIAL_ROOMS, desc.Data.Type, desc.Data.Shape, nil, nil, nil, nil, desc.AllowedDoors, subData.SubType)
            if(newRoom) then
                desc.OverrideData = desc.Data
                desc.Data = newRoom
            end

            data.AHAU_TRIGGERED = (data.AHAU_TRIGGERED or 0)+1

            data.AHAU_ROOM_UPGR = data.AHAU_ROOM_UPGR or {}
            data.AHAU_ROOM_UPGR[tostring(roomidx)] = true
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_CHANGE_ROOM, tryUpgradeRoom)

local function spawnFlowersInUpgradedRoom()
    local idx = ToyboxMod.GAME:GetLevel():GetCurrentRoomIndex()
    if((ToyboxMod:getExtraData("AHAU_ROOM_UPGR") or {})[tostring(idx)]) then
        local room = ToyboxMod.GAME:GetRoom()
        local rng = ToyboxMod:generateRng(room:GetDecorationSeed())

        local possibleIndexes = {}
        for i=0, room:GetGridSize()-1 do
            if(not room:GetGridEntity(i) and room:IsPositionInRoom(room:GetGridPosition(i), 0)) then
                table.insert(possibleIndexes, i)
            end
        end

        local finalAmount = math.min(10, #possibleIndexes//8)
        while(#possibleIndexes>finalAmount) do
            table.remove(possibleIndexes, rng:RandomInt(1,#possibleIndexes))
        end

        for _, i in ipairs(possibleIndexes) do
            local pos = room:GetGridPosition(i)

            local eff = Isaac.Spawn(1000, ToyboxMod.EFFECT_FLOWER_PATCH, 0, pos, Vector.Zero, nil):ToEffect()
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, spawnFlowersInUpgradedRoom)



---@param effect EntityEffect
local function flowerPatchInit(_, effect)
    local sp = effect:GetSprite()

    sp:Play("Idle", true)
    sp:SetFrame(math.random(sp:GetCurrentAnimationData():GetLength())-1)
    sp:Stop()

    effect.DepthOffset = -1000
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, flowerPatchInit, ToyboxMod.EFFECT_FLOWER_PATCH)

---@param effect EntityEffect
local function flowerPatchUpdate(_, effect)
    local room = ToyboxMod.GAME:GetRoom()
    if(room:GetGridEntity(room:GetGridIndex(effect.Position))) then
        effect:Remove()
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, flowerPatchUpdate, ToyboxMod.EFFECT_FLOWER_PATCH)