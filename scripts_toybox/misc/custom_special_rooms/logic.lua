ToyboxMod.SPECIAL_ROOM_TYPE_TEMPLATE = RoomType.ROOM_TELEPORTER

ToyboxMod.ROOM_TYPE_DATA = {
    GRAVEYARD_ROOM = {
        Id = 100,
        IconAnim = "IconGraveyardRoom",
        MinimapIcon = "ToyboxGraveyardRoom",
        Backdrop = ToyboxMod.BACKDROP_GRAVEYARD,
        DoorGfx = "gfx_tb/grid/graveyard_door.png",
        PedestalGfx = "gfx_tb/pickups/pickup_grave_altar.png",
        Locked = true,
        Pool = ToyboxMod.POOL_GRAVEYARD,
    },
    TEMPLE_ROOM = {
        Id = 101,
        IconAnim = "IconTempleRoom",
        MinimapIcon = "ToyboxTempleRoom",
        Backdrop = ToyboxMod.BACKDROP_TEMPLE,
        DoorGfx = "gfx_tb/grid/temple_door.png",
        PedestalGfx = "gfx_tb/pickups/pickup_caban_altar.png",
        Pool = ToyboxMod.POOL_TEMPLE,
    }
}

local ID_TO_TABLEKEY = {}
for key, val in pairs(ToyboxMod.ROOM_TYPE_DATA) do
    ID_TO_TABLEKEY[val.Id] = key
end

---@param id integer
function ToyboxMod:getSpecialRoomKeyFromId(id)
    return ID_TO_TABLEKEY[id]
end

for _, data in pairs(ToyboxMod.ROOM_TYPE_DATA) do
    ToyboxMod:addCustomRoomIcon(
        data.MinimapIcon,
        function(room)
            if(room.Type==ToyboxMod.SPECIAL_ROOM_TYPE_TEMPLATE) then
                if(room.Descriptor and room.Descriptor.Data and room.Descriptor.Data.Subtype==data.Id) then
                    return true
                end
            end
            return false
        end
    )
end

---@param roomDesc RoomDescriptor
---@param key string
function ToyboxMod:isCustomSpecialRoom(roomDesc, key)
    local dat = roomDesc and roomDesc.Data
    if(not dat) then return false end

    if((dat.Type==ToyboxMod.SPECIAL_ROOM_TYPE_TEMPLATE) and (ID_TO_TABLEKEY[dat.Subtype]==key)) then
        return true
    end
    return false
end

function ToyboxMod:isAnyCustomSpecialRoom(roomDesc)
    local dat = roomDesc and roomDesc.Data
    if(not dat) then return false end

    if(dat.Type==ToyboxMod.SPECIAL_ROOM_TYPE_TEMPLATE and ID_TO_TABLEKEY[dat.Subtype]) then
        return true
    end
end

-- replace pool
local function setRoomPool(_)
    local desc = ToyboxMod.GAME:GetLevel():GetCurrentRoomDesc()
    if(not (desc.Data and desc.Data.Type==ToyboxMod.SPECIAL_ROOM_TYPE_TEMPLATE and ID_TO_TABLEKEY[desc.Data.Subtype])) then return end

    local pool = ToyboxMod.ROOM_TYPE_DATA[ID_TO_TABLEKEY[desc.Data.Subtype]].Pool
    if(pool) then
        ToyboxMod.GAME:GetRoom():SetItemPool(pool)
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_ROOM, CallbackPriority.IMPORTANT, setRoomPool)

local function setPoolWhenItemSpawns(_, t, v)
    if(t==EntityType.ENTITY_PICKUP and v==PickupVariant.PICKUP_COLLECTIBLE) then
        setRoomPool()
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_PRE_ROOM_ENTITY_SPAWN, CallbackPriority.IMPORTANT, setPoolWhenItemSpawns)

-- replace backdrop
local function replaceBackdrop()
    local desc = ToyboxMod.GAME:GetLevel():GetCurrentRoomDesc()
    if(not (desc.Data and desc.Data.Type==ToyboxMod.SPECIAL_ROOM_TYPE_TEMPLATE and ID_TO_TABLEKEY[desc.Data.Subtype])) then return end
    local backdrop = ToyboxMod.ROOM_TYPE_DATA[ID_TO_TABLEKEY[desc.Data.Subtype]].Backdrop
    return backdrop
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_PRE_BACKDROP_CHANGE, CallbackPriority.IMPORTANT, replaceBackdrop)

---@param ent GridEntity
local function makeSpecialRoomDoor(_, ent, _, first)
    local door = ent:ToDoor()
    local room = ToyboxMod.GAME:GetLevel():GetRoomByIdx(door.TargetRoomIndex)
    if(not (room.Data and room.Data.Type==ToyboxMod.SPECIAL_ROOM_TYPE_TEMPLATE and ID_TO_TABLEKEY[room.Data.Subtype])) then return end
    if(string.find(string.lower(door:GetSprite():GetFilename()), "holeinwall")) then return end

    local data = ToyboxMod.ROOM_TYPE_DATA[ID_TO_TABLEKEY[room.Data.Subtype]]

    door:SetVariant(DoorVariant.DOOR_UNLOCKED)
    door:SetRoomTypes(RoomType.ROOM_DEFAULT, RoomType.ROOM_DEFAULT)
    if(data.DoorGfx) then
        local sp = door:GetSprite()
        for i, _ in pairs(sp:GetAllLayers()) do
            sp:ReplaceSpritesheet(i-1, data.DoorGfx, false)
        end
        sp:LoadGraphics()
    end
    if(data.Locked and room.VisitedCount==0) then
        door:SetVariant(DoorVariant.DOOR_LOCKED)
        door:SetLocked(true)
    end
end
ToyboxMod:AddCallback(ToyboxMod.CUSTOM_CALLBACKS.POST_GRID_INIT, makeSpecialRoomDoor, GridEntityType.GRID_DOOR)

local function makeSpecialRoomDoorsLate(_)
    local level = ToyboxMod.GAME:GetLevel()
    local room = ToyboxMod.GAME:GetRoom()
    for slot, _ in pairs(level:GetCurrentRoomDesc():GetNeighboringRooms()) do
        if(room:GetDoor(slot)) then
            local door = room:GetDoor(slot)
            makeSpecialRoomDoor(_, door)
        end
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_LEVEL, CallbackPriority.LATE+1, makeSpecialRoomDoorsLate)

local function replaceCollectiblePedestal(_, pickup)
    local room = ToyboxMod.GAME:GetLevel():GetCurrentRoomDesc()
    if(not (room.Data and room.Data.Type==ToyboxMod.SPECIAL_ROOM_TYPE_TEMPLATE and ID_TO_TABLEKEY[room.Data.Subtype])) then return end

    local data = ToyboxMod.ROOM_TYPE_DATA[ID_TO_TABLEKEY[room.Data.Subtype]]
    if(not data.PedestalGfx) then return end

    local sprite = pickup:GetSprite()
    local layer = sprite:GetLayer("altar") or sprite:GetLayer(0)
    if(not layer) then return end

    local oldImg = sprite:GetSpritesheet(layer:GetLayerID())
    local newImg = Renderer.CreateImage(oldImg:GetWidth(), oldImg:GetHeight(), oldImg:GetName().."2")
    local altarImg = Renderer.LoadImage(data.PedestalGfx)
    Renderer.RenderToImage(newImg,
        function()
            local brCorner = Vector(newImg:GetWidth(), newImg:GetHeight())
            local sQuad1 = ToyboxMod:makeQuadFromCorners(Vector(32,0), brCorner, true, false, false)
            local dQuad1 = ToyboxMod:makeQuadFromCorners(Vector(32,0), brCorner, false, false, false)
            oldImg:Render(sQuad1, dQuad1, KColor(1,1,1,1))

            local sQuad2 = ToyboxMod:makeQuadFromCorners(Vector(0,32), Vector(32,brCorner.Y), true, false, false)
            local dQuad2 = ToyboxMod:makeQuadFromCorners(Vector(0,32), Vector(32,brCorner.Y), false, false, false)
            oldImg:Render(sQuad2, dQuad2, KColor(1,1,1,1))

            local topRight = Vector(0,0)
            local bottomRight = Vector(32,32)

            altarImg:Render(
                ToyboxMod:makeQuadFromCorners(Vector(0,0), Vector(1,1), true, true, false),
                ToyboxMod:makeQuadFromCorners(topRight, bottomRight, false, false, false),
                KColor(1,1,1,1)
            )
        end
    )
    sprite:SetSpritesheet(layer:GetLayerID(), newImg)
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_POST_PICKUP_INIT, CallbackPriority.LATE+1, replaceCollectiblePedestal, PickupVariant.PICKUP_COLLECTIBLE)


-- room icon rendering

local MINIMAP_ICON_SPRITE = Sprite("gfx_tb/ui/ui_minimap_icons.anm2", true)
MINIMAP_ICON_SPRITE:Play("IconGraveyardRoom", true)

local function roomIconRender(_, isBig, idx, pos, size, alpha, tlclamp, brclamp, brclamp2)
    local room = ToyboxMod.GAME:GetLevel():GetRoomByIdx(idx)
    if(not (room.Data and ID_TO_TABLEKEY[room.Data.Subtype])) then return end

    local anim = ToyboxMod.ROOM_TYPE_DATA[ID_TO_TABLEKEY[room.Data.Subtype]].IconAnim

    MINIMAP_ICON_SPRITE:Play(anim, true)
    MINIMAP_ICON_SPRITE.Color = Color(1,1,1,alpha)
    local rpos = pos
    if(isBig) then
        rpos = rpos+size/2-Vector(2,2)+ToyboxMod:getRoomIconPosOffset(room)
    end

    MINIMAP_ICON_SPRITE:Render(rpos, tlclamp, (brclamp2 and brclamp2+Vector(5,6)))
end
--ToyboxMod:AddCallback(ToyboxMod.CUSTOM_CALLBACKS.POST_RENDER_MINIMAP_ROOM, roomIconRender, ToyboxMod.SPECIAL_ROOM_TYPE_TEMPLATE)

local function removeMissingIcons(_)
    local sp = Minimap.GetIconsSprite()
    local layer = sp:GetLayer(0)
    if(layer:GetSpritesheetPath()==layer:GetSpritesheetPath()) then
        --sp:ReplaceSpritesheet(0, "gfx_tb/ui/ui_vanilla_icons_missing.png", true)
    end
end
--ToyboxMod:AddCallback(ModCallbacks.MC_PRE_MINIMAP_RENDER, removeMissingIcons)