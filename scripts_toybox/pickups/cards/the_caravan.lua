local COINS_PER = 3
local COINS_PER_TAROT = 2

---@param pl EntityPlayer
local function useTheCaravan(_, _, pl, flags)
    if(pl:HasCollectible(CollectibleType.COLLECTIBLE_TAROT_CLOTH) and flags & UseFlag.USE_CARBATTERY == 0) then return end

    local carBattery = (flags & UseFlag.USE_CARBATTERY == UseFlag.USE_CARBATTERY)
    local coinsPer = carBattery and COINS_PER_TAROT or COINS_PER

    local stacks = pl:GetNumCoins()//coinsPer
    pl:AddCoins(pl:GetNumCoins())
    pl:AddBombs(stacks)
    pl:AddKeys(stacks)
    if(carBattery) then
        pl:AddHearts(stacks)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_USE_CARD, useTheCaravan, ToyboxMod.CARD_THE_CARAVAN)