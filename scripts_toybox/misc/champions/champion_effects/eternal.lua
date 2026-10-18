local function makeGlowSprite()
    local sp = Sprite("gfx_tb/effects/effect_tear_aura.anm2", true)
    sp:Play("Idle", true)
    sp.Color = Color(1,1,0.9,1,0.1,0.1,0)
    sp:SetCustomShader("shaders_tb/pixelate")

    return sp
end

---@param npc EntityNPC
local function addVisual(_, npc)
    if(npc.FrameCount==0) then
        local light = EntityEffect.CreateLight(npc.Position, 1.0, -1, 6)
        light:FollowParent(npc)

        ToyboxMod:setEntityData(npc, "ETERNAL_GLOW", makeGlowSprite())
    end

    npc.CollisionDamage = npc.CollisionDamage==0 and 4 or npc.CollisionDamage*2
    
    local col = npc.Color
    col:SetOffset(0.2, 0.2, 0.05)
    npc.Color = col
end
ToyboxMod:AddCallback(ToyboxMod.CUSTOM_CALLBACKS.POST_CUSTOM_CHAMPION_INIT, addVisual, ToyboxMod.CUSTOM_CHAMPIONS.ETERNAL.Idx)

local function preNpcRender(_, npc, offset)
    local id = ToyboxMod:getModChampionIdx(npc)
    if(id and id==ToyboxMod.CUSTOM_CHAMPIONS.ETERNAL.Idx) then
        local sp = ToyboxMod:getEntityData(npc, "ETERNAL_GLOW")
        if(not sp) then
            sp = makeGlowSprite()
            ToyboxMod:setEntityData(npc, "ETERNAL_GLOW", sp)
        end

        sp.Scale = Vector(1,1)*npc.Size/16*1/4*npc.SpriteScale
        local scol = sp.Color
        scol:SetColorize(1/4/sp.Scale.X, 0, 0, 0)
        sp.Color = scol

        local overlayOffset = npc.SpriteOffset+Vector(0,-6)*npc.SpriteScale
        local frame = npc:GetSprite():GetNullFrame("OverlayEffect") or npc:GetSprite():GetOverlayNullFrame("OverlayEffect")
        if(frame) then
            overlayOffset = overlayOffset+frame:GetPos()+Vector(0,8)
        else
            overlayOffset = overlayOffset+Vector(0,-npc.Size*1.25)*npc.SizeMulti+Vector(0,8)
        end

        local rpos = Isaac.WorldToRenderPosition(npc.Position)+offset+overlayOffset
        sp:Render(rpos)
        sp:Render(rpos)
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_PRE_NPC_RENDER, CallbackPriority.LATE+1, preNpcRender)

local function hitPlayer(_, ent, _, _, source)
    local pl = (ent and ent:ToPlayer())
    local npc = (source.Entity and source.Entity:ToNPC())
    if(pl and npc and ToyboxMod:getModChampionIdx(npc)==ToyboxMod.CUSTOM_CHAMPIONS.ETERNAL.Idx) then
        if(not (pl:IsDead() or pl:HasInstantDeathCurse())) then
            pl:AddVelocity((pl.Position-npc.Position):Resized(20))
            npc:AddVelocity((npc.Position-pl.Position):Resized(15))

            pl:TryFakeDeath()
            pl:AddNullItemEffect(NullItemID.ID_LOST_CURSE, true)

            local eff = Isaac.Spawn(1000, 16, 11, pl.Position, pl.Velocity, pl):ToEffect()
            eff:FollowParent(pl)

            ToyboxMod.SFX:Play(SoundEffect.SOUND_HOLY_MANTLE)
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, hitPlayer, EntityType.ENTITY_PLAYER)