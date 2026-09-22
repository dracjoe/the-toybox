---@type table<TrinketType, {Func:function,Sprite:Sprite}>
local TRINKET_FUNCS = {}
local TRINKETS_TO_HIDE = {}

---@param trinket TrinketType
---@param func fun(player: EntityPlayer): Vector?
function ToyboxMod:setCropOffsetLogic(trinket, func)
    if(not TRINKET_FUNCS[trinket]) then
        table.insert(TRINKETS_TO_HIDE, trinket)

        local sprite = Sprite("gfx_tb/ui/ui_item_render.anm2", true)
        sprite:Play("Idle", true)

        local conf = Isaac.GetItemConfig():GetTrinket(trinket)
        if(conf) then
            sprite:ReplaceSpritesheet(0, conf.GfxFileName, true)
        end

        TRINKET_FUNCS[trinket] = {
            Func = func,
            Sprite = sprite
        }
    end
end



local function trinketRenderCropOffset(_, slot, _, _, player)
    local trinket = player:GetTrinket(slot)
    if(TRINKET_FUNCS[trinket]) then
        return {
            CropOffset = TRINKET_FUNCS[trinket].Func(player)
        }
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_TRINKET_RENDER, trinketRenderCropOffset)

local function cancelRegisteredTrinkets(_)
    return {
        HideTrinkets = TRINKETS_TO_HIDE
    }
end
ToyboxMod:AddCallback(ModCallbacks.MC_PRE_HISTORYHUD_RENDER, cancelRegisteredTrinkets)

---@param hud HistoryHUD
---@param renderPos Vector
local function reRenderTrinkets(_, hud, renderPos)
    for i=0, 1 do
        local pl = hud:GetPlayer(i)
        local trinkets = hud:GetTrinkets(i, TRINKETS_TO_HIDE)
        for _, trinketData in ipairs(trinkets) do
            local id = (trinketData:GetItemID() & ~TrinketType.TRINKET_GOLDEN_FLAG)
            local isGold = (trinketData:GetItemID() & TrinketType.TRINKET_GOLDEN_FLAG ~= 0)

            local spr = TRINKET_FUNCS[id].Sprite
            local offset = TRINKET_FUNCS[id].Func(pl) or Vector(0,0)
            spr:GetLayer(0):SetCropOffset(offset)
            if(isGold) then
                spr:SetRenderFlags(AnimRenderFlags.GOLDEN)
            else
                spr:SetRenderFlags(0)
            end
            spr.Scale = Vector(1,1)*(Options.ExtraHUDStyle==2 and 0.5 or 1)
            spr.Offset = Vector(16,16)*spr.Scale
            spr.Color = Color(1,1,1,0.5)

            spr:Render(renderPos+trinketData:GetRenderOffset())
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_HISTORYHUD_RENDER, reRenderTrinkets)