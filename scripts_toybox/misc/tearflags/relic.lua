local BLEED_DURATION = 4*30
local TEARFLAG_COLOR = Color(1,1.4,1.2,1,0,0.2,0.1)

ToyboxMod:registerTearVariant(
    ToyboxMod.TEAR_RELIC,
    nil, nil, function(tear, splat)
        splat:GetSprite().Color = splat:GetSprite().Color*Color(124/185,252/207,198/255,1)
    end, false, false, nil
)

---@param entity Entity
---@param player EntityPlayer
local function postAddTearFlag(_, entity, player, _, weaponFlag)
    if(ToyboxMod.WEAPONFLAGS_NO_COLOR[weaponFlag]) then return end

    if(entity:ToTear()) then
        entity:ToTear():ChangeVariant(ToyboxMod.TEAR_RELIC)
    else
        entity.Color = entity.Color*TEARFLAG_COLOR
    end
end
ToyboxMod:AddCallback(TearFlagsLib.Callback.POST_ADD_TEARFLAG, postAddTearFlag, ToyboxMod.TEARFLAGS.RELIC)

---@param npc EntityNPC
---@param player EntityPlayer
local function applyTearFlagEffect(_, npc, player, source, weapon, params)
    local curseStacks = math.max(1, player:GetCollectibleNum(ToyboxMod.COLLECTIBLE_RUNIC_SAP))
    if(npc:CanDevolve() and (ToyboxMod:getEntityData(npc, "CURSE_STACKS") or 0)<curseStacks) then
        local prevStacks = ToyboxMod:getEntityData(npc, "CURSE_STACKS") or 0

        ToyboxMod.GAME:DevolveEnemy(npc)
        local newNpc = nil
        for _, ent in ipairs(Isaac.GetRoomEntities()) do
            if(ent and ent.FrameCount==0 and ent.Position:Distance(npc.Position)<3 and ent:ToNPC()) then
                newNpc = ent:ToNPC()
            end
        end
        if(newNpc) then
            local copydata = {
                newNpc.Type, newNpc.Variant, newNpc.SubType, newNpc.Position, newNpc.Velocity,
                newNpc.MaxHitPoints, newNpc.HitPoints, newNpc.Mass, newNpc.Size, newNpc.SizeMulti, newNpc.SpawnerEntity
            }

            local newNpc2 = Isaac.Spawn(copydata[1], copydata[2], copydata[3], copydata[4], copydata[5], copydata[11]):ToNPC()
            newNpc2.MaxHitPoints = copydata[6]
            newNpc2.HitPoints = copydata[7]
            newNpc2.Mass = copydata[8]
            newNpc2.Size = copydata[9]
            newNpc2.SizeMulti = copydata[10]

            newNpc:Remove()
            newNpc:Update()

            newNpc = newNpc2

            newNpc.HitPoints = newNpc.MaxHitPoints*npc.HitPoints/npc.MaxHitPoints
            newNpc:AddHealth(0)

            ToyboxMod:setEntityData(newNpc, "CURSE_STACKS", prevStacks+1)
            if(ToyboxMod:getEntityData(newNpc, "CURSE_STACKS")==curseStacks) then
                ToyboxMod:setEntityData(newNpc, "MAX_CURSE", true)
            end
        end

        if((npc:IsChampion() and npc:GetChampionColorIdx()~=ChampionColor.DARK_RED) or ToyboxMod:isModChampion(npc)) then
            local dummy = Isaac.Spawn(12,0,0,npc.Position,Vector.Zero,nil):ToNPC()
            dummy.MaxHitPoints = npc.MaxHitPoints
            dummy.HitPoints = npc.HitPoints
            if(npc:IsChampion()) then
                dummy:MakeChampion(npc.InitSeed, npc:GetChampionColorIdx(), false)
            else
                ToyboxMod:setEntityData(dummy, "CUSTOM_CHAMPION_IDX", ToyboxMod:getModChampionIdx(npc))
            end

            dummy.Visible = false
            dummy:Die()
            dummy:Update()
        end
    end
end
ToyboxMod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, applyTearFlagEffect, ToyboxMod.TEARFLAGS.RELIC)



---@param ent Entity
---@param offset Vector
local function spawnSparkle(ent, offset, scale)
    scale = scale^0.7

    local pos = ent.Position+offset+(Vector(ent.Size*(1+math.random()*0.5)*1.2,0):Rotated(math.random(1,360)))*scale*0.5
    pos = pos+ent.Velocity*(ToyboxMod:generateRng(ent.InitSeed):RandomFloat()*0.4-0.1)

    local sparkle = Isaac.Spawn(1000,104,4,pos,(RandomVector()-ent.Velocity:Normalized()*2):Normalized()*0.5,nil):ToEffect()
    sparkle.DepthOffset = 100
    sparkle:SetTimeout(30*1)
    sparkle:SetSpeedMultiplier(10)
    sparkle.SpriteScale = sparkle.SpriteScale*scale

    local r,g,b = 124/255, 252/255, 198/255

    sparkle:SetColor(Color(0,0,0,1.2,r,g,b), 30*0.5, 0, true, false)
    sparkle:SetColor(Color(0,0,0,0,r,g,b), 30*10, 10, false, false)

    sparkle:Update()
end

---@param tear EntityTear
local function relicPostTearUpdate(_, tear)
    if(not TearFlagsLib.HasTearFlags(tear, ToyboxMod.TEARFLAGS.RELIC)) then return end

    if(tear.FrameCount%3==0) then
        spawnSparkle(tear, tear.PositionOffset*0.67+Vector(0,-8)*tear.Scale, tear.Scale)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, relicPostTearUpdate)

---@param bomb EntityBomb
local function relicPostBombUpdate(_, bomb)
    if(not TearFlagsLib.HasTearFlags(bomb, ToyboxMod.TEARFLAGS.RELIC)) then return end

    if(bomb.FrameCount%3==0) then
        spawnSparkle(bomb, bomb.SpriteOffset+Vector(0,-6)*bomb:GetScale(), bomb:GetScale()*0.9)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, relicPostBombUpdate)



local function relicNpcUpdate(_, npc)
    if(not ToyboxMod:getEntityData(npc, "MAX_CURSE")) then return end

    if(npc.FrameCount%5==0) then
        local spr = npc:GetSprite()
        local offset = npc.SpriteOffset+Vector(0,-6)*npc.SpriteScale
        local frame = spr:GetNullFrame("OverlayEffect") or spr:GetOverlayNullFrame("OverlayEffect")
        if(frame) then
            offset = offset+frame:GetPos()+Vector(0,20)
        else
            offset = offset+Vector(0,-npc.Size*1.25)*npc.SizeMulti+Vector(0,20)
        end

        spawnSparkle(npc, offset, npc.SpriteScale.X)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, relicNpcUpdate)