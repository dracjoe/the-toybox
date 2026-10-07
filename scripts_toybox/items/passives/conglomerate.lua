local CARD_REPLACE_CHANCE = 0.08

local HUD_COLOR1 = Color.Default
local HUD_COLOR2 = Color(1,1,1,1,0.11,0.18,0.25)


local VALID_MANTLES = {
    [ToyboxMod.CARD_MANTLE_ROCK] = true,
    [ToyboxMod.CARD_MANTLE_POOP] = true,
    [ToyboxMod.CARD_MANTLE_BONE] = true,
    [ToyboxMod.CARD_MANTLE_DARK] = true,
    [ToyboxMod.CARD_MANTLE_HOLY] = true,
    [ToyboxMod.CARD_MANTLE_SALT] = true,
    [ToyboxMod.CARD_MANTLE_GLASS] = true,
    [ToyboxMod.CARD_MANTLE_METAL] = true,
    [ToyboxMod.CARD_MANTLE_GOLD] = true,
}

---@param card Card
---@param player EntityPlayer
---@param flags UseFlag
local function useMantle(_, card, player, flags)
    if(not VALID_MANTLES[card]) then return end
    if(not (flags & UseFlag.USE_CARBATTERY == 0)) then return end

    if(player:HasCollectible(ToyboxMod.COLLECTIBLE_CONGLOMERATE)) then
        player:UseCard(card, flags | UseFlag.USE_CARBATTERY | UseFlag.USE_NOANIM)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_USE_CARD, useMantle)

---@param player EntityPlayer
local function postAddItem(_, _, _, firstTime, slot, vData, player)
    if(firstTime~=true) then return end
    local pos = ToyboxMod.GAME:GetRoom():FindFreePickupSpawnPosition(player.Position,40)
    local mantle = Isaac.Spawn(5,ToyboxMod.PICKUP_RANDOM_SELECTOR,ToyboxMod.PICKUP_RANDOM_MANTLE,pos,Vector.Zero,player):ToPickup()
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, postAddItem, ToyboxMod.COLLECTIBLE_CONGLOMERATE)

---@param pickup EntityPickup
local function tryReplaceCard(_, pickup, var, sub, rvar, rsub, rng)
    if(not (var==PickupVariant.PICKUP_TAROTCARD and (rvar==0 or rsub==0))) then return end
    if(not PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_CONGLOMERATE)) then return end

    if(not VALID_MANTLES[sub]) then
        local chance = PlayerManager.GetNumCollectibles(ToyboxMod.COLLECTIBLE_CONGLOMERATE)*CARD_REPLACE_CHANCE
        if(rng:RandomFloat()<chance) then
            return {ToyboxMod.PICKUP_RANDOM_SELECTOR,ToyboxMod.PICKUP_RANDOM_MANTLE, true}
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PICKUP_SELECTION, tryReplaceCard)

-- also stolen from kerkel
HudHelper.RegisterHUDElement({
    Name = "TOYBOX_CONGLOMERATE",
    Priority = HudHelper.Priority.HIGH,
    Condition = function (player)
        if not player:HasCollectible(ToyboxMod.COLLECTIBLE_CONGLOMERATE) then return false end
        local config = Isaac.GetItemConfig():GetCard(player:GetCard(0))
        return config and config.ID > 0 and VALID_MANTLES[config.ID]
    end,
	OnRender = function(player, _, layout, position, alpha, scale)
        local id = player:GetCard(0)
        local conf = Isaac.GetItemConfig():GetCard(id)
        local sin = (1 + math.sin(ToyboxMod.GAME:GetFrameCount() * 0.2)) / 2

        local sprite = conf.ModdedCardFront
        sprite:Play(conf.HudAnim, true)
        --sprite.Offset = Vector(0, 6)
        sprite.Color = Color.Lerp(HUD_COLOR1, HUD_COLOR2, sin)
        sprite:Render(position)
	end,
}, HudHelper.HUDType.POCKET)