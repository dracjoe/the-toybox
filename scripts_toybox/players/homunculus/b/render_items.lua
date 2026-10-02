local id = -1

local UI_SPRITE = Sprite("gfx_tb/ui/ui_homunculus_inventory.anm2", true)
UI_SPRITE:Play("Idle", true)

local REVIVE_FONT = Font()
REVIVE_FONT:Load("font/pftempestasevencondensed.fnt")

local EID_OFFSET = "HomunculusBInventory"
local EID_POS_OFFSET = Vector(0,8)

---@param itemId CollectibleType
---@return Sprite
local function getItemSprite(itemId)
    local spr = Sprite("gfx_tb/ui/ui_item_render.anm2", true)
    spr:Play("Idle", true)
    spr.Scale = Vector(0.5,0.5)

    local conf = Isaac.GetItemConfig():GetCollectible(itemId)
    if(conf) then
        spr:ReplaceSpritesheet(0, conf.GfxFileName, true)
    end

    return {Sprite=spr, ID=itemId}
end

---@param pl EntityPlayer
local function renderCollectible(_, offset, sprite, pos, x, pl)
    if(ToyboxMod.GAME:GetLevel():GetCurses() & LevelCurse.CURSE_OF_THE_UNKNOWN ~= 0) then return end
    if(pl:GetPlayerIndex() < 0) then return end
    if(pl:GetPlayerType() ~= ToyboxMod.PLAYER_HOMUNCULUS_B) then return end

    local hud = ToyboxMod.GAME:GetHUD():GetPlayerHUD(math.min(7,pl:GetPlayerIndex()))
    local h = hud:GetHearts()

    local heartsPerLine = 6
    if(not hud:GetPlayer()) then
        heartsPerLine = 3
    end

    local data = ToyboxMod:getEntityDataTable(pl)

    local indexesToRender = {}
    local indexFrameData = {}

    local max_iMod = 0
    local max_iLines = 1

    local numMaxReds = math.ceil(pl:GetMaxHearts()/2)
    local maxIdx = 0
    for i, heartData in pairs(h) do
        if(heartData:IsVisible()) then
            max_iMod = math.max(max_iMod, (i-1)%heartsPerLine+1)
            max_iLines = math.max(max_iLines, 1+(i-1)//heartsPerLine)

            indexFrameData[i] = 2
            if(i<=numMaxReds or pl:IsBoneHeart(i-1-numMaxReds)) then
                if(#indexesToRender<#(data.HOMUNCULUS_B_ITEMS or {})) then
                    table.insert(indexesToRender, i)
                    indexFrameData[i] = -1
                else
                    indexFrameData[i] = 1
                end
            end
            maxIdx = math.max(maxIdx, i)
        end
    end

    local inventoryOffset = Vector(-1,6+max_iLines*12)
    local inventoryMult = Vector(12,13)

    if(maxIdx%heartsPerLine==0 and max_iLines<math.ceil(pl:GetHeartLimit()/(2*heartsPerLine)) and pl:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE)) then
        inventoryOffset.Y = inventoryOffset.Y+12
    end

    data.HOMUNCULUS_B_SPRITES = data.HOMUNCULUS_B_SPRITES or {}
    for i, idx in ipairs(indexesToRender) do
        local p = Vector((idx-1)%heartsPerLine, ((idx-1)//heartsPerLine))*inventoryMult+pos+inventoryOffset

        local sprData = data.HOMUNCULUS_B_SPRITES[i]
        if(not (sprData and sprData.ID==data.HOMUNCULUS_B_ITEMS[i])) then
            data.HOMUNCULUS_B_SPRITES[i] = getItemSprite(data.HOMUNCULUS_B_ITEMS[i])
            sprData = data.HOMUNCULUS_B_SPRITES[i]
        end

        sprData.Sprite:Render(p)
    end

    for idx, frame in ipairs(indexFrameData) do
        local p = Vector((idx-1)%heartsPerLine, ((idx-1)//heartsPerLine))*inventoryMult+pos+inventoryOffset
        if(frame~=-1) then
            UI_SPRITE.Color = Color(1,1,1,0.5)
            UI_SPRITE:SetFrame(frame)
            UI_SPRITE:Render(p+Vector(0.5,-0.5))
        end

        --[[] ]
        UI_SPRITE.Color = Color(0,0,0,1)
        UI_SPRITE:SetFrame(0)
        UI_SPRITE:Render(p)
        --]]
    end

    --[[] ]
    UI_SPRITE.Color = Color(1,1,1,1)
    UI_SPRITE:SetFrame(5)
    for idx, frame in ipairs(indexFrameData) do
        local p = Vector((idx-1)%6, ((idx-1)//6))*inventoryMult+pos+inventoryOffset
        UI_SPRITE:Render(p)
    end
    --]]

    --[ [] ]

    UI_SPRITE.Color = Color(1,1,1,1)
    UI_SPRITE:SetFrame(0)

    UI_SPRITE:Render(Vector(0,0)*inventoryMult+pos+inventoryOffset, Vector(0,0), Vector(8,8))
    UI_SPRITE:Render(Vector(max_iMod-1,0)*inventoryMult+pos+inventoryOffset, Vector(8,0), Vector(0,8))
    UI_SPRITE:Render(Vector(0,max_iLines-1)*inventoryMult+pos+inventoryOffset, Vector(0,8), Vector(8,0))
    UI_SPRITE:Render(Vector(max_iMod-1,max_iLines-1)*inventoryMult+pos+inventoryOffset, Vector(8,8), Vector(0,0))

    --]]
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PLAYERHUD_RENDER_HEARTS, renderCollectible)

local function checkHasModifier(_)
    if(EID) then
        local player = Isaac.GetPlayer()
        if(player:GetPlayerType()==ToyboxMod.PLAYER_HOMUNCULUS_B) then
            local offs = math.ceil(player:GetEffectiveMaxHearts()/2+player:GetSoulHearts()/2)

            if(offs%6==0 and offs<player:GetHeartLimit()/2 and player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE)) then
                offs = offs+1
            end

            local offset = Vector(0,16+24*(math.ceil(offs/6)-1))
            EID:addTextPosModifier(EID_OFFSET, offset)
        else
            EID:removeTextPosModifier(EID_OFFSET)
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_UPDATE, checkHasModifier)