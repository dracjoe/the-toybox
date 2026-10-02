local sfx = SFXManager()

local SHIELD_PIPS = 2

---@param pl EntityPlayer
---@param flags DamageFlag
---@param source EntityRef
local function tryCancelDamage(_, pl, _, flags, source)
    if(not pl:HasCollectible(ToyboxMod.COLLECTIBLE_CAUAC_STORM)) then return end
    if(pl:IsInvincible() or pl:GetDamageCooldown()>0 or pl:HasCollectible(CollectibleType.COLLECTIBLE_HOLY_MANTLE) or pl:HasInvincibility(flags)) then return end

    if(source.Type==6) then return end
    if(flags & (DamageFlag.DAMAGE_FAKE | DamageFlag.DAMAGE_IV_BAG | DamageFlag.DAMAGE_CLONES | DamageFlag.DAMAGE_INVINCIBLE)~=0) then return end

    local conf = Isaac.GetItemConfig()
    local hasCharges = -1
    for i=ActiveSlot.SLOT_PRIMARY, ActiveSlot.SLOT_POCKET2 do
        if(pl:GetActiveItem(i)~=0 and pl:GetActiveCharge(i)>=SHIELD_PIPS) then
            local iconf = conf:GetCollectible(pl:GetActiveItem(i))
            if(iconf and iconf.ChargeType==ItemConfig.CHARGE_NORMAL) then
                hasCharges = i
                break
            end
        end
    end
    if(hasCharges==-1) then return end

    pl:AddActiveCharge(-SHIELD_PIPS, hasCharges)
    pl:AddCollectibleEffect(ToyboxMod.COLLECTIBLE_CAUAC_STORM)
    pl:SetMinDamageCooldown(60*(pl:GetTrinketMultiplier(TrinketType.TRINKET_BLIND_RAGE)+1))

    for _=1, 8 do
        local angle = math.random(1,360)
        local timeout = math.random(4,8)

        local laser = EntityLaser.ShootAngle(LaserVariant.ELECTRIC, pl.Position, angle, timeout, Vector.Zero, nil)
        laser.CollisionDamage = 0
        laser:SetDamageMultiplier(0)
        laser:SetDisableFollowParent(true)
        laser:SetMaxDistance(math.random(30,90))
    end

    pl:SetColor(Color(1,1,1,1,0.35,0.27,0,0,0,0,0), 25, 0, true, false)
    sfx:Play(SoundEffect.SOUND_REDLIGHTNING_ZAP_WEAK)
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_PLAYER_TAKE_DMG, tryCancelDamage)

---@param pl EntityPlayer
local function grantOvercharge(_, pl)
    if(pl.FrameCount==0) then return end
    if(not pl:HasCollectible(ToyboxMod.COLLECTIBLE_CAUAC_STORM)) then return end

    for i=ActiveSlot.SLOT_PRIMARY, ActiveSlot.SLOT_POCKET2 do
        if(pl:GetActiveItem(i)~=0) then
            local conf = Isaac.GetItemConfig():GetCollectible(pl:GetActiveItem(i))
            if(conf and conf.ChargeType==ItemConfig.CHARGE_NORMAL) then
                pl:AddActiveCharge(pl:GetActiveMaxCharge(i), i, true, false, true)
            end
        end
    end
    sfx:Play(SoundEffect.SOUND_REDLIGHTNING_ZAP_WEAK)
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PLAYER_NEW_LEVEL, grantOvercharge)