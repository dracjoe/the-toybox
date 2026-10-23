--[[
Tint effects (WIP)

]]

ToyboxMod:registerInnateKey("ForRoom_TintedWhite")
ToyboxMod:registerInnateKey("ForRoom_TintedPurple")

local RED_DMG = 1.2
local BLUE_TEARS = 1
local GREEN_LUCK = 5
local BROWN_SIZE = 0.5

local CYAN_FLY_INTERVAL = 30*2
local CYAN_MAXFLIES = 3

local PINK_RESPAWN_CHANCE = 0.15

local YELLOW_COIN_TIMEOUT = 30*2

local BLACK_RETRIGGERS = 2

---@param pl EntityPlayer
---@param flag CacheFlag
local function evalCache(_, pl, flag)
    if(flag==CacheFlag.CACHE_LUCK and ToyboxMod:hasTintedRoomTint("GREEN")) then
        pl.Luck = pl.Luck+GREEN_LUCK
    elseif(flag==CacheFlag.CACHE_SIZE and ToyboxMod:hasTintedRoomTint("BROWN")) then
        pl.SpriteScale = pl.SpriteScale*BROWN_SIZE
        pl.SizeMulti = pl.SizeMulti*BROWN_SIZE
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evalCache)

---@param pl EntityPlayer
---@param val number
local function evalStat(_, pl, stat, val)
    if(not (stat==EvaluateStatStage.TEARS_UP or stat==EvaluateStatStage.DAMAGE_UP)) then return end

    if(stat==EvaluateStatStage.TEARS_UP and ToyboxMod:hasTintedRoomTint("BLUE")) then
        return val+BLUE_TEARS
    elseif(stat==EvaluateStatStage.DAMAGE_UP and ToyboxMod:hasTintedRoomTint("RED")) then
        return val+RED_DMG
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_EVALUATE_STAT, evalStat)

---@param pl EntityPlayer
---@param val number
local function postEvaluateCustomCache(_, pl, flag, val)
    if(ToyboxMod:hasTintedRoomTint("BLACK")) then
        return val+BLACK_RETRIGGERS
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_EVALUATE_CUSTOM_CACHE, postEvaluateCustomCache, "room-clear-retriggers")

---@param pl EntityPlayer
local function playerUpdate(_, pl)
    if(ToyboxMod:hasTintedRoomTint("CYAN") and pl.FrameCount%CYAN_FLY_INTERVAL==0) then
        local numflies = 0
        local plhash = GetPtrHash(pl)
        for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR,FamiliarVariant.BLUE_FLY)) do
            if(GetPtrHash(ent:ToFamiliar().Player)==plhash) then
                if(EntitySaveStateManager.GetEntityData(ToyboxMod, ent).CYANROOM_FLY) then
                    numflies = numflies+1
                end
            end
        end
        if(numflies<CYAN_MAXFLIES) then
            local fly = pl:AddBlueFlies(1, pl.Position, nil)

            for _, ent in ipairs(Isaac.FindByType(3,FamiliarVariant.BLUE_FLY)) do
                if(ent.FrameCount==0 and GetPtrHash(ent:ToFamiliar().Player)==plhash) then
                    local flyData = EntitySaveStateManager.GetEntityData(ToyboxMod, ent)
                    flyData.CYANROOM_FLY = true
                end
            end
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, playerUpdate)

local function newRoom(_)
    for _, pl in ipairs(PlayerManager.GetPlayers()) do
        if(ToyboxMod:hasTintedRoomTint("WHITE")) then
            pl:AddInnateCollectible(CollectibleType.COLLECTIBLE_WAFER, 1, "ForRoom_TintedWhite")
        end
        if(ToyboxMod:hasTintedRoomTint("PURPLE")) then
            pl:AddInnateCollectible(CollectibleType.COLLECTIBLE_SPOON_BENDER, 1, "ForRoom_TintedPurple")
        end
    end
end
ToyboxMod:AddCallback(ToyboxMod.CUSTOM_CALLBACKS.POST_NEW_ROOM_TINTED, newRoom)

---@param npc EntityNPC
local function npcDeath(_, npc)
    if(ToyboxMod:hasTintedRoomTint("PINK") and ToyboxMod:isValidEnemy(npc) and not (npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) or npc:IsBoss())) then
        local rng = npc:GetDropRNG()
        if(rng:RandomFloat()<PINK_RESPAWN_CHANCE) then
            local newNpc = Isaac.Spawn(npc.Type, npc.Variant, npc.SubType, npc.Position, Vector.Zero, pl):ToNPC()
            newNpc:AddCharmed(EntityRef(pl), -1)
        end
    end
    if(ToyboxMod:hasTintedRoomTint("YELLOW")) then
        local rng = npc:GetDropRNG()
        local dir = Vector.FromAngle(rng:RandomInt(1,360))*3
        local coin = Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COIN,0,npc.Position,dir,nil):ToPickup()
        coin.Timeout = YELLOW_COIN_TIMEOUT
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, npcDeath)