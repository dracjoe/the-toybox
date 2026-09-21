local ITEMS_DELAY = 17
local FASTER_DELAY = 10

local ITEM_DURATION = 45*30

local function useBreakthrough(_, _, rng, player, flags, slot)
    if(flags & UseFlag.USE_CARBATTERY == UseFlag.USE_CARBATTERY) then return end

    local isCarbattery = player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY)

    local itemsToGive = 2
    if(slot~=-1 and player:GetActiveItem(slot)==ToyboxMod.COLLECTIBLE_BREAKTHROUGH) then
        itemsToGive = player:GetActiveCharge(slot)
    end
    if(isCarbattery) then
        itemsToGive = itemsToGive*2
    end

    local pool = ToyboxMod.GAME:GetItemPool()
    local roomPool = ToyboxMod.GAME:GetRoom():GetItemPool(rng:Next(), false)
    roomPool = (roomPool==ItemPoolType.POOL_NULL and ItemPoolType.POOL_TREASURE or roomPool)

    Isaac.CreateTimer(function()
        if(not player) then return end

        local conf = Isaac.GetItemConfig()
        local id = CollectibleType.COLLECTIBLE_NULL
        local failsafe = 150
        while(id==CollectibleType.COLLECTIBLE_NULL and failsafe>0) do
            id = pool:GetCollectible(roomPool, false, nil, CollectibleType.COLLECTIBLE_SAD_ONION, GetCollectibleFlag.BAN_ACTIVES)
            local iconf = conf:GetCollectible(id)
            if(not (iconf and iconf:HasTags(ItemConfig.TAG_SUMMONABLE))) then
                id = CollectibleType.COLLECTIBLE_NULL
            end

            failsafe = failsafe-1
        end
        id = (id==CollectibleType.COLLECTIBLE_NULL and CollectibleType.COLLECTIBLE_SAD_ONION or id)

        player:AddInnateCollectible(id, 1, "Toybox_Breakthrough", ITEM_DURATION, true)
        player:AnimateCollectible(id, "UseItem")

        ToyboxMod.SFX:Play(SoundEffect.SOUND_POWERUP1)

        local data = ToyboxMod:getEntityDataTable(player)
        data.BREAKTHROUGH_TIMERS = data.BREAKTHROUGH_TIMERS or {}
        table.insert(data.BREAKTHROUGH_TIMERS, {ToyboxMod.GAME:GetFrameCount()+ITEM_DURATION, id})
    end, (isCarbattery and FASTER_DELAY or ITEMS_DELAY), itemsToGive, true)

    ToyboxMod.SFX:Play(ToyboxMod.SFX_EUREKA)

    return {
        Discharge = true,
        Remove = false,
        ShowAnim = true,
    }
end
ToyboxMod:AddCallback(ModCallbacks.MC_USE_ITEM, useBreakthrough, ToyboxMod.COLLECTIBLE_BREAKTHROUGH)

local function peffectUpdate(_, player)
    local data = ToyboxMod:getEntityDataTable(player)
    data.BREAKTHROUGH_TIMERS = data.BREAKTHROUGH_TIMERS or {}
    if(#data.BREAKTHROUGH_TIMERS>0) then
        local conf = Isaac.GetItemConfig()
        for i=1, #data.BREAKTHROUGH_TIMERS do
            if(data.BREAKTHROUGH_TIMERS[i] and data.BREAKTHROUGH_TIMERS[i][1]<=ToyboxMod.GAME:GetFrameCount()) then
                local eff = Isaac.Spawn(1000,ToyboxMod.EFFECT_ITEM_AFTERIMAGE,0,player.Position,Vector(0,-0.5),nil):ToEffect()
                local item = conf:GetCollectible(data.BREAKTHROUGH_TIMERS[i][2])
                if(item) then
                    eff:GetSprite():ReplaceSpritesheet(0, item.GfxFileName, true)
                end
                eff.SpriteScale = player.SpriteScale
                eff.SpriteOffset = player.SpriteScale*Vector(0,-10)
                eff.DepthOffset = 15
                eff:Update()

                table.remove(data.BREAKTHROUGH_TIMERS, i)
                i = i-1

                ToyboxMod.SFX:Play(ToyboxMod.SFX_EUREKA_DISCHARGE, 0.9, nil, nil, 1.17)
            end
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, peffectUpdate)

---@param pl EntityPlayer
---@param slot EntitySlot
local function renderBreakthrough(_, pl, slot)
    return {
        CropOffset = Vector(32*(pl:GetActiveCharge(slot)>0 and 1 or 0),0),
        HideOutline = true,
    }
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_ACTIVE_ITEM, renderBreakthrough, ToyboxMod.COLLECTIBLE_BREAKTHROUGH)

---@param slot ActiveSlot
---@param pl EntityPlayer
---@param minCharge integer
local function getMinUsableCharge(_, slot, pl, minCharge)
    return 1
end
ToyboxMod:AddCallback(ModCallbacks.MC_PLAYER_GET_ACTIVE_MIN_USABLE_CHARGE, getMinUsableCharge, ToyboxMod.COLLECTIBLE_BREAKTHROUGH)

local function afterimageEffectInit(_, eff)
    eff:GetSprite():Play("Idle", true)

    local impact = Isaac.Spawn(1000,50,5,eff.Position,eff.Velocity,eff):ToEffect()
    impact:FollowParent(eff)
    impact.SpriteScale = eff.SpriteScale*0.8
    impact.DepthOffset = -1
    impact:Update()
    eff.Child = impact
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, afterimageEffectInit, ToyboxMod.EFFECT_ITEM_AFTERIMAGE)

local function afterimageEffectUpdate(_, eff)
    if(eff.FrameCount>(30+15)) then
        eff:Remove()
        return
    end

    local rng = eff:GetDropRNG()

    local alpha = (1-math.max(eff.FrameCount-30, 0)/15)*ToyboxMod:clamp((rng:RandomFloat()-0.27)*30, 0, 1)*0.75
    local blue = rng:PhantomFloat()*0.7+0.3
    rng:Previous()
    if(eff.FrameCount%2==0) then
        rng:Next()
        rng:Next()
    end

    eff.Color = Color(0.8-blue*0.1,0.8+blue*0.1,0.9+blue*0.3,alpha,0,blue*0.15,blue*0.3)
    eff.Velocity = eff.Velocity*0.97

    if(eff.Child) then
        eff.Child.Color = Color(0,0,0,alpha*2,0,0.8,0.7+blue*0.3)
        eff.Child.SpriteOffset = eff.SpriteOffset
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, afterimageEffectUpdate, ToyboxMod.EFFECT_ITEM_AFTERIMAGE)