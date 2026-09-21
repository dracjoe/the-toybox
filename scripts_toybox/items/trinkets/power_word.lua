local SHOTS_PER_MULT = 1


---@param ent Entity
local function reduceShotsOnFire(_, _, _, ent)
    local pl = (ent and ent:ToPlayer())
    if(not pl) then return end
    --if(not (pl and pl:HasTrinket(ToyboxMod.TRINKET_POWER_WORD))) then return end

    local data = ToyboxMod:getEntityDataTable(pl)
    if(not data.POWER_WORD_SHOTS) then return end

    data.POWER_WORD_SHOTS = (data.POWER_WORD_SHOTS or 0)-1
    --if(data.POWER_WORD_SHOTS<=0) then data.POWER_WORD_SHOTS = nil end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_TRIGGER_WEAPON_FIRED, reduceShotsOnFire)

local function resetShots(_)
    for i=0, ToyboxMod.GAME:GetNumPlayers()-1 do
        local pl = Isaac.GetPlayer(i)
        if(pl:HasTrinket(ToyboxMod.TRINKET_POWER_WORD)) then
            --print(ToyboxMod:getEntityData(pl, "POWER_WORD_SHOTS"))
            ToyboxMod:setEntityData(pl, "POWER_WORD_SHOTS", pl:GetTrinketMultiplier(ToyboxMod.TRINKET_POWER_WORD)*SHOTS_PER_MULT+1)
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, resetShots)

---@param pl EntityPlayer
---@param params TearParams
local function makePowerWordTear(_, pl, params, _, _, _, source)
    if(not ((ToyboxMod:getEntityData(pl, "POWER_WORD_SHOTS") or 0)>0 or (pl:HasTrinket(ToyboxMod.TRINKET_POWER_WORD) and ToyboxMod.GAME:GetRoom():GetFrameCount()==0))) then return end

    params.TearScale = params.TearScale*1.4
    params.TearFlags = params.TearFlags | (TearFlags.TEAR_HORN | TearFlags.TEAR_HOMING)
    params.TearColor = Color(0,0,0,1)
end
ToyboxMod:AddCallback(ModCallbacks.MC_EVALUATE_TEAR_HIT_PARAMS, makePowerWordTear)