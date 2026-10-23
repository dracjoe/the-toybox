local sfx = SFXManager()

local FREE_PICKUP_ID = 12841
local MIN_DRILL_DIST = 60

local PRICE_PER_WAVE = 5
local PRICE_PER_BOSSWAVE = 25

local DEVIL_PRICE_TO_WAVES = {
    [PickupPrice.PRICE_ONE_HEART] = 1,
    [PickupPrice.PRICE_TWO_HEARTS] = 2,
    [PickupPrice.PRICE_THREE_SOULHEARTS] = 2,
    [PickupPrice.PRICE_ONE_HEART_AND_TWO_SOULHEARTS] = 2,
    [PickupPrice.PRICE_SPIKES] = 0,
    [PickupPrice.PRICE_SOUL] = 1,
    [PickupPrice.PRICE_ONE_SOUL_HEART] = 1,
    [PickupPrice.PRICE_TWO_SOUL_HEARTS] = 2,
    [PickupPrice.PRICE_ONE_HEART_AND_ONE_SOUL_HEART] = 2,
}

local PRICE_SPRITE = Sprite("gfx/005.150_shop item.anm2", true)
local SPIKES_SPRITE = Sprite("gfx/1000.174_shop spikes.anm2", true)
SPIKES_SPRITE:Play("Idle", true)

local DRILL_SOUND_VOLUME = 0
local MAX_VOLUME = 0.25
local FRAMES_TO_FULLVOLUME = 20
local FRAMES_TO_NOVOLUME = 5

---@param player EntityPlayer
local function gildedAppleUse(_, _, rng, player, flags, slot, vdata)
    if(ToyboxMod.GAME:GetRoom():GetType()==RoomType.ROOM_CHALLENGE) then
        return {
            Discharge = false,
            Remove = false,
            ShowAnim = true,
        }
    end

    local nearestShopPickup
    for _, pickup in ipairs(Isaac.FindByType(5)) do
        pickup = pickup:ToPickup()
        if(pickup:IsShopItem() and pickup.Price~=PickupPrice.PRICE_FREE) then
            if(nearestShopPickup==nil or (nearestShopPickup and pickup.Position:Distance(player.Position)<nearestShopPickup.Position:Distance(player.Position))) then
                nearestShopPickup = pickup
            end
        end
    end

    if(nearestShopPickup and nearestShopPickup.Position:Distance(player.Position)<=MIN_DRILL_DIST) then
        nearestShopPickup = nearestShopPickup:ToPickup()

        local spawnData = {nearestShopPickup.Type, nearestShopPickup.Variant, nearestShopPickup.SubType, nearestShopPickup.Position}

        local prevIdx = ToyboxMod.GAME:GetLevel():GetPreviousRoomIndex()
        local ogIdx = ToyboxMod.GAME:GetLevel():GetCurrentRoomIndex()

        local isBoss = false

        local ogPrice = nearestShopPickup.Price
        local devilWaves = (ogPrice>0 and 0 or (DEVIL_PRICE_TO_WAVES[ogPrice] or 1))
        if(devilWaves<=0) then
            if(ogPrice>=PRICE_PER_BOSSWAVE) then
                Ambush.SetMaxBossChallengeWaves(1+ogPrice//PRICE_PER_BOSSWAVE)
                isBoss = true
            else
                Ambush.SetMaxChallengeWaves(math.max(1, math.ceil(ogPrice/PRICE_PER_WAVE)))
            end
        else
            Ambush.SetMaxBossChallengeWaves(devilWaves)
            isBoss = true
        end

        local ogSprite = nearestShopPickup:GetSprite()
        local copySprite = Sprite()
        copySprite:Load(ogSprite:GetFilename(), false)
        local layers = copySprite:GetAllLayers()
        for i, layer in ipairs(layers) do
            local id = layer:GetLayerID()
            copySprite:ReplaceSpritesheet(id, ogSprite:GetLayer(id):GetSpritesheetPath())
        end
        copySprite:LoadGraphics()

        copySprite:SetFrame(ogSprite:GetAnimation(), ogSprite:GetFrame())
        if(not ogSprite:IsPlaying()) then
            copySprite:Stop(false)
        end
        if(not ogSprite:IsOverlayPlaying()) then
            copySprite:StopOverlay()
        end

        --print(copySprite:GetFilename())

        ToyboxMod:setExtraData("DRILL_SPRITEDATA", {
            SPRITE = copySprite,
            PRICE = ogPrice,
        })

        nearestShopPickup.Price = 0

        ToyboxMod:setExtraData("DRILLDATA", nil)

                --[ [
        local seed = rng:RandomInt(2^32-1)+1
        local sub = isBoss and 1 or 0
        local room = RoomConfig.GetRandomRoom(seed, false, StbType.SPECIAL_ROOMS, RoomType.ROOM_CHALLENGE, nil, nil, nil, 1, nil, nil, sub)
        Isaac.ExecuteCommand("goto s.challenge."..room.Variant)
        ToyboxMod.GAME:StartRoomTransition(GridRooms.ROOM_DEBUG_IDX, Direction.NO_DIRECTION, RoomTransitionAnim.TELEPORT)


        ToyboxMod:setExtraData("DRILLDATA", {
            IS_ACTIVE = 1,
            FORCE_SET_AMBUSH = 1,
            ITEM_ID = spawnData,
            OG_IDX = ogIdx,
            PRE_IDX = prevIdx,

            IGNORE_RESET_DATA = 1,
        })
        --]]
    end

    return {
        Discharge = true,
        Remove = false,
        ShowAnim = true,
    }
end
ToyboxMod:AddCallback(ModCallbacks.MC_USE_ITEM, gildedAppleUse, ToyboxMod.COLLECTIBLE_DRILL)

local function postUpdate(_)
    local data = ToyboxMod:getExtraDataTable().DRILLDATA
    if(not data) then return end
    if(data.IS_ACTIVE~=1) then return end

    if(data.IGNORE_RESET_DATA~=0) then
        data.IGNORE_RESET_DATA = 0
        ToyboxMod:setExtraData("DRILLDATA", data)
    elseif(ToyboxMod.GAME:GetRoom():GetType()~=RoomType.ROOM_CHALLENGE) then
        Ambush.SetMaxChallengeWaves(3)
        ToyboxMod:setExtraData("DRILLDATA", nil)
    end

    if(ToyboxMod.GAME:GetRoom():GetType()~=RoomType.ROOM_CHALLENGE) then
        return
    end

    if(data.FORCE_SET_AMBUSH~=0) then
        data.FORCE_SET_AMBUSH = 0
        ToyboxMod.GAME:GetRoom():SetAmbushDone(false)
    end

    if(ToyboxMod.GAME:GetRoom():IsAmbushDone()) then
        Ambush.SetMaxChallengeWaves(3)
        data.IS_ACTIVE = -1
        ToyboxMod.GAME:StartRoomTransition(data.OG_IDX, Direction.NO_DIRECTION, RoomTransitionAnim.TELEPORT)
    elseif(not ToyboxMod.GAME:GetRoom():IsAmbushActive()) then
        Ambush.StartChallenge()
    end

    ToyboxMod:setExtraData("DRILLDATA", data)
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_UPDATE, postUpdate)

local function preNewRoom(_)
    local data = ToyboxMod:getExtraDataTable().DRILLDATA
    if(not data) then return end

    if(data.IS_ACTIVE==-1) then
        data.IS_ACTIVE = -2

        local curIdx = ToyboxMod.GAME:GetLevel():GetCurrentRoomIndex()
        if(curIdx==data.OG_IDX) then
            ToyboxMod.GAME:GetLevel():ChangeRoom(data.PRE_IDX, -1)
            ToyboxMod.GAME:GetLevel():ChangeRoom(curIdx, -1)
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_NEW_ROOM, preNewRoom)

local function preIdxUpdate(_)
    ToyboxMod:setExtraData("DRILL_PREIDX", ToyboxMod.GAME:GetLevel():GetCurrentRoomIndex())

    local data = ToyboxMod:getExtraDataTable().DRILLDATA
    if(not data) then return end

    if(data.IS_ACTIVE==1) then
        local room = ToyboxMod.GAME:GetRoom()
        if(room:GetType()~=RoomType.ROOM_CHALLENGE) then
            Ambush.SetMaxChallengeWaves(3)
            ToyboxMod:setExtraData("DRILLDATA", nil)
        else
            local center = room:GetCenterPos()

            local hadPickupInCenter = false
            for _, pickup in ipairs(Isaac.GetRoomEntities()) do
                if(pickup.Type==5) then
                    if(pickup.Position:Distance(center)<5) then
                        hadPickupInCenter = true
                    end

                    pickup:Remove()
                end
            end

            local pos = (hadPickupInCenter and center or room:FindFreePickupSpawnPosition(center))
            local drill = Isaac.Spawn(EntityType.ENTITY_EFFECT,ToyboxMod.EFFECT_DRILL, 0, pos, Vector.Zero, nil)
        end
    else
        ToyboxMod:setExtraData("DRILL_SPRITEDATA", nil)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, preIdxUpdate)

local function cancelDrillChallengeRecharges(_)
    local data = ToyboxMod:getExtraDataTable().DRILLDATA
    if(not data) then return end
    if(data.IS_ACTIVE~=1) then return end

    return false
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_PLAYER_TRIGGER_ROOM_CLEAR, cancelDrillChallengeRecharges)

local function cancelDrillChallengeAwards(_)
    local data = ToyboxMod:getExtraDataTable().DRILLDATA
    if(not data) then return end
    if(data.IS_ACTIVE~=1) then return end

    return true
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, cancelDrillChallengeAwards)

---@param effect EntityEffect
---@param offset Vector
local function drillEffectRender(_, effect, offset)
    local spdata = ToyboxMod:getExtraData("DRILL_SPRITEDATA")
    if(spdata and spdata.SPRITE) then
        local sp = spdata.SPRITE ---@type Sprite

        local rPos = Isaac.WorldToRenderPosition(effect.Position)

        local price = spdata.PRICE or 15
        if(price>=0) then
            PRICE_SPRITE:Play("NumbersWhite", true)
            PRICE_SPRITE:SetLayerFrame(2, 10)
            PRICE_SPRITE:SetLayerFrame(1, price%10)
            PRICE_SPRITE:SetLayerFrame(0, price//10)
            if(price<10) then
                PRICE_SPRITE:GetLayer(0):SetVisible(false)
            else
                PRICE_SPRITE:GetLayer(0):SetVisible(true)
            end

            PRICE_SPRITE:Render(rPos)
        elseif(price==PickupPrice.PRICE_SPIKES) then
            SPIKES_SPRITE:Render(rPos)
        elseif(price>PickupPrice.PRICE_ONE_HEART_AND_ONE_SOUL_HEART) then
            PRICE_SPRITE:Play("Hearts", true)
            PRICE_SPRITE:SetFrame(-price-(price<PickupPrice.PRICE_SPIKES and 1 or 0)-1)

            PRICE_SPRITE:Render(rPos)
        end

        sp:Render(rPos)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_EFFECT_RENDER, drillEffectRender, ToyboxMod.EFFECT_DRILL)

---@param effect EntityEffect
local function drillEffectUpdate(_, effect)
    if(effect.FrameCount%3==0) then
        local pos = effect.Position+Vector(0,4)
        local vel = Vector.FromAngle(math.random(1,360))*1

        local ember = Isaac.Spawn(1000,66,0,pos,vel,nil):ToEffect()
        ember.Color = Color(1,1,1,1,0.4,0.4,0,1,1,0,1)
        ember.SpriteOffset = Vector(-1,-12)
        ember.SpriteScale = Vector(1,1)*0.67
    end

    DRILL_SOUND_VOLUME = math.min(MAX_VOLUME, DRILL_SOUND_VOLUME+MAX_VOLUME/FRAMES_TO_FULLVOLUME)
    if(not sfx:IsPlaying(ToyboxMod.SFX_DRILL)) then
        sfx:Play(ToyboxMod.SFX_DRILL, DRILL_SOUND_VOLUME, 2, true)
    end
    sfx:AdjustVolume(ToyboxMod.SFX_DRILL, DRILL_SOUND_VOLUME)
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, drillEffectUpdate, ToyboxMod.EFFECT_DRILL)

---@param effect EntityEffect
local function tryStopDrillSfx(_, effect)
    if(effect.Variant==ToyboxMod.EFFECT_DRILL) then
        local FADEOUT_DUR = 12
        Isaac.CreateTimer(function()
            DRILL_SOUND_VOLUME = math.max(0, DRILL_SOUND_VOLUME-MAX_VOLUME/FRAMES_TO_NOVOLUME)
            sfx:AdjustVolume(ToyboxMod.SFX_DRILL, DRILL_SOUND_VOLUME)

            if(DRILL_SOUND_VOLUME<0.01) then
                sfx:Stop(ToyboxMod.SFX_DRILL)
            end
        end, 1, FRAMES_TO_NOVOLUME, true)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, tryStopDrillSfx, EntityType.ENTITY_EFFECT)
--]]