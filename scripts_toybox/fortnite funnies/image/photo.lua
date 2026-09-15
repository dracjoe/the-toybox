
local PHOTO_RADIUS = 40

local MADE_IMAGES = false

---@type {Image: Image, SourceQuad: SourceQuad, DestQuad: DestinationQuad}[]
local images = {}

local function rendertest()
    local takePhotoButtonPressed = Input.IsButtonPressed(Keyboard.KEY_H, Isaac.GetPlayer().ControllerIndex)
    local resetButtonPressed = Input.IsButtonPressed(Keyboard.KEY_J, Isaac.GetPlayer().ControllerIndex)
    if(takePhotoButtonPressed and not MADE_IMAGES) then
        MADE_IMAGES = true

        local image1 = Renderer.CreateImage(Isaac.GetScreenWidth(), Isaac.GetScreenHeight(), "TestImage")
        Renderer.RenderToImage(image1, function()
            ToyboxMod.GAME:Render()
        end)
--[[] ]
        local image2 = Renderer.LoadImage("gfx_tb/black square.png")

        table.insert(images, {
            Image = image2,
            SourceQuad = ToyboxMod:makeQuadFromCorners(Vector(0,0), Vector(1,1), true, true),
            DestQuad = ToyboxMod:makeQuadFromCenterRadius(Isaac.WorldToRenderPosition(Input.GetMousePosition(true)), 22, false)
        })
        --]]

        table.insert(images, {
            Image = image1,
            SourceQuad = ToyboxMod:makeQuadFromCenterRadius(Isaac.WorldToRenderPosition(Input.GetMousePosition(true)), PHOTO_RADIUS, 0, true),
            DestQuad = ToyboxMod:makeQuadFromCenterRadius(Isaac.WorldToRenderPosition(Input.GetMousePosition(true)), PHOTO_RADIUS, 0, false)
        })
    elseif(not takePhotoButtonPressed) then
        MADE_IMAGES = false
    end

    if(resetButtonPressed) then
        images = {}
    end

    for _, imgData in ipairs(images) do
        imgData.Image:Render(imgData.SourceQuad, imgData.DestQuad, KColor(1.3,1.1,1.1,1))
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_HUD_RENDER, rendertest)