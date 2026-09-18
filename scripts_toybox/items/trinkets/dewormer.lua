local TRAIL_DAMAGE = 3
local TRAIL_TIMEOUT = 30*4
local TRAIL_SCALE = 1.5
local TRAIL_DMG_PER_MULT = 0.5

local DMG_PER_MULT = 0.5

local WORM_GREEN_COLOR = Color(0.7,1.1,0.7,1,0.05,0.2,0.02)

local POSSIBLE_WORMS = {
    { -- regular charger
        Type=EntityType.ENTITY_CHARGER, Variant=0, SubType=0, Weight=1,
    },
    { -- drowned charger (only in flooded caves)
        Type=EntityType.ENTITY_CHARGER, Variant=1, SubType=0, Weight=2,
        Condition=function(level) ---@param level Level
            return (level:GetStageType()==StageType.STAGETYPE_AFTERBIRTH and ((level:GetAbsoluteStage()+1)//2)==2)
        end
    },
    { -- dank charger (only in dank depths)
        Type=EntityType.ENTITY_CHARGER, Variant=2, SubType=0, Weight=2,
        Condition=function(level) ---@param level Level
            return (level:GetStageType()==StageType.STAGETYPE_AFTERBIRTH and ((level:GetAbsoluteStage()+1)//2)==3)
        end
    },
    { -- carrion princess (only in ashpit)
        Type=EntityType.ENTITY_CHARGER, Variant=3, SubType=0, Weight=2,
        Condition=function(level) ---@param level Level
            return (level:GetStageType()==StageType.STAGETYPE_REPENTANCE_B and ((level:GetAbsoluteStage()+1)//2)==2)
        end
    },
    { -- small leech (only in ch1.5)
        Type=EntityType.ENTITY_SMALL_LEECH, Variant=0, SubType=0, Weight=1,
        Condition=function(level) ---@param level Level
            return (level:GetStageType()>=StageType.STAGETYPE_REPENTANCE and ((level:GetAbsoluteStage()+1)//2)==1)
        end
    },
    { -- small maggot
        Type=EntityType.ENTITY_SMALL_MAGGOT, Variant=0, SubType=0, Weight=0.5,
    },
    { -- lvl2 charger (only in corpse)
        Type=EntityType.ENTITY_CHARGER_L2, Variant=0, SubType=0, Weight=1.5,
        Condition=function(level) ---@param level Level
            return (level:GetStageType()>=StageType.STAGETYPE_REPENTANCE and ((level:GetAbsoluteStage()+1)//2)==4)
        end
    },
    { -- elleech (only in ascent downpour)
        Type=EntityType.ENTITY_CHARGER_L2, Variant=1, SubType=0, Weight=2,
        Condition=function(level) ---@param level Level
            return (level:GetStageType()==StageType.STAGETYPE_REPENTANCE and ((level:GetAbsoluteStage()+1)//2)==1 and level:IsAscent())
        end
    },
    { -- spitty
        Type=EntityType.ENTITY_SPITTY, Variant=0, SubType=0, Weight=1,
    },
    { -- conjoined spitty
        Type=EntityType.ENTITY_CONJOINED_SPITTY, Variant=0, SubType=0, Weight=1,
    },
    { -- t.spitty (only in ascent downpour)
        Type=EntityType.ENTITY_SPITTY, Variant=1, SubType=0, Weight=2,
        Condition=function(level) ---@param level Level
            return (level:IsAscent())
        end
    },
    { -- leech
        Type=EntityType.ENTITY_LEECH, Variant=0, SubType=0, Weight=1,
        Condition=function(level) ---@param level Level
            return (level:IsAscent())
        end
    },
    { -- kamikaze leech (only in necropolis and dark path)
        Type=EntityType.ENTITY_LEECH, Variant=1, SubType=0, Weight=1.5,
        Condition=function(level) ---@param level Level
            return (level:GetStageType()==StageType.STAGETYPE_WOTL and ((level:GetAbsoluteStage()+1)//2)==3)
            or (level:GetStageType()==StageType.STAGETYPE_ORIGINAL and (level:GetAbsoluteStage()//2)==5)
        end
    },
    { -- holy leech (only in cathedral)
        Type=EntityType.ENTITY_LEECH, Variant=2, SubType=0, Weight=2,
        Condition=function(level) ---@param level Level
            return (level:GetStageType()==StageType.STAGETYPE_WOTL and level:GetAbsoluteStage()==10)
        end
    },
    { -- adult leech (only in corpse)
        Type=EntityType.ENTITY_ADULT_LEECH, Variant=0, SubType=0, Weight=2,
        Condition=function(level) ---@param level Level
            return (level:GetStageType()>=StageType.STAGETYPE_REPENTANCE and ((level:GetAbsoluteStage()+1)//2)==4)
        end
    },
    { -- para-bite (only in ch4)
        Type=EntityType.ENTITY_PARA_BITE, Variant=0, SubType=0, Weight=1,
        Condition=function(level) ---@param level Level
            return (level:GetStageType()<StageType.STAGETYPE_REPENTANCE and ((level:GetAbsoluteStage()+1)//2)==4)
        end
    },
    { -- scarred para-bite (only in scarred womb)
        Type=EntityType.ENTITY_PARA_BITE, Variant=1, SubType=0, Weight=2,
        Condition=function(level) ---@param level Level
            return (level:GetStageType()==StageType.STAGETYPE_AFTERBIRTH and ((level:GetAbsoluteStage()+1)//2)==4)
        end
    },
    { -- round worm
        Type=EntityType.ENTITY_ROUND_WORM, Variant=0, SubType=0, Weight=1,
    },
    { -- tube worm (only in ch1.5 and flooded caves)
        Type=EntityType.ENTITY_ROUND_WORM, Variant=1, SubType=0, Weight=2,
        Condition=function(level) ---@param level Level
            return (level:GetStageType()>=StageType.STAGETYPE_REPENTANCE and ((level:GetAbsoluteStage()+1)//2)==1)
            or (level:GetStageType()==StageType.STAGETYPE_AFTERBIRTH and ((level:GetAbsoluteStage()+1)//2)==2)
        end
    },
    { -- t. round worm (only in ascent)
        Type=EntityType.ENTITY_ROUND_WORM, Variant=2, SubType=0, Weight=2,
        Condition=function(level) ---@param level Level
            return (level:IsAscent())
        end
    },
    { -- t. tube worm (only in ascent ch1.5)
        Type=EntityType.ENTITY_ROUND_WORM, Variant=3, SubType=0, Weight=2,
        Condition=function(level) ---@param level Level
            return (level:IsAscent() and level:GetStageType()>=StageType.STAGETYPE_REPENTANCE and ((level:GetAbsoluteStage()+1)//2)==1)
        end
    },
    { -- night crawler
        Type=EntityType.ENTITY_NIGHT_CRAWLER, Variant=0, SubType=0, Weight=0.5,
    },
    { -- roundy
        Type=EntityType.ENTITY_ROUNDY, Variant=0, SubType=0, Weight=0.25,
    },
    { -- needle
        Type=EntityType.ENTITY_NEEDLE, Variant=0, SubType=0, Weight=0.5,
    },
    { -- pasty (only in ashpit)
        Type=EntityType.ENTITY_NEEDLE, Variant=1, SubType=0, Weight=2,
        Condition=function(level) ---@param level Level
            return (level:GetStageType()==StageType.STAGETYPE_REPENTANCE_B and ((level:GetAbsoluteStage()+1)//2)==2)
        end
    },
}

---@param pl Entity
local function triggerDewormerEffect(_, pl, _, flags, source)
    pl = pl:ToPlayer()
    if(not pl:HasTrinket(ToyboxMod.TRINKET_DEWORMER)) then return end

    local mult = pl:GetTrinketMultiplier(ToyboxMod.TRINKET_DEWORMER)
    local rng = pl:GetTrinketRNG(ToyboxMod.TRINKET_DEWORMER)

    local picker = WeightedOutcomePicker()
    local level = ToyboxMod.GAME:GetLevel()
    for i, entry in ipairs(POSSIBLE_WORMS) do
        if(entry.Condition==nil or entry.Condition(level)) then
            picker:AddOutcomeFloat(i, entry.Weight or 1)
        end
    end
    local outcome = POSSIBLE_WORMS[picker:PickOutcome(rng)]

    local worm = Isaac.Spawn(outcome.Type, outcome.Variant, outcome.SubType, pl.Position, Vector.Zero, pl):ToNPC()
    worm:AddEntityFlags(EntityFlag.FLAG_CHARM | EntityFlag.FLAG_FRIENDLY)
    worm:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
    worm:Update()
    ToyboxMod:setEntityData(worm, "DEWORMER_ACTIVE", mult)

    local creep = Isaac.Spawn(1000,EffectVariant.PLAYER_CREEP_GREEN,0,pl.Position,Vector.Zero,pl):ToEffect()
    creep.CollisionDamage = TRAIL_DAMAGE*(1+TRAIL_DMG_PER_MULT*(mult-1))
    creep:SetTimeout(TRAIL_TIMEOUT)
    creep.SpriteScale = creep.SpriteScale*TRAIL_SCALE
    creep:Update()

    local poof = Isaac.Spawn(1000,16,5,pl.Position,Vector.Zero,nil)
    poof.SpriteScale = Vector(1,1)*0.25
    poof.Color = Color(0,0,0,1,0,200/255,0,4)
    poof:GetSprite().PlaybackSpeed = 1.25
    poof:GetSprite():SetCustomShader("shaders_tb/pixelate")

    ToyboxMod.SFX:Play(SoundEffect.SOUND_POISON_HURT)
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, triggerDewormerEffect, EntityType.ENTITY_PLAYER)


local function wormNpcLogic(_, npc)
    local mult = ToyboxMod:getEntityData(npc, "DEWORMER_ACTIVE")
    if(mult) then
        npc:AddEntityFlags(EntityFlag.FLAG_CHARM | EntityFlag.FLAG_FRIENDLY)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, wormNpcLogic)

local function takeDmg(_, npc, amount, flags, ref, frames)
    if(ToyboxMod:getEntityData(npc, "DEWORMER_ACTIVE")) then
        return false
    else
        local ent = ref.Entity
        if(not ent) then return end

        if(ToyboxMod:getEntityData(ent, "DEWORMER_ACTIVE")) then
            ent = ent:ToNPC()
        elseif(ent.SpawnerEntity and ToyboxMod:getEntityData(ent.SpawnerEntity, "DEWORMER_ACTIVE")) then
            ent = ent.SpawnerEntity:ToNPC()
        elseif(ent.Parent and ToyboxMod:getEntityData(ent.Parent, "DEWORMER_ACTIVE")) then
            ent = ent.Parent:ToNPC()
        else
            return
        end

        local mult = ent and ToyboxMod:getEntityData(ent, "DEWORMER_ACTIVE")
        if(mult and mult>1) then
            return {
                Damage = amount*(1+DMG_PER_MULT*(mult-1))*0.5,
                DamageFlags = flags,
                DamageCountdown = frames,
            }
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, takeDmg)

local function mango(_, npc)
    if(ToyboxMod:getEntityData(npc, "DEWORMER_ACTIVE")) then
        local sprite = npc:GetSprite()
        local copyColor = Color.Lerp(sprite.Color, Color.Default, 0)
        copyColor = copyColor*WORM_GREEN_COLOR
        sprite.Color = copyColor

        local prevFlags = npc:GetEntityFlags()
        npc:ClearEntityFlags(EntityFlag.FLAG_CHARM | EntityFlag.FLAG_FRIENDLY)
        ToyboxMod:setEntityData(npc, "DEWORMER_PREV_FLAGS", prevFlags)
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_PRE_NPC_RENDER, CallbackPriority.LATE+1, mango)

local function mango2(_, npc)
    if(ToyboxMod:getEntityData(npc, "DEWORMER_ACTIVE")) then
        local sprite = npc:GetSprite()
        local copyColor = Color.Lerp(sprite.Color, Color.Default, 0)
        copyColor = copyColor*ToyboxMod:colorInverse(WORM_GREEN_COLOR)
        sprite.Color = copyColor
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_POST_NPC_RENDER, CallbackPriority.IMPORTANT-1, mango2)