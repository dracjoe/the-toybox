--TODO: Make it increase enemy HP by 50% or smth

local sfx = SFXManager()

local CLEAR_RETRIGGERS = 1

---@param pl EntityPlayer
---@param val number
local function postEvaluateCustomCache(_, pl, flag, val)
    return val+pl:GetCollectibleNum(ToyboxMod.COLLECTIBLE_TAMMYS_TAIL)*CLEAR_RETRIGGERS
end
ToyboxMod:AddCallback(ModCallbacks.MC_EVALUATE_CUSTOM_CACHE, postEvaluateCustomCache, "room-clear-retriggers")

local function retriggerClear(_, _)
    if(not PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_TAMMYS_TAIL)) then return end

    sfx:Play(ToyboxMod.SFX_MEOW)
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_ROOM_TRIGGER_CLEAR, retriggerClear)

local function playerRetriggerClear(_, pl)
    if(not PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_TAMMYS_TAIL)) then return end

    sfx:Play(ToyboxMod.SFX_MEOW)
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PLAYER_TRIGGER_ROOM_CLEAR, playerRetriggerClear)