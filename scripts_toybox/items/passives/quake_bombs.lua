local FETUS_QUAKE_CHANCE = 0.25

---@param pl EntityPlayer
---@param bomb EntityBomb
local function placeQuakeBomb(_, pl, bomb)
    if(pl:HasCollectible(ToyboxMod.COLLECTIBLE_QUAKE_BOMBS)) then
        TearFlagsLib.AddTearFlags(bomb, ToyboxMod.TEARFLAGS.BOMB_QUAKE)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PLAYER_USE_BOMB, placeQuakeBomb)

---@param entity Entity
---@param player EntityPlayer
local function pollTearflags(_, entity, player, weapon)
    if(player:HasCollectible(ToyboxMod.COLLECTIBLE_QUAKE_BOMBS)) then
        local rng = player:GetCollectibleRNG(ToyboxMod.COLLECTIBLE_QUAKE_BOMBS)
        if(rng:RandomFloat()<FETUS_QUAKE_CHANCE) then
            TearFlagsLib.AddTearFlags(entity:ToBomb(), ToyboxMod.TEARFLAGS.BOMB_QUAKE)
        end
    end
end
ToyboxMod:AddCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, pollTearflags, TearFlagsLib.WeaponFlag.DR_FETUS)