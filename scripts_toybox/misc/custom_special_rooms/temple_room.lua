local sfx = SFXManager()

local TEMPLE_ROOM_COUNT = 3
local TEMPLE_CHANCE = 0.05

local TEMPLE_GROUP = RoomDescriptor.CreateGroup("TempleTrialRooms")

---@param rng RNG
local function shouldMakeTemple(rng)
    return rng:RandomFloat()<TEMPLE_CHANCE
end

ToyboxMod:addCustomRoomIcon(
    "ToyboxTempleTrialRoom",
    function(room)
        if(room.Type ~= RoomType.ROOM_DEFAULT) then return end

        local templeExtraData = ToyboxMod:getExtraData("TEMPLE_TRIAL_ROOMS") or {}
        if(room.Descriptor and templeExtraData[tostring(room.Descriptor.SafeGridIndex)] and not room.Descriptor.Clear) then
            return true
        end
        return false
    end
)
ToyboxMod:addCustomRoomIcon(
    "ToyboxTempleTrialRoomInactive",
    function(room)
        if(room.Type ~= RoomType.ROOM_DEFAULT) then return end

        local templeExtraData = ToyboxMod:getExtraData("TEMPLE_TRIAL_ROOMS") or {}
        if(room.Descriptor and templeExtraData[tostring(room.Descriptor.SafeGridIndex)] and room.Descriptor.Clear) then
            return true
        end
        return false
    end
)

local COMBAT_STATS = {
    "TEARS",
    "DAMAGE",
}
local OTHER_STATS = {
    "SPEED",
    "RANGE",
}

---@param stage LevelStage
local function getChapterFromStage(stage)
    if(stage<9) then
        return math.ceil(stage/2)
    end
    return stage-5
end

local CHAPTER_STBS = {
    [1] = {
        StbType.BASEMENT, StbType.CELLAR, StbType.BURNING_BASEMENT, StbType.DOWNPOUR, StbType.DROSS
    },
    [2] = {
        StbType.CAVES, StbType.CATACOMBS, StbType.FLOODED_CAVES, StbType.MINES, StbType.ASHPIT
    },
    [3] = {
        StbType.DEPTHS, StbType.NECROPOLIS, StbType.DANK_DEPTHS, StbType.MAUSOLEUM, StbType.GEHENNA
    },
    [4] = {
        StbType.WOMB, StbType.UTERO, StbType.SCARRED_WOMB, StbType.CORPSE
    },
    [5] = {
        StbType.SHEOL, StbType.CATHEDRAL
    },
    [6] = {
        StbType.DARK_ROOM, StbType.CHEST
    },
}
local CHAPTER_BACKDROPS = {
    [1] = {
        BackdropType.BASEMENT, BackdropType.CELLAR, BackdropType.BURNT_BASEMENT, BackdropType.DOWNPOUR, BackdropType.DROSS
    },
    [2] = {
        BackdropType.CAVES, BackdropType.CATACOMBS, BackdropType.FLOODED_CAVES, BackdropType.MINES, BackdropType.ASHPIT
    },
    [3] = {
        BackdropType.DEPTHS, BackdropType.NECROPOLIS, BackdropType.DANK_DEPTHS, BackdropType.MAUSOLEUM, BackdropType.GEHENNA
    },
    [4] = {
        BackdropType.WOMB, BackdropType.UTERO, BackdropType.SCARRED_WOMB, BackdropType.CORPSE
    },
    [5] = {
        BackdropType.SHEOL, BackdropType.CATHEDRAL
    },
    [6] = {
        BackdropType.DARKROOM, BackdropType.CHEST
    },
}

local DOORSLOT_DIR = {
    [DoorSlot.LEFT0] = Vector(-1,0),
    [DoorSlot.UP0] = Vector(0,-1),
    [DoorSlot.RIGHT0] = Vector(1,0),
    [DoorSlot.DOWN0] = Vector(0,1),
    [DoorSlot.LEFT1] = Vector(-1,0),
    [DoorSlot.UP1] = Vector(0,-1),
    [DoorSlot.RIGHT1] = Vector(1,0),
    [DoorSlot.DOWN1] = Vector(0,1),
}

local ROOMSHAPE_DOORSLOT_POS = {
    [RoomShape.ROOMSHAPE_1x1] = {
        [DoorSlot.LEFT0] = Vector(0,0), [DoorSlot.UP0] = Vector(0,0), [DoorSlot.RIGHT0] = Vector(0,0), [DoorSlot.DOWN0] = Vector(0,0),
    },
    [RoomShape.ROOMSHAPE_IH] = {
        [DoorSlot.LEFT0] = Vector(0,0), [DoorSlot.UP0] = Vector(0,0), [DoorSlot.RIGHT0] = Vector(0,0), [DoorSlot.DOWN0] = Vector(0,0),
    },
    [RoomShape.ROOMSHAPE_IV] = {
        [DoorSlot.LEFT0] = Vector(0,0), [DoorSlot.UP0] = Vector(0,0), [DoorSlot.RIGHT0] = Vector(0,0), [DoorSlot.DOWN0] = Vector(0,0),
    },
    [RoomShape.ROOMSHAPE_1x2] = {
        [DoorSlot.LEFT0] = Vector(0,0), [DoorSlot.UP0] = Vector(0,0), [DoorSlot.RIGHT0] = Vector(0,0), [DoorSlot.DOWN0] = Vector(0,1),
        [DoorSlot.LEFT1] = Vector(0,1), [DoorSlot.RIGHT1] = Vector(0,1),
    },
    [RoomShape.ROOMSHAPE_IIV] = {
        [DoorSlot.LEFT0] = Vector(0,0), [DoorSlot.UP0] = Vector(0,0), [DoorSlot.RIGHT0] = Vector(0,0), [DoorSlot.DOWN0] = Vector(0,1),
        [DoorSlot.LEFT1] = Vector(0,1), [DoorSlot.RIGHT1] = Vector(0,1),
    },
    [RoomShape.ROOMSHAPE_2x1] = {
        [DoorSlot.LEFT0] = Vector(0,0), [DoorSlot.UP0] = Vector(0,0), [DoorSlot.RIGHT0] = Vector(1,0), [DoorSlot.DOWN0] = Vector(0,0),
        [DoorSlot.UP1] = Vector(1,0), [DoorSlot.DOWN1] = Vector(1,0),
    },
    [RoomShape.ROOMSHAPE_IIH] = {
        [DoorSlot.LEFT0] = Vector(0,0), [DoorSlot.UP0] = Vector(0,0), [DoorSlot.RIGHT0] = Vector(1,0), [DoorSlot.DOWN0] = Vector(0,0),
        [DoorSlot.UP1] = Vector(1,0), [DoorSlot.DOWN1] = Vector(1,0),
    },
    [RoomShape.ROOMSHAPE_2x2] = {
        [DoorSlot.LEFT0] = Vector(0,0), [DoorSlot.UP0] = Vector(0,0), [DoorSlot.RIGHT0] = Vector(1,0), [DoorSlot.DOWN0] = Vector(0,1),
        [DoorSlot.LEFT1] = Vector(0,1), [DoorSlot.UP1] = Vector(1,0), [DoorSlot.RIGHT1] = Vector(1,1), [DoorSlot.DOWN1] = Vector(1,1),
    },
    [RoomShape.ROOMSHAPE_LTL] = {
        [DoorSlot.LEFT0] = Vector(1,0), [DoorSlot.UP0] = Vector(0,1), [DoorSlot.RIGHT0] = Vector(1,0), [DoorSlot.DOWN0] = Vector(0,1),
        [DoorSlot.LEFT1] = Vector(0,1), [DoorSlot.UP1] = Vector(1,0), [DoorSlot.RIGHT1] = Vector(1,1), [DoorSlot.DOWN1] = Vector(1,1),
    },
    [RoomShape.ROOMSHAPE_LTR] = {
        [DoorSlot.LEFT0] = Vector(0,0), [DoorSlot.UP0] = Vector(0,0), [DoorSlot.RIGHT0] = Vector(0,0), [DoorSlot.DOWN0] = Vector(0,1),
        [DoorSlot.LEFT1] = Vector(0,1), [DoorSlot.UP1] = Vector(1,1), [DoorSlot.RIGHT1] = Vector(1,1), [DoorSlot.DOWN1] = Vector(1,1),
    },
    [RoomShape.ROOMSHAPE_LBL] = {
        [DoorSlot.LEFT0] = Vector(0,0), [DoorSlot.UP0] = Vector(0,0), [DoorSlot.RIGHT0] = Vector(1,0), [DoorSlot.DOWN0] = Vector(1,1),
        [DoorSlot.LEFT1] = Vector(1,1), [DoorSlot.UP1] = Vector(1,0), [DoorSlot.RIGHT1] = Vector(1,1), [DoorSlot.DOWN1] = Vector(1,1),
    },
    [RoomShape.ROOMSHAPE_LBR] = {
        [DoorSlot.LEFT0] = Vector(0,0), [DoorSlot.UP0] = Vector(0,0), [DoorSlot.RIGHT0] = Vector(1,0), [DoorSlot.DOWN0] = Vector(0,1),
        [DoorSlot.LEFT1] = Vector(0,1), [DoorSlot.UP1] = Vector(1,0), [DoorSlot.RIGHT1] = Vector(0,1), [DoorSlot.DOWN1] = Vector(1,0),
    },
}

local invalidSpawns = {
    [EntityType.ENTITY_POKY] = true,
    [EntityType.ENTITY_GRUDGE] = true,
}

---@param room RoomConfigRoom
---@param idx integer
---@return integer[]
local function getDoorSlotIndexes(room, idx)
    local doors = {}
    for _, slot in pairs(DoorSlot) do
        if(slot>=0 and slot<8 and (room.Doors & (1<<slot) ~= 0)) then
            local offs = ROOMSHAPE_DOORSLOT_POS[room.Shape][slot]+DOORSLOT_DIR[slot]
            local pos = Vector(idx%13+offs.X, idx//13+offs.Y)
            if(pos.X>=0 and pos.X<13 and pos.Y>=0 and pos.Y<13) then
                doors[slot] = pos.X+pos.Y*13
            end
        end
    end

    return doors
end

---@param room RoomConfigRoom
---@param vectorPos Vector
---@param unplacedRooms {roomData: RoomConfigRoom, index: integer}[]
local function canPlaceRoomAtIndex(room, vectorPos, unplacedRooms)
    if(vectorPos.X<0 or vectorPos.Y<0) then return false end
    if((vectorPos.X+room.Width//13)>13 or (vectorPos.Y+room.Height//7)>13) then return false end
    
    local level = ToyboxMod.GAME:GetLevel()
    local doors = getDoorSlotIndexes(room, vectorPos.X+vectorPos.Y*13)

    local validCorners = {}
    for _, offs in pairs(ROOMSHAPE_DOORSLOT_POS[room.Shape]) do
        if(not validCorners[offs.X*10+offs.Y]) then
            local p = vectorPos+offs
            local idx = p.X+p.Y*13
            if(level:GetRoomByIdx(math.tointeger(idx),-1).Data) then return false end -- overlaps with existing room
            
            for _, dat in ipairs(unplacedRooms) do
                local checkOffs = p-Vector(dat.index%13, dat.index//13)
                for _, cPos in pairs(ROOMSHAPE_DOORSLOT_POS[dat.roomData.Shape]) do
                    if(cPos.X==checkOffs.X and cPos.Y==checkOffs.Y) then
                        return false -- overlaps with planned room
                    end
                end
            end
        end

        validCorners[offs.X*10+offs.Y] = true
    end

    for _, slot in pairs(DoorSlot) do -- checks if it has entrance to already placed rooms (aka stuff it shouldnt be touching)
        if(slot>=0 and slot<8) then
            if(ROOMSHAPE_DOORSLOT_POS[room.Shape][slot]) then
                local idxtocheck = vectorPos+ROOMSHAPE_DOORSLOT_POS[room.Shape][slot]+DOORSLOT_DIR[slot]
                if(idxtocheck.X>=0 and idxtocheck.X<13 and idxtocheck.Y>=0 and idxtocheck.Y<13) then
                    local lRoom = level:GetRoomByIdx(idxtocheck.X+idxtocheck.Y*13, -1)
                    if(lRoom and lRoom.Data) then
                        if(#unplacedRooms==1 and lRoom.Data.Type==RoomType.ROOM_CURSE and lRoom.GridIndex==unplacedRooms[1].index) then
                            -- its ok! this is the first room placed and its touching the soon-to-be temple room
                        else
                            return false
                        end
                    end
                end
            end
        end
    end

    local hasAtLeastOneEntrance = false
    for i=1, #unplacedRooms do
        local prevRoom = unplacedRooms[i]

        for slot, pos in pairs(ROOMSHAPE_DOORSLOT_POS[room.Shape]) do
            local tocheck = pos+DOORSLOT_DIR[slot]+vectorPos
            if(tocheck.X>=0 and tocheck.X<13 and tocheck.Y>=0 and tocheck.Y<13) then
                local offs = tocheck-Vector(prevRoom.index%13, prevRoom.index//13)
                if(offs.X>=0 and offs.X<prevRoom.roomData.Width//13 and offs.Y>=0 and offs.Y<prevRoom.roomData.Height//7) then
                    for pSlot, cPos in pairs(ROOMSHAPE_DOORSLOT_POS[prevRoom.roomData.Shape]) do
                        if(cPos.X==offs.X and cPos.Y==offs.Y) then
                            if(room.Doors & (1<<slot) ~= (1<<slot)) then
                                return false -- slot leads to a room but has no door to it
                            else
                                local destIdx = tocheck+DOORSLOT_DIR[pSlot]
                                local destOffs = destIdx-vectorPos
                                if(destOffs.X==ROOMSHAPE_DOORSLOT_POS[room.Shape][slot].X and destOffs.Y==ROOMSHAPE_DOORSLOT_POS[room.Shape][slot].Y) then
                                    if(prevRoom.roomData.Doors & (1<<pSlot) ~= (1<<pSlot)) then
                                        return false -- previous room doesnt have a valid entrances to that door of the checking room
                                    else
                                        hasAtLeastOneEntrance = true
                                    end
                                else
                                    -- if the door from the previous room doesnt lead to the checking room
                                end
                            end
                        end
                    end
                end
            end
        end

        --[[] ]
        for slot, tocheck in pairs(doors) do
            local offs = Vector(tocheck%13, tocheck//13)-Vector(prevRoom.index%13, prevRoom.index//13)
            if(offs.X>=0 and offs.X<prevRoom.roomData.Width//13 and offs.Y>=0 and offs.Y<prevRoom.roomData.Height//7) then
                for pSlot, cPos in pairs(ROOMSHAPE_DOORSLOT_POS[prevRoom.roomData.Shape]) do
                    if(cPos.X==offs.X and cPos.Y==offs.Y) then
                        local destIdx = Vector(tocheck%13, tocheck//13)+DOORSLOT_DIR[pSlot]
                        local destOffs = destIdx-vectorPos
                        if(destOffs.X==ROOMSHAPE_DOORSLOT_POS[room.Shape][slot].X and destOffs.Y==ROOMSHAPE_DOORSLOT_POS[room.Shape][slot].Y) then
                            if(prevRoom.roomData.Doors & (1<<pSlot) ~= (1<<pSlot)) then
                                return false -- previous room doesnt have a valid entrances to that door of the checking room
                            else
                                hasAtLeastOneEntrance = true
                            end
                        else
                            -- if the door from the previous room doesnt lead to the checking room
                        end
                    end
                end
            end
        end
        --]]
    end
    if(not hasAtLeastOneEntrance) then return false end

    --[[] ]
    for i=1, #unplacedRooms-1 do -- checks the other rooms and makes sure it isn't touching them
        local prevRoom = unplacedRooms[i]

        for _, slot in pairs(DoorSlot) do
            if(slot>=0 and slot<8 and ROOMSHAPE_DOORSLOT_POS[room.Shape][slot]) then
                local offs = ROOMSHAPE_DOORSLOT_POS[room.Shape][slot]-Vector(prevRoom.index%13, prevRoom.index//13)
                if(offs.X>=0 and offs.X<prevRoom.roomData.Width//13 and offs.Y>=0 and offs.Y<prevRoom.roomData.Height//7) then
                    for pSlot, cPos in pairs(ROOMSHAPE_DOORSLOT_POS[prevRoom.roomData.Shape]) do
                        if(cPos.X==offs.X and cPos.Y==offs.Y) then
                            return false -- other room touches the checking room (don't need to check if its a valid entrance, this shouldnt be happening)                    end
                        end
                    end
                end
            end
        end
    end
    --]]

    return true
end

---@param currentRoom integer
---@param chosenStb StbType
---@param rooms {roomData: RoomConfigRoom, index: integer}[]
local function placeRooms(currentRoom, chosenStb, rooms)
    if(currentRoom>TEMPLE_ROOM_COUNT) then return {rooms} end

    local level = ToyboxMod.GAME:GetLevel()

    local returns = {}

    for _=1, 2 do
        local r = RoomConfig.GetRandomRoom(Random(), true, chosenStb, RoomType.ROOM_DEFAULT, nil, nil, nil, 10)
        if(r) then
            local hasValidSpawns = false
            for i=0, r.Spawns.Size-1 do
                local sp = r.Spawns:Get(i)
                for j=0, sp.Entries.Size-1 do
                    local ent = sp.Entries:Get(j)
                    if(ent.Type>=10 and not invalidSpawns[ent.Type]) then
                        hasValidSpawns = true
                    end
                end
            end

            if(hasValidSpawns) then
                for i=0, r.Width//13-1 do
                    for j=0, r.Height//7-1 do
                        for ri=1, #rooms do
                            local possiblePositions = getDoorSlotIndexes(rooms[ri].roomData, rooms[ri].index)
                            for _, pos in pairs(possiblePositions) do
                                local newPos = Vector(pos%13, pos//13)-Vector(i,j)
                                if(canPlaceRoomAtIndex(r, newPos, rooms)) then
                                    local newRooms = {}
                                    for idx, data in ipairs(rooms) do
                                        newRooms[idx] = {roomData=data.roomData, index=data.index}
                                    end
                                    table.insert(newRooms, {roomData=r, index=newPos.X+newPos.Y*13})

                                    local newRet = placeRooms(currentRoom+1, chosenStb, newRooms)
                                    for _, retRooms in ipairs(newRet) do
                                        table.insert(returns, retRooms)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return returns
end

local function addNewBossRoom(_)
    if(not ToyboxMod.GAME:GetRoom():IsFirstVisit()) then return end

    local tb = ToyboxMod:getExtraDataTable()
    tb.TEMPLE_TRIAL_ROOMS = nil
    tb.TEMPLE_MAIN_ROOMS = nil

    local level = ToyboxMod.GAME:GetLevel()
    local rng = ToyboxMod:generateRng(level:GetGenerationRNG():GetSeed())

    local changed = false

    local trialIndexes = {}
    local templeIndexes = {}

    local trialRooms = {}
    local mainRooms = {}

    local nextChapter = math.min(6, getChapterFromStage(level:GetStage())+1)

    for i=0, 168 do
        local room = level:GetRoomByIdx(i, -1)
        if(room and room.Data and room.Data.Type==RoomType.ROOM_CURSE and room.Data.Shape==RoomShape.ROOMSHAPE_1x1 and shouldMakeTemple(rng)) then
            local pickedBackdrop = rng:RandomInt(1, #CHAPTER_STBS[nextChapter])

            local changed2 = false
            local finals = placeRooms(1, CHAPTER_STBS[nextChapter][pickedBackdrop], {{roomData=room.Data, index=room.GridIndex}})
            if(#finals>0) then
                local rand = ToyboxMod:generateRng():RandomInt(1, #finals)

                local statsToAdd = {TEARS=0, DAMAGE=0, SPEED=0, RANGE=0}
                local startingIndex = rng:RandomInt(1, #COMBAT_STATS)

                local numItems = (nextChapter-2)
                if(pickedBackdrop>3) then -- extra item on alt path
                    numItems = numItems+1
                end

                for _=1, (nextChapter==6 and numItems+3 or numItems) do -- 3 extra items in ch6 (chest/darkroom)
                    startingIndex = startingIndex%(#COMBAT_STATS)+1
                    statsToAdd[COMBAT_STATS[startingIndex]] = statsToAdd[COMBAT_STATS[startingIndex]]+1
                end

                for _=1, numItems do
                    local idx = rng:RandomInt(1, #OTHER_STATS)
                    statsToAdd[OTHER_STATS[idx]] = statsToAdd[OTHER_STATS[idx]]+1
                end

                local rooms = finals[rand]
                for idx=2, #rooms do
                    local placed = level:TryPlaceRoom(rooms[idx].roomData, math.tointeger(rooms[idx].index), nil, nil, true, true, true)
                    --[[] ]
                    print(placed)
                    local doors = ""
                    for d=0,7 do
                        doors = doors..((rooms[idx].roomData.Doors & (1<<d) == 0) and "0" or "1")
                    end
                    print(rooms[idx].roomData.Shape, math.tointeger(rooms[idx].index), doors)
                    --]]
                    if(not placed) then
                        break
                    end

                    placed.Flags = placed.Flags | RoomDescriptor.FLAG_CURSED_MIST

                    changed = true
                    changed2 = true
                    table.insert(trialIndexes, placed.SafeGridIndex)
                    trialRooms[tostring(placed.SafeGridIndex)] = {
                        Backdrop = CHAPTER_BACKDROPS[nextChapter][pickedBackdrop],
                        Items = statsToAdd,
                        Parent = room.SafeGridIndex,
                    }

                    placed:SetGroup(TEMPLE_GROUP)
                end
            end

            if(changed2) then
                local temple = RoomConfig.GetRandomRoom(Random(), true, StbType.SPECIAL_ROOMS, RoomType.ROOM_TELEPORTER, RoomShape.ROOMSHAPE_1x1, nil, nil, nil, nil, nil, 101)
                room.Data = temple

                mainRooms[tostring(room.SafeGridIndex)] = 0

                table.insert(templeIndexes, room.SafeGridIndex)
            end
        end
    end

    if(changed) then
        tb.TEMPLE_TRIAL_ROOMS = ToyboxMod:cloneTable(trialRooms)
        tb.TEMPLE_MAIN_ROOMS = ToyboxMod:cloneTable(mainRooms)

        level:UpdateVisibility()
        if(MinimapAPI) then
            MinimapAPI:CheckForNewRedRooms()

            for _, idx in ipairs(trialIndexes) do
                local ogroom = level:GetRoomByIdx(idx)
                if(ogroom and ogroom.Data and ogroom.Data.Shape==RoomShape.ROOMSHAPE_LTL) then
                    MinimapAPI:AddRoom{
                        Shape = ogroom.Data.Shape,
                        PermanentIcons = { "ToyboxTempleTrialRoom" },
                        LockedIcons = {MinimapAPI:GetUnknownRoomTypeIconID(ogroom.Data.Type)},
                        ItemIcons = {},
                        VisitedIcons = {},
                        Position = MinimapAPI:GridIndexToVector(ogroom.SafeGridIndex),
                        Descriptor = ogroom,
                        AdjacentDisplayFlags = 5,
                        Type = ogroom.Data.Type,
                        Dimension = ogroom:GetDimension(),
                        Visited = ogroom.VisitedCount > 0,
                        Clear = ogroom.Clear,
                    }
                else
                    local room = MinimapAPI:GetRoomByIdx(idx)
                    room.ToyboxCustomIconsDone = nil
                    room.Type = ogroom.Data.Type
                    room.PermanentIcons = { "ToyboxTempleTrialRoom" }
                end
            end

            for _, idx in ipairs(templeIndexes) do
                local room = MinimapAPI:GetRoomByIdx(idx)
                --room.ToyboxCustomIconsDone = nil
                --room.Type = ToyboxMod.SPECIAL_ROOM_TYPE_TEMPLATE
                room.PermanentIcons = { "ToyboxTempleRoom" }
            end
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, addNewBossRoom)

local function setRoomBackdrops(_)
    local room = ToyboxMod.GAME:GetLevel():GetCurrentRoomDesc()
    local templeExtraData = ToyboxMod:getExtraData("TEMPLE_TRIAL_ROOMS") or {}
    if(templeExtraData[tostring(room.SafeGridIndex)]) then
        return templeExtraData[tostring(room.SafeGridIndex)].Backdrop
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_BACKDROP_CHANGE, setRoomBackdrops)

local function enterTrialRoom(_)
    local level = ToyboxMod.GAME:GetLevel()
    local room = level:GetCurrentRoomDesc()
    local templeMainData = ToyboxMod:getExtraData("TEMPLE_MAIN_ROOMS") or {}
    local templeExtraData = ToyboxMod:getExtraData("TEMPLE_TRIAL_ROOMS") or {}
    if(templeMainData[tostring(room.SafeGridIndex)]) then
        local unclearRooms = 0
        for idx, data in pairs(templeExtraData) do
            if(data.Parent==room.SafeGridIndex) then
                if(not level:GetRoomByIdx(tonumber(idx)).Clear) then
                    unclearRooms = unclearRooms+1
                end
            end
        end

        local pos = ToyboxMod.GAME:GetRoom():GetCenterPos()

        if(unclearRooms==0 and templeMainData[tostring(room.SafeGridIndex)]~=2) then
            templeMainData[tostring(room.SafeGridIndex)] = 2

            local rng = ToyboxMod:generateRng(room.SpawnSeed)

            local curPool = ToyboxMod.GAME:GetRoom():GetItemPool(rng:Next())
            local id = ToyboxMod.GAME:GetItemPool():GetCollectible(curPool, true, rng:Next(), CollectibleType.COLLECTIBLE_BREAKFAST)
            local item = Isaac.Spawn(5,100,id,pos,Vector.Zero,nil):ToPickup()
        end

        if(templeMainData[tostring(room.SafeGridIndex)]==0) then
            for slot, otherRoom in pairs(room:GetNeighboringRooms()) do
                if(templeExtraData[tostring(otherRoom.SafeGridIndex)] and templeExtraData[tostring(otherRoom.SafeGridIndex)].Parent==room.SafeGridIndex) then
                    local door = ToyboxMod.GAME:GetRoom():GetDoor(slot)
                    if(door) then
                        door:SetVariant(150)
                        door:Close(true)

                        door:GetSprite():Play("Closed", true)
                    end
                end
            end
        end

        local slab = Isaac.Spawn(1000, ToyboxMod.EFFECT_TEMPLE_SLAB, templeMainData[tostring(room.SafeGridIndex)], pos, Vector.Zero, nil):ToEffect()

        return
    end

    if(templeExtraData[tostring(room.SafeGridIndex)]) then
        if(ToyboxMod.GAME:GetRoom():IsFirstVisit()) then
            --ToyboxMod.GAME:ShakeScreen(15)
        end
    end

    for i=0, ToyboxMod.GAME:GetNumPlayers()-1 do
        local pl = Isaac.GetPlayer(i)
        local changeStats = true

        if(templeExtraData[tostring(room.SafeGridIndex)] and (room.Flags & RoomDescriptor.FLAG_CURSED_MIST ~= 0)) then
            ToyboxMod:setEntityData(pl, "WAS_IN_TEMPLE_TRIAL", true)
        elseif(ToyboxMod:getEntityData(pl, "WAS_IN_TEMPLE_TRIAL")) then
            ToyboxMod:setEntityData(pl, "WAS_IN_TEMPLE_TRIAL", nil)
        else
            changeStats = false
        end

        if(changeStats) then
            pl:AddCacheFlags(CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_DAMAGE, true)
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, enterTrialRoom)

---@param room Room
---@param desc RoomDescriptor
local function preEnterTrialRoom(_, room, desc)
    local extradata = ToyboxMod:getExtraDataTable()
    extradata.TEMPLE_TRIAL_ROOMS = extradata.TEMPLE_TRIAL_ROOMS or {}

    local idx = tostring(desc.SafeGridIndex)
    if(extradata.TEMPLE_TRIAL_ROOMS[idx] and desc.Clear and (desc.Flags & RoomDescriptor.FLAG_CURSED_MIST ~= 0)) then
        local parIdx = extradata.TEMPLE_TRIAL_ROOMS[idx].Parent
        local unclearRooms = 0
        for otherIdx, otherData in pairs(extradata.TEMPLE_TRIAL_ROOMS) do
            if(otherData.Parent==parIdx) then
                if(not ToyboxMod.GAME:GetLevel():GetRoomByIdx(tonumber(otherIdx)).Clear) then
                    unclearRooms = unclearRooms+1
                end
            end
        end

        if(unclearRooms==0) then
            for otherIdx, otherData in pairs(extradata.TEMPLE_TRIAL_ROOMS) do
                if(otherData.Parent==parIdx) then
                    local trialRoomDesc = ToyboxMod.GAME:GetLevel():GetRoomByIdx(tonumber(otherIdx))
                    trialRoomDesc.Flags = trialRoomDesc.Flags & (~RoomDescriptor.FLAG_CURSED_MIST)
                end
            end
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_NEW_ROOM, preEnterTrialRoom)

local function clearTrialRoom(_)
    local templeExtraData = ToyboxMod:getExtraData("TEMPLE_TRIAL_ROOMS") or {}
    local desc = ToyboxMod.GAME:GetLevel():GetCurrentRoomDesc()
    if(templeExtraData[desc.SafeGridIndex] and desc.Flags & RoomDescriptor.FLAG_CURSED_MIST ~= 0) then
        
    end
end
--ToyboxMod:AddCallback(ToyboxMod.CUSTOM_CALLBACKS.POST_ROOM_CLEAR, clearTrialRoom)

---@param pl EntityPlayer
---@param flag CacheFlag
local function evalTrialCache(_, pl, flag)
    if(flag & (CacheFlag.CACHE_SPEED | CacheFlag.CACHE_RANGE) == 0) then return end

    local room = ToyboxMod.GAME:GetLevel():GetCurrentRoomDesc()
    local templeExtraData = ToyboxMod:getExtraData("TEMPLE_TRIAL_ROOMS") or {}
    if(templeExtraData[tostring(room.SafeGridIndex)] and (room.Flags & RoomDescriptor.FLAG_CURSED_MIST ~= 0)) then
        if(flag & CacheFlag.CACHE_SPEED == CacheFlag.CACHE_SPEED) then
            pl.MoveSpeed = pl.MoveSpeed+templeExtraData[tostring(room.SafeGridIndex)].Items.SPEED*0.1
        else
            pl.TearRange = pl.TearRange+templeExtraData[tostring(room.SafeGridIndex)].Items.RANGE*30
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evalTrialCache)

---@param pl EntityPlayer
---@param stat EvaluateStatStage
---@param val number
local function evalTrialStats(_, pl, stat, val)
    if(not (stat==EvaluateStatStage.TEARS_UP or stat==EvaluateStatStage.DAMAGE_UP)) then return end

    local room = ToyboxMod.GAME:GetLevel():GetCurrentRoomDesc()
    local templeExtraData = ToyboxMod:getExtraData("TEMPLE_TRIAL_ROOMS") or {}
    if(templeExtraData[tostring(room.SafeGridIndex)] and (room.Flags & RoomDescriptor.FLAG_CURSED_MIST ~= 0)) then
        if(stat==EvaluateStatStage.TEARS_UP) then
            return val+templeExtraData[tostring(room.SafeGridIndex)].Items.TEARS*0.7
        else
            return val+templeExtraData[tostring(room.SafeGridIndex)].Items.DAMAGE
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_EVALUATE_STAT, evalTrialStats)

---@param effect EntityEffect
local function initSlab(_, effect)
    local sp = effect:GetSprite()

    effect.DepthOffset = -500
    effect.SortingLayer = SortingLayer.SORTING_BACKGROUND

    if(effect.SubType==0) then
        sp:Play("Idle", true)
    elseif(effect.SubType==1) then
        sp:Play("IdleActive", true)

        local data = ToyboxMod:getExtraDataTable()
        local room = ToyboxMod.GAME:GetLevel():GetCurrentRoomDesc()
        for slot, otherRoom in pairs(room:GetNeighboringRooms()) do
            if(data.TEMPLE_TRIAL_ROOMS[tostring(otherRoom.SafeGridIndex)] and data.TEMPLE_TRIAL_ROOMS[tostring(otherRoom.SafeGridIndex)].Parent==room.SafeGridIndex) then
                local door = ToyboxMod.GAME:GetRoom():GetDoor(slot)
                if(door) then
                    door:SetVariant(DoorVariant.DOOR_UNSPECIFIED)
                    door:SetLocked(false)
                    door:Open()
                end
            end
        end
    elseif(effect.SubType==2) then
        sp:Play("IdleInactive", true)
    end

    if(math.random()<0.001) then
        for i=0, 2 do
            sp:ReplaceSpritesheet(i, "gfx_tb/effects/effect_temple_slab_joe.png")
        end
        sp:LoadGraphics()
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, initSlab, ToyboxMod.EFFECT_TEMPLE_SLAB)

---@param effect EntityEffect
local function updateSlab(_, effect)
    local idx = tostring(ToyboxMod.GAME:GetLevel():GetCurrentRoomDesc().SafeGridIndex)
    local data = ToyboxMod:getExtraDataTable()
    if(not (data.TEMPLE_MAIN_ROOMS and data.TEMPLE_MAIN_ROOMS[idx])) then return end

    local sp =  effect:GetSprite()

    if(effect.SubType==0) then
        local hasNearbyPlayer = false
        for _, ent in ipairs(Isaac.FindInRadius(effect.Position, 60, EntityPartition.PLAYER)) do
            if(ent:ToPlayer()) then hasNearbyPlayer = true; break end
        end

        if(hasNearbyPlayer) then
            effect.SubType = 1
            sp:Play("Activate", true)

            
            sfx:Play(ToyboxMod.SFX_ROCK_SCRAPE, 0.2, 2, false, 0.8+math.random()*0.05)
        end
    elseif(effect.SubType==1) then
        if(sp:IsEventTriggered("shake")) then
            ToyboxMod.GAME:ShakeScreen(100)

            sfx:Play(SoundEffect.SOUND_GROUND_TREMOR)
        end

        if(sp:IsFinished("Activate")) then
            local room = ToyboxMod.GAME:GetLevel():GetCurrentRoomDesc()
            for slot, otherRoom in pairs(room:GetNeighboringRooms()) do
                if(data.TEMPLE_TRIAL_ROOMS[tostring(otherRoom.SafeGridIndex)] and data.TEMPLE_TRIAL_ROOMS[tostring(otherRoom.SafeGridIndex)].Parent==room.SafeGridIndex) then
                    local door = ToyboxMod.GAME:GetRoom():GetDoor(slot)
                    if(door) then
                        door:SetVariant(DoorVariant.DOOR_UNSPECIFIED)
                        door:SetLocked(false)
                        door:Open()
                    end
                end
            end

            sp:Play("IdleActive", true)
        end
    end

    data.TEMPLE_MAIN_ROOMS[idx] = effect.SubType
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, updateSlab, ToyboxMod.EFFECT_TEMPLE_SLAB)

local function playEpicSound(_)
    local extradata = ToyboxMod:getExtraDataTable()
    local idx = tostring(ToyboxMod.GAME:GetLevel():GetCurrentRoomDesc().SafeGridIndex)
    if(not (extradata.TEMPLE_TRIAL_ROOMS and extradata.TEMPLE_TRIAL_ROOMS[idx])) then return end

    local parIdx = extradata.TEMPLE_TRIAL_ROOMS[idx].Parent
    local unclearRooms = 0
    for otherIdx, otherData in pairs(extradata.TEMPLE_TRIAL_ROOMS) do
        if(otherData.Parent==parIdx) then
            if(not ToyboxMod.GAME:GetLevel():GetRoomByIdx(tonumber(otherIdx)).Clear) then
                unclearRooms = unclearRooms+1
            end
        end
    end
    if(unclearRooms==0) then
        local pCoord = Vector(parIdx%13, parIdx//13)
        local coord = Vector(tonumber(idx)%13, tonumber(idx)//13)

        local dif = pCoord-coord

        local dot = dif:Normalized():Dot(Vector(1,0))
        local len = math.max(1-dif:Length()*0.2, 0.3)

        sfx:Play(SoundEffect.SOUND_RAILROAD_TRACK_RAISE_FAR, len*0.8, 2, false, 1, dot)
    else

    end
    ToyboxMod.GAME:ShakeScreen(20)
end
ToyboxMod:AddCallback(ToyboxMod.CUSTOM_CALLBACKS.POST_ROOM_CLEAR, playEpicSound)


local function replaceCollectiblePedestal(_, pickup)
    local level = ToyboxMod.GAME:GetLevel()
    local room = level:GetCurrentRoomDesc()
    local templeMainData = ToyboxMod:getExtraData("TEMPLE_MAIN_ROOMS") or {}
    if(templeMainData[tostring(room.SafeGridIndex)]) then
        if(pickup:GetAlternatePedestal()==PedestalType.DEFAULT) then
            pickup:GetSprite():ReplaceSpritesheet(5, "gfx_tb/pickups/pickup_caban_altar.png", true)
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, replaceCollectiblePedestal, PickupVariant.PICKUP_COLLECTIBLE)