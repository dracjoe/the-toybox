local TINT_AURA_SIZE = 1
local TINT_GRADIENT_DURATION = 60

function ToyboxMod:getTintedRoomCompositeColor(tintBuffer, tintData, centerIntensity)
    if(centerIntensity==nil) then centerIntensity = true end

    local finalColor = Color(0,0,0,TINT_ALPHA)
    for i, flag in ipairs(tintBuffer) do
        local tempColor = ToyboxMod.TINTED_ROOM_COLOR_BITWISE[flag]

        local int = (tintData.Centers & flag ~= 0 and centerIntensity) and TINT_CENTER_INTENSITY or TINT_INTENSITY
        local col = Color(tempColor.Red*int, tempColor.Green*int, tempColor.Blue*int, tempColor.Alpha*TINT_ALPHA)

        finalColor = Color(
            (col.R*col.A+finalColor.R*finalColor.A*(1-col.A))/(col.A+finalColor.A*(1-col.A)),
            (col.G*col.A+finalColor.G*finalColor.A*(1-col.A))/(col.A+finalColor.A*(1-col.A)),
            (col.B*col.A+finalColor.B*finalColor.A*(1-col.A))/(col.A+finalColor.A*(1-col.A)),
            TINT_ALPHA
        )
    end
    return finalColor
end

---@param idx integer? Default: current room
---@return integer tints, integer centers
function ToyboxMod:getTintedRoomTint(idx)
    idx = tostring(idx or ToyboxMod.GAME:GetLevel():GetCurrentRoomDesc().SafeGridIndex)
    local data = (ToyboxMod:getExtraData("TINTED_ROOM_POSITIONS") or {})[idx] or {Tints=0, Centers=0}

    --print(data.Tints, data.Centers)

    return (data.Tints or 0), (data.Centers or 0)
end

---@param idx integer? Default: current room
function ToyboxMod:isTintedRoom(idx)
    local tintData = ToyboxMod:getTintedRoomTint(idx)

    return (tintData~=0)
end

---@param tint string
function ToyboxMod:hasTintedRoomTint(tint, bits)
    return ((bits or ToyboxMod:getTintedRoomTint()) & ToyboxMod.TINTED_ROOM[tint] ~= 0)
end

local function evaluateTintedRoomEffects()
    for _, pl in ipairs(PlayerManager.GetPlayers()) do
        pl:AddCacheFlags(CacheFlag.CACHE_ALL)
        pl:AddCustomCacheTag({"room-clear-retriggers"}, true)
        ToyboxMod:setEntityData(pl, "IN_TINTED_ROOM", ToyboxMod:isTintedRoom())
    end
    Isaac.RunCallback(ToyboxMod.CUSTOM_CALLBACKS.POST_NEW_ROOM_TINTED)

    --print(ToyboxMod:getTintedRoomTint())

    if(ToyboxMod:isTintedRoom()) then
        local tint = ToyboxMod:getTintedRoomTint()
        local tintBuffer = {}
        for flag, _ in pairs(ToyboxMod.TINTED_ROOM_COLOR_BITWISE) do
            if(tint & flag ~= 0) then
                table.insert(tintBuffer, flag)
            end
        end

        ToyboxMod:setExtraData("TINTED_ROOM_GRADIENT", tintBuffer)
    else
        ToyboxMod:setExtraData("TINTED_ROOM_GRADIENT", nil)
    end
end

---@param idx integer
---@param tint integer
---@param center boolean
local function markRoomAsTinted(idx, tint, center)
    idx = tostring(idx)

    local data = ToyboxMod:getExtraDataTable()
    data.TINTED_ROOM_POSITIONS = data.TINTED_ROOM_POSITIONS or {}
    data.TINTED_ROOM_POSITIONS[idx] = data.TINTED_ROOM_POSITIONS[idx] or {Tints=0, Centers=0}
    data.TINTED_ROOM_POSITIONS[idx].Tints = data.TINTED_ROOM_POSITIONS[idx].Tints | tint
    if(center) then
        data.TINTED_ROOM_POSITIONS[idx].Centers = data.TINTED_ROOM_POSITIONS[idx].Centers | tint
    end
end

---@param roomPos Vector
---@param tintedType integer
---@param radius integer?
function ToyboxMod:makeTintedRoom(roomPos, tintedType, radius)
    if(type(roomPos)~="number") then
        roomPos = ToyboxMod:positionVectorToGridIndex(roomPos)
    end
    radius = radius or TINT_AURA_SIZE

    local level = ToyboxMod.GAME:GetLevel()

    local alreadyAddedToTintedAura = {}
    local idx = 1
    local roomQueue = {}
    table.insert(roomQueue, {roomPos, radius})

    local affectsCurrentRoom = false
    local curIdx = level:GetCurrentRoomIndex()

    while(roomQueue[idx]) do
        local curPos = roomQueue[idx][1]
        local curRad = roomQueue[idx][2]

        if(curPos==curIdx) then
            affectsCurrentRoom = true
        end

        local room = level:GetRoomByIdx(curPos)
        if(room.Data and room.GridIndex>=0) then
            if(not alreadyAddedToTintedAura[room.SafeGridIndex]) then
                alreadyAddedToTintedAura[room.SafeGridIndex] = true

                markRoomAsTinted(room.SafeGridIndex, tintedType, curRad==radius)
            end

            if(curRad>1) then
                local topLeftPos = ToyboxMod:gridIndexToPositionVector(room.GridIndex)
                local roomSize = ToyboxMod.ROOM_DIMENSIONS[room.Data.Shape]
                if(room.Data.Subtype==BossType.DELIRIUM) then roomSize = ToyboxMod.ROOM_DIMENSIONS[RoomShape.ROOMSHAPE_1x1] end

                for rx=topLeftPos.X, topLeftPos.X+roomSize.X-1 do
                    for ry=topLeftPos.Y, topLeftPos.Y+roomSize.Y-1 do
                        if(level:GetRoomByIdx(ToyboxMod:positionVectorToGridIndex(Vector(rx,ry))).SafeGridIndex==room.SafeGridIndex) then
                            for ax=-1, 1 do
                                for ay=-1, 1 do
                                    local newidx = level:GetRoomByIdx(ToyboxMod:positionVectorToGridIndex(Vector(rx+ax,ry+ay))).SafeGridIndex
                                    if(newidx~=-1 and not alreadyAddedToTintedAura[newidx]) then
                                        table.insert(roomQueue, {newidx, curRad-1})
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        idx = idx+1
    end

    evaluateTintedRoomEffects()
end

local function resetTintedRoomsOnLevelGen(_)
    ToyboxMod:setExtraData("TINTED_ROOM_POSITIONS", {})
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_LEVEL_LAYOUT_GENERATED, resetTintedRoomsOnLevelGen)

local function evaluateTintedRoom(_)
    evaluateTintedRoomEffects()
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PLAYER_NEW_ROOM_TEMP_EFFECTS, evaluateTintedRoom)

local function workTintedRoomGradient(_)
    local buffer = ToyboxMod:getExtraData("TINTED_ROOM_GRADIENT")
    if(not (buffer and #buffer>0)) then return end

    local frames = ToyboxMod.GAME:GetRoom():GetFrameCount()
    if(frames%TINT_GRADIENT_DURATION==3) then
        local idx = (frames//TINT_GRADIENT_DURATION)%(#buffer)+1

        local col = ToyboxMod.TINTED_ROOM_COLOR_BITWISE[buffer[idx]]
        local modif = ColorModifier(col.Red, col.Green, col.Blue, col.Alpha*0.4, 0, 1.05)
        if(buffer[idx]==ToyboxMod.TINTED_ROOM.BLACK or buffer[idx]==ToyboxMod.TINTED_ROOM.WHITE) then
            modif.R = modif.R+0.5
            modif.G = modif.G+0.5
            modif.B = modif.B+0.5
        end

        ToyboxMod.GAME:SetColorModifier(modif, true, 0.02)
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_UPDATE, workTintedRoomGradient)


---@param player EntityPlayer
local function test(_, _, rng, player, flags)
    local numblablabla = 0
    for _, _ in pairs(ToyboxMod.TINTED_ROOM) do numblablabla = numblablabla+1 end

    local sel = ToyboxMod.TINTED_ROOM_PICKER:PickOutcome(rng)
    ToyboxMod:makeTintedRoom(ToyboxMod.GAME:GetLevel():GetCurrentRoomDesc().SafeGridIndex, sel, 2)
end
--ToyboxMod:AddCallback(ModCallbacks.MC_USE_ITEM, test)