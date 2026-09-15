local SHARD_SUBDIVISIONS = 2
local SHARD_RANDOM_PADDING = 0.25
local SHARD_IMG_SIZE = 128

---@class CrackData
---@field Active boolean
---@field NumCracks integer
---@field CrackQuads {TopLeft: Vector, TopRight: Vector, BottomLeft: Vector, BottomRight: Vector, Center: Vector}[]
---@field CrackImages {Image: Image, Color: KColor}[]
---@field CrackPosVel {PosOffset: Vector, Velocity: Vector, RotationXYZ: number[], RotationXYZVel: number[]}[]
---@field BasePosOffset Vector
local cracks = {}

---@param topLeft Vector
---@param topRight Vector
---@param bottomLeft Vector
---@param bottomRight Vector
---@param divisionLevel number? default: 0
---@param rng RNG
---@return CrackQuads
local function makeCrackQuads(topLeft, topRight, bottomLeft, bottomRight, divisionLevel, rng)
    local centerLeft = ToyboxMod:lerp(topLeft, bottomLeft, rng:RandomFloat()*(1-2*SHARD_RANDOM_PADDING)+SHARD_RANDOM_PADDING)
    local centerRight = ToyboxMod:lerp(topRight, bottomRight, rng:RandomFloat()*(1-2*SHARD_RANDOM_PADDING)+SHARD_RANDOM_PADDING)
    local centerTop = ToyboxMod:lerp(topLeft, topRight, rng:RandomFloat()*(1-2*SHARD_RANDOM_PADDING)+SHARD_RANDOM_PADDING)
    local centerBottom = ToyboxMod:lerp(bottomLeft, bottomRight, rng:RandomFloat()*(1-2*SHARD_RANDOM_PADDING)+SHARD_RANDOM_PADDING)
    local d = (centerLeft.X-centerRight.X)*(centerTop.Y-centerBottom.Y)-(centerLeft.Y-centerRight.Y)*(centerTop.X-centerBottom.X)
    local centerHorizVal = (centerLeft.X*centerRight.Y-centerLeft.Y*centerRight.X)
    local centerVertVal = (centerTop.X*centerBottom.Y-centerTop.Y*centerBottom.X)

    local center = Vector(
        centerHorizVal*(centerTop.X-centerBottom.X)-centerVertVal*(centerLeft.X-centerRight.X),
        centerHorizVal*(centerTop.Y-centerBottom.Y)-centerVertVal*(centerLeft.Y-centerRight.Y)
    )/d

    if((divisionLevel or 0)>=SHARD_SUBDIVISIONS) then
        return {
            {
                TopLeft = topLeft,
                TopRight = topRight,
                BottomLeft = bottomLeft,
                BottomRight = bottomRight,
                Center = center,
            }
        }
    end
    divisionLevel = divisionLevel or 0

    local newLeft = ToyboxMod:lerp(topLeft, bottomLeft, rng:RandomFloat()*(1-2*SHARD_RANDOM_PADDING)+SHARD_RANDOM_PADDING)
    local newRight = ToyboxMod:lerp(topRight, bottomRight, rng:RandomFloat()*(1-2*SHARD_RANDOM_PADDING)+SHARD_RANDOM_PADDING)
    local newTop = ToyboxMod:lerp(topLeft, topRight, rng:RandomFloat()*(1-2*SHARD_RANDOM_PADDING)+SHARD_RANDOM_PADDING)
    local newBottom = ToyboxMod:lerp(bottomLeft, bottomRight, rng:RandomFloat()*(1-2*SHARD_RANDOM_PADDING)+SHARD_RANDOM_PADDING)

    local toReturn = {}

    for _, returnData in ipairs(makeCrackQuads(topLeft, newTop, newLeft, center, (divisionLevel or 0)+1, rng)) do
        table.insert(toReturn, returnData)
    end
    for _, returnData in ipairs(makeCrackQuads(newTop, topRight, center, newRight, (divisionLevel or 0)+1, rng)) do
        table.insert(toReturn, returnData)
    end
    for _, returnData in ipairs(makeCrackQuads(newLeft, center, bottomLeft, newBottom, (divisionLevel or 0)+1, rng)) do
        table.insert(toReturn, returnData)
    end
    for _, returnData in ipairs(makeCrackQuads(center, newRight, newBottom, bottomRight, (divisionLevel or 0)+1, rng)) do
        table.insert(toReturn, returnData)
    end

    return toReturn
end

---@param image Image
---@param bounds {TopLeft: Vector, TopRight: Vector, BottomLeft: Vector, BottomRight: Vector}
---@param rng RNG?
local function shatterImage(image, bounds, baseOffset, rng)
    rng = rng or ToyboxMod:generateRng()

    local quads = makeCrackQuads(bounds.TopLeft, bounds.TopRight, bounds.BottomLeft, bounds.BottomRight, nil, rng)
    if(not quads) then return end
    local crackData = {}
    crackData.CrackQuads = quads
    crackData.CrackImages = {}
    crackData.CrackPosVel = {}
    crackData.NumCracks = #quads
    crackData.BasePosOffset = baseOffset

    local center = (bounds.TopLeft+bounds.TopRight+bounds.BottomLeft+bounds.BottomRight)/4

    for j=1, crackData.NumCracks do
        local quad = crackData.CrackQuads[j]

        local newImg = Renderer.CreateImage(SHARD_IMG_SIZE, SHARD_IMG_SIZE, "QuadImg")
        Renderer.RenderToImage(newImg, function()
            local newSource = SourceQuad(quad.TopLeft, quad.TopRight, quad.BottomLeft, quad.BottomRight, false)
            image:Render(newSource, ToyboxMod:makeQuadFromCorners(Vector(0,0), Vector(1,1)*SHARD_IMG_SIZE, false, false, false), KColor(1,1,1,1))
        end)

        crackData.CrackImages[j] = {
            Image = newImg,
            Color = KColor(1,1,1,1)
        }
        local rotatesX = math.random(0,1)==0
        crackData.CrackPosVel[j] = {
            PosOffset = Vector.Zero,
            Velocity = (quad.Center-center):Resized(1+math.random()*2)-Vector(0,0.5+math.random()*0.5),
            RotationXYZ = {0,0,0},
            RotationXYZVel = {
                rotatesX and ((math.random(0,1)*2-1)*(0.3+math.random()*0.7)*15) or 0,
                rotatesX and 0 or ((math.random(0,1)*2-1)*(0.3+math.random()*0.7)*15),
                (math.random(0,1)*2-1)*(0.3+math.random()*0.7)*12},
        }
    end

    table.insert(cracks, crackData)
end

-- stolen from charlie kirkel
---@param checkSprite Sprite
local function getSpriteBoundingBox(checkSprite)
    local sprites = {checkSprite}

    local topLeft
    local bottomRight
    for _, sprite in ipairs(sprites) do
        ---@type {Data: AnimationData, Frame: integer}[]
        local entries = {}
        local main = sprite:GetCurrentAnimationData()
        if main then
            entries[#entries + 1] = {
                Data = main,
                Frame = sprite:GetFrame()
            }
        end
        local overlay = sprite:GetOverlayAnimationData()
        if overlay then
            entries[#entries + 1] = {
                Data = overlay,
                Frame = sprite:GetOverlayFrame()
            }
        end
        for _, v in ipairs(entries) do
            for _, layer in ipairs(v.Data:GetAllLayers()) do
                if layer:IsVisible() then
                    local frame = layer:GetFrame(v.Frame)
                    if frame and frame:IsVisible() then
                        local flipX = sprite.FlipX
                        local flipY = sprite.FlipY
                        if reflect then
                            sprite.FlipY = not sprite.FlipY
                        end
                        local scale = frame:GetScale() * sprite.Scale
                        if scale.X < 0 then
                            sprite.FlipX = not sprite.FlipX
                            scale.X = -scale.X
                        end
                        if scale.Y < 0 then
                            sprite.FlipY = not sprite.FlipY
                            scale.Y = - scale.Y
                        end
                        local width = frame:GetWidth()
                        local height = frame:GetHeight()
                        local pos = frame:GetPos() * 0.5 * sprite.Scale
                        local pivot = frame:GetPivot() / Vector(width, height)
                        if sprite.FlipX then
                            pos.X = -pos.X
                            pivot.X = -pivot.X
                        end
                        if sprite.FlipY then
                            pos.Y = -pos.Y
                            pivot.Y = -pivot.Y
                        end
                        width = width * scale.X
                        height = height * scale.Y
                        local a = Vector(pos.X - pivot.X * width, pos.Y - pivot.Y * height)
                        if sprite.FlipX then
                            a.X = a.X - width
                        end
                        if sprite.FlipY then
                            a.Y = a.Y - height
                        end
                        local b = a + Vector(width, height)
                        width = width // 1
                        height = height // 1
                        local offset = Vector.Zero
                        local y = pos + b + offset
                        local x = pos + a + offset
                        if topLeft then
                            topLeft.X = math.min(topLeft.X, x.X)
                            topLeft.Y = math.min(topLeft.Y, x.Y)
                        else
                            topLeft = x
                        end
                        if bottomRight then
                            bottomRight.X = math.max(bottomRight.X, y.X)
                            bottomRight.Y = math.max(bottomRight.Y, y.Y)
                        else
                            bottomRight = y
                        end
                        sprite.FlipX = flipX
                        sprite.FlipY = flipY
                    end
                end
            end
        end
    end

    return topLeft, bottomRight
end

---@param ent Entity
local function generateImgFromEnt(ent)
    local boxTL, boxBR = getSpriteBoundingBox(ent:GetSprite())
    if(not boxBR or not boxTL) then return end

    boxTL = boxTL*1.5
    boxBR = boxBR*1.5

    local baseicSize = boxBR-boxTL
    local rendePos = baseicSize-boxBR

    local baseSize = baseicSize--Vector(1,1)*ent.Size*ent.SizeMulti*ent.SpriteScale*Vector(10, 13)
    baseSize = Vector(baseSize.X//1, baseSize.Y//1)
    if(baseSize.X<0.01 or baseSize.Y<0.01) then return end

    local img = Renderer.CreateImage(baseSize.X, baseSize.Y, "Mango1")

    local renderPos = rendePos--baseSize*Vector(0.5,0.8)
    Renderer.RenderToImage(img, function()
        ent:Render(-Isaac.WorldToRenderPosition(ent.Position)+renderPos)
    end)

    local boundsTop = baseSize.Y+1
    local boundsLeft = baseSize.X+1
    local boundsBottom = -1
    local boundsRight = -1

    local texelRegion = img:GetTexelRegion(0, 0, baseSize.X, baseSize.Y)
    for i=0, baseSize.Y-1 do
        for j=0, baseSize.X-1 do
            local colorData = {string.byte(texelRegion, 4*(baseSize.X*i+j)+1, 4*(baseSize.X*i+j)+4)}
            if(colorData[4]~=0) then
                boundsTop = math.min(boundsTop, i)
                boundsLeft = math.min(boundsLeft, j)
                boundsBottom = math.max(boundsBottom, i)
                boundsRight = math.max(boundsRight, j)
            end
        end
    end

    if(boundsBottom==-1 or boundsRight==-1) then return end

    local topLeft = Vector(boundsLeft, boundsTop)
    local newSize = Vector(boundsRight-boundsLeft+1, boundsBottom-boundsTop+1)
    local newImg = Renderer.CreateImage(newSize.X, newSize.Y, "Mango2")
    Renderer.RenderToImage(newImg, function()
        ent:Render(-Isaac.WorldToRenderPosition(ent.Position)+renderPos-topLeft)
    end)

    local newRenderPos = renderPos-topLeft
    local newoff = -newRenderPos+Isaac.WorldToRenderPosition(ent.Position)

    local endQuad = ToyboxMod:makeQuadFromCorners(Vector(0,0), newSize, false, false)
    return newImg, endQuad, newoff
end

local function rendertest()
    for i=1, #cracks do
        local crackData = cracks[i]
        for j=1, (crackData and crackData.NumCracks or 0) do
            local quads = crackData.CrackQuads[j]
            local img = crackData.CrackImages[j]
            local posVel = crackData.CrackPosVel[j]

            if(quads and img and posVel) then
                local newQuad2 = DestinationQuad(quads.TopLeft, quads.TopRight, quads.BottomLeft, quads.BottomRight)

                local rotation = (posVel.RotationXYZ[3]==0 and 0.001 or posVel.RotationXYZ[3])
                newQuad2:Rotate(rotation,quads.Center)

                local scaleX = math.cos(math.rad(posVel.RotationXYZ[1]))
                scaleX = ToyboxMod:sign(scaleX)*(math.abs(scaleX)^0.33)
                scaleX = math.abs(scaleX)

                local scaleY = math.cos(math.rad(posVel.RotationXYZ[2]))
                scaleY = ToyboxMod:sign(scaleY)*(math.abs(scaleY)^0.33)
                scaleY = math.abs(scaleY)

                newQuad2:Scale(Vector(scaleX, scaleY),quads.Center)

                newQuad2:Translate(posVel.PosOffset+crackData.BasePosOffset+ToyboxMod.GAME:GetRoom():GetRenderScrollOffset())

                img.Image:Render(
                    ToyboxMod:makeQuadFromCorners(Vector(0,0),Vector(1,1),true,true),
                    newQuad2,
                    img.Color
                )

                if(not ToyboxMod.GAME:IsPaused()) then
                    posVel.PosOffset = posVel.PosOffset+posVel.Velocity
                    posVel.Velocity = Vector(posVel.Velocity.X*0.995, posVel.Velocity.Y*0.98+0.35)

                    for k=1, 3 do
                        posVel.RotationXYZ[k] = posVel.RotationXYZ[k]+posVel.RotationXYZVel[k]
                    end

                    if(posVel.PosOffset.Y>1000) then
                        crackData.NumCracks = crackData.NumCracks-1
                        table.remove(crackData.CrackQuads, j)
                        table.remove(crackData.CrackImages, j)
                        table.remove(crackData.CrackPosVel, j)
                        j = j-1
                    end
                end
            end

            if((crackData.NumCracks or 0)<=0) then
                table.remove(cracks, i)
                i = i-1
            end
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_RENDER, rendertest)

local wasMousePressed = false

---@param player EntityPlayer
local function postUpdate(_, player)
    if(not (player and player:GetPlayerIndex()==0)) then return end

    local isPressed = Input.IsMouseBtnPressed(MouseButton.LEFT)
    if(isPressed and not wasMousePressed) then
        local nearestEnt
        local nearestDist = 2^30

        local mpos = Input.GetMousePosition(true)
        
        for _, ent in ipairs(Isaac.GetRoomEntities()) do
            --if(not ent:ToTear()) then
                local dist = ent.Position:Distance(mpos)-ent.Size
                if(dist<nearestDist) then
                    nearestEnt = ent
                    nearestDist = dist
                end
            --end
        end

        if(nearestEnt and nearestDist<40*1.5) then
            local img, quads, baseOffset = generateImgFromEnt(nearestEnt)
            if(img) then
                --[[]]
                shatterImage(
                    img,
                    {TopLeft=quads:GetTopLeft(), TopRight=quads:GetTopRight(), BottomLeft=quads:GetBottomLeft(), BottomRight=quads:GetBottomRight()}, 
                    baseOffset,
                    nearestEnt:GetDropRNG()
                )
                --]]
                nearestEnt:AddEntityFlags(EntityFlag.FLAG_REDUCE_GIBS)
                nearestEnt:Die()
                nearestEnt.Visible = false
                nearestEnt:SetColor(Color(0,0,0,0),5000,0,false,false)
                --nearestEnt:Remove()

                ToyboxMod.SFX:Play(ToyboxMod.SFX_ATLASA_GLASSBREAK)
            end
        end
    end
    wasMousePressed = isPressed
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, postUpdate)
