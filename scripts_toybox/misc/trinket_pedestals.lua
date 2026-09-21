local ROTATE_TIME = 30*4
local ROTATE_RADIUS = Vector(12,5)

local TIME_PER_TRINKET_THRESHOLD = 25
local RADIUS_PER_TRINKET_THRESHOLD = Vector(1,0.25)
local REQ_THRESHOLD = 3

local TRINKET_SPRITE = Sprite("gfx_tb/ui/ui_item_render.anm2", false)
TRINKET_SPRITE:Play("Idle", true)

local previousData = {}

---@param pickup EntityPickup
---@param newData table?
local function setPedestalTrinketSavedData(pickup, newData)
    local extraData = ToyboxMod:getExtraDataTable()
    extraData.SAVED_PEDESTAL_TRINKETS = extraData.SAVED_PEDESTAL_TRINKETS or {}

    local idx = ToyboxMod.GAME:GetLevel():GetCurrentRoomDesc().SafeGridIndex
    extraData[idx] = extraData[idx] or {}
    extraData[idx][tostring(pickup.InitSeed)] = newData
end

---@param pickup EntityPickup
---@return table?
local function getPedestalTrinketSavedData(pickup)
    local extraData = ToyboxMod:getExtraDataTable()
    extraData.SAVED_PEDESTAL_TRINKETS = extraData.SAVED_PEDESTAL_TRINKETS or {}

    local idx = ToyboxMod.GAME:GetLevel():GetCurrentRoomDesc().SafeGridIndex
    extraData[idx] = extraData[idx] or {}

    return extraData[idx][tostring(pickup.InitSeed)]
end

local function populateTrinketData(currentData)
    local baseData = {
        ID = 0,
        SFX = SoundEffect.SOUND_POWERUP1,
        IsTrinket = true,
    }
    for key, val in pairs(currentData) do
        baseData[key] = val
    end
    return baseData
end

local function cmpSortTrinketData(a,b)
    return (a.IsTrinket and 1 or 0)<(b.IsTrinket and 1 or 0)
end

---@param pickup EntityPickup
---@param trinket TrinketType|TrinketType[]
function ToyboxMod:addHybridPedestal(pickup, trinket)
    local data = ToyboxMod:getEntityDataTable(pickup)
    data.PEDESTAL_TRINKETS = data.PEDESTAL_TRINKETS or {}
    if(type(trinket)=="table") then
        if(trinket.ID) then
            table.insert(data.PEDESTAL_TRINKETS, populateTrinketData(trinket))
        else
            for _, tr in ipairs(trinket) do
                if(type(tr)=="number") then
                    table.insert(data.PEDESTAL_TRINKETS, populateTrinketData({ID=tr}))
                else
                    table.insert(data.PEDESTAL_TRINKETS, populateTrinketData(tr))
                end
            end
        end
    else
        table.insert(data.PEDESTAL_TRINKETS, populateTrinketData({ID=trinket}))
    end

    table.sort(data.PEDESTAL_TRINKETS, cmpSortTrinketData)

    setPedestalTrinketSavedData(pickup, data.PEDESTAL_TRINKETS)
end

---@param pickup EntityPickup
---@param id CollectibleType
function ToyboxMod:addHybridPedestalCollectible(pickup, id)
    ToyboxMod:addHybridPedestal(pickup, {ID=id, IsTrinket=false})
end

---@param pickup EntityPickup
---@param id CollectibleType
function ToyboxMod:addHybridPedestalTrinket(pickup, id)
    ToyboxMod:addHybridPedestal(pickup, {ID=id, IsTrinket=true})
end

local function replaceCollectiblePedestal(_, pickup)
    if(pickup.Touched) then return end

    local savedData = getPedestalTrinketSavedData(pickup)
    if(savedData) then
        ToyboxMod:setEntityData(pickup, "PEDESTAL_TRINKETS", savedData)
    else
        if(previousData[tostring(pickup.Type)..tostring(pickup.Variant)..tostring(pickup.SubType)]) then return end

        local callbacks = Isaac.GetCallbacks(ToyboxMod.CUSTOM_CALLBACKS.ADD_PEDESTAL_TRINKETS, true)
        for _, callbackData in ipairs(callbacks) do
            local ret = callbackData.Function(callbackData.Mod, pickup)
            if(ret) then
                ToyboxMod:addHybridPedestal(pickup, ret)
            end
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, replaceCollectiblePedestal, PickupVariant.PICKUP_COLLECTIBLE)

---@param pickup EntityPickup
---@param coll Entity
local function prePedestalCollection(_, pickup, coll, low)
    if(coll and coll:ToPlayer()) then
        local pl = coll:ToPlayer()
        if(pl:IsItemQueueEmpty() and pickup.SubType~=0) then
            ToyboxMod:setEntityData(pickup, "PEDESTAL_TRINKET_COLL_WAIT", pickup.SubType)
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, prePedestalCollection, PickupVariant.PICKUP_COLLECTIBLE)

---@param pickup EntityPickup
---@param coll Entity
local function postPedestalCollection(_, pickup, coll, low)
    if(coll and coll:ToPlayer()) then
        local pl = coll:ToPlayer()
        if(ToyboxMod:getEntityData(pickup, "PEDESTAL_TRINKET_COLL_WAIT") and not pl:IsItemQueueEmpty()) then
            if(pl.QueuedItem and pl.QueuedItem.Item and pl.QueuedItem.Item.ID==ToyboxMod:getEntityData(pickup, "PEDESTAL_TRINKET_COLL_WAIT")) then
                local trinkets = ToyboxMod:getEntityData(pickup, "PEDESTAL_TRINKETS")
                if(trinkets) then
                    local data = ToyboxMod:getEntityDataTable(pl)
                    data.PEDESTAL_TRINKET_QUEUE = data.PEDESTAL_TRINKET_QUEUE or {}
                    for _, trinket in ipairs(trinkets) do
                        table.insert(data.PEDESTAL_TRINKET_QUEUE, trinket)
                    end

                    ToyboxMod:setEntityData(pickup, "PEDESTAL_TRINKETS", nil)
                    setPedestalTrinketSavedData(pickup, nil)
                end
            end
        end
        ToyboxMod:setEntityData(pickup, "PEDESTAL_TRINKET_COLL_WAIT", nil)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, postPedestalCollection, PickupVariant.PICKUP_COLLECTIBLE)

---@param pickup EntityPickup
local function transferMorphData(_, pickup, t,v,s, keepPrice, keepSeed, keepModifiers)
    if(pickup.Variant~=PickupVariant.PICKUP_COLLECTIBLE) then return end

    if(keepModifiers) then
        previousData[tostring(t)..tostring(v)..tostring(s)] = {
            ToyboxMod:getEntityData(pickup, "PEDESTAL_TRINKET_COLL_WAIT"),
            ToyboxMod:getEntityData(pickup, "PEDESTAL_TRINKETS")
        }
    end
    setPedestalTrinketSavedData(pickup, nil)
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_PRE_PICKUP_MORPH, CallbackPriority.LATE+1, transferMorphData)

---@param pickup EntityPickup
local function receiveMorphData(_, pickup, t,v,s, keepPrice, keepSeed, keepModifiers)
    if(pickup.Variant~=PickupVariant.PICKUP_COLLECTIBLE) then return end

    if(keepModifiers) then
        local str = tostring(pickup.Type)..tostring(pickup.Variant)..tostring(pickup.SubType)
        if(previousData[str]) then
            ToyboxMod:setEntityData(pickup, "PEDESTAL_TRINKET_COLL_WAIT", previousData[str][1])
            ToyboxMod:setEntityData(pickup, "PEDESTAL_TRINKETS", previousData[str][2])
        end
        previousData[str] = nil
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_POST_PICKUP_MORPH, CallbackPriority.LATE+1, receiveMorphData)

local function giveQueuedPedestalTrinket(_, player)
    local data = ToyboxMod:getEntityDataTable(player)
    if(#(data.PEDESTAL_TRINKET_QUEUE or {})>0) then
        if(player:IsItemQueueEmpty()) then
            table.sort(data.PEDESTAL_TRINKET_QUEUE, cmpSortTrinketData)

            local conf = Isaac.GetItemConfig()
            local hud = ToyboxMod.GAME:GetHUD()

            local first = data.PEDESTAL_TRINKET_QUEUE[1]
            if(not first.IsTrinket) then
                player:AnimateCollectible(first.ID)

                local iconf = conf:GetCollectible(first.ID)
                if(iconf) then
                    hud:ShowItemText(player, iconf, true)
                    player:QueueItem(iconf, 0, false, false, 0)
                end

                ToyboxMod.SFX:Play(first.SFX or SoundEffect.SOUND_POWERUP1)

                table.remove(data.PEDESTAL_TRINKET_QUEUE, 1)
            else
                local pool = ToyboxMod.GAME:GetItemPool()

                local alreadySpawnedATrinket = false
                while(#data.PEDESTAL_TRINKET_QUEUE>0) do
                    first = data.PEDESTAL_TRINKET_QUEUE[1]

                    local tconf = conf:GetTrinket(first.ID)
                    if(tconf) then
                        if(player:GetTrinket(player:GetMaxTrinkets()-1)~=0) then
                            local pos = player.Position+RandomVector()
                            if(alreadySpawnedATrinket) then
                                pos = ToyboxMod.GAME:GetRoom():FindFreePickupSpawnPosition(pos, 0)
                            end
                            player:DropTrinket(pos, true)
                            alreadySpawnedATrinket = true
                        end

                        player:AnimateTrinket(first.ID)
                        if(first.ID & TrinketType.TRINKET_GOLDEN_FLAG ~= 0) then
                            player:GetHeldSprite():SetRenderFlags(AnimRenderFlags.GOLDEN)
                        end

                        if(#data.PEDESTAL_TRINKET_QUEUE==1) then
                            hud:ShowItemText(player, tconf, true)
                            player:QueueItem(tconf, 0, false, (first.ID & TrinketType.TRINKET_GOLDEN_FLAG ~= 0), 0)
                            ToyboxMod.SFX:Play(first.SFX or SoundEffect.SOUND_POWERUP1)
                        else
                            player:AddTrinket(first.ID, true)
                        end
                        
                        pool:RemoveTrinket(first.ID & ~TrinketType.TRINKET_GOLDEN_FLAG)
                    end

                    table.remove(data.PEDESTAL_TRINKET_QUEUE, 1)
                end
                if(alreadySpawnedATrinket) then
                    local numSpawned = 0
                    for _, pickup in ipairs(Isaac.FindByType(5,350)) do
                        if(pickup.FrameCount==0) then
                            pickup:ToPickup():SetDropDelay(numSpawned*3)

                            numSpawned = numSpawned+1
                        end
                    end
                end
            end
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, giveQueuedPedestalTrinket)


local function getRotationOffset(frame, reqTime, reqRadius)
    local rad = math.rad(frame*360/reqTime)
    local vec = Vector(math.cos(rad), math.sin(rad))*reqRadius
    return vec
end

local function preRenderPedestalTrinket(_, pickup, offset)
    if(pickup.SubType==0) then return end
    --if(ToyboxMod.GAME:GetRoom():GetRenderMode()==RenderMode.RENDER_WATER_REFLECT) then return end

    local trinkets = ToyboxMod:getEntityData(pickup, "PEDESTAL_TRINKETS")
    if(not trinkets) then return end

    local sp = pickup:GetSprite()
    local layer = sp:GetLayer(1)
    local frame = sp:GetLayerFrameData(1)
    if(not layer or not frame or not layer:IsVisible() or sp:GetAnimation()~="Idle") then return end

    local copyColor = Color.Lerp(layer:GetColor(), Color.Default, 0)
    copyColor.A = 0
    layer:SetColor(copyColor)
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_PRE_PICKUP_RENDER, CallbackPriority.LATE+1, preRenderPedestalTrinket, PickupVariant.PICKUP_COLLECTIBLE)

local function postRenderPedestalTrinket(_, pickup, offset)
    if(pickup.SubType==0) then return end
    --if(ToyboxMod.GAME:GetRoom():GetRenderMode()==RenderMode.RENDER_WATER_REFLECT) then return end

    local trinkets = ToyboxMod:getEntityData(pickup, "PEDESTAL_TRINKETS")
    if(not trinkets) then return end

    local conf = Isaac.GetItemConfig()

    local sp = pickup:GetSprite()
    local layer = sp:GetLayer(1)
    local frame = sp:GetLayerFrameData(1)
    if(not layer or not frame or not layer:IsVisible() or sp:GetAnimation()~="Idle") then return end

    local reflect = ToyboxMod.GAME:GetRoom():GetRenderMode()==RenderMode.RENDER_WATER_REFLECT

    local roomFrame = ToyboxMod.GAME:GetRoom():GetFrameCount()

    local copyColor = Color.Lerp(layer:GetColor(), Color.Default, 0)
    copyColor.A = 1
    layer:SetColor(copyColor)

    local renderList = {}

    local realTime = ROTATE_TIME+TIME_PER_TRINKET_THRESHOLD*math.max(#trinkets-REQ_THRESHOLD, 0)
    local realRadius = ROTATE_RADIUS+RADIUS_PER_TRINKET_THRESHOLD*math.max(#trinkets-REQ_THRESHOLD, 0)

    table.insert(renderList, {"REAL_ITEM", getRotationOffset(roomFrame, realTime, realRadius)})

    for i, trinket in ipairs(trinkets) do
        table.insert(renderList, {trinket, getRotationOffset(roomFrame+realTime*i/(#trinkets+1), realTime, realRadius)})
    end

    table.sort(renderList, function(a,b) return a[2].Y<b[2].Y end)

    for _, renderData in ipairs(renderList) do
        if(renderData[1]=="REAL_ITEM") then
            sp:RenderLayer(1, Isaac.WorldToRenderPosition(pickup.Position+renderData[2])+offset)
        else
            local trinketConf = renderData[1].IsTrinket and conf:GetTrinket(renderData[1].ID) or conf:GetCollectible(renderData[1].ID)

            if(renderData[1].IsTrinket and renderData[1].ID & TrinketType.TRINKET_GOLDEN_FLAG ~= 0) then
                TRINKET_SPRITE:SetRenderFlags(AnimRenderFlags.GOLDEN)
            else
                TRINKET_SPRITE:SetRenderFlags(0)
            end
            TRINKET_SPRITE:ReplaceSpritesheet(0, trinketConf.GfxFileName, true)
            TRINKET_SPRITE.Scale = frame:GetScale()

            local finalPedestalTrinketPos = renderData[2]+Vector(16,0)+frame:GetPos()-frame:GetPivot()
            finalPedestalTrinketPos = pickup.Position+Vector(1,(reflect and -1 or 1))*finalPedestalTrinketPos

            TRINKET_SPRITE:Render(Isaac.WorldToRenderPosition(finalPedestalTrinketPos)+offset)
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PICKUP_RENDER, postRenderPedestalTrinket, PickupVariant.PICKUP_COLLECTIBLE)



--[[] ]
local function testCallback(_, pickup)
    local numToAddTrinket = 1
    local numToAddItem = 1
    local pool = ToyboxMod.GAME:GetItemPool()
    local rng = pickup:GetDropRNG()

    local added = {}
    for _=1, numToAddTrinket do
        table.insert(added, {
            ID = pool:GetTrinket(false),
            SFX = ToyboxMod.SFX_POISON,
            IsTrinket = true,
        })
    end
    for _=1, numToAddItem do
        local roomPool = ToyboxMod.GAME:GetRoom():GetItemPool(rng:Next(), false)
        roomPool = (roomPool==ItemPoolType.POOL_NULL and ItemPoolType.POOL_TREASURE or roomPool)
        table.insert(added, {
            ID = pool:GetCollectible(roomPool),
            SFX = SoundEffect.SOUND_POWERUP1,
            IsTrinket = false,
        })
    end

    return added
end
ToyboxMod:AddCallback(ToyboxMod.CUSTOM_CALLBACKS.ADD_PEDESTAL_TRINKETS, testCallback)
--]]