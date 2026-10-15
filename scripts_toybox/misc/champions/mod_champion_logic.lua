--TODO: Make color not affected by stuff that sets colorize

---@param npc EntityNPC
---@return boolean
function ToyboxMod:isModChampion(npc)
    return (ToyboxMod:getEntityData(npc, "CUSTOM_CHAMPION_IDX")~=nil)
end
---@param npc EntityNPC
---@return int
function ToyboxMod:getModChampionIdx(npc)
    return ToyboxMod:getEntityData(npc, "CUSTOM_CHAMPION_IDX")
end

function ToyboxMod:getModChampionPicker()
    local level = ToyboxMod.GAME:GetLevel()

    local picker = WeightedOutcomePicker()
    for _, data in pairs(ToyboxMod.CUSTOM_CHAMPIONS) do
        if((data.Weight or 1)>0 and (data.StageReq==nil or level:GetAbsoluteStage()>=data.StageReq)) then
            picker:AddOutcomeFloat(data.Idx, data.Weight or 1)
        end
    end
    return picker
end

local function initModChampData(npc)
    local result = ToyboxMod.CUSTOM_CHAMPIONS[ToyboxMod.CUSTOM_CHAMPION_IDX_TO_NAME[ToyboxMod:getModChampionIdx(npc)]]
    if(not result) then return end

    npc.MaxHitPoints = npc.MaxHitPoints*result.HPMult
    npc.HitPoints = npc.HitPoints*result.HPMult
    if(npc.CollisionDamage>0) then
        npc.CollisionDamage = 2
    end
    npc.Scale = npc.Scale*1.15
    
    local spr = npc:GetSprite()
    for _, layer in pairs(spr:GetAllLayers()) do
        local path = layer:GetSpritesheetPath()
        path = string.sub(path, 1, -5).."_champion.png"
        if(pcall(Renderer.LoadImage, path)) then
            spr:ReplaceSpritesheet(layer:GetLayerID(), path, false)
        end
    end
    spr:LoadGraphics()
    spr:SetCustomShader("shaders_tb/custom_champion")

    local color = result.Color
    local npcCol = npc.Color
    npcCol:SetColorize(color.R, color.G, color.B, color.Mode)
    npc.Color = npcCol

    Isaac.RunCallbackWithParam(ToyboxMod.CUSTOM_CALLBACKS.POST_CUSTOM_CHAMPION_INIT, result.Idx, npc, result.Idx)
end

---@param npc EntityNPC
---@param id string
---@param init boolean?
function ToyboxMod:MakeModChampion(npc, id, init)
    local outcome = id or ToyboxMod.CUSTOM_CHAMPION_IDX_TO_NAME[ToyboxMod:getModChampionPicker():PickOutcome(npc:GetDropRNG())]

    ToyboxMod.DENY_CHAMP_ROLL = true

    local newNpc = npc
    if(init) then newNpc = nil end
    while(not (newNpc and newNpc:Exists() and not newNpc:IsChampion())) do
        newNpc = Isaac.Spawn(npc.Type, npc.Variant, npc.SubType, npc.Position, npc.Velocity, npc.SpawnerEntity):ToNPC()
        if(newNpc:IsChampion()) then
            newNpc:Remove()
        end
    end
    newNpc.Parent = npc.Parent
    newNpc.I1 = npc.I1
    newNpc.I2 = npc.I2
    newNpc.V1 = npc.V1
    newNpc.V2 = npc.V2
    newNpc.State = npc.State
    newNpc.StateFrame = npc.StateFrame
    newNpc:GetSprite():SetFrame(npc:GetSprite():GetAnimation(), npc:GetSprite():GetFrame())
    newNpc:GetSprite():SetOverlayFrame(npc:GetSprite():GetOverlayAnimation(), npc:GetSprite():GetOverlayFrame())
    newNpc.Target = npc.Target
    newNpc.TargetPosition = npc.TargetPosition
    if(npc.Parent and npc.Parent.Child and GetPtrHash(npc.Parent.Child)==GetPtrHash(npc)) then
        npc.Parent.Child = newNpc
    end
    newNpc:ClearEntityFlags(newNpc:GetEntityFlags())
    newNpc:AddEntityFlags(npc:GetEntityFlags())

    ToyboxMod.DENY_CHAMP_ROLL = false
    if(GetPtrHash(newNpc)~=GetPtrHash(npc)) then
        npc:Remove()
    end

    local result = ToyboxMod.CUSTOM_CHAMPIONS[outcome]
    ToyboxMod:setEntityData(newNpc:ToNPC(), "CUSTOM_CHAMPION_IDX", result.Idx)

    initModChampData(newNpc)

    return newNpc
end

---@param npc EntityNPC
local function tryMakeModChampion(npc)
    if(not (npc:IsChampion())) then return end

    if(npc:GetDropRNG():RandomFloat()<ToyboxMod.CONFIG.MOD_CHAMPION_CHANCE) then
        ToyboxMod:MakeModChampion(npc)
    end
end

local function makeModChampions(_)
    for _, ent in ipairs(Isaac.GetRoomEntities()) do
        if(ent:ToNPC()) then
            tryMakeModChampion(ent:ToNPC())
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, makeModChampions)

local function championProjDealDamage(_, _, amount, flags, source, frames)
    source = source.Entity
    if(not (source and source:ToProjectile())) then return end

    local npc = source.SpawnerEntity
    if(not (npc and npc:ToNPC() and ToyboxMod:getEntityData(npc:ToNPC(), "CUSTOM_CHAMPION_IDX"))) then return end

    if(amount>0) then
        return {
            Damage = 2,
            DamageFlags = flags,
            DamageCountdown = frames,
        }
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, -math.huge, championProjDealDamage, EntityType.ENTITY_PLAYER)

local function updateShader(_, npc)
    local id = ToyboxMod:getModChampionIdx(npc)
    if(id) then
        local color = ToyboxMod.CUSTOM_CHAMPIONS[ToyboxMod.CUSTOM_CHAMPION_IDX_TO_NAME[id]].Color

        local npcCol = npc.Color
        npcCol:SetColorize(color.R, color.G, color.B, color.Mode)
        npc.Color = npcCol
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, updateShader)

local function npcInit(_, npc)
    initModChampData(npc)
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_NPC_MORPH, npcInit)