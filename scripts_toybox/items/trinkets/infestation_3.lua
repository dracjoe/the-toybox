

---@param npc EntityNPC
local function npcInit(_, npc)
    if(not PlayerManager.AnyoneHasTrinket(ToyboxMod.TRINKET_INFESTATION_3)) then return end
    if(npc:IsBoss() or npc:IsInvincible() or not npc.SpawnerEntity) then return end
    if(npc.Type==EntityType.ENTITY_GEMINI) then return end -- fuck this game

    local mult = PlayerManager.GetTotalTrinketMultiplier(ToyboxMod.TRINKET_INFESTATION_3)
    local desType = EntityType.ENTITY_SPIDER--(mult>1 and EntityType.ENTITY_SWARM_SPIDER or EntityType.ENTITY_SPIDER)

    if(npc.Type~=desType) then
        local function convertEnemy()
            if(npc and npc.EntityCollisionClass~=EntityCollisionClass.ENTCOLL_NONE) then
                npc:Morph(desType,0,0,0)

                if(npc) then
                    npc.State = NpcState.STATE_JUMP
                    npc.V2 = Vector(0,-4)
                    npc.V1 = npc.Velocity:Length()>0.01 and npc.Velocity*0.5 or RandomVector()
                end

                if(mult>1) then
                    npc.HitPoints = 1
                    npc.MaxHitPoints = 1
                end
            end
        end

        convertEnemy()
        --Isaac.CreateTimer(convertEnemy, 0, 1, false)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, npcInit)