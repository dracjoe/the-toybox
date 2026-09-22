
local modName = "Toybox"

if(not EID) then return end

include("scripts_toybox.modcompat.eid.descriptions")
local STORED = require("scripts_toybox.modcompat.eid.stored")

--#region POOL LOGIC
local pools = {
    [ToyboxMod.POOL_GRAVEYARD] = {
        "Graveyard", STORED.CONSTANTS.Icon_PoolGraveyard
    },
}

for i, pooldata in pairs(pools) do
    EID:addItemPoolName(i, pooldata[1])
    EID:assignItemPoolMarkup(i, pooldata[2])
end

--#endregion

--#region TRANSFORMATION LOGIC
local transformationTagToId = {}

for _, tData in pairs(ToyboxMod.TRANSFORMATIONS) do
    local tId = "Toybox"..tData.EIDName.."Transformation"
    EID:createTransformation(tId, tData.StreakName)
    if(tData.NumReq and tData.NumReq~=3) then
        EID.TransformationData[tId] = {NumNeeded=tData.NumReq}
    end

    if(tData.CustomTag) then
        transformationTagToId[tData.CustomTag] = tId
    end
    if(tData.VanillaItems) then
        for _, id in ipairs(tData.VanillaItems) do
            EID:assignTransformation("collectible", id, tId)
        end
    end
end

local iconf = Isaac.GetItemConfig()
for id=1, iconf:GetCollectibles().Size-1 do
    local conf = iconf:GetCollectible(id)
    if(conf) then
        for tag, tId in pairs(transformationTagToId) do
            if(conf:HasCustomTag(tag)) then
                EID:assignTransformation("collectible", id, tId)
            end
        end
    end
end
--#endregion

local function getTypeMatchFunction(itemType, itemId)
    if(itemType==PickupVariant.PICKUP_COLLECTIBLE) then
        return function(descObj)
            return (descObj.ObjType==5 and descObj.ObjVariant==100 and descObj.ObjSubType==itemId)
        end
    elseif(itemType==PickupVariant.PICKUP_TRINKET) then
        return function(descObj)
            return (descObj.ObjType==5 and descObj.ObjVariant==350 and (descObj.ObjSubType & ~TrinketType.TRINKET_GOLDEN_FLAG)==itemId)
        end
    elseif(itemType==PickupVariant.PICKUP_PILL) then
        return function(descObj)
            return (descObj.ObjType==5 and descObj.ObjVariant==70 and ToyboxMod.GAME:GetItemPool():GetPillEffect(descObj.ObjSubType)==itemId)
        end
    elseif(itemType==PickupVariant.PICKUP_TAROTCARD) then
        return function(descObj)
            return (descObj.ObjType==5 and descObj.ObjVariant==300 and descObj.ObjSubType==itemId)
        end
    else
        return function(descObj)
            return false
        end
    end
end

---@param modifier table
---@param icon string?
---@param color string?
---@param baseCondition function?
local function formatModifier(modifier, icon, color, baseCondition)
    local newModifier = ToyboxMod:cloneTable(modifier)
    newModifier.Type = newModifier.Type or STORED.CONSTANTS.DescriptionModifier.APPEND
    --newModifier.Condition = newModifier.Condition or function(descObj) return true end
    if(baseCondition) then
        newModifier.Condition = newModifier.Condition
                                and function(descObj) return newModifier.Condition(descObj) and baseCondition(descObj) end
                                or baseCondition
    else
        newModifier.Condition = newModifier.Condition or function(descObj) return true end
    end

    if((icon or color) and not newModifier.IgnoreMarkup) then
        if(type(newModifier.ToModify)~="function") then
            for i, text in ipairs(newModifier.ToModify) do
                if(newModifier.Type==STORED.CONSTANTS.DescriptionModifier.REPLACE) then
                    text[2] = string.gsub(text[2], "{{CR}}", "{{CR}}"..(color or ""))
                    if(modifier.ColorOverride~=false) then
                        text[2] = (color or "")..text[2]..(color and "{{CR}}" or "")
                    end
                    text[2] = (icon and (icon.." ") or "")..text[2]

                    newModifier.ToModify[i] = text
                else
                    text = string.gsub(text, "{{CR}}", "{{CR}}"..(color or ""))
                    if(modifier.ColorOverride~=false) then
                        text = (color or "")..text..(color and "{{CR}}" or "")
                    end
                    text = (icon and (icon.." ") or "")..text

                    newModifier.ToModify[i] = text
                end
            end
        end
    end

    return newModifier
end

local function applyModifier(descObj, modifier)
    if(modifier.Condition(descObj)) then
        if(modifier.Type==STORED.CONSTANTS.DescriptionModifier.APPEND or modifier.Type==STORED.CONSTANTS.DescriptionModifier.APPEND_TOP) then
            local toAdd
            if(type(modifier.ToModify)=="function") then
                toAdd = STORED.FUNCTIONS.StringTableToDescription(modifier.ToModify(descObj))
            else
                toAdd = STORED.FUNCTIONS.StringTableToDescription(modifier.ToModify)
            end

            if(modifier.Type==STORED.CONSTANTS.DescriptionModifier.APPEND) then
                descObj.Description = descObj.Description.."#"..toAdd
            else
                descObj.Description = toAdd.."#"..descObj.Description
            end
        elseif(modifier.Type==STORED.CONSTANTS.DescriptionModifier.REPLACE) then
            if(type(modifier.ToModify)=="function") then
                descObj.Description = modifier.ToModify(descObj, descObj.Description)
            else
                for _, modifyTexts in ipairs(modifier.ToModify) do
                    descObj.Description = string.gsub(descObj.Description, modifyTexts[1], modifyTexts[2])
                end
            end
        end
    end
end

local function addDescriptionModifiers(itemType, itemId, modifiers)
    local matchFunc = getTypeMatchFunction(itemType, itemId)

    local finalCondition = function(descObj)
        if(not matchFunc(descObj)) then return false end

        for _, modifier in ipairs(modifiers) do
            if(modifier.Condition(descObj)) then
                return true
            end
        end
        return false
    end

    EID:addDescriptionModifier(
        tostring(modName).." "..tostring(itemType).." "..tostring(itemId).." MODIFIER",
        finalCondition,
        function(descObj)
            for _, modifier in ipairs(modifiers) do
                applyModifier(descObj, modifier)
            end

            return descObj
        end
    )
end

local BOVModifiers = {}

for id, data in pairs(STORED.ITEMS) do
    if(data.Description) then
        EID:addCollectible(id, STORED.FUNCTIONS.StringTableToDescription(data.Description), data.Name or "", "en_us")
    end

    local modifiersToAdd = {}
    if(data.Modifiers) then
        for _, modifier in ipairs(data.Modifiers) do
            table.insert(modifiersToAdd, formatModifier(modifier))
        end
    end
    for modifierName, modifierData in pairs(STORED.CONSTANTS.ModifierFunctionKey) do
        if(data[modifierName]) then
            local color = modifierData[3]
            for _, modifier in ipairs(data[modifierName]) do
                table.insert(
                    modifiersToAdd,
                    formatModifier(modifier, modifierData[2], color, STORED.CONSTANTS.ModifierCondition[modifierData[1]])
                )
            end
        end
    end

    if(data.WispProperties) then
        local layer = ToyboxMod:clamp(data.WispProperties.Layer, -1, 2)
        local amount = data.WispProperties.Amount or 1
        local health = data.WispProperties.HP or 2
        local dmg = data.WispProperties.Damage

        local ringIcon = STORED.CONSTANTS.WispRingIcons[layer] or STORED.CONSTANTS.WispRingIcons[1]

        local baseDataText = "{{VirtuesCollectible"..id.."}} "..ringIcon.."{{Wisp}} "..(amount~=0 and tostring(amount) or "").."|{{Heart}} "..tostring(health).."|{{Damage}} "..tostring(dmg)

        local wispText = {
            Type = STORED.CONSTANTS.DescriptionModifier.APPEND,
            Condition = nil,
            ToModify = {
                baseDataText,
            }
        }

        if(data.WispProperties.Description) then
            for _, str in ipairs(data.WispProperties.Description) do
                table.insert(wispText.ToModify, str)
            end
        end

        table.insert(
            modifiersToAdd, formatModifier(wispText, nil, "{{ColorPastelBlue}}", STORED.CONSTANTS.ModifierCondition.Virtues)
        )
        table.insert(
            BOVModifiers, formatModifier(wispText, nil, "{{ColorPastelBlue}}", STORED.CONSTANTS.ModifierCondition.VirtuesItem(id))
        )
    end

    if(modifiersToAdd[1]) then
        addDescriptionModifiers(PickupVariant.PICKUP_COLLECTIBLE, id, modifiersToAdd)
    end
end

addDescriptionModifiers(PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES, BOVModifiers)

for id, data in pairs(STORED.TRINKETS) do
    if(data.Description) then
        EID:addTrinket(id, STORED.FUNCTIONS.StringTableToDescription(data.Description), data.Name or "", "en_us")
    end

    local modifiersToAdd = {}
    if(data.Modifiers) then
        for _, modifier in ipairs(data.Modifiers) do
            table.insert(modifiersToAdd, formatModifier(modifier))
        end
    end
    for modifierName, modifierData in pairs(STORED.CONSTANTS.ModifierFunctionKey) do
        if(data[modifierName]) then
            for _, modifier in ipairs(data[modifierName]) do
                table.insert(
                    modifiersToAdd,
                    formatModifier(modifier, modifierData[2], modifierData[3], STORED.CONSTANTS.ModifierCondition[modifierData[1]])
                )
            end
        end
    end

    if(modifiersToAdd[1]) then
        addDescriptionModifiers(PickupVariant.PICKUP_TRINKET, id, modifiersToAdd)
    end
end

for id, data in pairs(STORED.PILLS) do
    if(data.Description) then
        EID:addPill(id, STORED.FUNCTIONS.StringTableToDescription(data.Description), data.Name or "", "en_us")

        local pill = iconf:GetPillEffect(id)
        EID:addPillMetadata(id, pill.MimicCharge, tostring(pill.EffectClass)..(pill.EffectSubClass>0 and (pill.EffectSubClass==2 and "-" or "+") or ""))
    end

    local modifiersToAdd = {}
    if(data.Modifiers) then
        for _, modifier in ipairs(data.Modifiers) do
            table.insert(modifiersToAdd, formatModifier(modifier))
        end
    end
    for modifierName, modifierData in pairs(STORED.CONSTANTS.ModifierFunctionKey) do
        if(data[modifierName]) then
            for _, modifier in ipairs(data[modifierName]) do
                table.insert(
                    modifiersToAdd,
                    formatModifier(modifier, modifierData[2], modifierData[3], STORED.CONSTANTS.ModifierCondition[modifierData[1]])
                )
            end
        end
    end

    if(modifiersToAdd[1]) then
        addDescriptionModifiers(PickupVariant.PICKUP_PILL, id, modifiersToAdd)
    end
end

for id, data in pairs(STORED.CARDS) do
    if(data.Description) then
        EID:addCard(id, STORED.FUNCTIONS.StringTableToDescription(data.Description), data.Name or "", "en_us")

        local card = iconf:GetCard(id)
        EID:addCardMetadata(id, card.MimicCharge, card:IsRune())
    end

    local modifiersToAdd = {}
    if(data.Modifiers) then
        for _, modifier in ipairs(data.Modifiers) do
            table.insert(modifiersToAdd, formatModifier(modifier))
        end
    end
    for modifierName, modifierData in pairs(STORED.CONSTANTS.ModifierFunctionKey) do
        if(data[modifierName]) then
            for _, modifier in ipairs(data[modifierName]) do
                table.insert(
                    modifiersToAdd,
                    formatModifier(modifier, modifierData[2], modifierData[3], STORED.CONSTANTS.ModifierCondition[modifierData[1]])
                )
            end
        end
    end

    if(modifiersToAdd[1]) then
        addDescriptionModifiers(PickupVariant.PICKUP_TAROTCARD, id, modifiersToAdd)
    end
end

for id, data in pairs(STORED.PLAYERS) do
    if(data.Description) then
        EID.descriptions["en_us"].CharacterInfo[id] = {data.Name, STORED.FUNCTIONS.StringTableToDescription(data.Description)}
    end
    if(data.BirthrightDescription) then
        EID:addBirthright(id, STORED.FUNCTIONS.StringTableToDescription(data.BirthrightDescription))
    end
end

for id, data in pairs(STORED.GLOBAL_MODIFIERS) do
    EID:addDescriptionModifier(
        tostring(modName).." "..tostring(id).." MODIFIER",
        function(descObj)
            for _, modifier in ipairs(data.Modifiers) do
                if(modifier.Condition(descObj)) then
                    return true
                end
            end
            return false
        end,
        function(descObj)
            for _, modifier in ipairs(data.Modifiers) do
                applyModifier(descObj, formatModifier(modifier, nil, nil))
            end

            return descObj
        end
    )
end

local function createEIDCategory(data)
    local descGen = function(player)
        if(data.Condition(player)) then
            local desc = data.Description(player)

            for _, descData in ipairs(desc) do
                EID:ItemReminderAddTempDescriptionEntry(
                    descData.Icon,
                    descData.Title,
                    type(descData.Desc)=="table" and STORED.FUNCTIONS.StringTableToDescription(descData.Desc) or descData.Desc,
                    descData.ObjID
                )
            end
        end
    end

    return {
        id = data.ID,
        entryGenerators = {descGen},
        hideInOverview = function ()
            return not data.ShowInOverview
        end,
    }
end

local categoryPriority = {}
for id, data in pairs(STORED.CATEGORIES) do
    table.insert(categoryPriority, {ID=id, Priority=(data.Priority or 0)})
end
table.sort(categoryPriority, function(a,b) return a.Priority>b.Priority end)

for _, data in ipairs(categoryPriority) do
    local catData = STORED.CATEGORIES[data.ID]

    local created

    for k, v in ipairs(EID.ItemReminderCategories) do
        if v.id == catData.ID then
            EID.ItemReminderCategories[k] = createEIDCategory(catData)
            created = true
            break
        end
    end

    if not created then
        EID.ItemReminderCategories[#EID.ItemReminderCategories + 1] = createEIDCategory(catData)
    end
end
EID:ResetItemReminderSelectedItems()


local oldFunc = EID.GridEntityDescriptions[GridEntityType.GRID_SPIKES][1].condition

-- for sacrifice spike conditional
EID.GridEntityDescriptions[GridEntityType.GRID_SPIKES][1].condition = function(gridEntity)
    return oldFunc(gridEntity) and not PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_CIMI_DEATH)
end

-- for cimi/death sacrifice spike conditional
EID:addGridEntityConditional(
    GridEntityType.GRID_SPIKES_ONOFF,
    function(gridEntity)
        if(not EID.Config["DisplaySacrificeInfo"]) then return end
        return (ToyboxMod.GAME:GetRoom():GetType()==RoomType.ROOM_SACRIFICE and PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_CIMI_DEATH))
    end,
    function(descObj)
        descObj.ObjSubType = math.abs(descObj.Entity.VarData)+1

        local finalDesc = ""
        if(descObj.ObjSubType<=#STORED.MISC.death_sacrifice) then
            finalDesc = STORED.FUNCTIONS.StringTableToDescription(STORED.MISC.death_sacrifice[descObj.ObjSubType])
        else
            if(descObj.ObjSubType%4==0) then
                finalDesc = STORED.FUNCTIONS.StringTableToDescription(STORED.MISC.death_sacrifice_endless[2])
            else
                finalDesc = STORED.FUNCTIONS.StringTableToDescription(STORED.MISC.death_sacrifice_endless[1])
            end
        end

        descObj.Name = "{{Collectible"..ToyboxMod.COLLECTIBLE_CIMI_DEATH.."}} [Next Sacrifice Room payout] ("..tostring(descObj.ObjSubType).."/"..tostring(#STORED.MISC.death_sacrifice)..")"
        descObj.Description = finalDesc
        return descObj
    end
)