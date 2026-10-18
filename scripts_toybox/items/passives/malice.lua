local DEATH_RETRIGGERS = 2
local MULT_DEATH_RETRIGGERS = 1

local CANCEL_INIT = false
local CANCEL_DEATH = false

---@param npc EntityNPC
local function npcInit(_, npc)
    if(CANCEL_INIT) then return end
    if(not ToyboxMod:isValidEnemy(npc) or npc:IsBoss()) then return end
    if(npc:IsChampion() or ToyboxMod:isModChampion(npc)) then return end

    if(not PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_MALICE)) then return end

    local conf = EntityConfig.GetEntity(npc.Type, npc.Variant, npc.SubType)
    local shouldMalice = (not conf:CanBeChampion()) or (ToyboxMod.GAME:GetRoom():GetFrameCount()>1)

    if(not shouldMalice) then return end

    local champChance = ToyboxMod:getChampionChance()
    local rng = npc:GetDropRNG()

    if(rng:RandomFloat()<champChance) then
        CANCEL_INIT = true

        if(rng:RandomFloat()<ToyboxMod.CONFIG.MOD_CHAMPION_CHANCE) then
            npc = ToyboxMod:MakeModChampion(npc)
        else
            npc:MakeChampion(npc.InitSeed, -1, true)
        end

        CANCEL_INIT = false

        npc:SetColor(Color(1,1,1,1,1,1,0,1,1,0,1), 10, 100, true, false)
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_POST_NPC_INIT, CallbackPriority.LATE, npcInit)

---@param npc EntityNPC
local function maliceChampionDie(_, npc, modChampId)
    if(CANCEL_DEATH) then return end
    if(npc:GetDarkRedChampionRegenTimer()>0) then return end
    if(not PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_MALICE)) then return end

    if(npc:IsChampion() or modChampId) then
        npc:BloodExplode()

        local copydata = {
            npc.Type, npc.Variant, npc.SubType, npc.Position, npc.Velocity,
            npc.MaxHitPoints, npc.HitPoints, npc.Mass, npc.Size, npc.SizeMulti,
            npc:IsChampion(), npc:GetChampionColorIdx(), modChampId,
        }

        Isaac.CreateTimer(
            function()
                CANCEL_DEATH = true
                CANCEL_INIT = true

                local dummy = Isaac.Spawn(copydata[1], copydata[2], copydata[3], copydata[4], copydata[5], nil):ToNPC()
                dummy.Position = dummy.Position+Vector(5,0):Rotated(math.random(1,360))
                dummy.MaxHitPoints = copydata[6]
                dummy.HitPoints = copydata[7]
                dummy.Mass = copydata[8]
                dummy.Size = copydata[9]
                dummy.SizeMulti = copydata[10]
                --dummy.Visible = false
                dummy:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH | EntityFlag.FLAG_REDUCE_GIBS)
                dummy:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

                if(copydata[11]) then
                    dummy:MakeChampion(dummy.InitSeed, copydata[12], false)
                else
                    ToyboxMod:setEntityData(dummy, "CUSTOM_CHAMPION_IDX", copydata[13])
                end
                dummy:Update()

                dummy:Kill()
                dummy:Update()

                CANCEL_DEATH = false
                CANCEL_INIT = false
            end,
            3, DEATH_RETRIGGERS+MULT_DEATH_RETRIGGERS*(PlayerManager.GetNumCollectibles(ToyboxMod.COLLECTIBLE_MALICE)-1), false
        )
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, maliceChampionDie)
ToyboxMod:AddCallback(ToyboxMod.CUSTOM_CALLBACKS.POST_CUSTOM_CHAMPION_DEATH, maliceChampionDie)