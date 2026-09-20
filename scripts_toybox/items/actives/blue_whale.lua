local DMG_MULT = 1.5
local STACK_DMG_UP = 1

local THRESHOLD = 5

local function useBlueWhale(_, _, rng, player, flags, slot)
    if(flags & UseFlag.USE_CARBATTERY == UseFlag.USE_CARBATTERY) then return end

    local dmg = (slot==-1 and 0 or player:GetActiveItemDesc(slot).VarData//THRESHOLD)
    if(dmg>0) then
        for _=1, dmg do
            player:ResetDamageCooldown()
            player:TakeDamage(1, DamageFlag.DAMAGE_INVINCIBLE | DamageFlag.DAMAGE_NO_PENALTIES, EntityRef(nil), 30)
        end
        ToyboxMod.SFX:Play(SoundEffect.SOUND_DEATH_BURST_SMALL, 0.8, 2, false, 1.1) 
    end

    local scale = math.min(1, 0.2+dmg*0.08)

    local poof = Isaac.Spawn(1000,16,5,player.Position,Vector.Zero,nil)
    poof.SpriteScale = Vector(1,1)*scale
    poof.DepthOffset = -80
    poof.SpriteOffset = Vector(0,-12*player.SpriteScale.Y)
    poof.Color = Color(0,0,0,1,200/255,0,0,1/scale)
    poof:GetSprite().PlaybackSpeed = 1.25
    poof:GetSprite():SetCustomShader("shaders_tb/pixelate")

    local poof2 = Isaac.Spawn(1000,16,0,player.Position,Vector.Zero,nil)
    poof2.SpriteScale = Vector(1,1)*scale
    poof2.DepthOffset = 10
    poof2.SpriteOffset = Vector(0,-12*player.SpriteScale.Y)
    poof2.Color = Color(1,0,0,1,255/255,0,0,1/scale)
    poof2:GetSprite().PlaybackSpeed = 1.25
    poof2:GetSprite():SetCustomShader("shaders_tb/pixelate")

    ToyboxMod.SFX:Play(SoundEffect.SOUND_BOSS2_BUBBLES, 0.8, 2, false, math.max(0.8, 1-dmg*0.05))

    player:GetActiveItemDesc(slot).VarData = player:GetActiveItemDesc(slot).VarData+1

    return {
        Discharge = true,
        Remove = false,
        ShowAnim = true,
    }
end
ToyboxMod:AddCallback(ModCallbacks.MC_USE_ITEM, useBlueWhale, ToyboxMod.COLLECTIBLE_BLUE_WHALE)

---@param pl EntityPlayer
---@param slot EntitySlot
local function renderBlueWhale(_, pl, slot)
    return {
        CropOffset = Vector(32*math.min(3, pl:GetActiveItemDesc(slot).VarData//THRESHOLD),0),
        HideOutline = true,
    }
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_ACTIVE_ITEM, renderBlueWhale, ToyboxMod.COLLECTIBLE_BLUE_WHALE)

---@param pl EntityPlayer
---@param val number
local function evalStat(_, pl, stat, val)
    if(not pl:GetEffects():HasCollectibleEffect(ToyboxMod.COLLECTIBLE_BLUE_WHALE)) then return end

    if(stat==EvaluateStatStage.DAMAGE_UP) then
        local num = pl:GetEffects():GetCollectibleEffectNum(ToyboxMod.COLLECTIBLE_BLUE_WHALE)
        if(num>1) then
            return val+(num-1)*STACK_DMG_UP
        end
    elseif(stat==EvaluateStatStage.FLAT_DAMAGE) then
        return val*DMG_MULT
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_EVALUATE_STAT, evalStat)