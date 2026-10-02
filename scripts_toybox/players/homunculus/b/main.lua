local HOMUNCULUS_COLOR = Color(245/255, 245/255, 215/255, 1, 0, 0, 0, 1, 1, 1, 0.5)--0.15)

---@param ent Entity
---@param amount number
---@param flags DamageFlag
---@param frames integer
local function tryIncreaseDMG(_, ent, amount, flags, source, frames)
    local pl = ent:ToPlayer()
    if(not (pl and pl:GetPlayerType()==ToyboxMod.PLAYER_HOMUNCULUS_B)) then return end

    if(source.Type==6) then return end
    if(flags & (DamageFlag.DAMAGE_FAKE | DamageFlag.DAMAGE_IV_BAG | DamageFlag.DAMAGE_CLONES | DamageFlag.DAMAGE_INVINCIBLE | DamageFlag.DAMAGE_NO_PENALTIES)~=0) then return end

    local hasBirthright = pl:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
    if(not hasBirthright) then
        return {
            Damage= 2*math.ceil(amount/2),
            DamageFlags= flags,
            DamageCountdown= frames,
        }
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, CallbackPriority.IMPORTANT, tryIncreaseDMG, EntityType.ENTITY_PLAYER)

---@param pl EntityPlayer
local function evalColorCache(_, pl)
    if(pl:GetPlayerType()~=ToyboxMod.PLAYER_HOMUNCULUS_B) then return end

    pl.Color = pl.Color*HOMUNCULUS_COLOR
end
ToyboxMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evalColorCache, CacheFlag.CACHE_COLOR)

local INVALID_HEALTH = {
    [AddHealthType.BLACK] = true,
    [AddHealthType.SOUL] = true,
}

---@param pl EntityPlayer
---@param amount integer
local function preAddHearts(_, pl, amount, hpType)
    if(pl:GetPlayerType()==ToyboxMod.PLAYER_HOMUNCULUS_B and INVALID_HEALTH[hpType]) then
        return 0
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_PLAYER_ADD_HEARTS, preAddHearts)

local FOOD_ITEMS = {}
local REPLACE_WITH_FOOD = false

local function loadFoodItems(_)
    FOOD_ITEMS = {}

    local conf = Isaac.GetItemConfig()
    for i=1, conf:GetCollectibles().Size-1 do
        local item = conf:GetCollectible(i)
        if(item and item:HasTags(ItemConfig.TAG_FOOD)) then
            table.insert(FOOD_ITEMS, item.ID)
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, loadFoodItems)

local function replaceClearBossPedestal(_)
    if(ToyboxMod.GAME:GetRoom():GetType()~=RoomType.ROOM_BOSS) then return end

    if(PlayerManager.AnyoneIsPlayerType(ToyboxMod.PLAYER_HOMUNCULUS_B)) then
        if(#FOOD_ITEMS==0) then
            loadFoodItems()
        end

        REPLACE_WITH_FOOD = true
        Isaac.CreateTimer(function()
            REPLACE_WITH_FOOD = false
        end,1,1,true)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, replaceClearBossPedestal)

local function preGetCollectible(_, pool, decrease, seed)
    if(REPLACE_WITH_FOOD) then
        return FOOD_ITEMS[ToyboxMod:generateRng(seed):RandomInt(1,#FOOD_ITEMS)]
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_GET_COLLECTIBLE, preGetCollectible)