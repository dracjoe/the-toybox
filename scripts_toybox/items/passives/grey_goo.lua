local SIZE_UP = 1.25

local COLL_DAMAGE = 12

local KILLS_TO_HEAL = 4

---@param pl EntityPlayer
---@param flag CacheFlag
local function evalCache(_, pl, flag)
    if(not pl:HasCollectible(ToyboxMod.COLLECTIBLE_GREY_GOO)) then return end

    pl.SpriteScale = pl.SpriteScale*(SIZE_UP^pl:GetCollectibleNum(ToyboxMod.COLLECTIBLE_GREY_GOO))
end
ToyboxMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evalCache, CacheFlag.CACHE_SIZE)

local function increaseHealCounter(_, player, coll)
    if(player:HasCollectible(ToyboxMod.COLLECTIBLE_GREY_GOO)) then
        if(coll:ToNPC() and not (coll:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) or not (coll:IsEnemy() and coll:IsActiveEnemy(true)))) then
            coll:TakeDamage(COLL_DAMAGE, DamageFlag.DAMAGE_COUNTDOWN, EntityRef(player), 15)
            
            if(coll:HasMortalDamage() or coll:IsDead()) then
                local data = ToyboxMod:getEntityDataTable(player)
                data.GREY_GOO_KILLS = (data.GREY_GOO_KILLS or 0) + 1
                if(data.GREY_GOO_KILLS >= KILLS_TO_HEAL) then
                    data.GREY_GOO_KILLS = 0
                    player:AddHearts(2)

                    
                    local notif = Isaac.Spawn(1000, EffectVariant.HEART, 1, player.Position, Vector.Zero, pl):ToEffect()
                    notif.SpriteOffset = Vector(0, -38)
                    --notif:FollowParent(pl)

                    local sp = notif:GetSprite()
                    sp:Load("gfx_tb/effects/effect_notify.anm2", true)
                    sp:Play("GreyGooHeal", true)

                    ToyboxMod.SFX:Play(SoundEffect.SOUND_VAMP_GULP)
                end
            end
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PLAYER_COLLISION, increaseHealCounter)