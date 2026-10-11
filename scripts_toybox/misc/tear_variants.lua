local VARIANTS = {}

---@param var TearVariant
---@param init function?
---@param update function?
---@param splat function?
---@param cancelScale boolean?
---@param cancelSplat boolean?
---@param splatSFX SoundEffect|boolean?
function ToyboxMod:registerTearVariant(var, init, update, splat, cancelScale, cancelSplat, splatSFX)
    VARIANTS[var] = {
        InitFunc = init,
        UpdateFunc = update,
        SplatFunc = splat,
        CancelAutoScale = cancelScale,
        CancelBaseSplat = cancelSplat,
        SplatSFX = (splatSFX==nil and SoundEffect.SOUND_SPLATTER or splatSFX),
    }
end


---@param tear EntityTear
local function tearInit(_, tear)
    local tearData = VARIANTS[tear.Variant]
    if(tearData) then
        if(not tearData.CancelAutoScale) then
            ToyboxMod:playTearScaleAnim(tear, true)
        end
        if(tearData.InitFunc) then
            tearData.InitFunc(tear)
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, tearInit)

---@param tear EntityTear
local function tearUpdate(_, tear)
    local tearData = VARIANTS[tear.Variant]
    if(tearData) then
        if(not tearData.CancelAutoScale) then
            ToyboxMod:playTearScaleAnim(tear, true)
        end
        if(tearData.UpdateFunc) then
            tearData.UpdateFunc(tear)
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, tearUpdate)

---@param tear EntityTear
local function tearDeath(_, tear)
    local tearData = VARIANTS[tear.Variant]
    if(not tearData) then return end

    if(tearData.SplatSFX and type(tearData.SplatSFX)=="number") then
        ToyboxMod.SFX:Play(tearData.SplatSFX or SoundEffect.SOUND_SPLATTER, 1, 0, false, 1.0)
    end

	if(tear.TearFlags & TearFlags.TEAR_EXPLOSIVE == TearFlags.TEAR_EXPLOSIVE) then return end

    local splat = nil
    if(not tearData.CancelBaseSplat) then
        splat = Isaac.Spawn(1000, ToyboxMod:getTearPoofVariantFromTear(tear), 0, tear.Position, Vector.Zero, tear):ToEffect()
        splat:GetSprite().Color = Color.Lerp(tear:GetSprite().Color, Color.Default, 0)
        if(tear.Scale > 0.8) then
            splat.SpriteScale = Vector(1, 1)*(tear.Scale*0.8)
        end
        splat.PositionOffset = tear.PositionOffset
    end

    if(tearData.SplatFunc) then
        tearData.SplatFunc(tear, splat)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_TEAR_DEATH, tearDeath)