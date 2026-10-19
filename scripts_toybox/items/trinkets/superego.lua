local REVIVE_CHANCE = 1/3

---@param npc EntityNPC
local function resummonOnKill(_, npc)
    if(not PlayerManager.AnyoneHasTrinket(ToyboxMod.TRINKET_SUPEREGO)) then return end
    if(npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) or not (npc:IsEnemy() and npc:IsActiveEnemy(true))) then return end

    local pl = PlayerManager.GetRandomTrinketOwner(ToyboxMod.TRINKET_SUPEREGO, npc:GetDropRNG():Next())
    if(npc.MaxHitPoints > pl.Damage) then return end

    local rng = pl:GetTrinketRNG(ToyboxMod.TRINKET_SUPEREGO)

    local mult = pl:GetTrinketMultiplier(ToyboxMod.TRINKET_SUPEREGO)

    if(rng:RandomFloat() < mult*REVIVE_CHANCE) then
        local newNpc = Isaac.Spawn(npc.Type, npc.Variant, npc.SubType, npc.Position, Vector.Zero, pl):ToNPC()
        newNpc:AddCharmed(EntityRef(pl), -1)

        newNpc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, resummonOnKill)