---@param entity Entity
---@param player EntityPlayer
local function pollTearflags(_, entity, player, weapon)
    if(player:HasCollectible(ToyboxMod.COLLECTIBLE_MOMS_EYELINER)) then
        TearFlagsLib.AddTearFlags(entity, ToyboxMod.TEARFLAGS.SLOWING_AURA)
    end
end
ToyboxMod:AddCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, pollTearflags)
ToyboxMod:AddCallback(TearFlagsLib.Callback.POLL_CHANCELESS_TEARFLAGS, pollTearflags)