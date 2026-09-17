

local DEVILCHANCE_INCREASE = 0.15
local function getDevilDealChance(_, chance)
    if(not PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_ATHEISM)) then return end
    return chance+(DEVILCHANCE_INCREASE*PlayerManager.GetNumCollectibles(ToyboxMod.COLLECTIBLE_ATHEISM)-0.01)
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_DEVIL_APPLY_ITEMS, getDevilDealChance)


local function replaceWithAtheismDeal(_)
    if(not PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_ATHEISM)) then return end

    local level = ToyboxMod.GAME:GetLevel()
    local st = RoomSubType.TREASURE_OPTIONS
    local newItemRoom = RoomConfigHolder.GetRandomRoom(math.max(1, Random()), true, StbType.SPECIAL_ROOMS, RoomType.ROOM_TREASURE, RoomShape.ROOMSHAPE_1x1, 0, -1, 0, 10, 0, st, -1)

    local devilroom = level:GetRoomByIdx(GridRooms.ROOM_DEVIL_IDX)
    if(not devilroom.Data) then
        devilroom:InitSeeds(ToyboxMod:generateRng())
        devilroom.Data = newItemRoom
        devilroom.OverrideData = newItemRoom
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, replaceWithAtheismDeal)

---@param door GridEntityDoor
local function unlockAtheismDealDoor(_, door)
    if(door:IsLocked() and door.TargetRoomIndex==-1 and door.TargetRoomType==RoomType.ROOM_TREASURE) then
        door:SetLocked(false)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_GRID_ENTITY_DOOR_UPDATE, unlockAtheismDealDoor)



local statsSprite = Sprite("gfx/ui/hudstats2.anm2", true)
statsSprite:Play("Idle", true)
local function renderAtheismDealIcon(_)
    if(not PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_ATHEISM)) then return end
    if(not ToyboxMod.GAME:GetHUD():IsVisible()) then return end

    local pos = Vector(20,12)*Options.HUDOffset + Vector(0,160)
    if(ToyboxMod.GAME:GetNumPlayers()>1) then
        pos = pos+Vector(0,12)

        if(Isaac.GetPlayer():GetPlayerType()==PlayerType.PLAYER_JACOB) then
            pos = pos+Vector(0,14)
        end
        if(PlayerManager.AnyoneIsPlayerType(PlayerType.PLAYER_BLUEBABY_B)) then
            pos = pos+Vector(0,9)
        end
    end
    if(PlayerManager.AnyoneIsPlayerType(PlayerType.PLAYER_BETHANY)) then
        pos = pos+Vector(0,8)
    end
    if(PlayerManager.AnyoneIsPlayerType(PlayerType.PLAYER_BETHANY_B)) then
        pos = pos+Vector(0,8)
    end
    if(ToyboxMod.GAME.Difficulty==Difficulty.DIFFICULTY_NORMAL and not ToyboxMod.GAME:AchievementUnlocksDisallowed()) then
        pos = pos-Vector(0,16)
    end

    statsSprite:SetFrame(10)
    statsSprite.Color = Color(0,0,0,1,0,0,0)
    statsSprite:Render(pos)

    statsSprite:SetFrame(9)
    statsSprite.Color = Color(1,1,1,0.5,0,0,0)
    statsSprite:Render(pos+Vector(0,1))
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_HUD_RENDER, renderAtheismDealIcon)

---@param pl EntityPlayer
local function addAtheism(_, _, _, firstTime, _, _, pl)
    pl:SetInnateCollectibleGroup("ToyboxAtheismDuality", {[CollectibleType.COLLECTIBLE_DUALITY]=1}, false)
    local data = ToyboxMod:getEntityDataTable(pl)
    data.ATHEISM_JUST_GOT = (data.ATHEISM_JUST_GOT or 0)+1

    local devilRoomData = ToyboxMod.GAME:GetLevel():GetRoomByIdx(GridRooms.ROOM_DEVIL_IDX).Data
    if(firstTime and not (devilRoomData and devilRoomData.Type==RoomType.ROOM_TREASURE)) then
        replaceWithAtheismDeal()
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, addAtheism, ToyboxMod.COLLECTIBLE_ATHEISM)

---@param pl EntityPlayer
local function removeAtheism(_, pl)
    if(not pl:HasCollectible(ToyboxMod.COLLECTIBLE_ATHEISM)) then
        pl:ClearInnateItemGroup("ToyboxAtheismDuality")
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, removeAtheism, ToyboxMod.COLLECTIBLE_ATHEISM)



---@param desc RoomDescriptor
local function isGreedTreasureDevil(desc)
    return desc.GridIndex==GridRooms.ROOM_DEVIL_IDX and (desc.Data and desc.Data.Type==RoomType.ROOM_TREASURE) and ToyboxMod.GAME:IsGreedMode()
end

-- replace pool
local function setRoomPool(_)
    local desc = ToyboxMod.GAME:GetLevel():GetCurrentRoomDesc()
    if(isGreedTreasureDevil(desc)) then
        ToyboxMod.GAME:GetRoom():SetItemPool(ItemPoolType.POOL_GREED_TREASURE)
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_ROOM, CallbackPriority.IMPORTANT, setRoomPool)

local function setPoolWhenItemSpawns(_, t, v)
    if(t==EntityType.ENTITY_PICKUP and v==PickupVariant.PICKUP_COLLECTIBLE) then
        setRoomPool()
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_PRE_ROOM_ENTITY_SPAWN, CallbackPriority.IMPORTANT, setPoolWhenItemSpawns)

---@param ent GridEntity
local function makeSpecialExitDoor(_, ent, _, first)
    local door = ent:ToDoor()
    if(string.find(string.lower(door:GetSprite():GetFilename()), "holeinwall")) then return end

    local currentRoom = ToyboxMod.GAME:GetLevel():GetCurrentRoomDesc()
    if(isGreedTreasureDevil(currentRoom)) then
        local sp = door:GetSprite()
        for i, _ in pairs(sp:GetAllLayers()) do
            sp:ReplaceSpritesheet(i-1, "gfx/grid/door_02_treasureroomdoor.png", false)
        end
        sp:LoadGraphics()
    end
end
ToyboxMod:AddCallback(ToyboxMod.CUSTOM_CALLBACKS.POST_GRID_INIT, makeSpecialExitDoor, GridEntityType.GRID_DOOR)

---@param ent GridEntity
local function makeSpecialEntranceDoor(_, ent)
    local door = ent:ToDoor()
    if(string.find(string.lower(door:GetSprite():GetFilename()), "holeinwall")) then return end

    local room = ToyboxMod.GAME:GetLevel():GetRoomByIdx(door.TargetRoomIndex)
    if(isGreedTreasureDevil(room)) then
        local sp = door:GetSprite()
        if(sp:GetLayer(0):GetSpritesheetPath()~="gfx/grid/door_02_treasureroomdoor.png") then
            for i, _ in pairs(sp:GetAllLayers()) do
                sp:ReplaceSpritesheet(i-1, "gfx/grid/door_02_treasureroomdoor.png", false)
            end
            sp:LoadGraphics()
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_GRID_ENTITY_DOOR_UPDATE, makeSpecialEntranceDoor, GridEntityType.GRID_DOOR)