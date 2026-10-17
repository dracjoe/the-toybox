
local sfx = SFXManager()

--! Make thi shit work daamn!
--? made thi shit work damn!
--* fixed this shi damb!

local ENUM_NUMFAMILIARS = 3
local ENUM_NUMFAMILIARS_EXTRA = 1

local CARBATTERY_NUMFAMILIARS = 5
local CARBATTERY_NUMFAMILIARS_EXTRA = 2

local ENUM_PICKER_WEIGHTFACT = 1000
local ENUM_EVILFAM_PICKER = WeightedOutcomePicker()
ENUM_EVILFAM_PICKER:AddOutcomeFloat(CollectibleType.COLLECTIBLE_BROTHER_BOBBY, 0.5, ENUM_PICKER_WEIGHTFACT)
ENUM_EVILFAM_PICKER:AddOutcomeFloat(CollectibleType.COLLECTIBLE_SISTER_MAGGY, 0.5, ENUM_PICKER_WEIGHTFACT)
ENUM_EVILFAM_PICKER:AddOutcomeFloat(CollectibleType.COLLECTIBLE_DEMON_BABY, 1, ENUM_PICKER_WEIGHTFACT)
ENUM_EVILFAM_PICKER:AddOutcomeFloat(CollectibleType.COLLECTIBLE_GHOST_BABY, 0.75, ENUM_PICKER_WEIGHTFACT)
ENUM_EVILFAM_PICKER:AddOutcomeFloat(CollectibleType.COLLECTIBLE_ROTTEN_BABY, 1, ENUM_PICKER_WEIGHTFACT)
ENUM_EVILFAM_PICKER:AddOutcomeFloat(CollectibleType.COLLECTIBLE_LIL_BRIMSTONE, 1, ENUM_PICKER_WEIGHTFACT)
ENUM_EVILFAM_PICKER:AddOutcomeFloat(CollectibleType.COLLECTIBLE_INCUBUS, 1, ENUM_PICKER_WEIGHTFACT)
ENUM_EVILFAM_PICKER:AddOutcomeFloat(CollectibleType.COLLECTIBLE_SUCCUBUS, 0.25, ENUM_PICKER_WEIGHTFACT)
ENUM_EVILFAM_PICKER:AddOutcomeFloat(CollectibleType.COLLECTIBLE_MULTIDIMENSIONAL_BABY, 1, ENUM_PICKER_WEIGHTFACT)
ENUM_EVILFAM_PICKER:AddOutcomeFloat(CollectibleType.COLLECTIBLE_LIL_ABADDON, 1, ENUM_PICKER_WEIGHTFACT)
ENUM_EVILFAM_PICKER:AddOutcomeFloat(CollectibleType.COLLECTIBLE_TWISTED_PAIR, 0.5, ENUM_PICKER_WEIGHTFACT)
ENUM_EVILFAM_PICKER:AddOutcomeFloat(ToyboxMod.COLLECTIBLE_CRAZED_BOBBY, 0.25, ENUM_PICKER_WEIGHTFACT)
ENUM_EVILFAM_PICKER:AddOutcomeFloat(ToyboxMod.COLLECTIBLE_PSYCHO_BABY, 0.5, ENUM_PICKER_WEIGHTFACT)

local ENUM_EVILFAM_ITEM_TO_VAR = {
    [CollectibleType.COLLECTIBLE_BROTHER_BOBBY] = FamiliarVariant.BROTHER_BOBBY,
    [CollectibleType.COLLECTIBLE_SISTER_MAGGY] = FamiliarVariant.SISTER_MAGGY,
    [CollectibleType.COLLECTIBLE_DEMON_BABY] = FamiliarVariant.DEMON_BABY,
    [CollectibleType.COLLECTIBLE_GHOST_BABY] = FamiliarVariant.GHOST_BABY,
    [CollectibleType.COLLECTIBLE_ROTTEN_BABY] = FamiliarVariant.ROTTEN_BABY,
    [CollectibleType.COLLECTIBLE_LIL_BRIMSTONE] = FamiliarVariant.LIL_BRIMSTONE,
    [CollectibleType.COLLECTIBLE_INCUBUS] = FamiliarVariant.INCUBUS,
    [CollectibleType.COLLECTIBLE_SUCCUBUS] = FamiliarVariant.SUCCUBUS,
    [CollectibleType.COLLECTIBLE_MULTIDIMENSIONAL_BABY] = FamiliarVariant.MULTIDIMENSIONAL_BABY,
    [CollectibleType.COLLECTIBLE_LIL_ABADDON] = FamiliarVariant.LIL_ABADDON,
    [CollectibleType.COLLECTIBLE_TWISTED_PAIR] = FamiliarVariant.TWISTED_BABY,
    [ToyboxMod.COLLECTIBLE_CRAZED_BOBBY] = ToyboxMod.FAMILIAR_CRAZED_BOBBY,
    [ToyboxMod.COLLECTIBLE_PSYCHO_BABY] = ToyboxMod.FAMILIAR_PSYCHO_BABY,
}

local ENUM_ORBIT_DIST = Vector(45,45)
local ENUM_ORBIT_SPEED = 5
local ENUM_ORBIT_LAYER = 1823
local ENUM_ORBIT_EASING = 3

local function getBloodRitualIndex(rng, num, invalidIds)
    local selIdx = rng:RandomInt(num)+1

    local numVals = 0
    for _, _ in pairs(invalidIds) do numVals=numVals+1 end

    if(numVals==num) then return -1 end

    while(invalidIds[selIdx]) do
        selIdx = rng:RandomInt(num)+1
    end

    return selIdx
end

---@param player EntityPlayer
local function useBloodRitual(_, _, rng, player, flags)
    if(flags & UseFlag.USE_CARBATTERY == 0) then
        local isCarbattery = player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY)

        local pdata = ToyboxMod:getEntityDataTable(player)

        pdata.BLOOD_RITUAL_DATA = pdata.BLOOD_RITUAL_DATA or {}
        pdata.BLOOD_RITUAL_INVALID_INDICES = pdata.BLOOD_RITUAL_INVALID_INDICES or {}
        pdata.BLOOD_RITUAL_NUM_FAMILIARS = pdata.BLOOD_RITUAL_NUM_FAMILIARS or 0

        local numFam = (isCarbattery and CARBATTERY_NUMFAMILIARS or ENUM_NUMFAMILIARS)
        if(#pdata.BLOOD_RITUAL_DATA>0) then numFam = (isCarbattery and CARBATTERY_NUMFAMILIARS_EXTRA or ENUM_NUMFAMILIARS_EXTRA) end

        local finalnum = 0
        local justgranted = {}

        for _, item in ipairs(pdata.BLOOD_RITUAL_DATA) do
            finalnum = finalnum+1
            if(item==CollectibleType.COLLECTIBLE_TWISTED_PAIR) then
                finalnum = finalnum+1
            end
        end
        
        for _=1, numFam do
            local item = ENUM_EVILFAM_PICKER:PickOutcome(rng)
            player:AddCollectibleEffect(item)
            table.insert(pdata.BLOOD_RITUAL_DATA, item)
            table.insert(justgranted, item)

            finalnum = finalnum+1
            if(item==CollectibleType.COLLECTIBLE_TWISTED_PAIR) then
                finalnum = finalnum+1
            end
        end

        player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS)
        player:EvaluateItems()

        for _, item in ipairs(justgranted) do
            if(item==CollectibleType.COLLECTIBLE_TWISTED_PAIR) then
                for i=0,1 do
                    for _, fam in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR,FamiliarVariant.TWISTED_BABY,i)) do
                        if(fam.FrameCount<=1 and not ToyboxMod:getEntityData(fam, "IS_BLOOD_RITUAL_ORBITAL")) then
                            local idx = getBloodRitualIndex(rng, finalnum, pdata.BLOOD_RITUAL_INVALID_INDICES)
                            ToyboxMod:setEntityData(fam, "IS_BLOOD_RITUAL_ORBITAL", idx)
                            pdata.BLOOD_RITUAL_INVALID_INDICES[idx] = true
                        end
                    end
                end
            else
                for _, fam in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR,ENUM_EVILFAM_ITEM_TO_VAR[item])) do
                    if(fam.FrameCount<=1 and not ToyboxMod:getEntityData(fam, "IS_BLOOD_RITUAL_ORBITAL")) then
                        local idx = getBloodRitualIndex(rng, finalnum, pdata.BLOOD_RITUAL_INVALID_INDICES)
                        ToyboxMod:setEntityData(fam, "IS_BLOOD_RITUAL_ORBITAL", idx)
                        pdata.BLOOD_RITUAL_INVALID_INDICES[idx] = true
                    end
                end
            end
        end

        pdata.BLOOD_RITUAL_NUM_FAMILIARS = finalnum

        local pentagram = Isaac.Spawn(1000, ToyboxMod.EFFECT_BLOOD_RITUAL_PENTAGRAM, 0, player.Position, Vector.Zero, player):ToEffect()
        pentagram.DepthOffset = -1000

        sfx:Play(SoundEffect.SOUND_DEVIL_CARD)
    end

    return {
        Discharge = true,
        Remove = false,
        ShowAnim = true,
    }
end
ToyboxMod:AddCallback(ModCallbacks.MC_USE_ITEM, useBloodRitual, ToyboxMod.COLLECTIBLE_BLOOD_RITUAL)

---@param player EntityPlayer
local function removeBloodRitualEffect(_, player)
    local pdata = ToyboxMod:getEntityDataTable(player)

    local eff = player:GetEffects()
    for _, item in ipairs(pdata.BLOOD_RITUAL_DATA or {}) do
        eff:RemoveCollectibleEffect(item, 1)
    end

    pdata.BLOOD_RITUAL_DATA = {}
    pdata.BLOOD_RITUAL_INVALID_INDICES = {}
    pdata.BLOOD_RITUAL_NUM_FAMILIARS = 0

    player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS, true)
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PLAYER_NEW_ROOM_TEMP_EFFECTS, removeBloodRitualEffect)

---@param familiar EntityFamiliar
local function bloodRitualOrbit(_, familiar)
    if(not ToyboxMod:getEntityData(familiar, "IS_BLOOD_RITUAL_ORBITAL")) then return end
    local p = familiar.Player
    local todiv = (ToyboxMod:getEntityData(p, "BLOOD_RITUAL_NUM_FAMILIARS") or 0)

    familiar:RemoveFromFollowers()
    familiar:RemoveFromDelayed()

    if(familiar.OrbitLayer~=ENUM_ORBIT_LAYER) then
        familiar:AddToOrbit(ENUM_ORBIT_LAYER)
    end

    familiar.OrbitDistance = ENUM_ORBIT_DIST
    familiar.OrbitSpeed = ENUM_ORBIT_SPEED

    local orbPos = p.Position+p.Velocity+Vector.FromAngle(p.FrameCount*familiar.OrbitSpeed+ToyboxMod:getEntityData(familiar, "IS_BLOOD_RITUAL_ORBITAL")/todiv*360)*familiar.OrbitDistance

    familiar.Velocity = (orbPos-familiar.Position)/ENUM_ORBIT_EASING
end
ToyboxMod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, bloodRitualOrbit)

---@param familiar EntityFamiliar
local function bloodRitualPriority(_, familiar)
    if(not ToyboxMod:getEntityData(familiar, "IS_BLOOD_RITUAL_ORBITAL")) then return end

    return -100
end
ToyboxMod:AddCallback(ModCallbacks.MC_GET_FOLLOWER_PRIORITY, bloodRitualPriority)

---@param effect EntityEffect
local function pentagramUpdate(_, effect)
    if(effect:GetSprite():IsFinished("Idle")) then effect:Remove() end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, pentagramUpdate, ToyboxMod.EFFECT_BLOOD_RITUAL_PENTAGRAM)