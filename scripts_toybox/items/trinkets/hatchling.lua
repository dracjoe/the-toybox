local SPAWN_FREQ = 30
local SPIDER_CHANCE = 0.15
local SPIDER_CHANCE_PER_PIT = 0.015

local MUTANT_CHANCE = 0.5

ToyboxMod:makeParasiteTrinket(ToyboxMod.TRINKET_HATCHLING, ToyboxMod.TRINKET_BUG_SPRAY, SoundEffect.SOUND_MATCHSTICK)

local function peffectUpdate(_, player)
    if(not player:HasTrinket(ToyboxMod.TRINKET_HATCHLING)) then return end
    if(player.FrameCount%SPAWN_FREQ~=0) then return end
    if(ToyboxMod:isRoomClear()) then return end

    local mult = player:GetTrinketMultiplier(ToyboxMod.TRINKET_HATCHLING)
    local rng = player:GetTrinketRNG(ToyboxMod.TRINKET_HATCHLING)

    local room = ToyboxMod.GAME:GetRoom()
    local pits = {}
    for i=0, room:GetGridSize()-1 do
        local ent = room:GetGridEntity(i)
        if(ent and ent:ToPit()) then
            table.insert(pits, i)
        end
    end

    local chance = (SPIDER_CHANCE+SPIDER_CHANCE_PER_PIT*#pits)*mult
    local rand = rng:RandomFloat()
    if(rand<chance) then
        local spawnPos
        if(rand<SPIDER_CHANCE*mult) then
            local walls = {}
            local roomSize = Vector(room:GetGridWidth(), room:GetGridHeight())

            for i=1,roomSize.X-1 do
                table.insert(walls, i)
                table.insert(walls, i+roomSize.X*(roomSize.Y-1))
            end
            for i=1,roomSize.Y-1 do
                table.insert(walls, roomSize.X*i)
                table.insert(walls, roomSize.X*i+roomSize.X-1)
            end

            local idx = walls[rng:RandomInt(1,#walls)]
            spawnPos = room:GetGridPosition(idx)
        else
            local idx = pits[rng:RandomInt(1,#pits)]
            spawnPos = room:GetGridPosition(idx)
        end

        local spider = player:ThrowBlueSpider(spawnPos, room:FindFreeTilePosition(spawnPos,0))
        if(spider and rng:RandomFloat()<MUTANT_CHANCE) then
            ToyboxMod:makeRandomUpgradedInsect(spider, true)
        end
        ToyboxMod.SFX:Play(SoundEffect.SOUND_BOIL_HATCH, 0.66)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, peffectUpdate)