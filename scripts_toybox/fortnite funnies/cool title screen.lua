
local conf = Isaac.GetItemConfig()
if(not ToyboxMod.CONFIG.AWESOME_FUCKING_TITLESCREEN) then return end

local CHANGED_MENU_SPRITE = false

local MENU_SIZE = Vector(480, 270)
local ITEM_POS_PADDING = Vector(120, 20)
local FRAMES = 0

local ALPHA_MOD = 1

local PLAYER_FILENAMES = {
    "gfx_tb/ui/player_portraits/atlas_portrait.png",
    "gfx_tb/ui/player_portraits/atlas_tar_portrait.png",
    "gfx_tb/ui/player_portraits/jonas_portrait.png",
    "gfx_tb/ui/player_portraits/milcom_portrait.png",
    "gfx_tb/ui/player_portraits/homunculus_portrait.png",
}
local PLAYER_SPRITE = Sprite("gfx_tb/ui/awesome_title_screen.anm2", true)
PLAYER_SPRITE:Play("Character", true)
PLAYER_SPRITE:ReplaceSpritesheet(0, PLAYER_FILENAMES[math.random(#PLAYER_FILENAMES)], true)

local LOGO_SPRITE = Sprite("gfx_tb/ui/awesome_title_logo.anm2", true)
LOGO_SPRITE:Play("Idle", true)
LOGO_SPRITE.PlaybackSpeed = 0.33

local CIRCLE_SPRITE = Sprite("gfx_tb/ui/awesome_title_circle.anm2", true)
CIRCLE_SPRITE:Play("Idle", true)

local BIG_ITEMS = {
    --["gfx_tb/items/collectibles/gambling_addiction.png"] = true,
}

local ITEM_FILENAMES = {}
local DEATH_INDEXES = {}

for key, id in pairs(ToyboxMod) do
    local iconf
    local isCollectible = false
    if(string.find(key, "COLLECTIBLE_")) then
        iconf = conf:GetCollectible(id)
        isCollectible = true
    end
    if(string.find(key, "TRINKET_")) then
        iconf = conf:GetTrinket(id)
    end

    if(iconf and not iconf.Hidden) then
        table.insert(ITEM_FILENAMES, iconf.GfxFileName)
        if(isCollectible) then
            table.insert(DEATH_INDEXES, id)
        end
    end
end


local function getRandomItemGfx()
    return ITEM_FILENAMES[math.random(#ITEM_FILENAMES)]
end
local function randomItemPos()
    return Vector(-ITEM_POS_PADDING.X, math.random(MENU_SIZE.Y+ITEM_POS_PADDING.Y*2)-ITEM_POS_PADDING.Y)
end
local function randomItemVel()
    return Vector(1.5*(math.random()*1.5+0.75), 1*(math.random()+1))
end
local function randomItemOscillation()
    return (math.random()+1)*0.3
end
local function randomItemOffset()
    return math.random(10000)
end
local function randomItemAccel()
    return Vector(0,0)
end

local ITEM_SPRITES = {}
for _=1, 100 do
    local itemgfx = getRandomItemGfx()

    local sp = Sprite("gfx_tb/ui/awesome_title_screen.anm2", true)
    sp:Play("Item", true)
    sp:ReplaceSpritesheet(1, itemgfx, true)

    if(BIG_ITEMS[itemgfx]) then
        sp:SetFrame(1)
    else
        sp:SetFrame(0)
    end

    table.insert(ITEM_SPRITES,{
        SPRITE = sp,
        POS = randomItemPos()+Vector(math.random(MENU_SIZE.X+ITEM_POS_PADDING.X*2), 0),
        VEL = randomItemVel(),
        OSC_INTENSITY = randomItemOscillation(),
        FRAME_OFFSET = randomItemOffset(),
        ACCEL = randomItemAccel(),
    })
end

local DEATH_SPRITES = {
    --[[]]
    {
        NumItems = 12,
        Radius = 60,
        LatOffset = 45, LatScrollMod = 0.8, ItemIdxLatMod = 1,
        LonOffset = 135, LonScrollMod = 0.2, ItemIdxLonMod = 0.3,
        ScaleMod = 0.8,
        Items = {},
    },
    --]]
    --[[] ]
    {
        NumItems = 12,
        Radius = 90,
        LatOffset = 45, LatScrollMod = 1, ItemIdxLatMod = 1,
        LonOffset = 45, LonScrollMod = 0, ItemIdxLonMod = 0.3,
        ScaleMod = 1,
        Items = {},
    },
    --]]
    --[[] ]
    {
        NumItems = 20,
        Radius = 100,
        LatOffset = 45, LatScrollMod = 0.8, ItemIdxLatMod = 1,
        LonOffset = 0, LonScrollMod = 0.5, ItemIdxLonMod = 0,
        ScaleMod = 1,
        Items = {},
    }
    --]]
}
for i=1, #DEATH_SPRITES do
    for _=1, DEATH_SPRITES[i].NumItems do
        local idx = DEATH_INDEXES[math.random(1,#DEATH_INDEXES)]

        local rng = ToyboxMod:generateRng()

        table.insert(DEATH_SPRITES[i].Items,
        {
            ID = idx,
            Color = Color(0,0,0, 1, 1,1,1),
            Color2 = Color(1,1,1,1,math.random()*0.5+0.2,math.random()*0.5+0.2,math.random()*0.5+0.2)
        })
    end
end

local function sortpos(a, b)
    return a.Pos[3]<b.Pos[3]
end

local function postMenuRender(_)
    local TITLE_SPRITE = TitleMenu.GetSprite()
    if(TITLE_SPRITE:GetLayer(0):GetSpritesheetPath()~="gfx_tb/ui/awesome_title_menu.png") then
        TITLE_SPRITE:ReplaceSpritesheet(0, "gfx_tb/ui/awesome_title_menu.png", true)
        TITLE_SPRITE:ReplaceSpritesheet(1, "gfx_tb/ui/awesome_title_menu.png", true)
        --TITLE_SPRITE:ReplaceSpritesheet(2, "gfx_tb/ui/awesome_title_logo.png", true)
        --TITLE_SPRITE:ReplaceSpritesheet(3, "gfx_tb/ui/awesome_title_logo.png", true)

        TITLE_SPRITE:GetLayer(2):SetVisible(false)
        TITLE_SPRITE:GetLayer(3):SetVisible(false)
    end

    local topLeftCorner = MenuManager:GetViewPosition()
    local bottomRightCorner = topLeftCorner+MENU_SIZE
    local centerCharacterPos = topLeftCorner+Vector(245,156)

    FRAMES = FRAMES+1

    local itemstorender = {}

    -- spinning items update
    for j, circledata in ipairs(DEATH_SPRITES) do
        circledata.LonOffset = circledata.LonOffset+circledata.LonScrollMod
        circledata.LatOffset = circledata.LatOffset+circledata.LatScrollMod
        itemstorender[j] = {}

        local NUM_ITEMS = #circledata.Items
        for i, itemdata in ipairs(circledata.Items) do
            local radlat = math.rad(circledata.LatOffset+i*360/NUM_ITEMS*circledata.ItemIdxLatMod)
            local radlon = math.rad(circledata.LonOffset+i*360/NUM_ITEMS*circledata.ItemIdxLonMod)
            
            local x = math.cos(radlat)*math.cos(radlon)
            local y = math.cos(radlat)*math.sin(radlon)
            local z = math.sin(radlat)

            if(1+z<0.02) then
                itemdata.ID = DEATH_INDEXES[math.random(1,#DEATH_INDEXES)]
                itemdata.Color2 = Color(1,1,1,1,math.random()*0.5+0.2,math.random()*0.5+0.2,math.random()*0.5+0.2)
            end

            table.insert(itemstorender[j], {
                ID = itemdata.ID,
                Pos = {x,y,z},
                Scale = Vector.One*(1+z*0.5)*circledata.ScaleMod,
                Color = itemdata.Color,
                Color2 = itemdata.Color2,
                Offset = Vector(x,y)*circledata.Radius,
            })
        end
    end

    for j=#itemstorender, 1, -1 do
        local tbl = itemstorender[j]
        table.sort(tbl, sortpos)

        for _, data in ipairs(tbl) do
            if(data.Pos[3]<=0) then
                CIRCLE_SPRITE.Scale = data.Scale
                CIRCLE_SPRITE.Color = data.Color2
                CIRCLE_SPRITE:Render(centerCharacterPos+data.Offset)

                Isaac.RenderCollectionItem(data.ID, centerCharacterPos+data.Offset, data.Scale, data.Color)
            end
        end
    end

    -- character
    PLAYER_SPRITE.Rotation = math.sin(math.rad(FRAMES))*10
    PLAYER_SPRITE:Render(centerCharacterPos)

    -- spinning items render in front
    for j=1, #itemstorender do
        local tbl = itemstorender[j]

        for _, data in ipairs(tbl) do
            if(data.Pos[3]>0) then
                CIRCLE_SPRITE.Scale = data.Scale
                CIRCLE_SPRITE.Color = data.Color2
                CIRCLE_SPRITE:Render(centerCharacterPos+data.Offset)

                Isaac.RenderCollectionItem(data.ID, centerCharacterPos+data.Offset, data.Scale, data.Color)
            end
        end
    end


    -- scrolling items
    local currentmenu = MenuManager.GetActiveMenu()
    if(currentmenu==MainMenuType.TITLE) then
        ALPHA_MOD = math.min(1, ALPHA_MOD+0.2)
    else
        ALPHA_MOD = math.max(0, ALPHA_MOD-0.1)
    end

    for _, spData in ipairs(ITEM_SPRITES) do
        spData.SPRITE.Color.A = ALPHA_MOD
        local dist = (spData.POS.X+ITEM_POS_PADDING.X)/(MENU_SIZE.X+ITEM_POS_PADDING.X*2)
        if(dist<0.2 or dist>0.8) then
            dist = (math.abs(0.5-dist)-0.3)*10
            spData.SPRITE.Color.A = spData.SPRITE.Color.A*(1-dist)
        end

        spData.SPRITE:Render(spData.POS+topLeftCorner)
        spData.POS = spData.POS+Vector(1,0)*spData.VEL.X+Vector(0,math.sin(math.rad((FRAMES+spData.FRAME_OFFSET)*spData.VEL.Y))*0.1*spData.OSC_INTENSITY)
        spData.VEL = spData.VEL+spData.ACCEL

        if(spData.POS.X>MENU_SIZE.X+ITEM_POS_PADDING.X) then
            local itemgfx = getRandomItemGfx()

            spData.SPRITE:ReplaceSpritesheet(1, itemgfx, true)
            spData.POS = randomItemPos()
            spData.VEL = randomItemVel()
            spData.OSC_INTENSITY = randomItemOscillation()
            spData.FRAME_OFFSET = randomItemOffset()
            spData.ACCEL = randomItemAccel()

            if(BIG_ITEMS[itemgfx]) then
                spData.SPRITE:SetFrame(1)
            else
                spData.SPRITE:SetFrame(0)
            end
        end
    end

    LOGO_SPRITE:Render(topLeftCorner)
    LOGO_SPRITE:Update()
end
ToyboxMod:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, postMenuRender)