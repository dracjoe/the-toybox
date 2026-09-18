local FLIES_TO_SPAWN = 3
local MUTANT_CHANCE = 0.5
local LOCUST_CHANCE = 0.167

ToyboxMod:makeParasiteTrinket(ToyboxMod.TRINKET_LIL_GRUB, ToyboxMod.TRINKET_DEWORMER, SoundEffect.SOUND_POISON_HURT)

---@param player EntityPlayer
local function spawnFlies(_, player)
    if(not player:HasTrinket(ToyboxMod.TRINKET_LIL_GRUB)) then return end
    local rng = player:GetTrinketRNG(ToyboxMod.TRINKET_LIL_GRUB)

    local numFlies = FLIES_TO_SPAWN*player:GetTrinketMultiplier(ToyboxMod.TRINKET_LIL_GRUB)
    for _=1, numFlies do
        local locust = (rng:RandomFloat()<LOCUST_CHANCE and rng:RandomInt(1,5) or 0)
        local flies = {}
        if(locust==0) then
            table.insert(flies, player:AddBlueFlies(1, player.Position, nil))
        else
            for _=1, (locust==LocustSubtypes.LOCUST_OF_CONQUEST and rng:RandomInt(1,4) or 1) do
                local fly = Isaac.Spawn(EntityType.ENTITY_FAMILIAR,FamiliarVariant.BLUE_FLY,locust,player.Position,Vector.Zero,player):ToFamiliar()
                fly.Player = player
                table.insert(flies, fly)
            end
        end

        for _, fly in ipairs(flies) do
            if(rng:RandomFloat()<MUTANT_CHANCE) then
                ToyboxMod:makeRandomUpgradedInsect(fly, true)
            end
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PLAYER_TRIGGER_ROOM_CLEAR, spawnFlies)