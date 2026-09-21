local NUM_BEGGARS = 3
local VALID_BEGGARS = {
    [SlotVariant.BEGGAR] =          {Weight=1},
    [SlotVariant.DEVIL_BEGGAR] =    {Weight=1},
    [SlotVariant.ROTTEN_BEGGAR] =   {Weight=1, Achievement=Achievement.ROTTEN_BEGGAR},
    [SlotVariant.BOMB_BUM] =        {Weight=1},
    [SlotVariant.BATTERY_BUM] =     {Weight=1},
    [SlotVariant.KEY_MASTER] =      {Weight=1},
}

local REPLACING_POOL = false
local GIVING_NEW_ITEM = false

local OVERLAY_IMAGE = Renderer.LoadImage("gfx_tb/slots/slot_overlay_brotherhood.png")

---@param slot EntitySlot
local function replaceBeggarSign(slot)
    local sprite = slot:GetSprite()
    local layer = sprite:GetLayer("Sign") or sprite:GetLayer(0)
    if(not layer) then return end

    local oldImg = sprite:GetSpritesheet(layer:GetLayerID())
    local newImg = Renderer.CreateImage(oldImg:GetWidth(), oldImg:GetHeight(), oldImg:GetName().."2")
    Renderer.RenderToImage(newImg,
        function()
            local brCorner = Vector(newImg:GetWidth(), newImg:GetHeight())
            local sQuad = ToyboxMod:makeQuadFromCorners(Vector(0,0), brCorner, true, false, false)
            local dQuad = ToyboxMod:makeQuadFromCorners(Vector(0,0), brCorner, false, false, false)

            oldImg:Render(sQuad, dQuad, KColor(1,1,1,1))

            local frame = sprite:GetLayerFrameData(layer:GetLayerID())
            if(frame) then
                local topRight = frame:GetCrop()
                local bottomRight = frame:GetCrop()+Vector(frame:GetWidth(), frame:GetHeight())

                OVERLAY_IMAGE:Render(
                    ToyboxMod:makeQuadFromCorners(Vector(0,0), Vector(1,1), true, true, false),
                    ToyboxMod:makeQuadFromCorners(topRight, bottomRight, false, false, false),
                    KColor(1,1,1,1)
                )
            end
        end
    )
    sprite:SetSpritesheet(layer:GetLayerID(), newImg)
end

---@param slot EntitySlot
local function slotInit(_, slot)
    if(not VALID_BEGGARS[slot.Variant]) then return end
    if(not (PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_BROTHERHOOD) and ToyboxMod.GAME:GetRoom():GetType()==RoomType.ROOM_ANGEL)) then return end

    replaceBeggarSign(slot)
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_SLOT_INIT, slotInit)

---@param pl EntityPlayer
local function replaceOnPickup(_, _, _, firstTime, _, _, pl)
    if(ToyboxMod.GAME:GetRoom():GetType()==RoomType.ROOM_ANGEL) then
        for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_SLOT)) do
            if(VALID_BEGGARS[ent.Variant]) then
                replaceBeggarSign(ent:ToSlot())
            end
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, replaceOnPickup, ToyboxMod.COLLECTIBLE_BROTHERHOOD)

local function spawnBeggars(_)
    local room = ToyboxMod.GAME:GetRoom()
    if(not (room:IsFirstVisit() and room:GetType()==RoomType.ROOM_ANGEL)) then return end
    if(not PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_BROTHERHOOD)) then return end

    local positions = {Vector(0,0),Vector(-80,-40),Vector(80,-40)}
    local beggarPicker = WeightedOutcomePicker()
    for id, data in pairs(VALID_BEGGARS) do
        if(not data.Achievement or Isaac.GetPersistentGameData():Unlocked(data.Achievement)) then
            beggarPicker:AddOutcomeFloat(id, data.Weight or 1, 100)
        end
    end

    local _, rng = PlayerManager.GetRandomCollectibleOwner(ToyboxMod.COLLECTIBLE_BROTHERHOOD, room:GetSpawnSeed())

    local centerPos = room:GetCenterPos()
    for _, pos in ipairs(positions) do
        local finalPos = room:FindFreePickupSpawnPosition(pos+centerPos, 0, true, false)
        local var = beggarPicker:PickOutcome(rng)
        beggarPicker:RemoveOutcome(var)

        local beggar = Isaac.Spawn(EntityType.ENTITY_SLOT,var,0,finalPos,Vector.Zero,nil):ToSlot()
        beggar:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
    end

    ToyboxMod:setExtraData("BROTHERHOOD_ENTERED_ANGEL", true)
    ToyboxMod.GAME:GetLevel():AddAngelRoomChance(100)
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, spawnBeggars)


local function replacePool(_, slot)
    if(not VALID_BEGGARS[slot.Variant]) then return end
    if(not (PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_BROTHERHOOD) and ToyboxMod.GAME:GetRoom():GetType()==RoomType.ROOM_ANGEL)) then return end

    if(slot:GetSprite():IsEventTriggered("Prize")) then
        REPLACING_POOL = true
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_PRE_SLOT_UPDATE, CallbackPriority.LATE+1, replacePool)

local function makePayoutUmmmmmmmm(_, slot)
    if(not VALID_BEGGARS[slot.Variant]) then return end
    if(not (PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_BROTHERHOOD) and ToyboxMod.GAME:GetRoom():GetType()==RoomType.ROOM_ANGEL)) then return end

    if(slot:GetDonationValue()<4) then
        slot:SetDonationValue(slot:GetDropRNG():RandomInt(4,5))
    end
    REPLACING_POOL = false
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, makePayoutUmmmmmmmm)

local function preGetCollectible(_, pool, decrease, seed)
    if(REPLACING_POOL) then
        local rng = ToyboxMod:generateRng(seed)
        local itempool = Game():GetItemPool()
        local angelPool = itempool:GetPoolForRoom(RoomType.ROOM_ANGEL, rng:Next())

        REPLACING_POOL = false
        local item = itempool:GetCollectible(angelPool, decrease, rng:Next(), CollectibleType.COLLECTIBLE_NULL)
        REPLACING_POOL = true
        return item
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_GET_COLLECTIBLE, preGetCollectible)


local function forceOpened(_)
    if(ToyboxMod:getExtraData("BROTHERHOOD_ENTERED_ANGEL")) then
        return 2
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_DEVIL_CALCULATE, forceOpened)

local function resetAngel(_)
    if(not ToyboxMod.GAME:GetRoom():IsFirstVisit()) then return end

    ToyboxMod:setExtraData("BROTHERHOOD_ENTERED_ANGEL", false)
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_LEVEL, CallbackPriority.IMPORTANT-1, resetAngel)