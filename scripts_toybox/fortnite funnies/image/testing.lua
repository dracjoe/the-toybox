
-- DRAW QUADS WITH MOUSE
--[[] ]
local HELD_POSITIONS = {}
local LAST_HELD = 0
local CURRENT_HELD = 0

local function rendertest()
    if(Input.IsMouseBtnPressed(MouseButton.LEFT)) then
        if(LAST_HELD==CURRENT_HELD) then
            CURRENT_HELD = CURRENT_HELD+1
        end
        HELD_POSITIONS[CURRENT_HELD] = Isaac.WorldToRenderPosition(Input.GetMousePosition(true))
        for i=CURRENT_HELD+1, 4*math.ceil(CURRENT_HELD/4) do
            HELD_POSITIONS[i] = HELD_POSITIONS[CURRENT_HELD]
        end
    else
        if(CURRENT_HELD~=LAST_HELD) then
            LAST_HELD = CURRENT_HELD
        end
    end

    if(Input.IsMouseBtnPressed(MouseButton.RIGHT)) then
        HELD_POSITIONS = {}
        LAST_HELD = 0
        CURRENT_HELD = 0
    end

    for i=0, math.ceil(CURRENT_HELD/4)-1 do
        Isaac.DrawQuad(HELD_POSITIONS[i*4+1], HELD_POSITIONS[i*4+2], HELD_POSITIONS[i*4+4], HELD_POSITIONS[i*4+3], KColor(1,1,1,1), 4)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_HUD_RENDER, rendertest)
--]]

local sp = Sprite("gfx_tb/black square.anm2", true)
sp:Play("Idle", true)
sp.Scale = Vector(0.25,0.25)

local mult = 3

local function rendertest()
    local image = Renderer.CreateImage(30, 30, "TestImage")

    local image1 = Renderer.LoadImage("gfx_tb/items/collectibles/lion_skull.png")
    local size = 32
    local init = 0
    local str = image1:GetTexelRegion(init, init, init+size, init+size)

    Isaac.RenderText(tostring(mult), 80, 60, 1,1,1,1)
    for i=0, size-1 do
        for j=0, size-1 do
            --local pixeldata = {string.byte(str, 4*(size*i+j)+1, 4*(size*i+j)+4)}
            local pixeldata = {string.byte(str, (mult*(size*i+j)+1)//1, (mult*(size*i+j)+4)//1)}
            sp.Color = Color(1,1,1,(pixeldata[4] or 0)/255,(pixeldata[1] or 0)/255, (pixeldata[2] or 0)/255, (pixeldata[3] or 0)/255)
            sp:Render(Vector(80,80)+Vector(1,1)*Vector(j,i))
        end
    end

    image:Render(ToyboxMod:makeQuadFromCorners(Vector(0,0),Vector(1,1), true, true), ToyboxMod:makeQuadFromCenterRadius(Vector(250, 100), 20, 0, false), KColor(1,1,1,1))
end
--ToyboxMod:AddCallback(ModCallbacks.MC_POST_HUD_RENDER, rendertest)