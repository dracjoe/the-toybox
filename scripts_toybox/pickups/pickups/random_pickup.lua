local ALT_TAROT_DATA = {
    {ToyboxMod.CARD_THE_WISE_MEN, 1.0},
    {ToyboxMod.CARD_THE_ANGEL, 1.0},
    {ToyboxMod.CARD_THE_GATE, 1.0},
    {ToyboxMod.CARD_APOCALYPSE, 1.0},
    {ToyboxMod.CARD_THE_CRYPT, 1.0},
    {ToyboxMod.CARD_THE_REAPER, 1.0},
    {ToyboxMod.CARD_THE_DRAGON, 1.0},
    {ToyboxMod.CARD_DUALITY, 1.0},
    {ToyboxMod.CARD_THE_BARON, 1.0},
    {ToyboxMod.CARD_THE_TRICKSTER, 1.0},
    {ToyboxMod.CARD_EXCALIBUR, 1.0},
    {ToyboxMod.CARD_FATE, 1.0},
    {ToyboxMod.CARD_THE_IDOL, 1.0},
    {ToyboxMod.CARD_THE_CARAVAN, 1.0},
    {ToyboxMod.CARD_MIRAGE, 1.0},

    --[[] ]
    
    {ToyboxMod.CARD_MEMORY, 1.0},
    {ToyboxMod.CARD_THE_PHANTOM, 1.0},
    
    --]]
}
local ALT_TAROT_PICKER = WeightedOutcomePicker()
for _, data in ipairs(ALT_TAROT_DATA) do
    ALT_TAROT_PICKER:AddOutcomeFloat(data[1], data[2], 100)
end

local YU_GI_OH_DATA = {
    {ToyboxMod.CARD_ALIEN_MIND, 1.0},
    {ToyboxMod.CARD_POISON_RAIN, 1.0},
    {ToyboxMod.CARD_FOUR_STARRED_LADYBUG, 1.0},
}
local YU_GI_OH_PICKER = WeightedOutcomePicker()
for _, data in ipairs(YU_GI_OH_DATA) do
    YU_GI_OH_PICKER:AddOutcomeFloat(data[1], data[2], 100)
end

---@param rng RNG
---@param subtype integer
function ToyboxMod:getRandomPickup(rng, subtype)
    if(subtype==ToyboxMod.PICKUP_RANDOM_MANTLE) then
        return {5,300,ToyboxMod:getRandomMantle(rng, false, true)}
    elseif(subtype==ToyboxMod.PICKUP_RANDOM_MANTLE_NOBIAS) then
        return {5,300,ToyboxMod:getRandomMantle(rng, true, true)}
    elseif(subtype==ToyboxMod.PICKUP_RANDOM_ALT_TAROT) then
        return {5,300,ALT_TAROT_PICKER:PickOutcome(rng)}
    elseif(subtype==ToyboxMod.PICKUP_RANDOM_YU_GI_OH) then
        return {5,300,YU_GI_OH_PICKER:PickOutcome(rng)}
    end
end


---@param pickup EntityPickup
local function replaceWithRandom(_, pickup)
    local res = ToyboxMod:getRandomPickup(pickup:GetDropRNG(), pickup.SubType)
    if(res) then
        pickup:Morph(res[1], res[2], res[3], true)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, replaceWithRandom, ToyboxMod.PICKUP_RANDOM_SELECTOR)