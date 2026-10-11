local CURSE_CHANCE = 0.08
local CURSE_MAXCHANCE = 0.2
local CURSE_MAXLUCK = 24

---@param entity Entity
---@param player EntityPlayer
local function pollTearflags(_, entity, player, weapon)
    if(player:HasCollectible(ToyboxMod.COLLECTIBLE_RUNIC_SAP)) then
        local rng = player:GetCollectibleRNG(ToyboxMod.COLLECTIBLE_RUNIC_SAP)
        local chance = TearFlagsLib.GetChance(TearFlagsLib.GetRealLuck(player, entity), CURSE_CHANCE, CURSE_MAXCHANCE, CURSE_MAXLUCK, 1)
        --chance = math.min(chance*player:GetCollectibleNum(ToyboxMod.COLLECTIBLE_VAMPIRE_TEETH), BLEED_MAXCHANCE)

        if(rng:RandomFloat()<chance) then
            TearFlagsLib.AddTearFlags(entity, ToyboxMod.TEARFLAGS.RELIC)
        end
    end
end
ToyboxMod:AddCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, pollTearflags)