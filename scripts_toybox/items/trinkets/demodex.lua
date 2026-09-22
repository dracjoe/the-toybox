local DAMAGE_DOWN_TIME = 30*4
local DAMAGE_MULT_PER_SEC = 0.075

local MULT_DECAY_PER_FRAME = 0.06
local FLAT_DECAY_PER_FRAME = 2.5

local CACHE_FREQ = 5

ToyboxMod:makeParasiteTrinket(ToyboxMod.TRINKET_DEMODEX, ToyboxMod.TRINKET_BATH_WATER, SoundEffect.SOUND_BOSS2_BUBBLES)

local function peffectUpdate(_, player)
    if(not player:HasTrinket(ToyboxMod.TRINKET_DEMODEX)) then return end

    local mult = player:GetTrinketMultiplier(ToyboxMod.TRINKET_DEMODEX)
    local dir = player:GetFireDirection()

    local data = ToyboxMod:getEntityDataTable(player)
    local minDecay = math.max(30*2, DAMAGE_DOWN_TIME-30*(mult-1))
    data.DEMODEX_FRAMES = data.DEMODEX_FRAMES or -minDecay

    if(dir==Direction.NO_DIRECTION) then
        if(data.DEMODEX_FRAMES>0) then
            local decay = math.max(FLAT_DECAY_PER_FRAME, data.DEMODEX_FRAMES*MULT_DECAY_PER_FRAME)*(dir==Direction.NO_DIRECTION and 1 or 2)*mult
            data.DEMODEX_FRAMES = math.max(data.DEMODEX_FRAMES-decay, 0)
            data.DEMODEX_UPDATED = true
        else
            if(data.DEMODEX_FRAMES>-minDecay) then
                data.DEMODEX_FRAMES = math.max(data.DEMODEX_FRAMES-FLAT_DECAY_PER_FRAME*3*mult, -minDecay)
            end
            data.DEMODEX_DIR = nil
        end
    else
        data.DEMODEX_FRAMES = data.DEMODEX_FRAMES+1*mult
        if(data.DEMODEX_FRAMES>0) then
            data.DEMODEX_UPDATED = true
        end
    end

    if(data.DEMODEX_UPDATED and player.FrameCount%CACHE_FREQ==0) then
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        data.DEMODEX_UPDATED = nil
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, peffectUpdate)

local function evaluateDamage(_, player, _, val)
    if(not player:HasTrinket(ToyboxMod.TRINKET_DEMODEX)) then return end

    local frames = ToyboxMod:getEntityData(player, "DEMODEX_FRAMES") or 0
    if(frames<=0) then return end

    local mult = (1-DAMAGE_MULT_PER_SEC)^(frames/30)
    return val*mult
end
ToyboxMod:AddCallback(ModCallbacks.MC_EVALUATE_STAT, evaluateDamage, EvaluateStatStage.FLAT_DAMAGE)



---@param player EntityPlayer
local function renderStat(_, player, offset)
    local renderPos = Isaac.WorldToRenderPosition(player.Position)+Vector(0,10)+offset+ToyboxMod.GAME.ScreenShakeOffset

    local frames = ToyboxMod:getEntityData(player, "DEMODEX_FRAMES")
    Isaac.RenderText(tostring(frames), renderPos.X, renderPos.Y, 1,1,1,1)
end
--ToyboxMod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, renderStat)