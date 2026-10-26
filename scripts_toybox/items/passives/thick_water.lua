--TODO: Add to itempools
--TODO: Add sprite

---@param player EntityPlayer
local function postAddItem(_, _, _, firstTime, slot, vData, player)
    if(firstTime~=true) then return end
    local pos = ToyboxMod.GAME:GetRoom():FindFreePickupSpawnPosition(player.Position,40)

    local trinker = Isaac.Spawn(5,PickupVariant.PICKUP_TRINKET,0,pos,Vector.Zero,player):ToPickup()
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, postAddItem, ToyboxMod.COLLECTIBLE_THICK_WATER)

---@param pl EntityPlayer
local function maybeRemoveTrinket(_, pl)
    if(pl.FrameCount==0) then return end

    if(pl:HasCollectible(ToyboxMod.COLLECTIBLE_THICK_WATER)) then
        local numTrinkets = 0
        for _=0, 1 do
            local trinket = pl:GetTrinket(0)
            if(trinket ~= 0) then
                numTrinkets = numTrinkets+1
                pl:TryRemoveTrinket(trinket)
                pl:AddSmeltedTrinket(trinket, false)
            end
        end

        if(numTrinkets > 0) then
            local mult = numTrinkets * pl:GetCollectibleNum(ToyboxMod.COLLECTIBLE_THICK_WATER)
            pl:GetEffects():AddCollectibleEffect(ToyboxMod.COLLECTIBLE_THICK_WATER, true, mult)

            Isaac.CreateTimer(function(eff) ---@param eff EntityEffect
                if(eff.FrameCount>0) then
                    ToyboxMod.SFX:Play(SoundEffect.SOUND_THUMBSUP)
                    ToyboxMod.SFX:Play(numTrinkets>1 and SoundEffect.SOUND_VAMP_DOUBLE or SoundEffect.SOUND_VAMP_GULP)

                    local poof = Isaac.Spawn(1000,79,0,pl.Position,Vector.Zero,nil)
                    poof.SpriteOffset = Vector(0,-20)*pl.SpriteScale
                end
            end, 2, 2, true)
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PLAYER_NEW_LEVEL, maybeRemoveTrinket)