---@param npc EntityNPC
local function devolverChampionDie(_, npc)
    local room = ToyboxMod.GAME:GetRoom()
    room:SpawnGridEntity(room:GetGridIndex(npc.Position), GridEntityType.GRID_POOP, GridPoopVariant.NORMAL, npc:GetDropRNG():Next())

    local player = Isaac.GetPlayer()
    player:UseActiveItem(CollectibleType.COLLECTIBLE_D10, UseFlag.USE_NOANIM)

    ToyboxMod.SFX:Play(SoundEffect.SOUND_THE_D6_ROLL)
    ToyboxMod.SFX:Play(SoundEffect.SOUND_FART)
end
ToyboxMod:AddCallback(ToyboxMod.CUSTOM_CALLBACKS.POST_CUSTOM_CHAMPION_DEATH, devolverChampionDie, ToyboxMod.CUSTOM_CHAMPIONS.DEVOLVER.Idx)