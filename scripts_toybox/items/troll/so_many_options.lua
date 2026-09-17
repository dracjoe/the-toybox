local SPAWNED_NEW_ENEMY = false

local function trySpawnCopy(_, npc)
    if(SPAWNED_NEW_ENEMY) then return end
    if(not PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_SO_MANY_OPTIONS)) then return end
    if(ToyboxMod.GAME:GetRoom():GetFrameCount()>1) then return end
    if(npc:IsBoss()) then return end

    if(npc:CanReroll()) then
        local posOffset = Vector.FromAngle(math.random(1,360))*15

        SPAWNED_NEW_ENEMY = true

        local copy = Isaac.Spawn(npc.Type, npc.Variant, npc.SubType, npc.Position+posOffset, Vector.Zero, npc):ToNPC()
        npc.Position = npc.Position-posOffset

        ToyboxMod.GAME:RerollEnemy(copy)
        for _, ent in ipairs(Isaac.GetRoomEntities()) do
            if(ent.Position:Distance(copy.Position)<10) then
                if(not (ent.Type==copy.Type and ent.Variant==copy.Variant and ent.SubType==copy.Variant)) then
                    copy = ent:ToNPC()
                end
            end
        end

        copy:UpdateDirtColor(true)

        local r,g,b = ToyboxMod:hsl2Rgb(math.random(), 0.9, 1)

        local color = Color(0.9+r*0.25, 0.9+g*0.25, 0.9+b*0.25, 0.44, r*0.25, g*0.25, b*0.25)

        ToyboxMod:setEntityData(npc, "SO_MANY_OPTIONS_PAUSED", true)
        ToyboxMod:setEntityData(npc, "SO_MANY_OPTIONS_FRIEND", copy)
        ToyboxMod:setEntityData(npc, "SO_MANY_OPTIONS_COLOR", color)
        --npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        npc.Color = color

        ToyboxMod:setEntityData(copy, "SO_MANY_OPTIONS_PAUSED", true)
        ToyboxMod:setEntityData(copy, "SO_MANY_OPTIONS_FRIEND", npc)
        ToyboxMod:setEntityData(copy, "SO_MANY_OPTIONS_COLOR", color)
        --copy:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        copy.Color = color

        SPAWNED_NEW_ENEMY = false
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, trySpawnCopy)

local function tryFreezeNpc(_, npc)
    if(ToyboxMod:getEntityData(npc, "SO_MANY_OPTIONS_PAUSED")) then
        if(npc.FrameCount>1) then
            npc:SetPauseTime(30*1000)
            npc.Color = ToyboxMod:getEntityData(npc, "SO_MANY_OPTIONS_COLOR") or Color.Default
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, tryFreezeNpc)

local function entityTakeDamage(_, ent)
    local data = ToyboxMod:getEntityDataTable(ent)
    if(data.SO_MANY_OPTIONS_PAUSED) then
        data.SO_MANY_OPTIONS_PAUSED = nil
        ent:SetPauseTime(0)
        ent.Color = Color.Default

        local other = data.SO_MANY_OPTIONS_FRIEND
        if(other and other:Exists() and not other:IsDead()) then
            ToyboxMod:setEntityData(other, "SO_MANY_OPTIONS_PAUSED", nil)
            ToyboxMod:setEntityData(other, "SO_MANY_OPTIONS_FRIEND", nil)

            local poof = Isaac.Spawn(1000,15,2,other.Position,Vector.Zero,nil)
            other:Remove()
        end
        data.SO_MANY_OPTIONS_FRIEND = nil
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, entityTakeDamage)

local function entityRemove(_, ent)
    local other = ToyboxMod:getEntityData(ent, "SO_MANY_OPTIONS_FRIEND")
    if(other and other:Exists() and not other:IsDead()) then
        ToyboxMod:setEntityData(other, "SO_MANY_OPTIONS_PAUSED", nil)
        ToyboxMod:setEntityData(other, "SO_MANY_OPTIONS_FRIEND", nil)
        other:SetPauseTime(0)
        other.Color = Color.Default
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, entityRemove)