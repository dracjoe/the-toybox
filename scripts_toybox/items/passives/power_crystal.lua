local KNOCKBACK_ADD = 0.7

---@param player EntityPlayer
local function postAddItem(_, _, _, firstTime, slot, vData, player)
    if(firstTime~=true) then return end

    for i=ActiveSlot.SLOT_PRIMARY, ActiveSlot.SLOT_POCKET2 do
        if(player:GetActiveItem(i)~=0) then
            local conf = Isaac.GetItemConfig():GetCollectible(player:GetActiveItem(i))
            if(conf and conf.ChargeType==ItemConfig.CHARGE_NORMAL) then
                player:AddActiveCharge(player:GetActiveMaxCharge(i)*2, i, true, true, true)
            end
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, postAddItem, ToyboxMod.COLLECTIBLE_POWER_CRYSTAL)

---@param pl EntityPlayer
---@param params TearParams
local function tryAddFlags(_, pl, params, weap, dmg, tearDisp, source)
    if(not pl:HasCollectible(ToyboxMod.COLLECTIBLE_POWER_CRYSTAL)) then return end

    params.KnockbackMultiplier = params.KnockbackMultiplier*(1+KNOCKBACK_ADD*pl:GetCollectibleNum(ToyboxMod.COLLECTIBLE_POWER_CRYSTAL))
end
ToyboxMod:AddCallback(ModCallbacks.MC_EVALUATE_TEAR_HIT_PARAMS, tryAddFlags)