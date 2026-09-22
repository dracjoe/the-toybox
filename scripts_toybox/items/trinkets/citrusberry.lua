local sfx = SFXManager()

ToyboxMod:setCropOffsetLogic(ToyboxMod.TRINKET_CITRUSBERRY, function(player)
    if(ToyboxMod:getEntityData(player, "CITRUSBERRY_TRIGGERED")) then
        return Vector(32,0)
    end
end)

---@param player Entity
local function healPlayer(_, player, _, flags, source)
    player = player:ToPlayer()
    if(not player:HasTrinket(ToyboxMod.TRINKET_CITRUSBERRY)) then return end

    if(not ToyboxMod:getEntityData(player, "CITRUSBERRY_TRIGGERED") and player:GetHearts()<player:GetEffectiveMaxHearts()/2) then
        local mult = player:GetTrinketMultiplier(ToyboxMod.TRINKET_CITRUSBERRY)
        local toheal = math.max(2, math.ceil(mult*player:GetEffectiveMaxHearts()/4))

        player:AddHearts(toheal)
        player:AddSoulHearts(2)

        sfx:Play(SoundEffect.SOUND_VAMP_GULP)

        ToyboxMod:setEntityData(player, "CITRUSBERRY_TRIGGERED", true)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, healPlayer, EntityType.ENTITY_PLAYER)

---@param pl EntityPlayer
local function refillFruits(_, pl)
    if(pl.FrameCount==0) then return end

    ToyboxMod:setEntityData(pl, "CITRUSBERRY_TRIGGERED", nil)
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PLAYER_NEW_LEVEL, refillFruits)