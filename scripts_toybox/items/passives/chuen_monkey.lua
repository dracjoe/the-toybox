local sfx = SFXManager()

local ITEM_CLONES = 3
local STACK_CLONES = 1

---@param id CollectibleType
local function isItemValid(id)
    local conf = Isaac.GetItemConfig():GetCollectible(id)
    if(conf) then
        if(not (conf:HasTags(ItemConfig.TAG_QUEST))) then
            return true
        end
    end
    return false
end

---@param items CollectibleType[]
---@param rng RNG
local function getHighestQualityItem(items, rng)
    local conf = Isaac.GetItemConfig()
    local highestQual = -10000
    local highItems = {}

    for i, id in ipairs(items) do
        local iconf = conf:GetCollectible(id)
        if(iconf) then
            if(iconf.Quality>highestQual) then
                highestQual = iconf.Quality
                highItems = {i}
            elseif(iconf.Quality==highestQual) then
                table.insert(highItems, i)
            end
        end
    end

    return (#highItems==1 and highItems[1] or highItems[rng:RandomInt(1,#highItems)])
end

---@param pickup EntityPickup
---@param num integer
local function removeCycles(pickup, num)
    num = math.min(num or 0, #pickup:GetCollectibleCycle())
    if(num<=0) then return end

    local rng = pickup:GetDropRNG()

    local finalCycle = {pickup.SubType}
    for _, id in ipairs(pickup:GetCollectibleCycle()) do
        table.insert(finalCycle, id)
    end

    for _=1, num do
        local res = getHighestQualityItem(finalCycle, rng)
        table.remove(finalCycle, res)
    end

    pickup:RemoveCollectibleCycle()

    local hasOriginalItem = -1
    for i, id in ipairs(finalCycle) do
        if(id==pickup.SubType) then
            hasOriginalItem = i
            break
        end
    end

    if(hasOriginalItem==-1) then
        pickup:Morph(5,100,finalCycle[1],true,nil,true)
        hasOriginalItem = 1
    end
    for i, id in ipairs(finalCycle) do
        if(i~=hasOriginalItem) then
            pickup:AddCollectibleCycle(id)
        end
    end
end

local NO_DUPE = false

local MORPHED_ITEMS = {}

---@param pickup EntityPickup
local function dupeItem(_, pickup)
    if(not PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_CHUEN_MONKEY)) then return end

    if(NO_DUPE) then
        pickup:ClearEntityFlags(EntityFlag.FLAG_ITEM_SHOULD_DUPLICATE)

        return
    end

    if(MORPHED_ITEMS[GetPtrHash(pickup)]~=nil) then return end

    if(ToyboxMod.GAME:GetLevel():GetDimension()==Dimension.DEATH_CERTIFICATE) then return end

    local room = ToyboxMod.GAME:GetRoom()

    local shouldDupe = room:GetFrameCount()>=0 or (room:GetFrameCount()==-1 and room:IsFirstVisit())
    shouldDupe = shouldDupe and isItemValid(pickup.SubType)

    local extraData = ToyboxMod:getExtraDataTable()
    local toRemove

    if(shouldDupe) then
        toRemove = (extraData.CHUEN_MONKEY_TOREMOVE or 0)

        NO_DUPE = true

        local rng = pickup:GetDropRNG()

        local numClones = ITEM_CLONES+(PlayerManager.GetNumCollectibles(ToyboxMod.COLLECTIBLE_CHUEN_MONKEY)-1)*STACK_CLONES

        local worked = pickup:TryInitOptionCycle(numClones)
        if(not worked) then
            local pool = ToyboxMod.GAME:GetItemPool()
            for _=1, numClones do
                local itempool = room:GetItemPool(math.max(1,rng:Next()))
                if(itempool==ItemPoolType.POOL_NULL) then itempool = pool:GetLastPool() end

                local item = pool:GetCollectible(itempool, true)
                pickup:AddCollectibleCycle(item)
            end
        end

        NO_DUPE = false
    else
        local roomIdx = tostring(ToyboxMod.GAME:GetLevel():GetCurrentRoomDesc().SafeGridIndex)
        toRemove = (extraData.CHUEN_MONKEY_TOREMOVE or 0)-((extraData.CHUEN_MONKEY_REMOVED_PERROOM or {})[roomIdx] or 0)
    end

    if(shouldDupe) then
        removeCycles(pickup, toRemove or 0)
    else
        Isaac.CreateTimer(function()
            removeCycles(pickup, toRemove or 0)
        end, 0, 1, false)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, dupeItem, PickupVariant.PICKUP_COLLECTIBLE)

---@param pl EntityPlayer
local function tryEqualMonkeysPaw(_, pl)
    --if(not ToyboxMod.GAME:GetRoom():IsFirstVisit()) then return end
    if(not PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_CHUEN_MONKEY)) then return end

    local data = ToyboxMod:getExtraDataTable()
    data.CHUEN_MONKEY_REMOVED_PERROOM = (data.CHUEN_MONKEY_REMOVED_PERROOM or {})

    local idx = ToyboxMod.GAME:GetLevel():GetCurrentRoomDesc().SafeGridIndex
    data.CHUEN_MONKEY_REMOVED_PERROOM[tostring(idx)] = (data.CHUEN_MONKEY_TOREMOVE or 0)
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, tryEqualMonkeysPaw)

---@param pickup EntityPickup
local function invalidateMorphedItem(_, pickup, _, _, _, keepPrice, keepSeed, keepModifiers)
    if(pickup.Variant~=PickupVariant.PICKUP_COLLECTIBLE) then return end

    if(keepModifiers) then
        MORPHED_ITEMS[GetPtrHash(pickup)] = true
        Isaac.CreateTimer(function ()
            MORPHED_ITEMS[GetPtrHash(pickup)] = nil
        end,0,1,false)
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_PRE_PICKUP_MORPH, CallbackPriority.LATE, invalidateMorphedItem)

---@param id CollectibleType
---@param firstTime boolean
---@param pl EntityPlayer
local function curlMonkeyPawFinger(_, id, _, firstTime, _, _, pl)
    if(not pl:HasCollectible(ToyboxMod.COLLECTIBLE_CHUEN_MONKEY)) then return end
    if(not firstTime) then return end

    if(not isItemValid(id)) then return end
    if(id==ToyboxMod.COLLECTIBLE_CHUEN_MONKEY) then return end

    local data = ToyboxMod:getExtraDataTable()
    data.CHUEN_MONKEY_TOREMOVE = (data.CHUEN_MONKEY_TOREMOVE or 0)+1
    data.CHUEN_MONKEY_REMOVED_PERROOM = (data.CHUEN_MONKEY_REMOVED_PERROOM or {})

    local idx = ToyboxMod.GAME:GetLevel():GetCurrentRoomDesc().SafeGridIndex
    data.CHUEN_MONKEY_REMOVED_PERROOM[tostring(idx)] = (data.CHUEN_MONKEY_TOREMOVE or 0)

    for _, ent in ipairs(Isaac.FindByType(5,100)) do
        if(ent.SubType~=0) then
            removeCycles(ent:ToPickup(), 1)
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, curlMonkeyPawFinger)

---@param pl EntityPlayer
local function resetMonkeysPaw(_, pl)
    if(not ToyboxMod.GAME:GetRoom():IsFirstVisit()) then return end
    --if(not pl:HasCollectible(ToyboxMod.COLLECTIBLE_CHUEN_MONKEY)) then return end

    local curIdx = tostring(ToyboxMod.GAME:GetLevel():GetCurrentRoomDesc().SafeGridIndex)

    ToyboxMod:setExtraData("CHUEN_MONKEY_TOREMOVE", 0)
    ToyboxMod:setExtraData("CHUEN_MONKEY_REMOVED_PERROOM", {[curIdx]=0})
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, resetMonkeysPaw)