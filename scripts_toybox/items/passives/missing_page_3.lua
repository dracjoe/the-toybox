

--local DEATH_CHAMP_CHANCE = 0.1
local CHAMP_CHANCE = 0.5
local HARD_BLACK_CHANCE = 0.1667

---@param npc EntityNPC
local function npcInit(_, npc)
    if(npc:IsBoss() or npc:IsChampion() or (not npc:IsEnemy())) then return end
    local conf = EntityConfig.GetEntity(npc.Type, npc.Variant, npc.SubType)
    if(not (conf and conf:CanBeChampion())) then return end

    local pageNum = PlayerManager.GetNumCollectibles(ToyboxMod.COLLECTIBLE_MISSING_PAGE_3)
    if(pageNum<=0) then return end

    local rng = npc:GetDropRNG()
    if(rng:RandomFloat()<(DEATH_CHAMP_CHANCE*pageNum)) then
        local oldHits = npc.MaxHitPoints
        npc:MakeChampion(math.max(Random(),1), ChampionColor.DEATH, true)
        if(pageNum==1) then
            npc.HitPoints = npc.MaxHitPoints
        else
            npc.MaxHitPoints = oldHits
        end
    end
end
--ToyboxMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, npcInit)

local function newRoom(_)
    if(not PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_MISSING_PAGE_3)) then return end

    local validEnemies = {}
    for _, ent in ipairs(Isaac.GetRoomEntities()) do
        if(ToyboxMod:isValidEnemy(ent)) then
            local conf = EntityConfig.GetEntity(ent.Type, ent.Variant, ent.SubType)
            if(conf and conf:CanBeChampion()) then
                table.insert(validEnemies, ent:ToNPC())
            end
        end
    end

    local num = PlayerManager.GetNumCollectibles(ToyboxMod.COLLECTIBLE_MISSING_PAGE_3)
    local pl = PlayerManager.FirstCollectibleOwner(ToyboxMod.COLLECTIBLE_MISSING_PAGE_3)
    local rng = pl:GetCollectibleRNG(ToyboxMod.COLLECTIBLE_MISSING_PAGE_3)

    local picker = WeightedOutcomePicker()
    for i, npc in ipairs(validEnemies) do
        local dist = npc.Position:Distance(pl.Position)
        dist = (dist/(40*4))^3

        picker:AddOutcomeFloat(i, dist, 100)
    end

    for _=1, num do
        if(picker:GetNumOutcomes()>0) then
            if(rng:RandomFloat()<CHAMP_CHANCE) then
                local picked = picker:PickOutcome(rng)
                picker:RemoveOutcome(picked)

                local npc = validEnemies[picked]
                local oldHits = npc.MaxHitPoints
                npc:MakeChampion(math.max(Random(),1), ChampionColor.DEATH, true)
                if(num==1) then
                    npc.HitPoints = npc.MaxHitPoints
                else
                    npc.MaxHitPoints = oldHits
                end
            end
        else
            break
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, newRoom)

---@param npc EntityNPC
local function npcDeath(_, npc)
    if(not (npc:IsChampion() and npc:GetChampionColorIdx()==ChampionColor.DEATH)) then return end

    if(PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_MISSING_PAGE_3)) then
        if(npc:GetDropRNG():RandomFloat()<HARD_BLACK_CHANCE) then
            local heart = Isaac.Spawn(5,10,HeartSubType.HEART_BLACK,ToyboxMod.GAME:GetRoom():FindFreePickupSpawnPosition(npc.Position),Vector.Zero,nil):ToPickup()
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, npcDeath)