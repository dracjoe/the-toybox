local EXPLORATION_DMG_PERC = 0.20
local EXTRA_MAX_DMG_PER_MULT = 0.15

local BONUS_ROOM_TYPES = {
    [RoomType.ROOM_SECRET] = true,
    [RoomType.ROOM_SUPERSECRET] = true,
    [RoomType.ROOM_ULTRASECRET] = true,
}

---@param firstTime boolean
---@param pl EntityPlayer
local function spawnCard(_, _, _, firstTime, _, _, pl)
    if(not firstTime) then return end

    local pos = ToyboxMod.GAME:GetRoom():FindFreePickupSpawnPosition(pl.Position, 40)
    local card = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_SUN, pos, Vector.Zero, nil):ToPickup()
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, spawnCard, ToyboxMod.COLLECTIBLE_SUN_MASK)

local function bossInit(_, ent)
    if(ent:IsBoss() and PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_SUN_MASK)) then
        local mult = PlayerManager.GetNumCollectibles(ToyboxMod.COLLECTIBLE_SUN_MASK)

        local roomsExplored = 0
        local maxRooms = 0

        local level = ToyboxMod.GAME:GetLevel()
        local seenRooms = {}
        for i=0, 168 do
            local room = level:GetRoomByIdx(i)
            if(room.GridIndex ~= -1 and not seenRooms[room.SafeGridIndex]) then
                if(room.DisplayFlags ~= RoomDescriptor.DISPLAY_NONE) then
                    roomsExplored = roomsExplored+1
                end
                if(room:GetGroup() == RoomGroup.GROUP_NONE and room.Flags & RoomDescriptor.FLAG_RED_ROOM == 0 and not (room.Data and BONUS_ROOM_TYPES[room.Data.Type])) then
                    maxRooms = maxRooms+1
                end
            end
        end

        local perc = roomsExplored/maxRooms * (EXPLORATION_DMG_PERC + (mult-1) * EXTRA_MAX_DMG_PER_MULT)
        if(perc >= 1) then
            ent:Die()
        else
            ent:AddHealth(-perc * ent.MaxHitPoints)
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, bossInit)