local ROOM_WHITELIST = {
    [RoomType.ROOM_ANGEL] = true,
    [RoomType.ROOM_BOSS] = true,
    [RoomType.ROOM_BOSSRUSH] = true,
}

local function addPedestalTrinkets(_, pickup)
    if(not PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_OFFERING)) then return end
    if(not ROOM_WHITELIST[ToyboxMod.GAME:GetRoom():GetType()]) then return end

    local pool = ToyboxMod.GAME:GetItemPool()

    local mult = PlayerManager.GetNumCollectibles(ToyboxMod.COLLECTIBLE_OFFERING)
    local trinkets = {}
    for _=1, mult do
        local trinket = pool:GetTrinket()

        table.insert(trinkets, trinket)
    end

    return trinkets
end
ToyboxMod:AddPriorityCallback(ToyboxMod.CUSTOM_CALLBACKS.ADD_PEDESTAL_TRINKETS, CallbackPriority.LATE+1, addPedestalTrinkets)