local HEAL_AMOUNT = 6*2

local FLIGHT_COSTUME = Isaac.GetCostumeIdByPath("gfx_tb/characters/costume_generic_wings.anm2")

---@param player EntityPlayer
local function triggerRevives(_, player)
    if(player:HasCollectible(ToyboxMod.COLLECTIBLE_REBIRTH)) then
        player:Revive()

        player:AddHearts(-99)
        player:AddSoulHearts(-99)
        player:AddHearts(math.min(player:GetEffectiveMaxHearts(), HEAL_AMOUNT))
        player:AddSoulHearts(math.max(0, HEAL_AMOUNT-player:GetHearts()))
        player:RemoveCollectible(ToyboxMod.COLLECTIBLE_REBIRTH)

        player:SetMinDamageCooldown(60*3)
        player:AddCollectibleEffect(ToyboxMod.COLLECTIBLE_REBIRTH, false)

        player:AddNullCostume(FLIGHT_COSTUME)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_TRIGGER_PLAYER_DEATH_POST_CHECK_REVIVES, triggerRevives)