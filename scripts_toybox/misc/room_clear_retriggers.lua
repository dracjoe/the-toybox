---@param pl EntityPlayer
---@param flag string
---@param val number
local function postEvaluateCustomCache(_, pl, flag, val)
    return 0
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CUSTOM_CACHE, -math.huge, postEvaluateCustomCache, "room-clear-retriggers")

local RETRIGGER_DELAY = 3
local CANCEL_RETRIGGER = false

local INVALID_ROOMTYPES = {
    [RoomType.ROOM_BOSS] = true,
    [RoomType.ROOM_BOSSRUSH] = true,
}

local function retriggerClear(_, _)
    if(CANCEL_RETRIGGER) then return end

    local room = ToyboxMod.GAME:GetRoom()
    if(INVALID_ROOMTYPES[room:GetType()]) then return end

    local numRetriggers = 0
    for _, player in ipairs(PlayerManager.GetPlayers()) do
        player:AddCustomCacheTag("room-clear-retriggers", true)
        numRetriggers = numRetriggers+player:GetCustomCacheValue("room-clear-retriggers")
    end
    if(numRetriggers<=0) then return end

    Isaac.CreateTimer(
        function(_)
            CANCEL_RETRIGGER = true

            room:TriggerClear(true)

            CANCEL_RETRIGGER = false
        end,
        RETRIGGER_DELAY,
        numRetriggers,
        false
    )
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_POST_ROOM_TRIGGER_CLEAR, CallbackPriority.IMPORTANT, retriggerClear)

local function playerRetriggerClear(_, pl)
    if(CANCEL_RETRIGGER) then return end

    local room = ToyboxMod.GAME:GetRoom()
    if(not (ToyboxMod.GAME:IsGreedMode() or INVALID_ROOMTYPES[room:GetType()])) then return end

    local numRetriggers = 0
    for _, player in ipairs(PlayerManager.GetPlayers()) do
        player:AddCustomCacheTag("room-clear-retriggers", true)
        numRetriggers = numRetriggers+player:GetCustomCacheValue("room-clear-retriggers")
    end
    if(numRetriggers<=0) then return end

    Isaac.CreateTimer(
        function(_)
            CANCEL_RETRIGGER = true

            pl:TriggerRoomClear()

            CANCEL_RETRIGGER = false
        end,
        RETRIGGER_DELAY,
        numRetriggers,
        false
    )
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_POST_PLAYER_TRIGGER_ROOM_CLEAR, CallbackPriority.IMPORTANT, playerRetriggerClear)

local function canceasouihfasash(_)
    CANCEL_RETRIGGER = false
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, canceasouihfasash)