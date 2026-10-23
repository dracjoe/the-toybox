local ROOM_CLEAR_RETRIGGERS = 4

---@param pl EntityPlayer
local function useMirage(_, _, pl, flags)
    --if(pl:HasCollectible(CollectibleType.COLLECTIBLE_TAROT_CLOTH) and flags & UseFlag.USE_CARBATTERY == 0) then return end

    local data = ToyboxMod:getEntityDataTable(pl)
    data.MIRAGE_USES = (data.MIRAGE_USES or 0)+1
    pl:AddCustomCacheTag("room-clear-retriggers", true)
end
ToyboxMod:AddCallback(ModCallbacks.MC_USE_CARD, useMirage, ToyboxMod.CARD_MIRAGE)

---@param pl EntityPlayer
---@param val number
local function postEvaluateCustomCache(_, pl, flag, val)
    return val+(ToyboxMod:getEntityData(pl, "MIRAGE_USES") or 0)*ROOM_CLEAR_RETRIGGERS
end
ToyboxMod:AddCallback(ModCallbacks.MC_EVALUATE_CUSTOM_CACHE, postEvaluateCustomCache, "room-clear-retriggers")

local function removeMirageOnNewRoom(_, pl)
    ToyboxMod:setEntityData(pl, "MIRAGE_USES", 0)
    pl:AddCustomCacheTag("room-clear-retriggers", true)
end
--ToyboxMod:AddCallback(ModCallbacks.MC_POST_PLAYER_NEW_ROOM_TEMP_EFFECTS, removeMirageOnNewRoom)

local function removeMirageOnClear(_)
    Isaac.CreateTimer(function()
        for _, pl in ipairs(PlayerManager:GetPlayers()) do
            ToyboxMod:setEntityData(pl, "MIRAGE_USES", 0)
            pl:AddCustomCacheTag("room-clear-retriggers", true)
        end
    end, 0, 1, false)
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PLAYER_TRIGGER_ROOM_CLEAR, removeMirageOnClear)
ToyboxMod:AddCallback(ModCallbacks.MC_POST_ROOM_TRIGGER_CLEAR, removeMirageOnClear)