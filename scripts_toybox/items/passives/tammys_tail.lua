--TODO: Make it increase enemy HP by 50% or smth

local sfx = SFXManager()

local CLEAR_RETRIGGERS = 1
local RETRIGGER_DELAY = 3

local CANCEL_RETRIGGER = false

local INVALID_ROOMTYPES = {
    [RoomType.ROOM_BOSS] = true,
    [RoomType.ROOM_BOSSRUSH] = true,
}

local function retriggerClear(_, _)
    if(CANCEL_RETRIGGER) then return end
    if(not PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_TAMMYS_TAIL)) then return end

    local room = ToyboxMod.GAME:GetRoom()
    if(INVALID_ROOMTYPES[room:GetType()]) then return end

    sfx:Play(ToyboxMod.SFX_MEOW)

    local numRetriggers = CLEAR_RETRIGGERS*PlayerManager.GetNumCollectibles(ToyboxMod.COLLECTIBLE_TAMMYS_TAIL)
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
ToyboxMod:AddCallback(ModCallbacks.MC_POST_ROOM_TRIGGER_CLEAR, retriggerClear)

local function playerRetriggerClear(_, pl)
    if(CANCEL_RETRIGGER) then return end
    if(not PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_TAMMYS_TAIL)) then return end

    local room = ToyboxMod.GAME:GetRoom()
    if(not (ToyboxMod.GAME:IsGreedMode() or INVALID_ROOMTYPES[room:GetType()])) then return end

    sfx:Play(ToyboxMod.SFX_MEOW)

    local numRetriggers = CLEAR_RETRIGGERS*PlayerManager.GetNumCollectibles(ToyboxMod.COLLECTIBLE_TAMMYS_TAIL)

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
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PLAYER_TRIGGER_ROOM_CLEAR, playerRetriggerClear)

local function canceasouihfasash(_)
    CANCEL_RETRIGGER = false
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, canceasouihfasash)