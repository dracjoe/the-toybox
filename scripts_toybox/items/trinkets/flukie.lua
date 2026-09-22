local RED_HEART_CHANCE = 0.1
local EMPTY_HP_ADD_CHANCE = 0.4
local PER_MULT_CHANCE = 0.15

ToyboxMod:makeParasiteTrinket(ToyboxMod.TRINKET_FLUKIE, ToyboxMod.TRINKET_ANTIBIOTICS, SoundEffect.SOUND_BEAST_LAVABALL_RISE)

---@param npc EntityNPC
local function spawnRedHp(npc)
    local mult = PlayerManager.GetTotalTrinketMultiplier(ToyboxMod.TRINKET_FLUKIE)
    if(mult>0) then
        local sub = (mult>1 and HeartSubType.HEART_FULL or HeartSubType.HEART_HALF)
        local pickup = Isaac.Spawn(5,10,sub,npc.Position,Vector.Zero,nil)
    end
end

local function championDeath(_, npc)
    if(not PlayerManager.AnyoneHasTrinket(ToyboxMod.TRINKET_FLUKIE)) then return end
    if(npc:IsChampion()) then
        spawnRedHp(npc)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, championDeath)

local function modChampionDeath(_, npc)
    if(not PlayerManager.AnyoneHasTrinket(ToyboxMod.TRINKET_FLUKIE)) then return end
    spawnRedHp(npc)
end
ToyboxMod:AddCallback(ToyboxMod.CUSTOM_CALLBACKS.POST_CUSTOM_CHAMPION_DEATH, modChampionDeath)

local function trySpawnRedHeart(_)
    if(not PlayerManager.AnyoneHasTrinket(ToyboxMod.TRINKET_FLUKIE)) then return end

    local room = ToyboxMod.GAME:GetRoom()
    local player = PlayerManager.GetRandomTrinketOwner(ToyboxMod.TRINKET_FLUKIE, room:GetSpawnSeed())

    local rng = player:GetTrinketRNG(ToyboxMod.TRINKET_FLUKIE)
    local chance = RED_HEART_CHANCE+PER_MULT_CHANCE*(PlayerManager.GetTotalTrinketMultiplier(ToyboxMod.TRINKET_FLUKIE)-1)
    chance = chance+EMPTY_HP_ADD_CHANCE*(player:GetEffectiveMaxHearts()-player:GetHearts())//2
    if(rng:RandomFloat()<chance) then
        local pos = room:FindFreePickupSpawnPosition(room:GetCenterPos())

        local heart = Isaac.Spawn(5,10,HeartSubType.HEART_FULL,pos,Vector.Zero,nil):ToPickup()
        ToyboxMod.SFX:Play(SoundEffect.SOUND_BOSS2_BUBBLES)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_ROOM_TRIGGER_CLEAR, trySpawnRedHeart)