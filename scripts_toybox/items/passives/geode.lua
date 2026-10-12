local PICKUP_NUM_PICKER = WeightedOutcomePicker()
PICKUP_NUM_PICKER:AddOutcomeFloat(0, 1)
PICKUP_NUM_PICKER:AddOutcomeFloat(1, 1)
PICKUP_NUM_PICKER:AddOutcomeFloat(2, 1)

local PICKUPS_PER_MULT = 2

---@param rock GridEntityRock
---@param type GridEntityType
---@param immediate boolean
local function spawnDrops(_, rock, type, immediate)
    if(not PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_GEODE)) then return end

    local mult = PlayerManager.GetNumCollectibles(ToyboxMod.COLLECTIBLE_GEODE)
    local rng = ToyboxMod:generateRng(rock:GetSaveState().SpawnSeed) ---@type RNG
    
    local num = PICKUP_NUM_PICKER:PickOutcome(rng)+PICKUPS_PER_MULT*(mult-1)
    for _=1, num do
        local pickup = Isaac.Spawn(5, 0, NullPickupSubType.NO_COLLECTIBLE, rock.Position, rng:RandomVector()*3, nil):ToPickup()
    end
    local mantle = Isaac.Spawn(5,ToyboxMod.PICKUP_RANDOM_SELECTOR,ToyboxMod.PICKUP_RANDOM_MANTLE,rock.Position,rng:RandomVector()*3,nil):ToPickup()
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_GRID_ROCK_DESTROY, spawnDrops, GridEntityType.GRID_ROCKT)
ToyboxMod:AddCallback(ModCallbacks.MC_POST_GRID_ROCK_DESTROY, spawnDrops, GridEntityType.GRID_ROCK_SS)