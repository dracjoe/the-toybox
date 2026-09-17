local SLOW_DURATION = 30*2
local SLOW_DURATION_MULT = 30*1
local SLOW_INTENSITY = 0.8
local SLOW_COLOR = Color(1,1.2,1.1,1,0.157,0.2,0.157)

---@param ent Entity
---@param ref EntityRef
local function slowEnemy(_, ent, amount, _, ref, _)
    if(not PlayerManager.AnyoneHasTrinket(ToyboxMod.TRINKET_CATNIP)) then return end

    local fam = ref.Entity
    if(fam and fam:ToFamiliar()) then
        fam = fam:ToFamiliar()
    elseif(fam and fam.SpawnerEntity and fam.SpawnerEntity:ToFamiliar()) then
            fam = fam.SpawnerEntity:ToFamiliar()
    elseif(fam and fam.Parent and fam.Parent:ToFamiliar()) then
        fam = fam.Parent:ToFamiliar()
    else
        return
    end

    if(fam and fam.Player:HasTrinket(ToyboxMod.TRINKET_CATNIP)) then
        local mult = PlayerManager.GetTotalTrinketMultiplier(ToyboxMod.TRINKET_CATNIP)

        local duration = SLOW_DURATION+(mult-1)*SLOW_DURATION_MULT

        ent:AddSlowing(EntityRef(fam.Player), -duration, SLOW_INTENSITY^(1+(mult-1)/3), SLOW_COLOR)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, slowEnemy)