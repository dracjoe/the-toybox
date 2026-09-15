

-- [[] ] SCARY RENDERING
local img = nil

local baseImg = nil

local function postAddCollectible()
    img = Renderer.CreateImage(Isaac.GetScreenWidth(), Isaac.GetScreenHeight(), "ScaryImage")
    baseImg = Renderer.CreateImage(Isaac.GetScreenWidth(), Isaac.GetScreenHeight(), "ScaryImage2")

    Renderer.RenderToImage(img, function()
        Game():Render()
    end)
    Renderer.RenderToImage(baseImg, function()
        Game():Render()
    end)
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, postAddCollectible)

--postAddCollectible()

local cancelRender = false

local automaticallyCancel = false

---@param ent Entity
---@param offset Vector
local function renderEnt(_, ent, offset)
    if(not img) then return end
    if(cancelRender) then return end

    automaticallyCancel = not automaticallyCancel

    if(automaticallyCancel) then return end

    local chance = (ent.Type==EntityType.ENTITY_PLAYER and 0.3 or 0.08)
    if(ent:GetDropRNG():RandomFloat()<chance) then
        Renderer.RenderToImage(img, function()
            cancelRender = true

            --local pos = etIsaac.WorldToRenderPosition(ent.Position)
            ent:Render(offset)

            cancelRender = false
        end)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, renderEnt)

ToyboxMod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, renderEnt)
ToyboxMod:AddCallback(ModCallbacks.MC_POST_TEAR_RENDER, renderEnt)
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PICKUP_RENDER, renderEnt)
ToyboxMod:AddCallback(ModCallbacks.MC_POST_BOMB_RENDER, renderEnt)
ToyboxMod:AddCallback(ModCallbacks.MC_POST_SLOT_RENDER, renderEnt)
ToyboxMod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, renderEnt)
ToyboxMod:AddCallback(ModCallbacks.MC_POST_LASER_RENDER, renderEnt)
ToyboxMod:AddCallback(ModCallbacks.MC_POST_KNIFE_RENDER, renderEnt)
ToyboxMod:AddCallback(ModCallbacks.MC_POST_FAMILIAR_RENDER, renderEnt)
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_RENDER, renderEnt)

local function renderHud()
    if(not img) then return end
    if(cancelRender) then return end

    local chance = 0.05
    if(math.random()<chance) then
        Renderer.RenderToImage(img, function()
            cancelRender = true

            ToyboxMod.GAME:GetHUD():Render()

            cancelRender = false
        end)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_HUD_RENDER, renderHud)

local function postRender()
    if(not img) then return end
    ---@cast img Image
    
    local size = Vector(Isaac.GetScreenWidth(), Isaac.GetScreenHeight())

    local sQuad = SourceQuad(size*Vector(0,0),size*Vector(1,0),size*Vector(0,1),size*Vector(1,1))
    local dQuad = DestinationQuad(size*Vector(0,0),size*Vector(1,0),size*Vector(0,1),size*Vector(1,1))

    img:Render(sQuad, dQuad, KColor(1.2,1.1,1,1), Color(1,1,1,1,0,0,0,1,0,0.5,0.15))
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_RENDER, postRender)
--]]