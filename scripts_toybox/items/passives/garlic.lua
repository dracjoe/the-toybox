local RANGE_DOWN = 1
local RANGE_MULT = 0.9

---@param player EntityPlayer
---@param flag CacheFlag
local function evalCache(_, player, flag)
    if(not player:HasCollectible(ToyboxMod.COLLECTIBLE_GARLIC)) then return end

    if(flag==CacheFlag.CACHE_TEARCOLOR) then
        player.TearColor = Color.TearScorpio
        player.LaserColor = Color.LaserPoison
    elseif(flag==CacheFlag.CACHE_TEARFLAG) then
        player.TearFlags = player.TearFlags | TearFlags.TEAR_POISON
    elseif(flag==CacheFlag.CACHE_RANGE) then
        local mult = player:GetCollectibleNum(ToyboxMod.COLLECTIBLE_GARLIC)

        --player.TearRange = player.TearRange-RANGE_DOWN*mult*40
        player.TearRange = player.TearRange*RANGE_MULT
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evalCache)

---@param entity Entity
---@param player EntityPlayer
local function pollTearflags(_, entity, player, weapon)
    if(player:HasCollectible(ToyboxMod.COLLECTIBLE_GARLIC)) then
        TearFlagsLib.AddTearFlags(entity, ToyboxMod.TEARFLAGS.POISON_AURA)

    end
end
ToyboxMod:AddCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, pollTearflags)
ToyboxMod:AddCallback(TearFlagsLib.Callback.POLL_CHANCELESS_TEARFLAGS, pollTearflags)

---@param pl EntityPlayer
local function cancelVampireEffect(_, pl)
    if(pl:HasCollectible(ToyboxMod.COLLECTIBLE_GARLIC)) then
        pl:SetCharmOfTheVampireKills(0)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, cancelVampireEffect)