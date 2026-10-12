local UNDERTALE = false

local EVIL_TINTEDROCK_COLOR = Color(1,0.9,0.9,1,0,0,0,0.9,0.8,0.8,1)
local EVIL_TINTEDSPIDER_COLOR = Color(0.9,0.85,0.85,1,0,0,0,0.8,0.8,0.8,1)

local EVIL_TINTEDROCK_AFTERIMAGES = 3
local AFTERIMAGE_SPIN_DUR = 90
local AFTERIMAGE_PULSE_DUR = 150
local AFTERIMAGE_PULSE_DIST = 1.5

if(UNDERTALE) then
    EVIL_TINTEDROCK_COLOR = Color(1,0,0,1,0.5)
    EVIL_TINTEDROCK_AFTERIMAGES = 6
    AFTERIMAGE_PULSE_DIST = 75
end

local EVIL_TINTEDROCK_PICKUP_MORPHS = {
    {
        ORIGINAL = {{5,10,0}}, -- hearts
        MORPH = {{5,10,6, 1.0}},  -- black heart
    },
    {
        ORIGINAL = {{5,30,0}}, -- keys
        MORPH = {{5,40,3, 0.55}, {5,70,0, 0.45}}, -- troll bombs / pills
    },
    {
        ORIGINAL = {{5,60,0},{5,50,0}}, -- chests
        MORPH = {{5,360,0, 1.0}}, -- red chest
    },
    {
        ORIGINAL = {{5,100,0}}, -- item
        MORPH = {{5,100,ToyboxMod.COLLECTIBLE_ONYX, 1.0}}, -- onyx
    },
}

---@param ent Entity
---@param rng RNG
local function getEvilTintedRockMorph(ent, rng)
    for _, data in ipairs(EVIL_TINTEDROCK_PICKUP_MORPHS) do
        local passThis = true
        for _, pData in ipairs(data.ORIGINAL) do
            if((pData[1]==0 or ent.Type==pData[1]) and (pData[2]==0 or ent.Variant==pData[2]) and (pData[3]==0 or ent.SubType==pData[3])) then
                passThis = false
            end
        end

        if(not passThis) then
            local maxWeight = 0
            for _, pData in ipairs(data.MORPH) do maxWeight = maxWeight+pData[4] end

            local selWeight = rng:RandomFloat()*maxWeight
            local curWeight = 0
            for _, pData in ipairs(data.MORPH) do
                curWeight = curWeight+pData[4]
                if(selWeight<curWeight) then return pData end
            end
        end
    end
end

---@param rock GridEntityRock
---@param offset Vector
local function renderEvilAfterimages(_, rock, offset)
    if(not PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_EVIL_ROCK)) then
        if(ToyboxMod:getGridEntityData(rock, "EVIL_ROCK_TINTED")) then
            ToyboxMod:setGridEntityData(rock, "EVIL_ROCK_TINTED", nil)
            rock:GetSprite().Color = Color.Default
        end

        return
    end
    if(rock.State==2) then return end
    
    ToyboxMod:setGridEntityData(rock, "EVIL_ROCK_TINTED", true)

    local renderPos = Isaac.WorldToRenderPosition(rock.Position)+offset-Vector(0,1)
    local sp = rock:GetSprite()
    sp.Color = Color(1,1,1,0.85,0,0,0,0,0,0,1)

    local frames = ToyboxMod.GAME:GetFrameCount()
    local angleOffset = (360*frames/AFTERIMAGE_SPIN_DUR)%360
    local pulseIntensity = math.sin(math.rad(frames*360/AFTERIMAGE_PULSE_DUR))
    pulseIntensity = 0.1+0.9*(pulseIntensity+1)/2

    for i=1, EVIL_TINTEDROCK_AFTERIMAGES do
        if(UNDERTALE) then
            if(i==1) then sp.Color = Color(1,0.5,0,0.85,0.5,0.25)
            elseif(i==2) then sp.Color = Color(1,1,0,0.85,0.5,0.5)
            elseif(i==3) then sp.Color = Color(0,1,0,0.85,0,0.5)
            elseif(i==4) then sp.Color = Color(0.5,0,1,0.85,0.25,0,0.5)
            elseif(i==5) then sp.Color = Color(0,0,1,0.85,0,0,0.5)
            elseif(i==6) then sp.Color = Color(0,1,1,0.85,0,0.5,0.5) end
        end

        local renderPosOffset = Vector.FromAngle(360*i/EVIL_TINTEDROCK_AFTERIMAGES+angleOffset)
        renderPosOffset:Resize(AFTERIMAGE_PULSE_DIST*(pulseIntensity+1)/2)

        sp:Render(renderPos+renderPosOffset)
    end

    sp.Color = EVIL_TINTEDROCK_COLOR
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_GRID_ENTITY_ROCK_RENDER, renderEvilAfterimages, GridEntityType.GRID_ROCKT)
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_GRID_ENTITY_ROCK_RENDER, renderEvilAfterimages, GridEntityType.GRID_ROCK_SS)

---@param rock GridEntityRock
---@param type GridEntityType
---@param immediate boolean
local function replaceEvilTintedRockDrops(_, rock, type, immediate)
    if(not PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_EVIL_ROCK)) then return end

    local rng = ToyboxMod:generateRng(rock:GetSaveState().SpawnSeed) ---@type RNG
    
    for _, pickup in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP)) do ---@type Entity
        pickup = pickup:ToPickup() ---@cast pickup EntityPickup
        if(pickup.Position:Distance(rock.Position)<10 and pickup.FrameCount==0) then
            local newData = getEvilTintedRockMorph(pickup, rng)
            if(newData) then
                pickup:Morph(newData[1], newData[2], newData[3])
            end
        end
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_POST_GRID_ROCK_DESTROY, CallbackPriority.LATE, replaceEvilTintedRockDrops, GridEntityType.GRID_ROCKT)
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_POST_GRID_ROCK_DESTROY, CallbackPriority.LATE, replaceEvilTintedRockDrops, GridEntityType.GRID_ROCK_SS)

---@param ent EntityNPC
local function preTintedSpiderUpdate(_, ent)
    if(ent.Variant~=1) then return end
    if(not PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_EVIL_ROCK)) then return end

    ent.Color = EVIL_TINTEDSPIDER_COLOR
    ent.SplatColor = EVIL_TINTEDROCK_COLOR

    if(ent:IsDead()) then
        local blackHeart = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_BLACK, ent.Position, ent.Velocity, ent):ToPickup()
        return true
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, preTintedSpiderUpdate, EntityType.ENTITY_ROCK_SPIDER)