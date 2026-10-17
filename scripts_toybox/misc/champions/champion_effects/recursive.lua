---@param npc EntityNPC
local function recursiveChampionDie(_, npc)
    ToyboxMod.DENY_CHAMP_ROLL = true

    local devolvedCorrectly = false

    if(npc:CanDevolve()) then
        ToyboxMod.GAME:DevolveEnemy(npc)

        local newNpc = nil
        for _, ent in ipairs(Isaac.GetRoomEntities()) do
            if(ent and ent.FrameCount==0 and ent.Position:Distance(npc.Position)<3) then
                newNpc = ent:ToNPC()
            end
        end
        if(newNpc) then
            local conf = EntityConfig.GetEntity(newNpc.Type, newNpc.Variant, newNpc.SubType)
            if(conf and conf:CanBeChampion()) then
                ToyboxMod:MakeModChampion(newNpc, "RECURSIVE", true)

                devolvedCorrectly = true
            end
        end
    end

    if(not devolvedCorrectly) then
        --local pos = ToyboxMod.GAME:GetRoom():FindFreePickupSpawnPosition(npc.Position,0)
        local vel = npc:GetDropRNG():RandomVector()*2

        local mantle = Isaac.Spawn(5,ToyboxMod.PICKUP_RANDOM_SELECTOR,ToyboxMod.PICKUP_RANDOM_MANTLE,npc.Position,vel,npc):ToPickup()
    end

    ToyboxMod.DENY_CHAMP_ROLL = false
end
ToyboxMod:AddCallback(ToyboxMod.CUSTOM_CALLBACKS.POST_CUSTOM_CHAMPION_DEATH, recursiveChampionDie, ToyboxMod.CUSTOM_CHAMPIONS.RECURSIVE.Idx)