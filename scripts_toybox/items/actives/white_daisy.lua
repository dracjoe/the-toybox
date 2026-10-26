local sfx = SFXManager()

local MAX_USES = 6

local ACTIVE_TEARS_UP = 2
local ACTIVE_DMG_UP = 2.5
local ACTIVE_RANGE_UP = 1.5
local ACTIVE_LUCK_UP = 4

local PASSIVE_DMG_UP = -1
local PASSIVE_LUCK_UP = -2

---@param player EntityPlayer
local function preUseWhiteDaisy(_, _, rng, player, flags, slot)
    local data = (slot==-1 and 0 or player:GetActiveItemDesc(slot).VarData)
    if(data>=MAX_USES) then return true end
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, preUseWhiteDaisy, ToyboxMod.COLLECTIBLE_WHITE_DAISY)

---@param player EntityPlayer
---@param slot ActiveSlot
local function useWhiteDaisy(_, _, rng, player, flags, slot)
    local data = (slot==-1 and 0 or player:GetActiveItemDesc(slot).VarData)
    if(slot~=-1) then
        local toAdd = 1
        player:SetActiveVarData(math.min(data+toAdd, MAX_USES), slot)

        data = math.min(data+toAdd, MAX_USES)
    end

    if(data > 0 and player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES)) then
        for _=1, data do
            player:AddWisp(ToyboxMod.COLLECTIBLE_WHITE_DAISY, player.Position)
        end
    end

    sfx:Play(SoundEffect.SOUND_THREAD_SNAP)

    return {
        Discharge = true,
        Remove = false,
        ShowAnim = true,
    }
end
ToyboxMod:AddCallback(ModCallbacks.MC_USE_ITEM, useWhiteDaisy, ToyboxMod.COLLECTIBLE_WHITE_DAISY)

---@param pl EntityPlayer
local function refreshWhiteDaisy(_, pl)
    if(pl.FrameCount==0) then return end

    for _, slot in pairs(ActiveSlot) do
        local data = pl:GetActiveItemDesc(slot)
        if(data.Item==ToyboxMod.COLLECTIBLE_WHITE_DAISY) then
            data.VarData = 0
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PLAYER_NEW_LEVEL, refreshWhiteDaisy)

---@param pl EntityPlayer
---@param slot EntitySlot
local function renderWhiteDaisy(_, pl, slot)
    local data = math.min(slot==-1 and 0 or pl:GetActiveItemDesc(slot).VarData, MAX_USES)

    return {CropOffset = Vector(32*data,0)}
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_ACTIVE_ITEM, renderWhiteDaisy, ToyboxMod.COLLECTIBLE_WHITE_DAISY)

---@param id CollectibleType
---@param pl EntityPlayer
local function removeWhiteDaisyCharge(_, id, pl, vardata, current)
    if(vardata>=MAX_USES) then
        return 0
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_PLAYER_GET_ACTIVE_MAX_CHARGE, removeWhiteDaisyCharge, ToyboxMod.COLLECTIBLE_WHITE_DAISY)

-- < BOOK OF VIRTUES > --

local function removeWisps()
    for _, ent in ipairs(Isaac.FindByType(3,FamiliarVariant.WISP,ToyboxMod.COLLECTIBLE_WHITE_DAISY)) do
        ent:Remove()
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, removeWisps)