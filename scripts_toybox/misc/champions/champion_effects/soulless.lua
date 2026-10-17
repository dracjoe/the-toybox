---@param npc EntityNPC
local function soullessChampionDie(_, npc)
    local swirl = Isaac.Spawn(1000, EffectVariant.ENEMY_BRIMSTONE_SWIRL, 0, npc.Position, Vector.Zero, nil)
end
ToyboxMod:AddCallback(ToyboxMod.CUSTOM_CALLBACKS.POST_CUSTOM_CHAMPION_DEATH, soullessChampionDie, ToyboxMod.CUSTOM_CHAMPIONS.SOULLESS.Idx)