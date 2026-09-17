local PARASITE_TRINKET_DATA = {}

---@param id TrinketType
---@param replaceTrinket TrinketType|TrinketType[]
---@param replaceSfx SoundEffect?
function ToyboxMod:makeParasiteTrinket(id, replaceTrinket, replaceSfx)
    PARASITE_TRINKET_DATA[id] = {
        ReplaceTrinkets = (type(replaceTrinket)=="table" and replaceTrinket or {replaceTrinket}),
        ReplaceSFX = replaceSfx or SoundEffect.SOUND_MATCHSTICK
    }
end



local function trinketCollision(_, pickup, coll)
    local player = coll and coll:ToPlayer()
    if(not player) then return end

    local hasTick = false
    local removalAtSlot = {}
    local hasFreeSlot = {}
    local hasTrinkets = false
    for i=0, player:GetMaxTrinkets()-1 do
        local trinket = (player:GetTrinket(i) & (~TrinketType.TRINKET_GOLDEN_FLAG))
        if(trinket~=0) then
            table.insert(removalAtSlot, false)
            table.insert(hasFreeSlot, false)
            if(PARASITE_TRINKET_DATA[trinket]) then
                for _, other in ipairs(PARASITE_TRINKET_DATA[trinket].ReplaceTrinkets) do
                    if(other == (pickup.SubType & (~TrinketType.TRINKET_GOLDEN_FLAG))) then
                        removalAtSlot[0] = true
                        removalAtSlot[#removalAtSlot] = true
                    end
                end
            elseif(trinket~=TrinketType.TRINKET_TICK) then
                hasFreeSlot[0] = true
                hasFreeSlot[#hasFreeSlot] = true
            else
                hasTick = true

                if(removalAtSlot[0]) then
                    removalAtSlot[#removalAtSlot] = nil
                    table.insert(removalAtSlot, 1, 67)
                end
            end
            hasTrinkets = true
        end
    end

    if(not hasTrinkets) then return end

    if(removalAtSlot[0]) then
        local trinketsToReadd = {}
        for _, removes in ipairs(removalAtSlot) do
            if(removes==67) then
                local tempPickup = player:DropTrinket(player.Position, true)
                table.insert(trinketsToReadd, tempPickup.SubType)
                tempPickup:Remove()
            else
                local trinket = player:GetTrinket(0)
                if(trinket~=0) then
                    if(trinket==TrinketType.TRINKET_TICK) then
                        removes = false
                    end
                    ToyboxMod:setEntityData(player, "PARASITE_OVERWRITE", removes)
                    local tempPickup = player:DropTrinket(player.Position+RandomVector(), true)
                    if(trinket==TrinketType.TRINKET_TICK and not removes) then
                        ToyboxMod.SFX:Stop(SoundEffect.SOUND_TICK_BURN)
                    end
                    ToyboxMod:setEntityData(player, "PARASITE_OVERWRITE", nil)
                    if(not removes) then
                        tempPickup:Remove()
                        table.insert(trinketsToReadd, trinket)
                    end
                end
            end
        end
        for _, trinket in ipairs(trinketsToReadd) do
            player:AddTrinket(trinket, false)
        end
    elseif(hasFreeSlot[0]) then
        local trinketsToReadd = {}
        for i=1, #hasFreeSlot do
            if(hasFreeSlot[i]) then break end

            local trinket = player:GetTrinket(0)
            if(trinket~=0) then
                ToyboxMod:setEntityData(player, "PARASITE_OVERWRITE", false)
                local tempPickup = player:DropTrinket(player.Position, true)
                if(trinket==TrinketType.TRINKET_TICK and not removes) then
                    ToyboxMod.SFX:Stop(SoundEffect.SOUND_TICK_BURN)
                end
                ToyboxMod:setEntityData(player, "PARASITE_OVERWRITE", nil)
                tempPickup:Remove()
                table.insert(trinketsToReadd, trinket)
            end
        end
        for _, trinket in ipairs(trinketsToReadd) do
            player:AddTrinket(trinket, false)
        end
    elseif(not (hasTick and pickup.SubType & (~TrinketType.TRINKET_GOLDEN_FLAG) == TrinketType.TRINKET_MATCH_STICK)) then
        return false
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, CallbackPriority.LATE+1, trinketCollision, PickupVariant.PICKUP_TRINKET)


local function postDropTrinket(_, trinket, pos, player, golden, replaceTick, pickup)
    if(not PARASITE_TRINKET_DATA[trinket]) then return end

    local overwrite = ToyboxMod:getEntityData(player, "PARASITE_OVERWRITE")
    if(overwrite~=nil) then
        if(overwrite==true) then
            ToyboxMod.SFX:Play(PARASITE_TRINKET_DATA[trinket].ReplaceSFX)
        end
    else
        if(replaceTick) then
            ToyboxMod.SFX:Play(PARASITE_TRINKET_DATA[trinket].ReplaceSFX)
        else
            player:AddTrinket(golden and (trinket | TrinketType.TRINKET_GOLDEN_FLAG) or trinket, false)
            pickup:Remove()
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PLAYER_DROP_TRINKET, postDropTrinket)