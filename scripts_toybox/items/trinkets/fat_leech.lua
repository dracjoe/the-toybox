ToyboxMod:setCropOffsetLogic(ToyboxMod.TRINKET_FAT_LEECH, function(player)
    if((ToyboxMod:getEntityData(player, "FAT_LEECH_ATE") or -1)~=-1) then
        return Vector(32,0)
    end
end)

local REMOVE_TRINKETS = {
    [TrinketType.TRINKET_FLAT_PENNY] = true, 
    [TrinketType.TRINKET_FLAT_FILE] = true,
}

ToyboxMod:makeParasiteTrinket(ToyboxMod.TRINKET_FAT_LEECH, {TrinketType.TRINKET_FLAT_PENNY, TrinketType.TRINKET_FLAT_FILE}, SoundEffect.SOUND_LEECH)

local function trinketCollision(_, pickup, coll)
    local player = coll and coll:ToPlayer()
    if(not (player and player:HasTrinket(ToyboxMod.TRINKET_FAT_LEECH))) then return end
    if(REMOVE_TRINKETS[(pickup.SubType & ~TrinketType.TRINKET_GOLDEN_FLAG)]) then return end

    if(player:CanPickupItem() and player:IsExtraAnimationFinished() and (ToyboxMod:getEntityData(player, "FAT_LEECH_ATE") or -1)==-1) then
        ToyboxMod:setEntityData(player, "FAT_LEECH_ATE", pickup.SubType)

        pickup:Die()
        player:AnimateTrinket(ToyboxMod.TRINKET_FAT_LEECH, "UseItem")

        local poof = Isaac.Spawn(1000,16,5,pickup.Position,Vector.Zero,nil)
        poof.SpriteScale = Vector(1,1)*0.35
        poof.DepthOffset = -80
        poof.SpriteOffset = Vector(0,-6*player.SpriteScale.Y)
        poof.Color = Color(0,0,0,1,200/255,0,0,1/0.35)
        poof:GetSprite().PlaybackSpeed = 0.95
        poof:GetSprite():SetCustomShader("shaders_tb/pixelate")

        local poof2 = Isaac.Spawn(1000,16,0,pickup.Position,Vector.Zero,nil)
        poof2.SpriteScale = Vector(1,1)*0.5
        poof2.DepthOffset = 10
        poof2.SpriteOffset = Vector(0,-6*pickup.SpriteScale.Y)
        poof2.Color = Color(1,0,0,1,255/255,0,0,1/0.5)
        poof2:GetSprite().PlaybackSpeed = 1.25
        poof2:GetSprite():SetCustomShader("shaders_tb/pixelate")

        local splat = Isaac.Spawn(1000,7,0,pickup.Position,Vector.Zero,nil)
        splat.SpriteScale = Vector(1,1)*0.75
        splat:Update()

        ToyboxMod.SFX:Play(SoundEffect.SOUND_VAMP_GULP)
        ToyboxMod.SFX:Play(SoundEffect.SOUND_MEAT_JUMPS)

        return true
    end
end
ToyboxMod:AddPriorityCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, CallbackPriority.EARLY, trinketCollision, PickupVariant.PICKUP_TRINKET)

---@param player EntityPlayer
---@param isInitFinished boolean
local function giveHeldTrinket(_, player, _, isInitFinished)
    if(player.FrameCount==0) then return end

    local trinket = ToyboxMod:getEntityData(player, "FAT_LEECH_ATE")
    if((trinket or -1)==-1) then return end

    ToyboxMod:setEntityData(player, "FAT_LEECH_ATE", nil)

    if(not player:HasTrinket(ToyboxMod.TRINKET_FAT_LEECH)) then return end

    Isaac.CreateTimer(
        function(eff)
            if(eff.FrameCount>0 and player) then
                if(player:GetTrinketMultiplier(ToyboxMod.TRINKET_FAT_LEECH)>1) then
                    trinket = trinket | TrinketType.TRINKET_GOLDEN_FLAG
                end

                local tconf = Isaac.GetItemConfig():GetTrinket(trinket)
                if(not tconf) then return end

                player:AnimateTrinket(trinket)
                if(trinket & TrinketType.TRINKET_GOLDEN_FLAG ~= 0) then
                    player:GetHeldSprite():SetRenderFlags(AnimRenderFlags.GOLDEN)
                end
                player:AddSmeltedTrinket(trinket, true)
                ToyboxMod.SFX:Play(SoundEffect.SOUND_SHELLGAME)
                ToyboxMod.SFX:Play(SoundEffect.SOUND_WHEEZY_COUGH)
                ToyboxMod.GAME:GetHUD():ShowItemText(player, tconf)
            end
        end,
        1, 2, true
    )
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PLAYER_NEW_LEVEL, giveHeldTrinket)