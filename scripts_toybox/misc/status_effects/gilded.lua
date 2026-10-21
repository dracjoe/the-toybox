local COIN_PICKER = WeightedOutcomePicker()
COIN_PICKER:AddOutcomeFloat(1, 1.0)
COIN_PICKER:AddOutcomeFloat(2, 1.0)
COIN_PICKER:AddOutcomeFloat(3, 0.5)

local COIN_TIMEOUT = 30*3

local STATUS_COLOR = Color((205/255)^0.5,(181/255)^0.5,(60/255)^0.5,1,0.15*(205/255),0.15*(181/255),0.15*(60/255))

ToyboxMod:addOverlayEffect("Gilded", nil, nil, STATUS_COLOR, 100)

---@param ent Entity
---@param duration integer Negative makes it a setter instead of additive
---@param source EntityRef
---@param ignoreBoss? boolean Default: false
function ToyboxMod:applyGilded(ent, duration, source, ignoreBoss)
    ToyboxMod:applyStatusEffect(ent, "Gilded", duration, source, true, ignoreBoss)
end

local function spawnCoinsOnDeath(_, npc)
    if(not ToyboxMod:hasStatusEffect(npc, "Gilded")) then return end

    local rng = npc:GetDropRNG()
    local numCoins = COIN_PICKER:PickOutcome(rng)
    for i=1, numCoins do
        local dir = rng:RandomVector()*3
        local pickup = Isaac.Spawn(5,PickupVariant.PICKUP_COIN,CoinSubType.COIN_PENNY,npc.Position,dir,npc):ToPickup()

        --pickup:AppearFast()
        pickup:SetDropDelay(i-1)
        pickup.Timeout = COIN_TIMEOUT
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, spawnCoinsOnDeath)

---@param ent Entity
---@param offset Vector
local function spawnSparkle(ent, offset, scale)
    scale = scale^0.7

    local pos = ent.Position+offset+(Vector(ent.Size*(1+math.random()*0.5)*1.2,0):Rotated(math.random(1,360)))*scale*0.66
    pos = pos+ent.Velocity*(ToyboxMod:generateRng(ent.InitSeed):RandomFloat()*0.4-0.1)

    local sparkle = Isaac.Spawn(1000,104,4,pos,(RandomVector()-ent.Velocity:Normalized()*2):Normalized()*0.5,nil):ToEffect()
    sparkle.DepthOffset = 100
    sparkle:SetTimeout(30*1)
    sparkle:SetSpeedMultiplier(10)
    sparkle.SpriteScale = sparkle.SpriteScale*scale

    local r,g,b = 205/255, 181/255, 61/255

    sparkle:SetColor(Color(0,0,0,1.2,r,g,b), 30*0.5, 0, true, false)
    sparkle:SetColor(Color(0,0,0,0,r,g,b), 30*10, 10, false, false)

    sparkle:Update()
end

local function sparkleNpcs(_, npc)
    if(not ToyboxMod:hasStatusEffect(npc, "Gilded")) then return end

    if(npc.FrameCount%4==0) then
        local spr = npc:GetSprite()
        local offset = npc.SpriteOffset+Vector(0,-6)*npc.SpriteScale
        local frame = spr:GetNullFrame("OverlayEffect") or spr:GetOverlayNullFrame("OverlayEffect")
        if(frame) then
            offset = offset+frame:GetPos()+Vector(0,20)
        else
            offset = offset+Vector(0,-npc.Size*1.25)*npc.SizeMulti+Vector(0,20)
        end

        spawnSparkle(npc, offset, npc.SpriteScale.X*1)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, sparkleNpcs)