local GRID_SIZE = 40

local QUAKE_TIMER = 6
local QUAKE_LAYERS = 2

---@param entity Entity
---@param player EntityPlayer
local function postAddTearFlag(_, entity, player, _, weaponFlag)
    if(entity and entity:ToBomb()) then
        local sp = entity:GetSprite()

        local name = sp:GetFilename()
        name = string.gsub(name, "gfx/items/pick ups/bombs/", "")
        name = string.gsub(name, ".anm2", "")
        if(string.lower(string.sub(name,1,-2))=="bomb") then
            sp:ReplaceSpritesheet(0, "gfx_tb/bombs/quake_bomb.png", true)
        elseif(name=="gfx/004.000_Bomb") then
            sp:Load("gfx_tb/bombs/quake2.anm2", true)
            Isaac.CreateTimer(function()
                sp:Load("gfx_tb/bombs/quake2.anm2", true)
            end, 0, 1, false)
        end
    end
end
ToyboxMod:AddCallback(TearFlagsLib.Callback.POST_ADD_TEARFLAG, postAddTearFlag, ToyboxMod.TEARFLAGS.BOMB_QUAKE)

local destrucibleGrids = {
    [GridEntityType.GRID_ROCK] = true,
    [GridEntityType.GRID_ROCKT] = true,
    [GridEntityType.GRID_ROCK_BOMB] = true,
    [GridEntityType.GRID_ROCK_ALT] = true,
    [GridEntityType.GRID_TNT] = true,
    [GridEntityType.GRID_ROCK_SS] = true,
    [GridEntityType.GRID_ROCK_SPIKED] = true,
    [GridEntityType.GRID_ROCK_ALT2] = true,
    [GridEntityType.GRID_ROCK_GOLD] = true,
    [GridEntityType.GRID_POOP] = true,
}
local function isDestructibleGrid(index)
    local room = ToyboxMod.GAME:GetRoom()

    local grid = room:GetGridEntity(index)
    if(not grid) then return false end
    if(grid and grid:ToRock() and grid.State==2) then return false end
    return (destrucibleGrids[grid:GetType()]==true)
end
local function squareIntersectCircle(pos, radius, posSq)
    local rotAngle = Vector(1,1)*GRID_SIZE/2

    for i=0, 3 do
        rotAngle = rotAngle:Rotated(90)
        if(pos:DistanceSquared(posSq+rotAngle)<=radius*radius) then
            return true
        end
    end
    return false
end

local function destroyQuakedGrids(timer)
    local quakeLayers = ToyboxMod:getEntityData(timer, "QUAKE_TIMER_LAYERS")
    if(not quakeLayers) then return end

    local room = ToyboxMod.GAME:GetRoom()
    local currentLayer = (timer.FrameCount//QUAKE_TIMER)
	--print(currentLayer)
    if(currentLayer<=0) then return end

    quakeLayers[currentLayer] = {}
    if(#quakeLayers[currentLayer-1]==0) then return end

    for _, quakedIndex in ipairs(quakeLayers[currentLayer-1]) do
        local quakedPosition = room:GetGridPosition(quakedIndex)
        for dir=0,3 do
            local indexToQuake = room:GetGridIndex(quakedPosition+Vector.FromAngle(dir*90)*GRID_SIZE)
            if(not quakeLayers.INVALID[indexToQuake] and isDestructibleGrid(indexToQuake)) then
                local grid = room:GetGridEntity(indexToQuake)
                if(grid:Destroy()) then
                    if(grid:ToRock()) then
                        GridEntityRock.SpawnDrops(grid.Position, grid:GetType(), grid:GetVariant(), math.max(Random(), 1), true, room:GetBackdropType())
                        grid:ToRock():RegisterRockDestroyed(grid:GetType())
                    end
                    table.insert(quakeLayers[currentLayer], indexToQuake)
                end
            end
            quakeLayers.INVALID[indexToQuake] = 1
        end
    end
    ToyboxMod:setEntityData(timer, "QUAKE_TIMER_LAYERS", quakeLayers)
end

local function updateStoredGrids()
    local grids = {}

    local room = ToyboxMod.GAME:GetRoom()
    local maxIdx = room:GetGridWidth()*room:GetGridHeight()-1

    for i=0, maxIdx do
        local gridEnt = room:GetGridEntity(i)
        grids[i] = GridEntityType.GRID_NULL
        if(gridEnt) then
            if(gridEnt:ToRock() and gridEnt.State==2) then
                grids[i] = GridEntityType.GRID_NULL
            else
                grids[i] = gridEnt:GetType()
            end
        end
    end
    ToyboxMod:setExtraData("QUAKEBOMBS_GRIDS", grids)
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_UPDATE, updateStoredGrids)

---@param effect EntityEffect
---@param player EntityPlayer
---@param ent Entity
local function quakeBombUpdate(_, effect, player, ent)
    if(not (ent and ent:ToBomb())) then return end
    
    ToyboxMod.GAME:ShakeScreen(10)

    local quakeLayers = {[0]={}, ["INVALID"]={}}
    local bombRadius = ToyboxMod:getBombRadius(ent:ToBomb())

    local room = ToyboxMod.GAME:GetRoom()
    local gridsRadius = math.ceil(bombRadius/40)
    local gridAlignedPos = room:GetGridPosition(room:GetGridIndex(effect.Position))
    local previousGrids = ToyboxMod:getExtraData("QUAKEBOMBS_GRIDS") or {}

    for x=-gridsRadius, gridsRadius do
        for y=-gridsRadius, gridsRadius do
            local quakePos = gridAlignedPos+Vector(x,y)*40
            local quakeIndex = room:GetGridIndex(quakePos)
            if(not quakeLayers.INVALID[quakeIndex] and squareIntersectCircle(gridAlignedPos, bombRadius, quakePos)) then
                if(destrucibleGrids[previousGrids[quakeIndex] or 0]) then
                    local grid = room:GetGridEntity(quakeIndex)
                    grid:Destroy()
                    if(grid:ToRock()) then
                        GridEntityRock.SpawnDrops(grid.Position, grid:GetType(), grid:GetVariant(), math.max(Random(), 1), true, room:GetBackdropType())
                        grid:ToRock():RegisterRockDestroyed(grid:GetType())
                    end
                    table.insert(quakeLayers[0], quakeIndex)
                    quakeLayers.INVALID[quakeIndex] = true
                end
            end
        end
    end

    local timer = Isaac.CreateTimer(destroyQuakedGrids, QUAKE_TIMER, QUAKE_LAYERS, false)
    ToyboxMod:setEntityData(timer, "QUAKE_TIMER_LAYERS", quakeLayers)
end
ToyboxMod:AddCallback(TearFlagsLib.Callback.APPLY_EXPLOSION_TEARFLAG_EFFECT, quakeBombUpdate, ToyboxMod.TEARFLAGS.BOMB_QUAKE)