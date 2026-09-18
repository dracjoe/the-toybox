local INVALID_ROOMTYPES = {
    [RoomType.ROOM_BOSS] = true,
    [RoomType.ROOM_BOSSRUSH] = true,
}

ToyboxMod:makeParasiteTrinket(ToyboxMod.TRINKET_LADYBUG, ToyboxMod.TRINKET_ANTIBIOTICS, SoundEffect.SOUND_MATCHSTICK)

local function tryGetRewards(_)
    if(not PlayerManager.AnyoneHasTrinket(ToyboxMod.TRINKET_LADYBUG)) then return end

    local room = ToyboxMod.GAME:GetRoom()

    if(INVALID_ROOMTYPES[room:GetType()]) then
        local spawns = ToyboxMod:getExtraData("LADYBUG_SPAWNS")

        local inverseOptions = {}
        for _, pickupdata in ipairs(spawns) do
            local pos = room:FindFreePickupSpawnPosition(room:GetCenterPos())
            local ent = Isaac.Spawn(pickupdata[1], pickupdata[2], pickupdata[3], pos, Vector.Zero, nil)

            if(ent.Type==EntityType.ENTITY_PICKUP and pickupdata[4]~=0) then
                ent = ent:ToPickup() ---@type EntityPickup

                local idx = 0
                if(inverseOptions[pickupdata[4]]) then
                    idx = inverseOptions[pickupdata[4]]
                else
                    idx = ent:SetNewOptionsPickupIndex()
                    inverseOptions[pickupdata[4]] = idx
                end
                ent.OptionsPickupIndex = idx
            end
        end

        ToyboxMod:setExtraData("LADYBUG_SPAWNS", nil)
        ToyboxMod:setExtraData("LADYBUG_TRIGGERED", true)
    elseif(not ToyboxMod:getExtraData("LADYBUG_TRIGGERED")) then
        local occupiedIndexes = {}
        local nextindex = 1

        local pickups = {}
        local todel = {}
        for _, ent in ipairs(Isaac.FindByType(5)) do
            local pickup = ent:ToPickup()
            if(ent.FrameCount==0) then
                local idx = 0
                if(pickup and pickup.OptionsPickupIndex~=0) then
                    if(occupiedIndexes[pickup.OptionsPickupIndex]) then
                        idx = occupiedIndexes[pickup.OptionsPickupIndex]
                    else
                        idx = nextindex
                        occupiedIndexes[pickup.OptionsPickupIndex] = nextindex
                        nextindex = nextindex+1
                    end
                end
                table.insert(pickups, {pickup.Type, pickup.Variant, pickup.SubType, idx})
                table.insert(todel, ent)
            end
        end

        if(#pickups>0) then
            local data = ToyboxMod:getExtraDataTable()
            data.LADYBUG_SPAWNS = data.LADYBUG_SPAWNS or {}

            for _, ent in ipairs(todel) do
                ent:Remove()
                ent:Update()
            end

            for _, pickupdata in ipairs(pickups) do
                table.insert(data.LADYBUG_SPAWNS, pickupdata)
            end
        end
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_POST_ROOM_TRIGGER_CLEAR, CallbackPriority.LATE+1, tryGetRewards)

local function resetLadybug(_)
    if(not ToyboxMod.GAME:GetRoom():IsFirstVisit()) then return end

    ToyboxMod:setExtraData("LADYBUG_TRIGGERED", false)
    ToyboxMod:setExtraData("LADYBUG_SPAWNS", {})
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, resetLadybug)