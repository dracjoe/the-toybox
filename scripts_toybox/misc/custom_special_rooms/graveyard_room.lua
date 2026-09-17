local BASE_CHANCE = 10.2 -- 0.05
local INCREMENT_PER_MISSING_HEAR = 0.05
local LOST_BASE_CHANCE = 0.1

local PARASITE_ROTATE_TIME = 30*4
local PARASITE_ROTATE_RADIUS = Vector(12,5)

local TRINKET_SPRITE = Sprite("gfx_tb/ui/ui_item_render.anm2", false)
TRINKET_SPRITE:Play("Idle", true)

local function getGraveyardChance()
    local chance = 0
    local players = PlayerManager.GetPlayers()
    local nump = #players
    for _, pl in ipairs(players) do
        local addedChance
        if(pl:GetHealthType()==HealthType.LOST) then
            addedChance = LOST_BASE_CHANCE
        else
            local missingHp = (pl:GetEffectiveMaxHearts()-pl:GetHearts())//2
            addedChance = BASE_CHANCE+missingHp*INCREMENT_PER_MISSING_HEAR
        end

        chance = chance+addedChance/nump
    end

    return chance
end

local function addNewBossRoom(_)
    local level = ToyboxMod.GAME:GetLevel()
    local stage = level:GetAbsoluteStage()--+(level:GetStageType()>=StageType.STAGETYPE_REPENTANCE and 1 or 0)
    if(stage%2==0 or stage==LevelStage.STAGE8) then return end -- only odd stages
    local rng = level:GetGenerationRNG()
    --local chance = getGraveyardChance()
    if(rng:RandomFloat()<BASE_CHANCE) then
        local newBossRoom = RoomConfigHolder.GetRandomRoom(Random(), true, StbType.SPECIAL_ROOMS, RoomType.ROOM_TELEPORTER, nil, nil, nil, nil, nil, nil, 100)
        if(not newBossRoom) then return end
        local possibleRooms = level:FindValidRoomPlacementLocations(newBossRoom, level:GetDimension(), false, false)

        local finalRoom
        while(#possibleRooms>0 and not finalRoom) do
            local idx = rng:RandomInt(#possibleRooms)+1
        
            finalRoom = level:TryPlaceRoom(newBossRoom, possibleRooms[idx], level:GetDimension(), 0, true, true, false)
            table.remove(possibleRooms, idx)
        end

        if(finalRoom) then
            level:UpdateVisibility()
            if(MinimapAPI) then
                MinimapAPI:CheckForNewRedRooms()
            end
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, addNewBossRoom)

local GRAVEYARD_COLOR_MOD = ColorModifier(0.87,0.92,1.07,0.5,0,1.05)

local function spawnMist(pos, dir, instant)
    local mist = Isaac.Spawn(1000,138,0,pos,dir,nil):ToEffect()
    local sp = mist:GetSprite()
    sp:SetFrame(math.random(1,sp:GetCurrentAnimationData():GetLength())-1)
    sp:Stop()

    mist.DepthOffset = 100
    mist.RenderZOffset = 100
    mist.SortingLayer = SortingLayer.SORTING_NORMAL

    ToyboxMod:setEntityData(mist, "STUPID_GRAVEYARD_MIST", (instant and 1 or 0))

    mist.Color = Color(1,1,1,(instant and 0.7 or 0))
    mist:Update()
end

local function makeChoiceCollectibles(_)
    if(not ToyboxMod:isCustomSpecialRoom(ToyboxMod.GAME:GetLevel():GetCurrentRoomDesc(), "GRAVEYARD_ROOM")) then
        local curmodifier = ToyboxMod.GAME:GetCurrentColorModifier()
        if(curmodifier==GRAVEYARD_COLOR_MOD) then
            ToyboxMod.GAME:SetColorModifier(ToyboxMod.GAME:GetTargetColorModifier(),true,0.08)
        end
        return
    end

    ToyboxMod.GAME:SetColorModifier(GRAVEYARD_COLOR_MOD,false)

    local optionsIdx
    for _, ent in ipairs(Isaac.FindByType(5,100)) do
        if(ent.SubType~=0) then
            if(optionsIdx) then
                ent:ToPickup().OptionsPickupIndex = optionsIdx
            else
                optionsIdx = ent:ToPickup():SetNewOptionsPickupIndex()
            end
        end
    end

    local room = ToyboxMod.GAME:GetRoom()
    for i=-1,1,2 do
        local rng = ToyboxMod:generateRng()
        local tlpos = room:GetTopLeftPos()
        local brpos = room:GetBottomRightPos()

        local pos = Vector(0,rng:RandomInt(tlpos.Y+10, brpos.Y-10))
        local vel = Vector.Zero
        if(i==1) then
            pos.X = rng:RandomInt(tlpos.X+40, (tlpos.X+brpos.X)/2-20)
            vel = Vector(1,0)
        else
            pos.X = rng:RandomInt((tlpos.X+brpos.X)/2+20, brpos.X-40)
            vel = Vector(-1,0)
        end

        vel = vel*(0.5+math.random()*0.7)

        spawnMist(pos, vel, true)
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_ROOM, CallbackPriority.IMPORTANT, makeChoiceCollectibles)

local function spawnScrollingMist(_)
    if(not ToyboxMod:isCustomSpecialRoom(ToyboxMod.GAME:GetLevel():GetCurrentRoomDesc(), "GRAVEYARD_ROOM")) then return end

    local room = ToyboxMod.GAME:GetRoom()
    if(room:GetFrameCount()%140==20) then
        local rng = ToyboxMod:generateRng()
        local pos = Vector(0,rng:RandomInt(room:GetTopLeftPos().Y, room:GetBottomRightPos().Y))
        local vel = Vector.Zero
        if(rng:RandomFloat()<0.5) then
            pos.X = room:GetTopLeftPos().X-400
            vel = Vector(1,0)
        else
            pos.X = room:GetBottomRightPos().X+400
            vel = Vector(-1,0)
        end

        vel = vel*(0.5+math.random()*0.7)

        spawnMist(pos, vel)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_UPDATE, spawnScrollingMist)

---@param effect EntityEffect
local function mistUpdate(_, effect)
    if(not ToyboxMod:getEntityData(effect, "STUPID_GRAVEYARD_MIST")) then return end

    local START_INVISIBLE = (ToyboxMod:getEntityData(effect, "STUPID_GRAVEYARD_MIST")==1 and -1 or 80)
    local LIFE_DURATION = 30*15
    local INVISIBLE_DIE = 100
    local ALPHA_MOD = 0.7

    if(effect.FrameCount<=START_INVISIBLE) then
        effect.Color = Color(1,1,1,ALPHA_MOD*effect.FrameCount/START_INVISIBLE)
    elseif(effect.FrameCount<=START_INVISIBLE+LIFE_DURATION) then
        effect.Color = Color(1,1,1,ALPHA_MOD*1)
    elseif(effect.FrameCount<=START_INVISIBLE+LIFE_DURATION+INVISIBLE_DIE) then
        if(effect.FrameCount==START_INVISIBLE+LIFE_DURATION+INVISIBLE_DIE) then
            effect:Remove()
            return
        end

        effect.Color = Color(1,1,1,ALPHA_MOD*(1-(effect.FrameCount-START_INVISIBLE-LIFE_DURATION)/INVISIBLE_DIE))
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mistUpdate, EffectVariant.MIST)

local function replaceCollectiblePedestal(_, pickup)
    if(not ToyboxMod:isCustomSpecialRoom(ToyboxMod.GAME:GetLevel():GetCurrentRoomDesc(), "GRAVEYARD_ROOM")) then return end

    if(not pickup.Touched) then
        local rng = ToyboxMod:generateRng(pickup.InitSeed)
        local pool = ToyboxMod.GAME:GetItemPool()

        local possibleParasites = {}
        for id, _ in pairs(ToyboxMod.PARASITE_TRINKETS) do
            if(pool:HasTrinket(id)) then
                table.insert(possibleParasites, id)
            end
        end
        local testGoldenTrinket = pool:GetTrinket(true)
        local isGold = (testGoldenTrinket & TrinketType.TRINKET_GOLDEN_FLAG ~= 0)

        local finalParasite
        if(#possibleParasites>0) then
            finalParasite = possibleParasites[rng:RandomInt(1, #possibleParasites)]
            if(isGold) then
                finalParasite = finalParasite | TrinketType.TRINKET_GOLDEN_FLAG
            end
        else
            finalParasite = pool:GetTrinket(false)
        end
        if(finalParasite) then
            ToyboxMod:setEntityData(pickup, "GRAVEYARD_PARASITE", finalParasite)
        end
    end

    if(pickup:GetAlternatePedestal()==PedestalType.DEFAULT) then
        pickup:GetSprite():ReplaceSpritesheet(5, "gfx_tb/pickups/pickup_grave_altar.png", true)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, replaceCollectiblePedestal, PickupVariant.PICKUP_COLLECTIBLE)

---@param pickup EntityPickup
---@param coll Entity
local function prePedestalCollection(_, pickup, coll, low)
    if(coll and coll:ToPlayer()) then
        local pl = coll:ToPlayer()
        if(pl:IsItemQueueEmpty() and pickup.SubType~=0) then
            ToyboxMod:setEntityData(pickup, "PARASITE_WAIT_FOR_QUEUE", pickup.SubType)
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, prePedestalCollection, PickupVariant.PICKUP_COLLECTIBLE)

---@param pickup EntityPickup
---@param coll Entity
local function postPedestalCollection(_, pickup, coll, low)
    if(coll and coll:ToPlayer()) then
        local pl = coll:ToPlayer()
        if(ToyboxMod:getEntityData(pickup, "PARASITE_WAIT_FOR_QUEUE") and not pl:IsItemQueueEmpty()) then
            if(pl.QueuedItem and pl.QueuedItem.Item and pl.QueuedItem.Item.ID==ToyboxMod:getEntityData(pickup, "PARASITE_WAIT_FOR_QUEUE")) then
                local trinket = ToyboxMod:getEntityData(pickup, "GRAVEYARD_PARASITE")
                if(trinket) then
                    local data = ToyboxMod:getEntityDataTable(pl)
                    data.PARASITE_QUEUE = data.PARASITE_QUEUE or {}
                    table.insert(data.PARASITE_QUEUE, trinket)

                    ToyboxMod:setEntityData(pickup, "GRAVEYARD_PARASITE", nil)
                end
            end
        end
        ToyboxMod:setEntityData(pickup, "PARASITE_WAIT_FOR_QUEUE", nil)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, postPedestalCollection, PickupVariant.PICKUP_COLLECTIBLE)

local previousData = {}

---@param pickup EntityPickup
local function transferMorphData(_, pickup, t,v,s, keepPrice, keepSeed, keepModifiers)
    if(pickup.Variant~=PickupVariant.PICKUP_COLLECTIBLE) then return end
    previousData[tostring(t)..tostring(v)..tostring(s)] = {
        ToyboxMod:getEntityData(pickup, "PARASITE_WAIT_FOR_QUEUE"),
        ToyboxMod:getEntityData(pickup, "GRAVEYARD_PARASITE")
    }
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_PRE_PICKUP_MORPH, CallbackPriority.LATE+1, transferMorphData)

---@param pickup EntityPickup
local function receiveMorphData(_, pickup, t,v,s, keepPrice, keepSeed, keepModifiers)
    if(pickup.Variant~=PickupVariant.PICKUP_COLLECTIBLE) then return end
    local str = tostring(pickup.Type)..tostring(pickup.Variant)..tostring(pickup.SubType)
    if(previousData[str]) then
        ToyboxMod:setEntityData(pickup, "PARASITE_WAIT_FOR_QUEUE", previousData[str][1])
        ToyboxMod:setEntityData(pickup, "GRAVEYARD_PARASITE", previousData[str][2])
    end
    previousData[str] = nil
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_POST_PICKUP_MORPH, CallbackPriority.LATE+1, receiveMorphData)

local function giveQueuedParasite(_, player)
    local data = ToyboxMod:getEntityDataTable(player)
    if(#(data.PARASITE_QUEUE or {})>0) then
        if(player:IsItemQueueEmpty()) then
            local firstParasite = data.PARASITE_QUEUE[1]
            table.remove(data.PARASITE_QUEUE, 1)

            local conf = Isaac.GetItemConfig():GetTrinket(firstParasite or 0)
            if(conf) then
                ToyboxMod.GAME:GetItemPool():RemoveTrinket(firstParasite & (~TrinketType.TRINKET_GOLDEN_FLAG))

                if(player:GetTrinket(player:GetMaxTrinkets()-1)~=0) then
                    player:DropTrinket(player.Position, true)
                end

                player:AnimateTrinket(firstParasite)
                if(firstParasite & TrinketType.TRINKET_GOLDEN_FLAG ~= 0) then
                    player:GetHeldSprite():SetRenderFlags(AnimRenderFlags.GOLDEN)
                end

                ToyboxMod.GAME:GetHUD():ShowItemText(player, conf, true)
                player:QueueItem(conf, 0, false, (firstParasite & TrinketType.TRINKET_GOLDEN_FLAG ~= 0), 0)

                ToyboxMod.SFX:Play(ToyboxMod.SFX_POISON)
            end
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, giveQueuedParasite)


local function getRotationOffset(frame)
    local rad = math.rad(frame*360/PARASITE_ROTATE_TIME)
    local vec = Vector(math.cos(rad), math.sin(rad))*PARASITE_ROTATE_RADIUS
    return vec
end

local function preRenderParasite(_, pickup, offset)
    if(pickup.SubType==0) then return end

    local trinket = ToyboxMod:getEntityData(pickup, "GRAVEYARD_PARASITE")
    if(not trinket) then return end

    local sp = pickup:GetSprite()
    local layer = sp:GetLayer(1)
    local frame = sp:GetLayerFrameData(1)
    if(not layer or not frame or not layer:IsVisible() or sp:GetAnimation()~="Idle") then return end

    local copyColor = Color.Lerp(layer:GetColor(), Color.Default, 0)
    copyColor.A = 0
    layer:SetColor(copyColor)
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_PRE_PICKUP_RENDER, CallbackPriority.LATE+1, preRenderParasite, PickupVariant.PICKUP_COLLECTIBLE)

local function postRenderParasite(_, pickup)
    if(pickup.SubType==0) then return end

    local trinket = ToyboxMod:getEntityData(pickup, "GRAVEYARD_PARASITE")
    if(not trinket) then return end

    local conf = Isaac.GetItemConfig()
    local trinketConf = conf:GetTrinket(trinket)
    if(not trinketConf) then return end

    local sp = pickup:GetSprite()
    local layer = sp:GetLayer(1)
    local frame = sp:GetLayerFrameData(1)
    if(not layer or not frame or not layer:IsVisible() or sp:GetAnimation()~="Idle") then return end

    local roomFrame = ToyboxMod.GAME:GetRoom():GetFrameCount()

    local copyColor = Color.Lerp(layer:GetColor(), Color.Default, 0)
    copyColor.A = 1
    layer:SetColor(copyColor)

    local baseItemPos = getRotationOffset(roomFrame+PARASITE_ROTATE_TIME/2)
    local parasitePos = getRotationOffset(roomFrame)

    if(baseItemPos.Y<parasitePos.Y) then
        sp:RenderLayer(1, Isaac.WorldToRenderPosition(pickup.Position+baseItemPos))
    end

    if(trinket & TrinketType.TRINKET_GOLDEN_FLAG ~= 0) then
        TRINKET_SPRITE:SetRenderFlags(AnimRenderFlags.GOLDEN)
    else
        TRINKET_SPRITE:SetRenderFlags(0)
    end
    TRINKET_SPRITE:ReplaceSpritesheet(0, trinketConf.GfxFileName, true)
    TRINKET_SPRITE.Scale = frame:GetScale()

    local finalParasitePos = parasitePos+pickup.Position+Vector(16,0)+frame:GetPos()-frame:GetPivot()
    TRINKET_SPRITE:Render(Isaac.WorldToRenderPosition(finalParasitePos))

    if(baseItemPos.Y>=parasitePos.Y) then
        sp:RenderLayer(1, Isaac.WorldToRenderPosition(pickup.Position+baseItemPos))
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PICKUP_RENDER, postRenderParasite, PickupVariant.PICKUP_COLLECTIBLE)