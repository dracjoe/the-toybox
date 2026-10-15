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

local function preNpcRender(_, npc)
    local id = ToyboxMod:getModChampionIdx(npc)
    if(id and id==ToyboxMod.CUSTOM_CHAMPIONS.RECURSIVE.Idx) then
        local color = ToyboxMod.CUSTOM_CHAMPIONS[ToyboxMod.CUSTOM_CHAMPION_IDX_TO_NAME[ToyboxMod:getModChampionIdx(npc)]].Color
        local npcCol = npc.Color

        local overlayOffset = npc.SpriteOffset+Vector(0,-6)*npc.SpriteScale
        local frame = npc:GetSprite():GetNullFrame("OverlayEffect") or npc:GetSprite():GetOverlayNullFrame("OverlayEffect")
        if(frame) then
            overlayOffset = overlayOffset+frame:GetPos()+Vector(0,8)
        else
            overlayOffset = overlayOffset+Vector(0,-npc.Size*1.25)*npc.SizeMulti+Vector(0,20)
        end

        local centerPos = Isaac.WorldToScreen(Isaac.RenderToWorld(Isaac.WorldToRenderPosition(npc.Position)+npc.SpriteOffset+overlayOffset/2))
        centerPos = centerPos*Vector(2.0, 2.0)

        --local screenCenter = Vector(Isaac.GetScreenWidth(), Isaac.GetScreenHeight())/2
        --centerPos = screenCenter+(centerPos-screenCenter)*Vector(2.0, 2.0)

        npcCol:SetColorize(color.R, centerPos.X, centerPos.Y, color.Mode+(npc.FrameCount/80)%1)
        npc.Color = npcCol
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_PRE_NPC_UPDATE, CallbackPriority.LATE+1, preNpcRender)