local FIRE_DMG = 12

---@param player EntityPlayer
local function useMeltedCandle(_, _, rng, player, flags)
    if(player:GetItemState()==ToyboxMod.COLLECTIBLE_MELTED_CANDLE) then
        player:SetItemState(0)
        player:AnimateCollectible(ToyboxMod.COLLECTIBLE_MELTED_CANDLE, "HideItem")
    else
        player:SetItemState(ToyboxMod.COLLECTIBLE_MELTED_CANDLE)
        player:AnimateCollectible(ToyboxMod.COLLECTIBLE_MELTED_CANDLE, "LiftItem")
    end

    return {
        Discharge = false,
        Remove = false,
        ShowAnim = false,
    }
end
ToyboxMod:AddCallback(ModCallbacks.MC_USE_ITEM, useMeltedCandle, ToyboxMod.COLLECTIBLE_MELTED_CANDLE)

---@param player EntityPlayer
local function tryUseHeldCandle(_, player)
    if(player:GetItemState()~=ToyboxMod.COLLECTIBLE_MELTED_CANDLE) then return end

    if(player:GetAimDirection():Length()>0) then
        local dir = (player:GetAimDirection():Length()<0.01 and player.Velocity or player:GetAimDirection())
        local helper = Isaac.Spawn(EntityType.ENTITY_EFFECT, ToyboxMod.EFFECT_FLAME_BREATH_HELPER, 0, player.Position, dir, player):ToEffect()
        helper.CollisionDamage = FIRE_DMG

        player:DischargeActiveItem(ActiveSlot.SLOT_PRIMARY)
        player:AnimateCollectible(ToyboxMod.COLLECTIBLE_MELTED_CANDLE, "HideItem")
        player:SetItemState(0)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, tryUseHeldCandle)

-- < BOOK OF VIRTUES > --

local function removeWisps()
    for _, ent in ipairs(Isaac.FindByType(3,FamiliarVariant.WISP,ToyboxMod.COLLECTIBLE_MELTED_CANDLE)) do
        ent:Remove()
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, removeWisps)