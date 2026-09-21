local GIVE_ITEM_CHANCE = 0.66

local PICKER_WEIGHT_MULTS = {
    [CollectibleType.COLLECTIBLE_THE_NAIL] = 0.25,
    [CollectibleType.COLLECTIBLE_MONSTER_MANUAL] = 0,
    [CollectibleType.COLLECTIBLE_FRIEND_BALL] = 0,
    [CollectibleType.COLLECTIBLE_DELIRIOUS] = 0,
    [CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES] = 0,
    [CollectibleType.COLLECTIBLE_LARYNX] = 0,
    [CollectibleType.COLLECTIBLE_MEGA_MUSH] = 0.25,
    [CollectibleType.COLLECTIBLE_ERASER] = 0,
    [CollectibleType.COLLECTIBLE_URN_OF_SOULS] = 0,
    [CollectibleType.COLLECTIBLE_FRIEND_FINDER] = 0,
    [CollectibleType.COLLECTIBLE_BERSERK] = 0,

    [CollectibleType.COLLECTIBLE_PONY] = 0, -- removes flight mid charge which looks weird
    [CollectibleType.COLLECTIBLE_WHITE_PONY] = 0, -- ditto
    [CollectibleType.COLLECTIBLE_SPIN_TO_WIN] = 0, -- weird

    [ToyboxMod.COLLECTIBLE_WHITE_DAISY] = 0.1,
    [ToyboxMod.COLLECTIBLE_BIG_RED_BUTTON] = 0.5,
    [ToyboxMod.COLLECTIBLE_PUGGYS_CLAW] = 0, -- removed because it takes a while to startup?
    [ToyboxMod.COLLECTIBLE_SNAKE_RING] = 0, -- removed because it takes a while to startup?
    [ToyboxMod.COLLECTIBLE_LAB_MEAT] = 0.1,
    [ToyboxMod.COLLECTIBLE_HAND_PUMP] = 0.5, -- lowered cuz its kind of useless
    [ToyboxMod.COLLECTIBLE_BLUE_WHALE] = 0.5, -- lowered because its just a free 1.5x dmg
    [ToyboxMod.COLLECTIBLE_BREAKTHROUGH] = 0, -- removed for giving bonus that lasts outside the current room

    --[ToyboxMod.COLLECTIBLE_MELTED_CANDLE] = 10000,
    --[CollectibleType.COLLECTIBLE_CANDLE] = 10000,
}
local ZEROCHARGE_WEIGHT = 1/1.5

local TIMED_WEIGHT = 1/1.5
local TIMED_BASELINE = 2

local WEIGHT_POW = 1


local ACTIVE_PICKER = WeightedOutcomePicker()

local iconf = Isaac.GetItemConfig()
for id, _ in pairs(ToyboxMod.COMBAT_ACTIVES) do
    local conf = iconf:GetCollectible(id)

    local weightMod = PICKER_WEIGHT_MULTS[id] or 1
    if(conf.MaxCharges==0) then
        weightMod = weightMod*ZEROCHARGE_WEIGHT^WEIGHT_POW
    elseif(conf.ChargeType==ItemConfig.CHARGE_NORMAL) then
        weightMod = weightMod*(1/conf.MaxCharges)^WEIGHT_POW
    elseif(conf.ChargeType==ItemConfig.CHARGE_TIMED) then
        local charges = conf.MaxCharges/30
        weightMod = weightMod*(1/math.max(1, charges-(TIMED_BASELINE-1)))^WEIGHT_POW

        weightMod = weightMod*TIMED_WEIGHT^WEIGHT_POW
    end

    if(conf.ChargeType==ItemConfig.CHARGE_SPECIAL or conf.Hidden) then
        weightMod = 0
    end

    if(weightMod~=0) then
        ACTIVE_PICKER:AddOutcomeFloat(id, weightMod, 1000)
    end
end

---@param pl EntityPlayer
local function tryGiveBladeItem(_, pl)
    if(not pl:HasCollectible(ToyboxMod.COLLECTIBLE_HIDDEN_BLADE)) then return end
    if(ToyboxMod.GAME:GetRoom():IsClear()) then return end

    local rng = pl:GetCollectibleRNG(ToyboxMod.COLLECTIBLE_HIDDEN_BLADE)
    local mult = pl:GetCollectibleNum(ToyboxMod.COLLECTIBLE_HIDDEN_BLADE)
    if(rng:RandomFloat()<GIVE_ITEM_CHANCE^(1/mult)) then
        local pickedId = ACTIVE_PICKER:PickOutcome(rng)
        ToyboxMod:setEntityData(pl, "CANCEL_PICKUP_LOGIC", pickedId)
        pl:SetPocketActiveItem(pickedId, ActiveSlot.SLOT_POCKET2, true)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PLAYER_NEW_ROOM_TEMP_EFFECTS, tryGiveBladeItem)

---@param id CollectibleType
---@param charge integer
---@param firstTime boolean
---@param slot ActiveSlot
---@param vardata number
---@param pl EntityPlayer
local function makeAddedItemFirstTime(_, id, charge, firstTime, slot, vardata, pl)
    if(firstTime and slot==ActiveSlot.SLOT_POCKET2 and ToyboxMod:getEntityData(pl, "CANCEL_PICKUP_LOGIC")==id) then
        ToyboxMod:setEntityData(pl, "CANCEL_PICKUP_LOGIC", nil)
        return {id, charge, false, slot, var}
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_ADD_COLLECTIBLE, makeAddedItemFirstTime)

---@param id CollectibleType
---@param removed boolean
---@param pl EntityPlayer
---@param slot ActiveSlot
local function dischargeActive(_, id, removed, pl, slot)
    if(ToyboxMod.COMBAT_ACTIVES[id] and ToyboxMod:getEntityData(pl, "REMOVE_ON_DISCHARGE")) then
        for i=0,3 do
            local pocketitem = pl:GetPocketItem(i)
            if(pocketitem:GetType()==PocketItemType.ACTIVE_ITEM and pocketitem:GetSlot()==(ActiveSlot.SLOT_POCKET2+1)) then
                if(pl:GetActiveItem(ActiveSlot.SLOT_POCKET2)==id) then
                    pl:SetPocketActiveItem(0, ActiveSlot.SLOT_POCKET2, true)
                    break
                end
            end
        end
        ToyboxMod:setEntityData(pl, "REMOVE_ON_DISCHARGE", nil)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_DISCHARGE_ACTIVE_ITEM, dischargeActive)

---@param player EntityPlayer
local function tryUseHeldCandle(_, player)
    ToyboxMod:setEntityData(player, "FAKE_FRAMECOUNT", (ToyboxMod:getEntityData(player, "FAKE_FRAMECOUNT") or 0)+1)

    if(not ToyboxMod.COMBAT_ACTIVES[player:GetItemState()]) then return end
    if(player:GetActiveItem(ActiveSlot.SLOT_POCKET2)~=player:GetItemState()) then return end

    local input = player:GetShootingInput()
    if(input:LengthSquared()==0 and Options.MouseControl and Input.IsMouseBtnPressed(MouseButton.LEFT)) then
        input = (Input.GetMousePosition(true)-player.Position):Normalized()
    end

    if(player:CanShoot() and input:LengthSquared()>0) then
        --if(player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)~=0) then
        local desc = player:GetActiveItemDesc(ActiveSlot.SLOT_PRIMARY)
        ToyboxMod:setEntityData(player, "ORIGINAL_SLOT1", {
            Item = desc.Item,
            Charge = desc.Charge,
            BatteryCharge = desc.BatteryCharge,
            PartialCharge = desc.PartialCharge,
            SubCharge = desc.SubCharge,
            TimedRechargeCooldown = desc.TimedRechargeCooldown,
            VarData = desc.VarData,
        })
        --end
        local oldDesc = player:GetActiveItemDesc(ActiveSlot.SLOT_PRIMARY)
        oldDesc.Item = player:GetItemState()
        oldDesc.VarData = 1

        ToyboxMod:setEntityData(player, "REMOVE_ON_DISCHARGE", true)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_PLAYER_UPDATE, tryUseHeldCandle)

---@param player EntityPlayer
local function asdasdasd(_, player)
    if(not ToyboxMod:getEntityData(player, "ORIGINAL_SLOT1")) then return end

    local data = ToyboxMod:getEntityData(player, "ORIGINAL_SLOT1")
    local desc = player:GetActiveItemDesc(ActiveSlot.SLOT_PRIMARY)
    desc.Item = data.Item
    desc.Charge = data.Charge
    desc.BatteryCharge = data.BatteryCharge
    desc.PartialCharge = data.PartialCharge
    desc.SubCharge = data.SubCharge
    desc.TimedRechargeCooldown = data.TimedRechargeCooldown
    desc.VarData = data.VarData

    local conf = iconf:GetCollectible(data.Item)
    if(conf) then
        local ischargeframe = (ToyboxMod:getEntityData(player, "FAKE_FRAMECOUNT") or 0)%2==0
        if(conf.ChargeType==ItemConfig.CHARGE_TIMED and ischargeframe) then
            desc.Charge = math.min(desc.Charge+1, player:GetActiveMaxCharge(ActiveSlot.SLOT_PRIMARY))
        end
    end

    ToyboxMod:setEntityData(player, "ORIGINAL_SLOT1", nil)
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, CallbackPriority.LATE, asdasdasd)