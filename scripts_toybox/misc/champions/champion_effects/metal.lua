local SHIELD_ADD = 10

---@param npc EntityNPC
local function addMetalArmor(_, npc)
    npc:SetShieldStrength(npc:GetShieldStrength()+SHIELD_ADD)
end
ToyboxMod:AddCallback(ToyboxMod.CUSTOM_CALLBACKS.POST_CUSTOM_CHAMPION_INIT, addMetalArmor, ToyboxMod.CUSTOM_CHAMPIONS.METAL.Idx)