local RADIUS_MULT = 1.25
local BOMB_DAMAGE = 90

local MO_BOMBA_SUB = 15

---@param rng RNG
---@param player EntityPlayer
local function useMoBomba(_, _, rng, player, flags, slot)
    local bomb = Isaac.Spawn(4, BombVariant.BOMB_GOLDENTROLL, MO_BOMBA_SUB, player.Position, Vector.Zero, player):ToBomb()
    player:TryHoldEntity(bomb)

    if(slot~=-1) then
        player:DischargeActiveItem(slot)
    end

    return false
end
ToyboxMod:AddCallback(ModCallbacks.MC_USE_ITEM, useMoBomba, ToyboxMod.COLLECTIBLE_MO_BOMBA)

local function bombInit(_, bomb)
    if(bomb.SubType ~= MO_BOMBA_SUB) then return end

    bomb.ExplosionDamage = BOMB_DAMAGE
    bomb.RadiusMultiplier = bomb.RadiusMultiplier * RADIUS_MULT

    local player = bomb.SpawnerEntity and bomb.SpawnerEntity:ToPlayer()
    if(player) then
        bomb:AddTearFlags(player:GetBombFlags())

        Isaac.RunCallback(ModCallbacks.MC_POST_PLAYER_USE_BOMB, player, bomb)
    end

    local spr = bomb:GetSprite()
    spr:Load("gfx_tb/bombs/mo_bomba.anm2", true)
    while(spr:GetAnimation()=="Appear" and not spr:IsFinished()) do
        spr:Update()
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_BOMB_INIT, bombInit, BombVariant.BOMB_GOLDENTROLL)