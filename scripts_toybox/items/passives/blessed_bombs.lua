local EXPLOSION_TIME_MULT = 2

---@param pl EntityPlayer
---@param bomb EntityBomb
local function playerPlaceBomb(_, pl, bomb)
    if(not pl:HasCollectible(ToyboxMod.COLLECTIBLE_BLESSED_BOMBS)) then return end

    bomb:SetExplosionCountdown(math.floor(bomb:GetExplosionCountdown()*EXPLOSION_TIME_MULT))
    TearFlagsLib.AddTearFlags(bomb, ToyboxMod.TEARFLAGS.BOMB_BLESSED)
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PLAYER_USE_BOMB, playerPlaceBomb)
