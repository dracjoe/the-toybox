--- stuff to render above entities
local overlaySprite = Sprite("gfx_tb/ui/ui_overlay_effects.anm2", true)

ToyboxMod.OVERLAY_EFFECTS = {}

local function sortOverlays(a, b)
    return a.Priority<b.Priority
end

---@param statusName? string
---@param animName string
---@param applyCondition? function Params: Entity ent
---@param priority? number Inverted (higher has less priority than lower)
---@param overlayColor? Color
function ToyboxMod:addOverlayEffect(statusName, animName, applyCondition, overlayColor, priority)
    table.insert(ToyboxMod.OVERLAY_EFFECTS,
        {
            Animation = animName,
            Condition = applyCondition or (statusName and function(ent)
                return ToyboxMod:hasStatusEffect(ent, statusName)
            end),
            Priority = priority or 0,
            StatusName = statusName,
            EntityColor = overlayColor or nil,
        }
    )

    table.sort(ToyboxMod.OVERLAY_EFFECTS, sortOverlays)
end

local function getStatusIndexByName(name)
    for i, data in ipairs(ToyboxMod.OVERLAY_EFFECTS) do
        if(data.StatusName and data.StatusName==name) then
            return i
        end
    end
    return nil
end

---@param ent Entity
---@param name string
---@param duration integer
---@param source EntityRef
---@param ignoreBoss? boolean Default: false
---@param setColor? boolean Default: true
function ToyboxMod:applyStatusEffect(ent, name, duration, source, setColor, ignoreBoss)
    if(ent:IgnoreEffectFromFriendly(source)) then return end
    if(ent:GetBossStatusEffectCooldown()>0 and not ignoreBoss) then return end
    if(ent:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)) then return end

    if(ent:ToPlayer() and ent:ToPlayer():HasCollectible(CollectibleType.COLLECTIBLE_EVIL_CHARM)) then return end

    local visitedParent = {}
    local pr = ent
    while(pr) do
        if(visitedParent[pr.InitSeed]) then break end
        visitedParent[pr.InitSeed] = true

        if((not pr.Parent) or (visitedParent[pr.Parent.InitSeed])) then
            ent = pr
        end
        pr = pr.Parent
    end

    if(ent:IsBoss() and not ignoreBoss) then
        ent:SetBossStatusEffectCooldown(30*8)
    end

    local additive = true
    if(duration<0) then
        additive = false
    end
    duration = ent:ComputeStatusEffectDuration(math.abs(duration), source)

    local data = ToyboxMod:getEntityDataTable(ent)
    local oldStatusDuration = data["STATUS_"..name.."_DURATION"] or 0
    if(additive) then
        data["STATUS_"..name.."_DURATION"] = (data["STATUS_"..name.."_DURATION"] or 0)+duration
    else
        data["STATUS_"..name.."_DURATION"] = math.max(data["STATUS_"..name.."_DURATION"] or 0, duration)
    end
    local finalDuration = data["STATUS_"..name.."_DURATION"]

    data["STATUS_"..name.."_SOURCE"] = source

    local statusIdx = (setColor~=false) and getStatusIndexByName(name)
    if(statusIdx and finalDuration>oldStatusDuration) then
        ent:SetColor(ToyboxMod.OVERLAY_EFFECTS[statusIdx].EntityColor, finalDuration, ToyboxMod.OVERLAY_EFFECTS[statusIdx].Priority, false, false)
    end

    local visited = {}
    local ch = ent
    while(ch) do
        if(visited[ch.InitSeed]) then break end
        visited[ch.InitSeed] = true

        ToyboxMod:setEntityData(ch, "STATUS_"..name.."_DURATION", finalDuration)
        ToyboxMod:setEntityData(ch, "STATUS_"..name.."_SOURCE", source)

        if(ent:IsBoss() and ch:IsBoss()) then
            ch:SetBossStatusEffectCooldown(ent:GetBossStatusEffectCooldown())
        end

        ch = ch.Child
    end
end
---@param ent Entity
---@param name string
function ToyboxMod:hasStatusEffect(ent, name)
    return (ToyboxMod:getEntityData(ent, "STATUS_"..name.."_DURATION") or 0)>0
end
---@param ent Entity
---@param name string
function ToyboxMod:getStatusEffectSource(ent, name)
    return ToyboxMod:getEntityData(ent, "STATUS_"..name.."_SOURCE")
end

---@param ent Entity
local function getHighestPriorityStatus(ent)
    for i, data in ipairs(ToyboxMod.OVERLAY_EFFECTS) do
        if(data.Condition(ent)) then
            return i
        end
    end
    return nil
end
---@param ent Entity
local function hasVanillaOverlay(ent)
    local statusFlags = EntityFlag.FLAG_BAITED | EntityFlag.FLAG_BLEED_OUT  | EntityFlag.FLAG_BRIMSTONE_MARKED
                      | EntityFlag.FLAG_BURN   | EntityFlag.FLAG_CHARM      | EntityFlag.FLAG_CONFUSION
                      | EntityFlag.FLAG_FEAR   | EntityFlag.FLAG_MAGNETIZED | EntityFlag.FLAG_POISON
                      | EntityFlag.FLAG_SLOW   | EntityFlag.FLAG_WEAKNESS
    if(ent:GetEntityFlags() & statusFlags ~= 0) then return true end

    if(ent:ToNPC()) then
        local npc = ent:ToNPC()
        if(npc:IsChampion()) then
            local color = npc:GetChampionColorIdx()
            if(color==ChampionColor.KING) then return true end
            if(color==ChampionColor.SKULL) then return true end
        end
    end
    return false
end

---@param npc EntityNPC
local function renderOverlays(_, npc, offset)
    if(hasVanillaOverlay(npc)) then return end

    local status = getHighestPriorityStatus(npc)
    if(not status) then return end

    local data = ToyboxMod.OVERLAY_EFFECTS[status]
    if(not data) then return end
    local overlayFrame = npc:GetSprite():GetNullFrame("OverlayEffect")
    if(not overlayFrame) then return end
    

    local pos = overlayFrame:GetPos()
    local rPos = pos+Isaac.WorldToScreen(npc.Position)+offset-ToyboxMod.GAME:GetRoom():GetRenderScrollOffset()
    overlaySprite:SetFrame(data.Animation, npc.FrameCount%overlaySprite:GetAnimationData(data.Animation):GetLength())
    overlaySprite:Render(rPos)
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_POST_NPC_RENDER, math.huge, renderOverlays)

---@param npc EntityNPC
local function npcUpdate(_, npc)
    local data = ToyboxMod:getEntityDataTable(npc)
    for _, sData in ipairs(ToyboxMod.OVERLAY_EFFECTS) do
        if(sData.StatusName and ToyboxMod:hasStatusEffect(npc, sData.StatusName)) then
            data["STATUS_"..sData.StatusName.."_DURATION"] = (data["STATUS_"..sData.StatusName.."_DURATION"] or 0)-1
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, npcUpdate)