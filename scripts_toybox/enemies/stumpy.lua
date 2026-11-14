--TODO: Make spat grids not respawn on room reentry

local sfx = SFXManager()

local FLY_PICKER = WeightedOutcomePicker()
    FLY_PICKER:AddOutcomeWeight(EntityType.ENTITY_FLY, 1)
    FLY_PICKER:AddOutcomeWeight(EntityType.ENTITY_ATTACKFLY, 1)
    FLY_PICKER:AddOutcomeWeight(EntityType.ENTITY_MOTER, 1)

local POP_OUT_PLAYER_SAFEDIST = 80

local GROUND_HIDE_DURATION = 30
local IDLE_WAIT_DURATION = 60
local ATTACK_TELEGRAPH_DURATION = 50

local VALID_ROCKS = {
    [GridEntityType.GRID_ROCK] = true,
    [GridEntityType.GRID_ROCKT] = true,
    [GridEntityType.GRID_ROCK_BOMB] = true,
    --[GridEntityType.GRID_ROCK_ALT] = true,
    --[GridEntityType.GRID_TNT] = true,
    [GridEntityType.GRID_ROCK_SS] = true,
    [GridEntityType.GRID_ROCK_SPIKED] = true,
    --[GridEntityType.GRID_ROCK_ALT2] = true,
    [GridEntityType.GRID_ROCK_GOLD] = true,
    [GridEntityType.GRID_POOP] = true,
}

---@param npc EntityNPC
local function stumpyInit(_, npc)
    if(not (npc.Variant==ToyboxMod.NPC_STUMPY)) then return end

    npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
    npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE

    npc:GetSprite():Play("DigIn", true)
    npc.State = NpcState.STATE_IDLE
    npc.StateFrame = IDLE_WAIT_DURATION
    npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, stumpyInit, ToyboxMod.NPC_ENEMY)

---@param npc EntityNPC
local function stumpyUpdte(_, npc)
    if(not (npc.Variant==ToyboxMod.NPC_STUMPY)) then return end
    local sp = npc:GetSprite()
    local data = ToyboxMod:getEntityDataTable(npc)

    npc.Velocity = Vector.Zero
    npc:UpdateDirtColor(true)

    if(npc.State==NpcState.STATE_IDLE) then
        if(npc.StateFrame==1) then
            local room = ToyboxMod.GAME:GetRoom()
            local failsafe = 40000
            local nearFirePlace = false
            repeat
                failsafe = failsafe-1
                npc.Position = room:GetRandomPosition(40)
                
                for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_FIREPLACE)) do
                    if(ent.Position:DistanceSquared(npc.Position)<5) then
                        nearFirePlace = true
                        break
                    end
                end
            until(failsafe<=0 or (
                room:GetGridCollisionAtPos(npc.Position)==GridCollisionClass.COLLISION_NONE and
                #Isaac.FindInRadius(npc.Position, POP_OUT_PLAYER_SAFEDIST, EntityPartition.PLAYER)==0 and
                not nearFirePlace
            ))

            npc.Position = room:GetGridPosition(room:GetGridIndex(npc.Position))

            sp:Play("PopOut", true)
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        end

        if(npc.StateFrame==IDLE_WAIT_DURATION) then
            sp:Play("DigIn", true)
        end

        if(sp:IsFinished("PopOut")) then
            sp:Play("Idle", true)
        end
        if(sp:IsFinished("DigIn")) then
            npc.State = NpcState.STATE_SPECIAL
            npc.StateFrame = 0

            npc.I1 = 1
        end
    elseif(npc.State==NpcState.STATE_ATTACK) then
        if(npc.StateFrame==1) then
            local rocksToPickFrom = {}
            local room = ToyboxMod.GAME:GetRoom()
            for i=0, room:GetGridSize()-1 do
                local gridEnt = room:GetGridEntity(i)
                if(gridEnt and VALID_ROCKS[gridEnt:GetType()]) then
                    if((gridEnt:ToRock()==nil and gridEnt:ToPoop()==nil) or (gridEnt:ToPoop() and gridEnt.State~=1000) or (gridEnt:ToRock() and gridEnt.State~=2)) then
                        table.insert(rocksToPickFrom, i)
                    end
                end
            end

            local numRocks = #rocksToPickFrom
            if(numRocks<=0) then
                npc.I1 = 0
                npc.StateFrame = 0
                npc.State = NpcState.STATE_IDLE
            else
                local rng = npc:GetDropRNG()
                local chosenIdx = rocksToPickFrom[rng:RandomInt(numRocks)+1]
                local chosenGrid = room:GetGridEntity(chosenIdx)
                local pos = room:GetGridPosition(chosenIdx)

                npc.Position = pos

                sp:Play("PopOutRock", true)
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL

                if(chosenGrid:ToRock()) then
                    chosenGrid = chosenGrid:ToRock()
                    if(chosenGrid.Anim=="big") then
                        chosenGrid.Anim = "normal"
                        chosenGrid:UpdateAnimFrame()
                    end
                end

                local oldSprite = chosenGrid:GetSprite()
                local newSprite = Sprite()
                newSprite:Load(oldSprite:GetFilename(), false)
                for i, layerState in pairs(oldSprite:GetAllLayers()) do
                    newSprite:ReplaceSpritesheet(layerState:GetLayerID(), layerState:GetSpritesheetPath(), true)
                end
                newSprite:LoadGraphics()

                newSprite:SetFrame(oldSprite:GetAnimation(), oldSprite:GetFrame())
                newSprite.Color = oldSprite.Color

                data.STUMPY_ROCKSPRITE = newSprite
                data.STUMPY_ROCKDESC = chosenGrid.Desc

                if(chosenGrid:ToRock()) then
                    chosenGrid.State = 2
                    chosenGrid:ToRock():UpdateNeighbors()
                end
                room:RemoveGridEntityImmediate(chosenIdx, 0, false)
                --room:SpawnGridEntity(chosenIdx, GridEntityType.GRID_DECORATION, 0, 0, 0)
                
                chosenGrid = room:GetGridEntity(chosenIdx)
                if(chosenGrid) then
                    chosenGrid:GetSprite():ReplaceSpritesheet(0, "gfx_tb/empty.png", true)
                end
            end
        end

        if(sp:IsEventTriggered("Shoot") and (npc.Target and npc.Target:Exists())) then
            local dir = (npc.Target.Position-npc.Position)
            local proj = npc:FireGridEntity(data.STUMPY_ROCKSPRITE, data.STUMPY_ROCKDESC, dir:Resized(7), BackdropType.BACKDROP_NULL)

            local heightScale = 1.8
            proj.FallingAccel = 1.2*heightScale-0.1
            proj.FallingSpeed = -17.5*heightScale
            proj.Height = proj.Height-20
            ToyboxMod:setEntityData(proj, "STUMPY_ROCKPROJ", data.STUMPY_ROCKDESC.Type)

            data.STUMPY_ROCKDESC = nil
            data.STUMPY_ROCKSPRITE = nil

            sfx:Play(SoundEffect.SOUND_STONESHOOT)
        end

        if(npc.StateFrame==ATTACK_TELEGRAPH_DURATION) then
            sp:Play("Attack", true)

            npc.Target = npc:GetPlayerTarget()
        end

        if(sp:IsFinished("PopOutRock")) then
            sp:Play("IdleRock", true)
        end
        if(sp:IsFinished("Attack") and npc.I1~=0) then
            npc.State = NpcState.STATE_SPECIAL
            npc.StateFrame = 0

            npc.I1 = 1
        end
    elseif(npc.State==NpcState.STATE_SPECIAL) then
        if(npc.StateFrame==1) then
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            npc.I2 = math.random(0,5)
        end

        if(npc.StateFrame==GROUND_HIDE_DURATION+npc.I2) then
            npc.StateFrame = 0
            if(npc.I1==0) then
                npc.State = NpcState.STATE_IDLE
            else
                npc.State = NpcState.STATE_ATTACK
            end
        end
    end

    npc.StateFrame = npc.StateFrame+1
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, stumpyUpdte, ToyboxMod.NPC_ENEMY)

---@param npc EntityNPC
local function renderRockOnStumpy(_, npc, offset)
    if(not (npc.Variant==ToyboxMod.NPC_STUMPY)) then return end
    local sp = npc:GetSprite()
    local data = ToyboxMod:getEntityDataTable(npc)

    if(not data.STUMPY_ROCKSPRITE) then return end
    local renderPos = Isaac.WorldToRenderPosition(npc.Position)+offset+sp:GetNullFrame("rockpos"):GetPos()*1.2
    data.STUMPY_ROCKSPRITE:Render(renderPos)
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_PRE_NPC_RENDER, math.huge, renderRockOnStumpy, ToyboxMod.NPC_ENEMY)

---@param npc Entity
local function spawnRockOnDeath(_, npc)
    if(not (npc.Variant==ToyboxMod.NPC_STUMPY)) then return end
    npc = npc:ToNPC()

    local sp = npc:GetSprite()
    local data = ToyboxMod:getEntityDataTable(npc)

    if(data.STUMPY_ROCKSPRITE) then
        local proj = npc:FireGridEntity(data.STUMPY_ROCKSPRITE, data.STUMPY_ROCKDESC, Vector.Zero, ToyboxMod.GAME:GetRoom():GetBackdropType())

        local heightScale = 1.8
        proj.FallingAccel = 0.75
        proj.FallingSpeed = -5
        proj.Height = proj.Height-sp:GetNullFrame("rockpos"):GetPos().Y
        ToyboxMod:setEntityData(proj, "STUMPY_ROCKPROJ", data.STUMPY_ROCKDESC.Type)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, spawnRockOnDeath, ToyboxMod.NPC_ENEMY)

---@param proj EntityProjectile
local function rockProjectileDeath(_, proj)
    local rockprojtype = ToyboxMod:getEntityData(proj, "STUMPY_ROCKPROJ")
    if(not rockprojtype) then return end

    if(rockprojtype==GridEntityType.GRID_POOP) then
        local type = FLY_PICKER:PickOutcome(proj:GetDropRNG())
        local fly = Isaac.Spawn(type,0,0,proj.Position,Vector.Zero,nil)
        --fly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
    else
        local spawnData = {
            SpawnType = "CIRCLELINE",
            SpawnData = {EntityType.ENTITY_EFFECT,EffectVariant.ROCK_EXPLOSION,0},
            SpawnerEntity = proj.SpawnerEntity,
            Position = proj.Position,
            Amount = 2,
            Damage = 1,
            PlayerFriendly = false,
            Distance = Vector(40,40),
            Radius = Vector(20,20),
            RadiusCount = 9,
            Delay = 4,
            AngleVariation = 30,
            DamageCooldown = 10,
            DestroyGrid = 1,
        }
        ToyboxMod:spawnCustomObjects(spawnData)
    end

    proj:Remove()
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_DEATH, rockProjectileDeath)