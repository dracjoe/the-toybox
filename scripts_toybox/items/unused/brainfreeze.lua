-- feels a bit too janky, uses a cool shader tho
-- its supposed to be an active that gives you this aura for the room but idkkkkkk
-- weird

local BASE_AURA_RADIUS = 1.5*40

local SLOW_MULT = 0.98
local SLOW_FREEZE_THRESHOLD = 0.4
local PROJ_SLOW = 0.85
local SLOW_COLOR = Color(0.9,0.9,1.3,1,0.16,0.16,0.16,0.8,0.8,1.3,1)

---@param pl EntityPlayer
local function checkEnterExitFlayerRadius(_, pl)
    local aura = ToyboxMod:getEntityData(pl, "BRAINFREEZE_AURA")
    if(not (aura and aura:Exists())) then
        aura = Isaac.Spawn(1000,ToyboxMod.EFFECT_AURA,ToyboxMod.EFFECT_AURA_FREEZE,pl.Position,Vector.Zero,pl):ToEffect()
        aura.DepthOffset = -1000
        aura:FollowParent(pl)

        aura.Scale = 1
        aura.SpriteScale = Vector(1,1)*BASE_AURA_RADIUS/(2*40)
        aura.Color = Color(1,1,1,1,0,0,0,0,1,aura.Position.X/1000, aura.Position.Y/1000)

        --aura:GetSprite():GetLayer(0):GetBlendMode():SetMode(BlendType.OVERLAY)
        aura:GetSprite():Play("Appear", true)
        aura:GetSprite():SetCustomShader("shaders_tb/snowflake")

        ToyboxMod:setEntityData(pl, "BRAINFREEZE_AURA", aura)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, checkEnterExitFlayerRadius)

---@param effect EntityEffect
local function auraUpdate(_, effect)
    if(effect.SubType~=ToyboxMod.EFFECT_AURA_FREEZE) then return end

    local sp = effect:GetSprite()
    if(sp:IsFinished("Appear")) then
        sp:Play("Idle", true)
    end

    local alpha = 0.2
    if(sp:GetAnimation()=="Idle") then
        alpha = alpha*(1+0.3*math.sin(math.rad(effect.FrameCount-sp:GetAnimationData("Appear"):GetLength())*15))
    end
    effect.Color = Color(1,1,1,alpha,0,0,0, effect.FrameCount/30, 2, effect.Position.X/1000, effect.Position.Y/1000)

    if(sp:GetAnimation()=="Idle") then
        for _, ent in ipairs(Isaac.FindInRadius(effect.Position, BASE_AURA_RADIUS*effect.Scale, EntityPartition.ENEMY | EntityPartition.BULLET)) do
            if(ToyboxMod:isValidEnemy(ent)) then
                local slow = ToyboxMod:getEntityData(ent, "BRAINFREEZE_SLOW") or 1
                ToyboxMod:setEntityData(ent, "BRAINFREEZE_SLOW", math.max(SLOW_FREEZE_THRESHOLD, slow*SLOW_MULT))
                ToyboxMod:setEntityData(ent, "BRAINFREEZE_ACTIVE", effect.SpawnerEntity)
            elseif(ent:ToProjectile()) then
                local slow = ToyboxMod:getEntityData(ent, "BRAINFREEZE_SLOW") or 1
                ToyboxMod:setEntityData(ent, "BRAINFREEZE_SLOW", math.max(0, slow*PROJ_SLOW))
                ToyboxMod:setEntityData(ent, "BRAINFREEZE_ACTIVE", effect.SpawnerEntity)
            end
        end
    end

    if(effect:Exists() and not (effect.Parent and effect.Parent:Exists())) then
        if(sp:GetAnimation()~="Disappear") then
            sp:Play("Disappear")
        end
        if(sp:IsFinished("Disappear")) then
            effect:Remove()
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, auraUpdate, ToyboxMod.EFFECT_AURA)

local function freezeUpdate(_, ent)
    local slowAmount = ToyboxMod:getEntityData(ent, "BRAINFREEZE_SLOW")
    if(not slowAmount) then return end

    if(ent:ToProjectile()) then
        local prevSlow = ToyboxMod:getEntityData(ent, "BRAINFREEZE_PREV_SLOW") or 1

        ent.Velocity = ent.Velocity/prevSlow
        ent.Velocity = ent.Velocity*slowAmount

        ToyboxMod:setEntityData(ent, "BRAINFREEZE_PREV_SLOW", slowAmount)
    else
        ent:SetSpeedMultiplier(ent:GetSpeedMultiplier()*slowAmount)
        if(not ent:IsBoss() and slowAmount<=SLOW_FREEZE_THRESHOLD) then
            ent:AddIce(EntityRef(ToyboxMod:getEntityData(ent, "BRAINFREEZE_ACTIVE")), 30)
            ent:TakeDamage(99999999, DamageFlag.DAMAGE_INVINCIBLE | DamageFlag.DAMAGE_IGNORE_ARMOR, EntityRef(nil), 0)
            --ent:KillWithSource(EntityRef(ToyboxMod:getEntityData(ent, "BRAINFREEZE_ACTIVE")))
        end
    end

    local color = Color.Lerp(Color.Default, SLOW_COLOR, 1-(slowAmount-SLOW_FREEZE_THRESHOLD)/(1-SLOW_FREEZE_THRESHOLD))
    ent:SetColor(ent.Color*color, 2, 1, false, false)

    if(not ToyboxMod:getEntityData(ent, "BRAINFREEZE_ACTIVE")) then
        slowAmount = ToyboxMod:lerp(slowAmount, 1, 0.1)
        if(slowAmount>0.98) then
            slowAmount = nil
        end
        ToyboxMod:setEntityData(ent, "BRAINFREEZE_SLOW", slowAmount)
    end
    ToyboxMod:setEntityData(ent, "BRAINFREEZE_ACTIVE", nil)
end
ToyboxMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, freezeUpdate)
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, freezeUpdate)