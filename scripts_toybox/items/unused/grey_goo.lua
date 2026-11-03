local SIZE_UP = 1/6

local COLL_DAMAGE = 6
local COLL_DAMAGE_PER_EFFECT = 2
local COLL_FREQ = 10

---@param player EntityPlayer
---@param npc EntityNPC
local function isBiggerThanNPC(player, npc)
    local playerSize = player.Size * player.SizeMulti * player.SpriteScale
    local npcSize = npc.Size * npc.SizeMulti * npc.SpriteScale

    return (playerSize.X + playerSize.Y) > ((npcSize.X + npcSize.Y) + npc.MaxHitPoints) / 2
end

---@param pl EntityPlayer
---@param flag CacheFlag
local function evalCache(_, pl, flag)
    local mult = pl:GetEffects():GetCollectibleEffectNum(ToyboxMod.COLLECTIBLE_GREY_GOO)
    if(mult == 0) then return end
    pl.SpriteScale = pl.SpriteScale*(1 + SIZE_UP*mult)
end
ToyboxMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evalCache, CacheFlag.CACHE_SIZE)

local function cancelColl(_, npc, coll)
    if(coll and coll:ToPlayer() and coll:ToPlayer():HasCollectible(ToyboxMod.COLLECTIBLE_GREY_GOO)) then
        if(isBiggerThanNPC(coll:ToPlayer(), npc)) then
            return {
                Collide = true,
                SkipCollisionEffects = true,
            }
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, cancelColl)

local function hurtOnColl(_, player, coll)
    if(player:HasCollectible(ToyboxMod.COLLECTIBLE_GREY_GOO) and ToyboxMod:isValidEnemy(coll)) then
        if(coll:GetDamageCountdown() == 0 and isBiggerThanNPC(player, coll:ToNPC())) then
            local dmg = COLL_DAMAGE + pl:GetEffects():GetCollectibleEffectNum(ToyboxMod.COLLECTIBLE_GREY_GOO) * COLL_DAMAGE_PER_EFFECT

            coll:TakeDamage(dmg, DamageFlag.DAMAGE_COUNTDOWN, EntityRef(player), COLL_FREQ)
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, hurtOnColl)

local function increaseSizeOnBossClear(_)
    local roomType = ToyboxMod.GAME:GetRoom():GetType()
    if(not (roomType==RoomType.ROOM_BOSS or roomType==RoomType.ROOM_BOSSRUSH or roomType==RoomType.ROOM_MINIBOSS)) then return end

    for plIdx=0, ToyboxMod.GAME:GetNumPlayers()-1 do
        local pl = Isaac.GetPlayer(plIdx)
        if(pl:HasCollectible(ToyboxMod.COLLECTIBLE_GREY_GOO)) then
            pl:GetEffects():AddCollectibleEffect(ToyboxMod.COLLECTIBLE_GREY_GOO, true, pl:GetCollectibleNum(ToyboxMod.COLLECTIBLE_GREY_GOO))

            ToyboxMod.SFX:Play(SoundEffect.SOUND_BLOBBY_WIGGLE)
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, increaseSizeOnBossClear)