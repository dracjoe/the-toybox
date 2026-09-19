---@class DescriptionModifier
---@field Type number?
---@field Condition function?
---@field ToModify table


local STORED = {
    ITEMS = {},
    TRINKETS = {},
    PILLS = {},
    CARDS = {},
    PLAYERS = {},
    MISC = {},

    GLOBAL_MODIFIERS = {},
    CATEGORIES = {},

    CONSTANTS = {},
    FUNCTIONS = {},
}

local functions = {
    AddItem = function(itemData)
        STORED.ITEMS[itemData.ID] = {}
        for key, val in pairs(itemData) do
            STORED.ITEMS[itemData.ID][key] = val
        end
    end,

    AddTrinket = function(itemData)
        STORED.TRINKETS[itemData.ID] = {}
        for key, val in pairs(itemData) do
            STORED.TRINKETS[itemData.ID][key] = val
        end
    end,

    AddPill = function(itemData)
        STORED.PILLS[itemData.ID] = {}
        for key, val in pairs(itemData) do
            STORED.PILLS[itemData.ID][key] = val
        end
    end,

    AddCard = function(itemData)
        STORED.CARDS[itemData.ID] = {}
        for key, val in pairs(itemData) do
            STORED.CARDS[itemData.ID][key] = val
        end
    end,

    AddPlayer = function(itemData)
        STORED.PLAYERS[itemData.ID] = {}
        for key, val in pairs(itemData) do
            STORED.PLAYERS[itemData.ID][key] = val
        end
    end,

    AddGlobalModifier = function(itemData)
        STORED.GLOBAL_MODIFIERS[itemData.ID] = {}
        for key, val in pairs(itemData) do
            STORED.GLOBAL_MODIFIERS[itemData.ID][key] = val
        end
    end,

    AddCategory = function(categoryData)
        STORED.CATEGORIES[categoryData.ID] = {}
        for key, val in pairs(categoryData) do
            STORED.CATEGORIES[categoryData.ID][key] = val
        end
    end,

    ---@param lines string[] | string
    ---@return string
    StringTableToDescription = function(lines)
        if(type(lines)=="string") then
            return lines
        end

        local desc = lines[1]
        for i=2, #lines do
            desc = desc.."#"..lines[i]
        end
        return desc
    end,

    ---@return boolean
    IsTrinketDoubled = function(descObj)
        local hasBox = PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX)
        local isGold = (descObj.ObjSubType & TrinketType.TRINKET_GOLDEN_FLAG ~= 0)

        return ((not hasBox) ~= (not isGold))
    end,

    ---@return boolean
    IsTrinketTripled = function(descObj)
        local hasBox = PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX)
        local isGold = (descObj.ObjSubType & TrinketType.TRINKET_GOLDEN_FLAG ~= 0)

        return (hasBox and isGold)
    end,

    ---@param itemId CollectibleType
    ---@return function
    GetItemStackFunction = function(itemId)
        ---@return boolean
        return function(descObj)
            if(not descObj.Entity) then return false end

            local hasItem = PlayerManager.AnyoneHasCollectible(itemId)
            local hasDiplo = PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_DIPLOPIA)

            return (hasItem or hasDiplo)
        end
    end,
}

STORED.FUNCTIONS = functions

---@param color number[]
---@return KColor
local function MakeColor(color)
    return KColor(color[1]/255,color[2]/255,color[3]/255,(color[4] or 100)/100)
end

---@param colors number[][]
---@param maxAnimTime number
---@return function
local function MakeSwagColor(colors, maxAnimTime)
    for i=1, #colors do
        colors[i] = MakeColor(colors[i])
    end

    return function()
        maxAnimTime = maxAnimTime or 80
        local animTime = ToyboxMod.GAME:GetFrameCount() % maxAnimTime
        local colorFractions = (maxAnimTime - 1) / #colors
        local subAnm = math.floor(animTime / (colorFractions + 1)) + 1
        local primaryColorIndex = subAnm % (#colors + 1)
        if primaryColorIndex == 0 then
            primaryColorIndex = 1
        end
        local secondaryColorIndex = (subAnm + 1) % (#colors + 1)
        if secondaryColorIndex == 0 then
            secondaryColorIndex = 1
        end
        return EID:interpolateColors(
            colors[primaryColorIndex],
            colors[secondaryColorIndex],
            (animTime % (colorFractions + 1)) / colorFractions
        )
    end
end

local iconSprite = Sprite("gfx_tb/eid/eid_icons.anm2", true)

--- PLAYERS
EID:addIcon("Player"..tostring(ToyboxMod.PLAYER_ATLAS_A), "Players", 0, 16, 16, 0, 0, iconSprite)
EID:addIcon("Player"..tostring(ToyboxMod.PLAYER_ATLAS_A_TAR), "Players", 1, 16, 16, 0, 0, iconSprite)
EID:addIcon("Player"..tostring(ToyboxMod.PLAYER_JONAS_A), "Players", 2, 16, 16, 0, 0, iconSprite)
EID:addIcon("Player"..tostring(ToyboxMod.PLAYER_MILCOM_A), "Players", 3, 16, 16, 0, 0, iconSprite)
EID:addIcon("Player"..tostring(ToyboxMod.PLAYER_HOMUNCULUS_A), "Players", 4, 16, 16, 0, 0, iconSprite)

--- TRANSFORMATIONS (MANTLE)
EID:addIcon("ToyboxIconRockTransformation", "MantleTransformations", 0, 16, 16, 0, 0, iconSprite)
EID:addIcon("ToyboxIconPoopTransformation", "MantleTransformations", 1, 16, 16, 0, 0, iconSprite)
EID:addIcon("ToyboxIconBoneTransformation", "MantleTransformations", 2, 16, 16, 0, 0, iconSprite)
EID:addIcon("ToyboxIconDarkTransformation", "MantleTransformations", 3, 16, 16, 0, 0, iconSprite)
EID:addIcon("ToyboxIconHolyTransformation", "MantleTransformations", 4, 16, 16, 0, 0, iconSprite)
EID:addIcon("ToyboxIconSaltTransformation", "MantleTransformations", 5, 16, 16, 0, 0, iconSprite)
EID:addIcon("ToyboxIconGlassTransformation", "MantleTransformations", 6, 16, 16, 0, 0, iconSprite)
EID:addIcon("ToyboxIconMetalTransformation", "MantleTransformations", 7, 16, 16, 0, 0, iconSprite)
EID:addIcon("ToyboxIconGoldTransformation", "MantleTransformations", 8, 16, 16, 0, 0, iconSprite)
EID:addIcon("ToyboxIconEmptyTransformation", "MantleTransformations", 10, 16, 16, 0, 0, iconSprite)
EID:addIcon("ToyboxIconTarTransformation", "MantleTransformations", 9, 16, 16, 0, 0, iconSprite)

--- TRANSFORMATIONS (REGULAR)
EID:addIcon("ToyboxFancyTransformation", "Transformations", 0, 16, 16, 0, 0, iconSprite)
EID:addIcon("ToyboxHydraTransformation", "Transformations", 1, 16, 16, 0, 0, iconSprite)

--- CARDS
EID:addIcon("Card"..tostring(ToyboxMod.CARD_PRISMSTONE), "Cards", 0, 16, 16, 0, 0, iconSprite)
EID:addIcon("Card"..tostring(ToyboxMod.CARD_FOIL_CARD), "Cards", 1, 16, 16, 0, 0, iconSprite)
EID:addIcon("Card"..tostring(ToyboxMod.CARD_FOUR_STARRED_LADYBUG), "Cards", 2, 16, 16, 0, 0, iconSprite)
EID:addIcon("Card"..tostring(ToyboxMod.CARD_POISON_RAIN), "Cards", 3, 16, 16, 0, 0, iconSprite)
EID:addIcon("Card"..tostring(ToyboxMod.CARD_ALIEN_MIND), "Cards", 4, 16, 16, 0, 0, iconSprite)
EID:addIcon("Card"..tostring(ToyboxMod.CARD_MANTLE_ROCK), "Cards", 5, 16, 16, 0, 0, iconSprite)
EID:addIcon("Card"..tostring(ToyboxMod.CARD_MANTLE_POOP), "Cards", 6, 16, 16, 0, 0, iconSprite)
EID:addIcon("Card"..tostring(ToyboxMod.CARD_MANTLE_DARK), "Cards", 7, 16, 16, 0, 0, iconSprite)
EID:addIcon("Card"..tostring(ToyboxMod.CARD_MANTLE_HOLY), "Cards", 8, 16, 16, 0, 0, iconSprite)
EID:addIcon("Card"..tostring(ToyboxMod.CARD_MANTLE_SALT), "Cards", 9, 16, 16, 0, 0, iconSprite)
EID:addIcon("Card"..tostring(ToyboxMod.CARD_MANTLE_GLASS), "Cards", 10, 16, 16, 0, 0, iconSprite)
EID:addIcon("Card"..tostring(ToyboxMod.CARD_MANTLE_METAL), "Cards", 11, 16, 16, 0, 0, iconSprite)
EID:addIcon("Card"..tostring(ToyboxMod.CARD_MANTLE_GOLD), "Cards", 12, 16, 16, 0, 0, iconSprite)
EID:addIcon("Card"..tostring(ToyboxMod.CARD_MANTLE_BONE), "Cards", 13, 16, 16, 0, 0, iconSprite)
EID:addIcon("Card"..tostring(ToyboxMod.CARD_DARK_EXPLOSION), "Cards", 14, 16, 16, 0, 0, iconSprite)
EID:addIcon("Card"..tostring(ToyboxMod.CARD_ENDLESS_CHAOS), "Cards", 15, 16, 16, 0, 0, iconSprite)
EID:addIcon("Card"..tostring(ToyboxMod.CARD_CHAIN_REACTION), "Cards", 16, 16, 16, 0, 0, iconSprite)
EID:addIcon("Card"..tostring(ToyboxMod.CARD_GREEN_APPLE), "Cards", 17, 16, 16, 0, 0, iconSprite)
EID:addIcon("Card"..tostring(ToyboxMod.CARD_THE_WISE_MEN), "Cards", 18, 16, 16, 0, 0, iconSprite)
EID:addIcon("Card"..tostring(ToyboxMod.CARD_THE_ANGEL), "Cards", 19, 16, 16, 0, 0, iconSprite)
EID:addIcon("Card"..tostring(ToyboxMod.CARD_THE_GATE), "Cards", 20, 16, 16, 0, 0, iconSprite)
EID:addIcon("Card"..tostring(ToyboxMod.CARD_APOCALYPSE), "Cards", 21, 16, 16, 0, 0, iconSprite)
EID:addIcon("Card"..tostring(ToyboxMod.CARD_THE_CRYPT), "Cards", 22, 16, 16, 0, 0, iconSprite)
EID:addIcon("Card"..tostring(ToyboxMod.CARD_THE_REAPER), "Cards", 23, 16, 16, 0, 0, iconSprite)
EID:addIcon("Card"..tostring(ToyboxMod.CARD_THE_DRAGON), "Cards", 24, 16, 16, 0, 0, iconSprite)
EID:addIcon("Card"..tostring(ToyboxMod.CARD_DUALITY), "Cards", 25, 16, 16, 0, 0, iconSprite)
EID:addIcon("Card"..tostring(ToyboxMod.CARD_THE_BARON), "Cards", 26, 16, 16, 0, 0, iconSprite)
EID:addIcon("Card"..tostring(ToyboxMod.CARD_THE_TRICKSTER), "Cards", 27, 16, 16, 0, 0, iconSprite)
EID:addIcon("Card"..tostring(ToyboxMod.CARD_MEMORY), "Cards", 28, 16, 16, 0, 0, iconSprite)
EID:addIcon("Card"..tostring(ToyboxMod.CARD_THE_CARAVAN), "Cards", 29, 16, 16, 0, 0, iconSprite)
EID:addIcon("Card"..tostring(ToyboxMod.CARD_EXCALIBUR), "Cards", 30, 16, 16, 0, 0, iconSprite)
EID:addIcon("Card"..tostring(ToyboxMod.CARD_FATE), "Cards", 31, 16, 16, 0, 0, iconSprite)
EID:addIcon("Card"..tostring(ToyboxMod.CARD_THE_PHANTOM), "Cards", 32, 16, 16, 0, 0, iconSprite)
EID:addIcon("Card"..tostring(ToyboxMod.CARD_MIRAGE), "Cards", 33, 16, 16, 0, 0, iconSprite)
EID:addIcon("Card"..tostring(ToyboxMod.CARD_THE_IDOL), "Cards", 34, 16, 16, 0, 0, iconSprite)
EID:addIcon("Card"..tostring(ToyboxMod.CARD_GREYHOUND), "Cards", 35, 16, 16, 0, 0, iconSprite)

--- ROOMS
EID:addIcon("Graveyard", "RoomIcons", 0, 10, 9, 0, 0, iconSprite)
EID:addIcon("TempleRoom", "RoomIcons", 1, 10, 9, 0, 0, iconSprite)
EID:addIcon("LibraryTreasureRoom", "RoomIcons", 2, 8, 9, 0, 0, iconSprite)

--- POOLS
EID:addIcon("ItemPoolGraveyard", "PoolIcons", 0, 11, 11, 0, 0, iconSprite)
EID:addIcon("ItemPoolTempleRoom", "PoolIcons", 1, 11, 11, 0, 0, iconSprite)

--- MISC
EID:addIcon("ToyboxIconElectrifiedStatus", "Misc", 0, 16, 16, 0, 0, iconSprite)
EID:addIcon("ToyboxIconOverflowingStatus", "Misc", 1, 16, 16, 0, 0, iconSprite)
EID:addIcon("ToyboxIconGoldenPill", "Misc", 2, 16, 16, 0, 0, iconSprite)
EID:addIcon("ToyboxIconHorsePill", "Misc", 3, 16, 16, 0, 0, iconSprite)
EID:addIcon("ToyboxIconGoldenHorsePill", "Misc", 4, 16, 16, 0, 0, iconSprite)
EID:addIcon("ToyboxIconInk", "Misc", 5, 16, 16, 0, 0, iconSprite)
EID:addIcon("ToyboxIconTintedRoom", "Misc", 6, 16, 16, 0, 0, iconSprite)
EID:addIcon("ToyboxIconJuice", "Misc", 7, 16, 16, 0, 0, iconSprite)
EID:addIcon("ToyboxIconEarwormStatus", "Misc", 8, 16, 16, 0, 0, iconSprite)
EID:addIcon("ToyboxIconBloodCoin", "Misc", 9, 16, 16, 0, 0, iconSprite)
EID:addIcon("ToyboxIconAltTarot", "Misc", 10, 16, 16, 0, 0, iconSprite)

--- COLORS
EID:addColor("ToyboxColorLimitBreak", nil, MakeSwagColor({{162,164,222},{255,234,160}}, 40))
EID:addColor("ToyboxColorHorsePill", nil, MakeSwagColor({{184,169,163},{111,134,192}}, 80))
EID:addColor("ToyboxColorJonas", MakeColor({173,189,228}))
EID:addColor("ToyboxColorItemStack", MakeColor({196,167,196}))
EID:addColor("ToyboxColorConglomerate", nil, MakeSwagColor({{119,137,147},{91,99,104}}, 80))

STORED.CONSTANTS = {
    --- ICONS ---
    Icon_AtlasRock = "{{ToyboxIconRockTransformation}}",
    Icon_AtlasPoop = "{{ToyboxIconPoopTransformation}}",
    Icon_AtlasBone = "{{ToyboxIconBoneTransformation}}",
    Icon_AtlasDark = "{{ToyboxIconDarkTransformation}}",
    Icon_AtlasHoly = "{{ToyboxIconHolyTransformation}}",
    Icon_AtlasSalt = "{{ToyboxIconSaltTransformation}}",
    Icon_AtlasGlass = "{{ToyboxIconGlassTransformation}}",
    Icon_AtlasMetal = "{{ToyboxIconMetalTransformation}}",
    Icon_AtlasGold = "{{ToyboxIconGoldTransformation}}",
    Icon_AtlasEmpty = "{{ToyboxIconEmptyTransformation}}",
    Icon_AtlasTar = "{{ToyboxIconTarTransformation}}",

    Icon_PlayerAtlas = "{{Player" .. tostring(ToyboxMod.PLAYER_ATLAS_A) .. "}}",
    Icon_PlayerAtlasTar = "{{Player" .. tostring(ToyboxMod.PLAYER_ATLAS_A_TAR) .. "}}",
    Icon_PlayerJonas = "{{Player" .. tostring(ToyboxMod.PLAYER_JONAS_A) .. "}}",
    Icon_PlayerMilcom = "{{Player" .. tostring(ToyboxMod.PLAYER_MILCOM_A) .. "}}",

    Icon_TransfFancy = "{{ToyboxFancyTransformation}}",
    Icon_TransfHydra = "{{ToyboxHydraTransformation}}",

    Icon_CardMantleRock = "{{Card" .. tostring(ToyboxMod.CARD_MANTLE_ROCK) .. "}}",
    Icon_CardMantlePoop = "{{Card" .. tostring(ToyboxMod.CARD_MANTLE_POOP) .. "}}",
    Icon_CardMantleBone = "{{Card" .. tostring(ToyboxMod.CARD_MANTLE_BONE) .. "}}",
    Icon_CardMantleDark = "{{Card" .. tostring(ToyboxMod.CARD_MANTLE_DARK) .. "}}",
    Icon_CardMantleHoly = "{{Card" .. tostring(ToyboxMod.CARD_MANTLE_HOLY) .. "}}",
    Icon_CardMantleSalt = "{{Card" .. tostring(ToyboxMod.CARD_MANTLE_SALT) .. "}}",
    Icon_CardMantleGlass = "{{Card" .. tostring(ToyboxMod.CARD_MANTLE_GLASS) .. "}}",
    Icon_CardMantleMetal = "{{Card" .. tostring(ToyboxMod.CARD_MANTLE_METAL) .. "}}",
    Icon_CardMantleGold = "{{Card" .. tostring(ToyboxMod.CARD_MANTLE_GOLD) .. "}}",
    Icon_CardLaurel = "{{Card" .. tostring(ToyboxMod.CARD_LAUREL) .. "}}",
    Icon_CardYanny = "{{Card" .. tostring(ToyboxMod.CARD_YANNY) .. "}}",
    Icon_CardPrismstone = "{{Card" .. tostring(ToyboxMod.CARD_PRISMSTONE) .. "}}",
    Icon_CardFoilCard = "{{Card" .. tostring(ToyboxMod.CARD_FOIL_CARD) .. "}}",
    Icon_CardTheWiseMen = "{{Card" .. tostring(ToyboxMod.CARD_THE_WISE_MEN) .. "}}",
    Icon_CardTheAngel = "{{Card" .. tostring(ToyboxMod.CARD_THE_ANGEL) .. "}}",
    Icon_CardTheGate = "{{Card" .. tostring(ToyboxMod.CARD_THE_GATE) .. "}}",
    Icon_CardApocalypse = "{{Card" .. tostring(ToyboxMod.CARD_APOCALYPSE) .. "}}",
    Icon_CardTheCrypt = "{{Card" .. tostring(ToyboxMod.CARD_THE_CRYPT) .. "}}",
    Icon_CardTheReaper = "{{Card" .. tostring(ToyboxMod.CARD_THE_REAPER) .. "}}",
    Icon_CardTheDragon = "{{Card" .. tostring(ToyboxMod.CARD_THE_DRAGON) .. "}}",
    Icon_CardDuality = "{{Card" .. tostring(ToyboxMod.CARD_DUALITY) .. "}}",
    Icon_CardTheBaron = "{{Card" .. tostring(ToyboxMod.CARD_THE_BARON) .. "}}",
    Icon_CardTheTrickster = "{{Card" .. tostring(ToyboxMod.CARD_THE_TRICKSTER) .. "}}",
    Icon_CardMemory = "{{Card" .. tostring(ToyboxMod.CARD_MEMORY) .. "}}",
    Icon_CardTheCaravan = "{{Card" .. tostring(ToyboxMod.CARD_THE_CARAVAN) .. "}}",
    Icon_CardExcalibur = "{{Card" .. tostring(ToyboxMod.CARD_EXCALIBUR) .. "}}",
    Icon_CardFate = "{{Card" .. tostring(ToyboxMod.CARD_FATE) .. "}}",
    Icon_CardThePhantom = "{{Card" .. tostring(ToyboxMod.CARD_THE_PHANTOM) .. "}}",
    Icon_CardMirage = "{{Card" .. tostring(ToyboxMod.CARD_MIRAGE) .. "}}",
    Icon_CardTheIdol = "{{Card" .. tostring(ToyboxMod.CARD_THE_IDOL) .. "}}",
    Icon_CardGreyhound = "{{Card" .. tostring(ToyboxMod.CARD_GREYHOUND) .. "}}",

    Icon_RoomGraveyard = "{{Graveyard}}",
    Icon_RoomTemple = "{{TempleRoom}}",
    Icon_RoomLibraryTreasure = "{{LibraryTreasureRoom}}",

    Icon_PoolGraveyard = "{{ItemPoolGraveyard}}",
    Icon_PoolTemple = "{{ItemPoolTempleRoom}}",

    Icon_StatusElectrified = "{{ToyboxIconElectrifiedStatus}}",
    Icon_StatusOverflowing = "{{ToyboxIconOverflowingStatus}}",
    Icon_StatusEarworm = "{{ToyboxIconEarwormStatus}}",
    Icon_HorsePill = "{{ToyboxIconHorsePill}}",
    Icon_GoldenPill = "{{ToyboxIconGoldenPill}}",
    Icon_GoldenHorsePill = "{{ToyboxIconGoldenHorsePill}}",
    Icon_Ink = "{{ToyboxIconInk}}",
    Icon_BloodCoin = "{{ToyboxIconBloodCoin}}",
    Icon_TintedRoom = "{{ToyboxIconTintedRoom}}",
    Icon_Juice = "{{ToyboxIconJuice}}",
    Icon_AltTarotCard = "{{ToyboxIconAltTarot}}",

    --- COLORS ---
    Color_LimitBreak = "{{ToyboxColorLimitBreak}}",
    Color_HorsePill = "{{CToyboxColorHorsePill}}",
    Color_Jonas = "{{ToyboxColorJonas}}",
    Color_ItemStack = "{{ToyboxColorItemStack}}",
    Color_Conglomerate = "{{ToyboxColorConglomerate}}",

    --- ENUMS ---
    DescriptionModifier = {
        APPEND = 0,
        APPEND_BOTTOM = 0,
        APPEND_TOP = 1,
        REPLACE = 2,
    },
    ModifierCondition = {
        ItemStack = function(descObj)
            if(not descObj.Entity) then return false end

            local hasItem = PlayerManager.AnyoneHasCollectible(descObj.ObjSubType)
            local hasDiplo = PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_DIPLOPIA)

            return (hasItem or hasDiplo)
        end,
        BFFS = function(descObj)
            return PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_BFFS)
        end,
        CarBattery = function(descObj)
            return PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY)
        end,
        Virtues = function(descObj)
            return PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES)
        end,
        VirtuesItem = function(id)
            return function(descObj)
                if(id and descObj.ObjSubType==584 and not EID.InsideItemReminder) then
                    return PlayerManager.AnyoneHasCollectible(id)
                end
            end
        end,
        Belial = function(descObj)
            return PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE)
        end,

        TrinketDouble = STORED.FUNCTIONS.IsTrinketDoubled,
        TrinketTriple = STORED.FUNCTIONS.IsTrinketTripled,

        PillHorse = function(descObj)
            return (descObj.ObjSubType & PillColor.PILL_GIANT_FLAG ~= 0)
        end,

        CardTarotCloth = function(descObj)
            return PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_TAROT_CLOTH)
        end,

        CardConglomerate = function(descObj)
            return PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_CONGLOMERATE)
        end,
        CardConglomerateNoAtlas = function(descObj)
            return PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_CONGLOMERATE) and ToyboxMod:isAnybodyNotAtlasA()
        end,
        CardConglomerateYesAtlas = function(descObj)
            return PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_CONGLOMERATE) and ToyboxMod:isAnyPlayerAtlasA()
        end,
    },
    ModifierFunctionKey = {
        StackModifiers = {"ItemStack", "{{Collectible347}}", "{{ToyboxColorItemStack}}"},
        BFFSModifiers = {"BFFS", "{{Collectible247}}", "{{BlinkPink}}"},
        CarBatteryModifiers = {"CarBattery", "{{Collectible356}}", "{{BlinkYellowGreen}}"},
        DoubleModifiers = {"TrinketDouble", nil, "{{ColorGold}}"},
        TripleModifiers = {"TrinketTriple", nil, "{{ColorRainbow}}"},
        HorseModifiers = {"PillHorse", nil, nil},
        TarotClothModifiers = {"CardTarotCloth", "{{Collectible451}}", "{{ColorShinyPurple}}"},
        ConglomerateModifiers = {"CardConglomerate", "{{Collectible"..ToyboxMod.COLLECTIBLE_CONGLOMERATE.."}}", "{{ToyboxColorConglomerate}}"},
    },

    WispRingIcons = {
        [-1] = "{{StationaryWisp}}",
        [0] = "{{InnerWisp}}",
        [1] = "{{MiddleWisp}}",
        [2] = "{{OuterWisp}}"
    }
}



return STORED