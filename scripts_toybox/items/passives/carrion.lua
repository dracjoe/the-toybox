local NUM_ROTTEN_HEARTS = 1

local EXTRA_HITS = 2
local HIT_DELAY = 25
local DAMAGE_MULT = 0.45

local STACK_HITS = 1

---@param player EntityPlayer
---@param firstTime boolean
local function addRottenHp(_, _, _, firstTime, _, _, player)
    if(not firstTime) then return end

    player:AddRottenHearts(NUM_ROTTEN_HEARTS*2)
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, addRottenHp, ToyboxMod.COLLECTIBLE_CARRION)

---@param ent Entity
---@param amount number
---@param flags DamageFlag
---@param source EntityRef
---@param countdown integer
local function entityTakeDmg(_, ent, amount, flags, source, countdown)
    if(flags & DamageFlag.DAMAGE_CLONES ~= 0) then return end
    if(not PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_CARRION)) then return end

    local npc = ent and ent:ToNPC()
    if(not (npc and npc:IsEnemy() and npc:IsActiveEnemy(false))) then return end

    return {
        Damage = amount * DAMAGE_MULT,
        DamageFlags = flags,
        DamageCountdown = countdown,
    }
end
ToyboxMod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, entityTakeDmg)

---@param npc EntityNPC
---@param rng RNG
---@param idx integer
local function generateRenderedCarrionFly(npc, rng, idx)
    local overlayFrame = npc:GetSprite():GetNullFrame("OverlayEffect")
    local pos
    if(overlayFrame) then
        pos = overlayFrame:GetPos()
    else
        pos = Vector(0,-npc.Size*1.25)*npc.SizeMulti
    end

    local offs = Vector.FromAngle(rng:RandomInt(-90,90)-90)*25
    return {
        CurrentPos = pos,
        DesiredPos = offs+pos,
        Vel = offs:Resized(2),
        Frame = rng:RandomInt(0,3),
        Alpha = 0.1,
        LifeSpan = idx*HIT_DELAY*2,
    }
end

---@param ent Entity
---@param dmg number
---@param flags DamageFlag
---@param ref EntityRef
local function postTakeDamage(_, ent, dmg, flags, ref, _, _)
    if(flags & DamageFlag.DAMAGE_CLONES == DamageFlag.DAMAGE_CLONES) then return end
    if(not PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_CARRION)) then return end

    local npc = ent and ent:ToNPC()
    if(not (npc and npc:IsEnemy() and npc:IsActiveEnemy(false))) then return end

    local data = ToyboxMod:getEntityDataTable(npc)
    data.CARRION_PRE_QUEUE = data.CARRION_PRE_QUEUE or {}

    Isaac.CreateTimer(function()
        if(not (npc and npc:Exists())) then return end

        local data2 = ToyboxMod:getEntityDataTable(npc)
        for i=1, #(data2.CARRION_PRE_QUEUE or {}) do
            if(data2.CARRION_PRE_QUEUE[i].Frame==npc.FrameCount) then
                local numHits = EXTRA_HITS+STACK_HITS*(PlayerManager.GetNumCollectibles(ToyboxMod.COLLECTIBLE_CARRION)-1)

                local eff = Isaac.CreateTimer(
                    function(effect)
                        local effData = ToyboxMod:getEntityData(effect, "CARRION_DATA")
                        if(not effData) then return end
                        if(not (npc and npc:Exists())) then return end

                        npc:TakeDamage(effData.Damage, effData.DamageFlags, effData.EntityRef, 0)

                        if(effData.ModdedFlagData) then
                            local preData = effData.PreModdedFlagData
                            local modData = effData.ModdedFlagData

                            local pl = modData.Player or Isaac.GetPlayer()
                            local placeholdEff = TearFlagsLib.SpawnDummyEntity(pl, preData.WeaponFlag, npc.Position)
                            TearFlagsLib.AddTearFlags(placeholdEff, modData.Flags)

                            TearFlagsLib.ApplyWeaponTearFlags(
                                npc, pl, placeholdEff, preData.WeaponFlag, preData.Hitbox
                            )
                        end

                        if(effData.VanillaFlagData) then
                            local vanData = effData.VanillaFlagData

                            npc:ApplyTearflagEffects(vanData.PositionOffset and (vanData.PositionOffset+npc.Position) or vanData.Position, vanData.Flags, vanData.Source, vanData.Damage)
                        end

                        ToyboxMod.SFX:Play(SoundEffect.SOUND_SPLATTER)
                    end, HIT_DELAY, numHits, false
                )
                ToyboxMod:setEntityData(eff, "CARRION_DATA", ToyboxMod:deepCopy(data2.CARRION_PRE_QUEUE[i]))

                data2.CARRION_FLY_DATA = data2.CARRION_FLY_DATA or {}
                local rng = ToyboxMod:generateRng()
                for hitIdx=1, numHits do
                    table.insert(data2.CARRION_FLY_DATA, generateRenderedCarrionFly(npc, rng, hitIdx))
                end

                table.remove(data2.CARRION_PRE_QUEUE, i)
                i = i-1
            elseif(data.CARRION_PRE_QUEUE[i].Frame>npc.FrameCount) then
                table.remove(data2.CARRION_PRE_QUEUE, i)
                i = i-1
            end
        end
    end, 1, 1, false)
    --]]

    data.CARRION_CHECK_IDX = #data.CARRION_PRE_QUEUE+1
    data.CARRION_PRE_QUEUE[data.CARRION_CHECK_IDX] = {
        Frame = npc.FrameCount+1,
        Damage = dmg,
        DamageFlags = flags | DamageFlag.DAMAGE_CLONES,
        EntityRef = EntityRef(ref.Entity),
        VanillaFlagData = nil,
        PreModdedFlagData = nil,
        ModdedFlagData = nil,
    }
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, postTakeDamage)

---@param npc EntityNPC
---@param pos Vector
---@param flags TearFlags
---@param source Entity
---@param dmg number
local function postApplyVanillaTearflags(_, npc, pos, flags, source, dmg)
    local data = ToyboxMod:getEntityDataTable(npc)
    if(data.CARRION_CHECK_IDX and (data.CARRION_PRE_QUEUE or {})[data.CARRION_CHECK_IDX]) then
        data.CARRION_PRE_QUEUE = data.CARRION_PRE_QUEUE or {}

        data.CARRION_PRE_QUEUE[data.CARRION_CHECK_IDX].VanillaFlagData = {
            Flags = TearFlags.TEAR_NORMAL,
            Position = pos,
            PositionOffset = pos-npc.Position,
            Source = source,
            Damage = dmg or 3.5
        }

        for _, val in pairs(TearFlags) do
            if(flags & val == val) then
                data.CARRION_PRE_QUEUE[data.CARRION_CHECK_IDX].VanillaFlagData.Flags = data.CARRION_PRE_QUEUE[data.CARRION_CHECK_IDX].VanillaFlagData.Flags | val
            end
        end

        data.CARRION_CHECK_IDX = nil
    else
        data.CARRION_CHECK_IDX = nil
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_APPLY_TEARFLAG_EFFECTS, postApplyVanillaTearflags)

local function preApplyModdedTearflags(_, ent, player, source, weaponFlag, hitbox)
    local data = ToyboxMod:getEntityDataTable(ent)
    if(data.CARRION_CHECK_IDX and (data.CARRION_PRE_QUEUE or {})[data.CARRION_CHECK_IDX]) then
        data.CARRION_PRE_QUEUE = data.CARRION_PRE_QUEUE or {}

        data.CARRION_PRE_QUEUE[data.CARRION_CHECK_IDX].PreModdedFlagData = {
            WeaponFlag = weaponFlag,
            Hitbox = hitbox,
        }
    end
end
ToyboxMod:AddCallback(TearFlagsLib.Callback.PRE_APPLY_TEARFLAG_EFFECTS, preApplyModdedTearflags)

local function postApplyModdedTearflags(_, ent, player, source)
    local data = ToyboxMod:getEntityDataTable(ent)
    if(data.CARRION_CHECK_IDX and (data.CARRION_PRE_QUEUE or {})[data.CARRION_CHECK_IDX]) then
        data.CARRION_PRE_QUEUE = data.CARRION_PRE_QUEUE or {}

        data.CARRION_PRE_QUEUE[data.CARRION_CHECK_IDX].ModdedFlagData = {
            Flags = TearFlagsLib.GetTearFlags(source),
            Player = player,
            Source = source,
        }
    end
end
ToyboxMod:AddCallback(TearFlagsLib.Callback.POST_APPLY_TEARFLAG_EFFECTS, postApplyModdedTearflags)

local FLY_SPRITE = Sprite("gfx_tb/effects/effect_carrion_fly.anm2", true)
FLY_SPRITE:Play("Idle", true)

---@param npc EntityNPC
local function renderThingies(_, npc, offset)
    local npcData = ToyboxMod:getEntityDataTable(npc)
    if(#(npcData.CARRION_FLY_DATA or {})<=0) then return end
    --if(numFlies<=0) then return end

    local worldPos = npc.Position
    local rng = ToyboxMod:generateRng()
    
    for _, data in ipairs(npcData.CARRION_FLY_DATA) do
        if(not ToyboxMod.GAME:IsPaused()) then
            local toAdd = rng:RandomVector()*3
            local curLen = (data.DesiredPos-data.CurrentPos):Length()
            local nextLen = (data.DesiredPos-data.CurrentPos+toAdd):Length()
            if(curLen>npc.Size*npc.SizeMulti.X*2 and nextLen>curLen) then
                toAdd = -toAdd
            end

            data.DesiredPos = data.DesiredPos+toAdd

            data.Vel = ToyboxMod:lerp(data.Vel*0.9, (data.DesiredPos-data.CurrentPos):Resized(3), 0.45)
            data.CurrentPos = data.CurrentPos+data.Vel

            if(data.LifeSpan<=5) then
                data.Alpha = ToyboxMod:lerp(data.Alpha, 0, 0.45)
            else
                data.Alpha = ToyboxMod:lerp(data.Alpha, 1, 0.4)
            end
            data.LifeSpan = data.LifeSpan-1
        end

        local renderedPos = Isaac.WorldToRenderPosition(worldPos+data.CurrentPos)+Vector(0,15)+ToyboxMod.GAME:GetRoom():GetRenderScrollOffset()
        FLY_SPRITE:SetFrame(data.Frame//1)
        FLY_SPRITE.Color = Color(1,1,1,data.Alpha)
        FLY_SPRITE:Render(renderedPos)
        if(not ToyboxMod.GAME:IsPaused()) then
            data.Frame = (data.Frame+0.95)%FLY_SPRITE:GetCurrentAnimationData():GetLength()
        end
    end

    for i=1, #npcData.CARRION_FLY_DATA do
        if(npcData.CARRION_FLY_DATA[i] and npcData.CARRION_FLY_DATA[i].LifeSpan<=0) then
            table.remove(npcData.CARRION_FLY_DATA, i)
            i = i-1
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, renderThingies)