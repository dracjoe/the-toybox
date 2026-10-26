

ToyboxMod.ABOX_ITEMS_ALPHABETICAL = {}
ToyboxMod.ABOX_ITEMS_INDEX = {}

local function alphabeticalSort(sortA, sortB)
    return string.lower(sortA[1])<string.lower(sortB[1])
end
local function gameLoaded(_, _)
    ToyboxMod.ABOX_ITEMS_ALPHABETICAL = {}
    ToyboxMod.ABOX_ITEMS_INDEX = {}

    local conf = Isaac.GetItemConfig()
    for i=1, conf:GetCollectibles().Size-1 do
        local item = conf:GetCollectible(i)
        if(item and item:IsAvailable() and not item.Hidden) then
            local name = item.Name
            local locName = Isaac.GetString("Items", item.Name)
            if(locName~="StringTable::InvalidKey") then name=locName end

            table.insert(ToyboxMod.ABOX_ITEMS_ALPHABETICAL, {name, item.ID})
        end
    end

    table.sort(ToyboxMod.ABOX_ITEMS_ALPHABETICAL, alphabeticalSort)
    for idx, itemDat in ipairs(ToyboxMod.ABOX_ITEMS_ALPHABETICAL) do
        ToyboxMod.ABOX_ITEMS_INDEX[itemDat[2]] = idx
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, gameLoaded)

function ToyboxMod:getNextAlphabetItem(val, reverseOrder)
    if(#ToyboxMod.ABOX_ITEMS_ALPHABETICAL==0) then gameLoaded() end

    local idx = ToyboxMod.ABOX_ITEMS_INDEX[val]
    if(not idx) then return -1 end

    local itemConfig = Isaac.GetItemConfig()

    local isOk = false
    while(not isOk) do
        isOk = true
        idx = idx+(reverseOrder and -1 or 1)

        if(ToyboxMod.ABOX_ITEMS_ALPHABETICAL[idx]) then
            local conf = itemConfig:GetCollectible(ToyboxMod.ABOX_ITEMS_ALPHABETICAL[idx][2])
            if(not conf) then isOk = false
            elseif(not conf:IsAvailable()) then isOk = false end
        else
            return -1
        end
    end

    return ToyboxMod.ABOX_ITEMS_ALPHABETICAL[idx][2]
end

local function getName(id)
    for key, i in pairs(CollectibleType) do
        if(i==id) then
            return key
        end
    end
    for key, i in pairs(ToyboxMod) do
        if(string.find(key, "COLLECTIBLE_")) then
            if(i==id) then
                return key
            end
        end
    end
    return "NO NAME :("
end

---@param player EntityPlayer
local function useAlphabetBox(_, id, rng, player, flags)
    for _, item in ipairs(Isaac.FindByType(5,100)) do
        item = item:ToPickup()
        if(item.SubType~=0) then
            local idx = ToyboxMod:getNextAlphabetItem(item.SubType)
            local shouldRemoveItem = true

            if(idx~=-1) then
                item:Morph(5,100,(idx or 0), true)
                local poof = Isaac.Spawn(1000,15,2,item.Position,Vector.Zero,item)

                shouldRemoveItem = false
            end

            if(shouldRemoveItem) then
                item:TryRemoveCollectible()
            end
        end
    end

    if(player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES)) then
        local conf = Isaac.GetItemConfig()
        for _, ent in ipairs(Isaac.FindByType(3,FamiliarVariant.WISP)) do
            if(ent:ToFamiliar() and GetPtrHash(ent:ToFamiliar().Player)==GetPtrHash(player)) then
                local idx = ent.SubType
                repeat
                    idx = ToyboxMod:getNextAlphabetItem(idx)
                until(idx==-1 or (conf:GetCollectible(idx) and conf:GetCollectible(idx):HasTags(ItemConfig.TAG_WISP)))

                if(idx==-1) then
                    idx = ToyboxMod:getRandomWisp(rng)
                end

                ent:Remove()
                player:AddWisp(idx, ent.Position)
            end
        end

        player:AddWisp(ToyboxMod:getRandomWisp(rng), player.Position)
    end

    return {
        Discharge = true,
        Remove = false,
        ShowAnim = true,
    }
end
ToyboxMod:AddCallback(ModCallbacks.MC_USE_ITEM, useAlphabetBox, ToyboxMod.COLLECTIBLE_ALPHABET_BOX)