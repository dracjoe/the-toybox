local DAMAGE_INCREASE = 1
local DAMAGE_PER_MULT = 0.5

local POISON_CHANCE = 1/3
local POISON_DURATION = 40

ToyboxMod:makeParasiteTrinket(ToyboxMod.TRINKET_CANDIDA, ToyboxMod.TRINKET_ANTIBIOTICS, SoundEffect.SOUND_POISON_HURT)

---@param tear EntityTear
local function familiarFireProj(_, tear)
    local fam = tear.SpawnerEntity and tear.SpawnerEntity:ToFamiliar() ---@type EntityFamiliar
    if(fam and fam.Player:HasTrinket(ToyboxMod.TRINKET_CANDIDA)) then
        local mult = PlayerManager.GetTotalTrinketMultiplier(ToyboxMod.TRINKET_CANDIDA)

        tear.CollisionDamage = tear.CollisionDamage+DAMAGE_INCREASE+(mult-1)*DAMAGE_PER_MULT
        if(tear:GetDropRNG():RandomFloat()<POISON_CHANCE*mult) then
            tear:AddTearFlags(TearFlags.TEAR_POISON)
            tear.Color = tear.Color*Color.TearCommonCold
        end
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_POST_FAMILIAR_FIRE_PROJECTILE, CallbackPriority.EARLY, familiarFireProj)


---@param ent Entity
---@return EntityFamiliar?
local function getFamiliarFromEnt(ent)
    if(not ent or ent:ToTear()) then return end

    local fam
    if(ent and ent:ToFamiliar()) then
        fam = ent:ToFamiliar()
    elseif(ent and ent.SpawnerEntity and ent.SpawnerEntity:ToFamiliar()) then
            fam = ent.SpawnerEntity:ToFamiliar()
    elseif(ent and ent.Parent and ent.Parent:ToFamiliar()) then
        fam = ent.Parent:ToFamiliar()
    else
        return
    end
    if(fam and fam.Player:HasTrinket(ToyboxMod.TRINKET_CANDIDA)) then
        return fam
    end
end

---@param ent Entity
---@param ref EntityRef
local function increaseDamage(_, ent, amount, flags, ref, countdown)
    if(not PlayerManager.AnyoneHasTrinket(ToyboxMod.TRINKET_CANDIDA)) then return end

    local fam = getFamiliarFromEnt(ref.Entity)
    if(fam) then
        local mult = PlayerManager.GetTotalTrinketMultiplier(ToyboxMod.TRINKET_CANDIDA)
        local dmgUp = DAMAGE_INCREASE+(mult-1)*DAMAGE_PER_MULT

        return {
            Damage = amount+dmgUp,
            DamageFlags = flags,
            DamageCountdown = countdown,
        }
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, increaseDamage)

---@param ent Entity
---@param ref EntityRef
local function poisonEnemy(_, ent, amount, _, ref, _)
    if(not PlayerManager.AnyoneHasTrinket(ToyboxMod.TRINKET_CANDIDA)) then return end

    local fam = getFamiliarFromEnt(ref.Entity)
    if(fam) then
        local mult = PlayerManager.GetTotalTrinketMultiplier(ToyboxMod.TRINKET_CANDIDA)
        local rng = fam.Player:GetTrinketRNG(ToyboxMod.TRINKET_CANDIDA)

        if(rng:RandomFloat()<POISON_CHANCE*mult) then
            ent:AddPoison(EntityRef(fam.Player), -POISON_DURATION, fam.Player.Damage)
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, poisonEnemy)