local BLOCK_CHANCE = 1/3
local MAX_CHANCE = 1
local MAX_LUCK = 10

local BASE_CHANCE_PER_MULT = 1/6

local function prePlayerDamage(_, ent, dmg, flags, source)
    local player = ent and ent:ToPlayer()
    if(not (player and player:HasCollectible(ToyboxMod.COLLECTIBLE_BULLETPROOF_VEST) and source.Entity and source.Entity:ToProjectile())) then return end

    local mult = player:GetCollectibleNum(ToyboxMod.COLLECTIBLE_BULLETPROOF_VEST)
    local chance = ToyboxMod:lerp(BLOCK_CHANCE + (mult - 1) * BASE_CHANCE_PER_MULT, MAX_CHANCE, ToyboxMod:clamp(player.Luck / MAX_LUCK, 0, 1))
    if(player:GetCollectibleRNG(ToyboxMod.COLLECTIBLE_BULLETPROOF_VEST):RandomFloat() < chance) then
        return {
            Damage = dmg,
            DamageFlags = flags | DamageFlag.DAMAGE_FAKE,
            DamageCountdown = countdown,
        }
    else
        return {
            Damage = math.min(dmg, 1),
            DamageFlags = flags,
            DamageCountdown = countdown,
        }
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, prePlayerDamage, EntityType.ENTITY_PLAYER)