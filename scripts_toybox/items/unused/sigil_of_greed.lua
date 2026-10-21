local sfx = SFXManager()

local CHARGE_DURATION = math.floor(60*6.66)
local SIGIL_RANGE = 40*2
local SIGIL_DAMAGE = 66.6
local MIDAS_CHANCE = 0.25
local MIDAS_DURATION = 30*2

local CHARGEBAR_SCALE = 0.9
local CHARGEBAR_ALPHA = 0.4

---@param p EntityPlayer
local function playerUpdate(_, p)
    if(not p:HasCollectible(ToyboxMod.COLLECTIBLE_SIGIL_OF_GREED)) then return end

    local data = ToyboxMod:getEntityDataTable(p)

    if(p:GetFireDirection()~=Direction.NO_DIRECTION or p:GetShootingInput():Length()>0.01) then
        data.SIGIL_OF_GREED_CHARGE = math.min((data.SIGIL_OF_GREED_CHARGE or 0)+1, CHARGE_DURATION)

        local eff = data.SIGIL_OF_GREED_EFFECTENTITY
        if(not (eff and eff:Exists())) then
            eff = Isaac.Spawn(1000, ToyboxMod.EFFECT_GREED_SIGIL_CHARGEBAR, 0, p.Position, Vector.Zero, p):ToEffect()
            eff:FollowParent(p)

            eff:GetSprite():SetAnimation("Idle", true)
            eff:GetSprite():Stop(true)
            eff.SpriteScale = Vector(CHARGEBAR_SCALE,CHARGEBAR_SCALE)
            ToyboxMod:setEntityData(eff, "CHARGEBAR_STATE", 0)
            ToyboxMod:setEntityData(eff, "CHARGEBAR_STATEFRAME", 0)
        elseif(eff and ToyboxMod:getEntityData(eff, "CHARGEBAR_STATE")==-1) then
            ToyboxMod:setEntityData(data.SIGIL_OF_GREED_EFFECTENTITY, "CHARGEBAR_STATE", 0)
            ToyboxMod:setEntityData(data.SIGIL_OF_GREED_EFFECTENTITY, "CHARGEBAR_STATEFRAME", 0)
        end

        local chPerc = (ToyboxMod:getEntityData(p, "SIGIL_OF_GREED_CHARGE") or 0)/CHARGE_DURATION
        local isFinal = (math.abs(chPerc-1)<0.01)
        local anmLength = eff:GetSprite():GetAnimationData("Idle"):GetLength()
        chPerc = math.floor(chPerc*(anmLength-1))

        if(chPerc~=eff:GetSprite():GetFrame()) then
            if(isFinal) then
                p:SetColor(Color(1,1,1,1,1,0.9,0.5),8,1,true,false)
                sfx:Play(SoundEffect.SOUND_BEEP, 1, 0, false, 0.9)
            end
            ToyboxMod:setEntityData(eff, "CHARGEBAR_STATE", (isFinal and 2 or 1))
            ToyboxMod:setEntityData(eff, "CHARGEBAR_STATEFRAME", 0)
        end

        eff:GetSprite():SetFrame("Idle", chPerc)

        data.SIGIL_OF_GREED_EFFECTENTITY = eff
    else
        local isFull = false
        if((data.SIGIL_OF_GREED_CHARGE or 0)>=CHARGE_DURATION) then
            isFull = true
            sfx:Play(SoundEffect.SOUND_CASH_REGISTER, 0.7)
            sfx:Play(SoundEffect.SOUND_GOLD_HEART, 0.3)
            ToyboxMod.GAME:ShakeScreen(5)
            local rng = p:GetCollectibleRNG(ToyboxMod.COLLECTIBLE_SIGIL_OF_GREED)

            local eff = Isaac.Spawn(1000, ToyboxMod.EFFECT_GOLDMANTLE_BREAK,0,p.Position,Vector.Zero,p):ToEffect()
            eff.SpriteScale = Vector(1,1)*0.5
            eff:FollowParent(p)
            
            for _, ent in ipairs(Isaac.FindInRadius(p.Position, SIGIL_RANGE, EntityPartition.ENEMY)) do
                if(ToyboxMod:isValidEnemy(ent)) then
                    local willDie = (ent:IsDead() or ent:HasMortalDamage() or ent.HitPoints<=SIGIL_DAMAGE)
                    local willMidas = (rng:RandomFloat()<MIDAS_CHANCE)

                    if(willDie and willMidas and not ent:HasEntityFlags(EntityFlag.FLAG_MIDAS_FREEZE)) then
                        ent:TakeDamage(ent.HitPoints-1, 0, EntityRef(p), 0)
                        ent:AddMidasFreeze(EntityRef(p),MIDAS_DURATION)
                    else
                        if(willMidas) then ent:AddMidasFreeze(EntityRef(p),MIDAS_DURATION) end
                        ent:TakeDamage(SIGIL_DAMAGE, 0, EntityRef(p), 0)
                    end
                end
            end
        end

        if(data.SIGIL_OF_GREED_EFFECTENTITY) then
            local state = ToyboxMod:getEntityData(data.SIGIL_OF_GREED_EFFECTENTITY, "CHARGEBAR_STATE")
            if(not (state and state<0)) then
                ToyboxMod:setEntityData(data.SIGIL_OF_GREED_EFFECTENTITY, "CHARGEBAR_STATE", (isFull and -2 or -1))
                ToyboxMod:setEntityData(data.SIGIL_OF_GREED_EFFECTENTITY, "CHARGEBAR_STATEFRAME", 0)
            end
        end

        data.SIGIL_OF_GREED_CHARGE = 0
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, playerUpdate, 0)

local function chargebarUpdate(_, e)
    local data = ToyboxMod:getEntityDataTable(e)

    if(data.CHARGEBAR_STATE==1) then
        local SHRINK_DUR = 3
        local SHRINK_SCALE = 0.95
        local GROW_DUR = 8
        local START_WHITE_DUR = 4
        local STOP_WHITE_DUR = 6
        local TINT_INTENSITY = 0.2

        if(data.CHARGEBAR_STATEFRAME<START_WHITE_DUR) then
            local val = data.CHARGEBAR_STATEFRAME/START_WHITE_DUR
            val = val*TINT_INTENSITY
            e.Color = Color(1,1,1,CHARGEBAR_ALPHA,val,val,val)
        elseif(data.CHARGEBAR_STATEFRAME<START_WHITE_DUR+STOP_WHITE_DUR) then
            local val = (START_WHITE_DUR+STOP_WHITE_DUR-data.CHARGEBAR_STATEFRAME)/STOP_WHITE_DUR
            val = val*TINT_INTENSITY
            e.Color = Color(1,1,1,CHARGEBAR_ALPHA,val,val,val)
        else
            e.Color = Color(1,1,1,CHARGEBAR_ALPHA,0,0,0)
        end

        if(data.CHARGEBAR_STATEFRAME<SHRINK_DUR) then
            local val = 1-data.CHARGEBAR_STATEFRAME/SHRINK_DUR
            val = SHRINK_SCALE+(1-SHRINK_SCALE)*val

            e.SpriteScale = Vector(val,val)*CHARGEBAR_SCALE
        elseif(data.CHARGEBAR_STATEFRAME<SHRINK_DUR+GROW_DUR) then
            local val = (SHRINK_DUR+GROW_DUR-data.CHARGEBAR_STATEFRAME)/GROW_DUR
            val = SHRINK_SCALE+(1-SHRINK_SCALE)*(1-val^2)

            e.SpriteScale = Vector(val,val)*CHARGEBAR_SCALE
        else
            data.CHARGEBAR_STATE = 0
            data.CHARGEBAR_STATEFRAME = 0

            e.SpriteScale = Vector(CHARGEBAR_SCALE,CHARGEBAR_SCALE)
        end
    elseif(data.CHARGEBAR_STATE==2) then
        local GROW_DUR = 4
        local GROW_SCALE = 1.3*SIGIL_RANGE/40

        if(data.CHARGEBAR_STATEFRAME<GROW_DUR) then
            local val = data.CHARGEBAR_STATEFRAME/GROW_DUR
            val = 1-(1-val)^2

            e.Color = Color(1,1,1,CHARGEBAR_ALPHA*(0.2+(1-val)*0.8),0,0,0)
            local sc = 1+(GROW_SCALE-1)*val
            e.SpriteScale = Vector(sc,sc)*CHARGEBAR_SCALE
        else
            e.SpriteScale = Vector(GROW_SCALE,GROW_SCALE)*CHARGEBAR_SCALE
        end
    elseif(data.CHARGEBAR_STATE==-1) then
        local DEATH_DUR = 12
        local GROW_SCALE = 1.2

        if(data.CHARGEBAR_STATEFRAME<DEATH_DUR) then
            local val = data.CHARGEBAR_STATEFRAME/DEATH_DUR
            val = 1-(1-val)^2

            e.Color = Color(1,1,1,CHARGEBAR_ALPHA*(1-val),0,0,0)
            local sc = 1+(GROW_SCALE-1)*val
            e.SpriteScale = Vector(sc,sc)*CHARGEBAR_SCALE
        else
            data.CHARGEBAR_STATE = 0
            data.CHARGEBAR_STATEFRAME = 0
            e:Remove()
        end
    elseif(data.CHARGEBAR_STATE==-2) then
        local DEATH_DUR = 5
        local GROW_SCALE = 1.9*SIGIL_RANGE/40
        local START_SCALE = 1.5*SIGIL_RANGE/40
        local START_ALPHA = 0.2

        if(data.CHARGEBAR_STATEFRAME<DEATH_DUR) then
            local val = data.CHARGEBAR_STATEFRAME/DEATH_DUR
            val = 1-(1-val)^2

            e.Color = Color(1,1,1,CHARGEBAR_ALPHA*(1-val)*START_ALPHA,0,0,0)
            local sc = START_SCALE+(GROW_SCALE-START_SCALE)*val
            e.SpriteScale = Vector(sc,sc)*CHARGEBAR_SCALE
        else
            data.CHARGEBAR_STATE = 0
            data.CHARGEBAR_STATEFRAME = 0
            e:Remove()
        end

        --[[] ]
        local FADEOUT_DUR = GROW_DUR+DEATH_DUR

        if(data.CHARGEBAR_STATEFRAME<GROW_DUR) then
            local val = data.CHARGEBAR_STATEFRAME/GROW_DUR
            val = 1-(1-val)^2
            local sc = CHARGEBAR_SCALE+(GROW_SCALE-CHARGEBAR_SCALE)*val
            e.SpriteScale = Vector(sc,sc)
        elseif(data.CHARGEBAR_STATEFRAME<GROW_DUR+DEATH_DUR) then
            local val = (data.CHARGEBAR_STATEFRAME-GROW_DUR)/DEATH_DUR
            local sc = GROW_SCALE+(DEATH_SCALE-GROW_SCALE)*val
            e.SpriteScale = Vector(sc,sc)
        else
            data.CHARGEBAR_STATE = 0
            data.CHARGEBAR_STATEFRAME = 0
            e:Remove()
        end

        if(data.CHARGEBAR_STATEFRAME<FADEOUT_DUR) then
            local val = data.CHARGEBAR_STATEFRAME/FADEOUT_DUR
            val = 1-(1-val)^5
            e.Color = Color(1,1,1,CHARGEBAR_ALPHA*(1-val),0,0,0)
        else
            data.CHARGEBAR_STATE = 0
            data.CHARGEBAR_STATEFRAME = 0
            e:Remove()
        end
        --]]
    end

    data.CHARGEBAR_STATEFRAME = (data.CHARGEBAR_STATEFRAME or 0)+1
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, chargebarUpdate, ToyboxMod.EFFECT_GREED_SIGIL_CHARGEBAR)