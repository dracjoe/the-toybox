local STAT_UPS = 2
local POSSIBLE_MODIFIERS = {
    "Damage",
    "FireDelay",
    "Luck",
    "ShotSpeed",
    "Speed",
    "TearRange",
}

ToyboxMod:makeParasiteTrinket(ToyboxMod.TRINKET_NEMATODE, ToyboxMod.TRINKET_ANTIBIOTICS, SoundEffect.SOUND_BEAST_LAVABALL_RISE)

---@param type CollectibleType
---@param firstTime boolean
---@param pl EntityPlayer
local function preAddCollectible(_, type, _, firstTime, _, _, pl)
    if(not firstTime) then return end
    if(not pl:HasTrinket(ToyboxMod.TRINKET_NEMATODE)) then return end

    local conf = Isaac.GetItemConfig():GetCollectible(type)
    if(conf and conf:HasTags(ItemConfig.TAG_FOOD)) then
        ToyboxMod:setEntityData(pl, "NEMATODE_ACTIVE", true)
        Isaac.CreateTimer(function()
            ToyboxMod:setEntityData(pl, "NEMATODE_ACTIVE", nil)
        end, 1,1, true)
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_PRE_ADD_COLLECTIBLE, CallbackPriority.IMPORTANT-1, preAddCollectible)

local function postAddCollectible(_, type, _, firstTime, _, _, pl)
    local conf = Isaac.GetItemConfig():GetCollectible(type)
    if(conf and conf:HasTags(ItemConfig.TAG_FOOD) and pl:HasTrinket(ToyboxMod.TRINKET_NEMATODE)) then
        ToyboxMod:setEntityData(pl, "NEMATODE_ACTIVE", nil)

        if(ToyboxMod:getEntityData(pl, "NEMATODE_WORKED")) then
            ToyboxMod.SFX:Play(SoundEffect.SOUND_VAMP_GULP, nil, nil, nil, 0.95+math.random()*0.1)

            ToyboxMod:setEntityData(pl, "NEMATODE_WORKED", nil)

            ToyboxMod:setEntityData(pl, "NEMATODE_ACTIVE_CHAPI", true)
            Isaac.CreateTimer(function()
                ToyboxMod:setEntityData(pl, "NEMATODE_ACTIVE_CHAPI", nil)
            end, 1,1, true)
        end

        local rng = pl:GetTrinketRNG(ToyboxMod.TRINKET_NEMATODE)
        for _=1, pl:GetTrinketMultiplier(ToyboxMod.TRINKET_NEMATODE) do
            local usedModifiers = {}
            for _=1, STAT_UPS do
                local pickModifier
                while(not pickModifier) do
                    pickModifier = rng:RandomInt(1, #POSSIBLE_MODIFIERS)
                    if(usedModifiers[pickModifier]) then
                        pickModifier = nil
                    end
                end
                usedModifiers[pickModifier] = true

                local modifString = POSSIBLE_MODIFIERS[pickModifier].."Modifier"
                pl["Set"..modifString](pl, pl["Get"..modifString](pl)+1)
            end
        end
        pl:AddCacheFlags(CacheFlag.CACHE_ALL, true)
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, CallbackPriority.LATE, postAddCollectible)

---@param pl EntityPlayer
---@param amount integer
local function preAddHearts(_, pl, amount)
    if(ToyboxMod:getEntityData(pl, "NEMATODE_ACTIVE") and amount~=0) then
        local data = ToyboxMod:getEntityDataTable(pl)
        data.NEMATODE_WORKED = true

        return 0
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_PLAYER_ADD_HEARTS, preAddHearts, AddHealthType.RED)

if(CustomHealthAPI) then
    local function cancelChapiHeal(p, k, n)
        if(k=="RED_HEART" and ToyboxMod:getEntityData(p, "NEMATODE_ACTIVE_CHAPI")) then
            return true
        end
    end
    CustomHealthAPI.Library.AddCallback(ToyboxMod, CustomHealthAPI.Enums.Callbacks.PRE_ADD_HEALTH, 0, cancelChapiHeal)
end