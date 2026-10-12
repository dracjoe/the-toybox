local BASE_AURA_RADIUS = 80

local TEAR_MULT = 3
local DMG_MULT = 2

---@param entity Entity
---@param player EntityPlayer
local function postAddTearFlag(_, entity, player, _, weaponFlag)
    if(entity and entity:ToBomb()) then
        local sp = entity:GetSprite()

        local name = sp:GetFilename()
        name = string.gsub(name, "gfx/items/pick ups/bombs/", "")
        name = string.gsub(name, ".anm2", "")

        if(string.sub(name,1,-2)=="bomb") then
            sp:ReplaceSpritesheet(0, "gfx_tb/bombs/blessed_bomb.png", true)
        end
    end
end
ToyboxMod:AddCallback(TearFlagsLib.Callback.POST_ADD_TEARFLAG, postAddTearFlag, ToyboxMod.TEARFLAGS.BOMB_BLESSED)


---@param bomb EntityBomb
local function blessedBombUpdate(_, bomb)
    if(not TearFlagsLib.HasTearFlags(bomb, ToyboxMod.TEARFLAGS.BOMB_BLESSED)) then return end

    local blessedAura = ToyboxMod:getEntityData(bomb, "BLESSED_BOMB_AURA")
    if(not (blessedAura and blessedAura:Exists())) then
        blessedAura = Isaac.Spawn(1000,ToyboxMod.EFFECT_AURA,ToyboxMod.EFFECT_AURA_BOMB_BLESSED,bomb.Position,Vector.Zero,bomb):ToEffect()
        blessedAura.DepthOffset = -1000
        blessedAura:FollowParent(bomb)
        --blessedAura:GetSprite():GetLayer(0):GetBlendMode():SetMode(BlendType.NORMAL)
    
        blessedAura.Scale = ToyboxMod:getBombRadius(bomb)/BASE_AURA_RADIUS
        blessedAura.SpriteScale = Vector(1,1)*blessedAura.Scale*BASE_AURA_RADIUS/(2*40)
    
        blessedAura:GetSprite():Play("Appear", true)

        ToyboxMod:setEntityData(bomb, "BLESSED_BOMB_AURA", blessedAura)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, blessedBombUpdate)

---@param effect EntityEffect
local function blessedAuraUpdate(_, effect)
    if(effect.SubType~=ToyboxMod.EFFECT_AURA_BOMB_BLESSED) then return end

    local sp = effect:GetSprite()
    if(sp:IsFinished("Appear")) then
        sp:Play("Idle", true)
    end

    local alpha = 0.3
    if(sp:GetAnimation()=="Idle") then
        alpha = alpha*(1+0.1*math.sin(math.rad(effect.FrameCount-sp:GetAnimationData("Appear"):GetLength())*15))
    end
    effect.Color = Color(1,1,1,alpha)

    if(effect:Exists() and not (effect.Parent and effect.Parent:Exists())) then
        if(sp:GetAnimation()~="Disappear") then
            sp:Play("Disappear")
        end
        if(sp:IsFinished("Disappear")) then
            effect:Remove()
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, blessedAuraUpdate, ToyboxMod.EFFECT_AURA)

local function checkEnterExitBlessedRadius(_, pl)
    local data = ToyboxMod:getEntityDataTable(pl)

    data.BLESSED_AURAS = 0
    for _, effect in ipairs(Isaac.FindByType(1000,ToyboxMod.EFFECT_AURA,ToyboxMod.EFFECT_AURA_BOMB_BLESSED)) do
        effect = effect:ToEffect()

        local dist = effect.Scale*effect.Scale*BASE_AURA_RADIUS*BASE_AURA_RADIUS
        if(effect.Position:DistanceSquared(pl.Position)<=dist) then
            data.BLESSED_AURAS = data.BLESSED_AURAS+1
        end
    end

    if(data.BLESSED_AURAS~=data.BLESSED_AURAS_PREV) then
        pl:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_TEARFLAG | CacheFlag.CACHE_TEARCOLOR, true)
    end

    data.BLESSED_AURAS_PREV = data.BLESSED_AURAS
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, checkEnterExitBlessedRadius)

---@param player EntityPlayer
---@param flag CacheFlag
local function evalAuraCache(_, player, flag)
    local aurasNum = ToyboxMod:getEntityData(player, "BLESSED_AURAS") or 0
    if(aurasNum<=0) then return end

    if(flag==CacheFlag.CACHE_DAMAGE) then
        player.Damage = player.Damage*DMG_MULT
    elseif(flag==CacheFlag.CACHE_FIREDELAY) then
        player.MaxFireDelay = ToyboxMod:toFireDelay(TEAR_MULT*ToyboxMod:toTps(player.MaxFireDelay))
    elseif(flag==CacheFlag.CACHE_TEARFLAG) then
        player.TearFlags = player.TearFlags | TearFlags.TEAR_HOMING
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evalAuraCache)