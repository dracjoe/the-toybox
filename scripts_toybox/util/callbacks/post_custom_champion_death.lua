

local CHAMPIONS_JUST_DIED = {}

local function getNpcKey(npc)
    return tostring(npc.InitSeed)..tostring(GetPtrHash(npc))
end

---@param npc Entity
local function markChampionAsDead(_, npc)
    if(not ToyboxMod:getEntityData(npc, "CUSTOM_CHAMPION_IDX")) then return end
    CHAMPIONS_JUST_DIED[getNpcKey(npc)] = ToyboxMod:getEntityData(npc, "CUSTOM_CHAMPION_IDX")
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, markChampionAsDead, EntityType.ENTITY_NPC)

---@param npc EntityNPC
local function checkIfChampionDied(_, npc)
    local nKey = getNpcKey(npc)
    if(CHAMPIONS_JUST_DIED[nKey]) then
        Isaac.RunCallbackWithParam(ToyboxMod.CUSTOM_CALLBACKS.POST_CUSTOM_CHAMPION_DEATH, CHAMPIONS_JUST_DIED[nKey], npc, CHAMPIONS_JUST_DIED[nKey])
        
        CHAMPIONS_JUST_DIED[nKey] = nil
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, checkIfChampionDied)