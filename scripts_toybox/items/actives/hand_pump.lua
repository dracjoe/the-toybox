local MAX_BONUSES = 9

local STACKS_PER_USE = 3

local PUMP_COSTUMES = {
    [1] = Isaac.GetCostumeIdByPath("gfx_tb/characters/costume_pump_1.anm2"),
    [2] = Isaac.GetCostumeIdByPath("gfx_tb/characters/costume_pump_2.anm2"),
    [3] = Isaac.GetCostumeIdByPath("gfx_tb/characters/costume_pump_3.anm2"),
}

---@param player EntityPlayer
---@param count integer
local function setCostume(player, count)
    for i, costume in ipairs(PUMP_COSTUMES) do
        if(i~=count) then
            player:TryRemoveNullCostume(costume)
        end
    end
    if(PUMP_COSTUMES[count]) then
        player:AddNullCostume(PUMP_COSTUMES[count])
    end
end

---@param player EntityPlayer
---@param item CollectibleType
local function handPumpUse(_, item, rng, player, flags, slot, vdata)
    local eff = player:GetEffects()

    eff:AddCollectibleEffect(item, false, STACKS_PER_USE-1)
    if(eff:GetCollectibleEffectNum(item)>=MAX_BONUSES) then
        eff:RemoveCollectibleEffect(item, eff:GetCollectibleEffectNum(item)-MAX_BONUSES+1)
    end

    setCostume(player, math.ceil((eff:GetCollectibleEffectNum(item)+1)/STACKS_PER_USE))
    ToyboxMod.SFX:Play(SoundEffect.SOUND_INFLATE, 0.65, nil, nil, 1.5)

--    player:AnimateCollectible(item, "HideItem")

    return {
        Discharge = true,
        Remove = false,
        ShowAnim = true,
    }
end
ToyboxMod:AddCallback(ModCallbacks.MC_USE_ITEM, handPumpUse, ToyboxMod.COLLECTIBLE_HAND_PUMP)

---@param dir Vector
---@param amount number
---@param owner Entity
---@param weapon Weapon
local function postTriggerWeaponFired(_, dir, amount, owner, weapon)
    local pl = owner and owner:ToPlayer()
    if(not pl) then return end

    local eff = pl:GetEffects()
    if(not eff:HasCollectibleEffect(ToyboxMod.COLLECTIBLE_HAND_PUMP)) then return end

    eff:RemoveCollectibleEffect(ToyboxMod.COLLECTIBLE_HAND_PUMP, 1)
    setCostume(pl, math.ceil(eff:GetCollectibleEffectNum(ToyboxMod.COLLECTIBLE_HAND_PUMP)/STACKS_PER_USE))
    ToyboxMod.SFX:Play(SoundEffect.SOUND_PLOP, 0.8, nil, nil, 1.2)
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_TRIGGER_WEAPON_FIRED, postTriggerWeaponFired)

local function removeStacksOnClear(_)
    for i=0, ToyboxMod.GAME:GetNumPlayers()-1 do
        local player = ToyboxMod.GAME:GetPlayer(i)
        local eff = player:GetEffects()
        if(eff:HasCollectibleEffect(ToyboxMod.COLLECTIBLE_HAND_PUMP)) then
            eff:RemoveCollectibleEffect(ToyboxMod.COLLECTIBLE_HAND_PUMP, -1)
            setCostume(player, 0)
            player:AddCacheFlags(CacheFlag.CACHE_LUCK, true)
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_ROOM_TRIGGER_CLEAR, removeStacksOnClear)

local function removeCostumeOnNewRoom(_, player)
    if(player:HasCollectible(ToyboxMod.COLLECTIBLE_HAND_PUMP)) then
        setCostume(player, 0)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PLAYER_NEW_ROOM_TEMP_EFFECTS, removeCostumeOnNewRoom)