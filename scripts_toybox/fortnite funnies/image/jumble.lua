local BLOCK_SIZE = Vector(1,10000)

local mmm = 5
local nnnn = 10

local function jumbleBlock(i, j)
    if(i%nnnn<nnnn/2) then
        return mmm*(i//mmm)+(mmm-i%mmm-1), j
    else
        return nnnn*(i//nnnn)+(nnnn-1-(mmm*(i//mmm)+(mmm-i%mmm-1))%nnnn), j
    end
end

local rendering = false

local function rendertest()
    if(rendering) then return end

    local image = Renderer.CreateImage(Isaac.GetScreenWidth(), Isaac.GetScreenHeight(), "TestImage")
    Renderer.RenderToImage(image, function()
        rendering = true
        ToyboxMod.GAME:Render()
        rendering = false
    end)

    for i=0, math.ceil(Isaac.GetScreenWidth()/BLOCK_SIZE.X) do
        for j=0, math.ceil(Isaac.GetScreenHeight()/BLOCK_SIZE.Y) do
            local i2, j2 = jumbleBlock(i, j)

            local sourceTL = Vector(i2, j2)*BLOCK_SIZE
            local sourceBR = Vector(i2+1, j2+1)*BLOCK_SIZE

            local destTL = Vector(i, j)*BLOCK_SIZE
            local destBR = Vector(i+1, j+1)*BLOCK_SIZE

            local sourceQ = ToyboxMod:makeQuadFromCorners(sourceTL, sourceBR, true, false, false)
            local destQ = ToyboxMod:makeQuadFromCorners(destTL, destBR, false, false, false)

            image:Render(sourceQ, destQ, KColor(1,1,1,1),Color(1,1,1,1,(i%2==0 and 0.0 or 0),(j%2==0 and 0.0 or 0)))
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_HUD_RENDER, rendertest)