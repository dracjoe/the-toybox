local SHIELD_ADD = 10

---@param npc EntityNPC
local function addMetalArmor(_, npc)
    npc:SetShieldStrength(npc:GetShieldStrength()+SHIELD_ADD)
end
ToyboxMod:AddCallback(ToyboxMod.CUSTOM_CALLBACKS.POST_CUSTOM_CHAMPION_INIT, addMetalArmor, ToyboxMod.CUSTOM_CHAMPIONS.METAL.Idx)

---@param npc EntityNPC
local function recursiveChampionDie(_, npc)
    local pos = ToyboxMod.GAME:GetRoom():FindFreePickupSpawnPosition(npc.Position,0)

    local heart = Isaac.Spawn(5,PickupVariant.PICKUP_HEART,HeartSubType.HEART_SOUL,pos,Vector.Zero,npc):ToPickup()
end
ToyboxMod:AddCallback(ToyboxMod.CUSTOM_CALLBACKS.POST_CUSTOM_CHAMPION_DEATH, recursiveChampionDie, ToyboxMod.CUSTOM_CHAMPIONS.METAL.Idx)