local sfx = SFXManager()

local BLEED_CHANCE = 0.10
local BLEED_MAXCHANCE = 0.5
local BLEED_MAXLUCK = 20

---@param entity Entity
---@param player EntityPlayer
local function pollTearflags(_, entity, player, weapon)
    if(player:HasCollectible(ToyboxMod.COLLECTIBLE_VAMPIRE_TEETH)) then
        local rng = player:GetCollectibleRNG(ToyboxMod.COLLECTIBLE_VAMPIRE_TEETH)
        local chance = TearFlagsLib.GetChance(TearFlagsLib.GetRealLuck(player, entity), BLEED_CHANCE, BLEED_MAXCHANCE, BLEED_MAXLUCK, 1)
        chance = math.min(chance*player:GetCollectibleNum(ToyboxMod.COLLECTIBLE_VAMPIRE_TEETH), BLEED_MAXCHANCE)

        if(rng:RandomFloat()<chance) then
            TearFlagsLib.AddTearFlags(entity, ToyboxMod.TEARFLAGS.BLOODY)
        end
    end
end
ToyboxMod:AddCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, pollTearflags)

---@param npc EntityNPC
local function healOnBleedKill(_, npc)
    if(not PlayerManager.AnyoneHasCollectible(ToyboxMod.COLLECTIBLE_VAMPIRE_TEETH)) then return end
    if(not npc:HasEntityFlags(EntityFlag.FLAG_BLEED_OUT)) then return end

    for i=0, ToyboxMod.GAME:GetNumPlayers()-1 do
        local pl = Isaac.GetPlayer(i)
        if(pl:HasCollectible(ToyboxMod.COLLECTIBLE_VAMPIRE_TEETH)) then
            pl:AddHearts(1)

            local maxdist = npc.Position:Distance(pl.Position)
            local dir = (pl.Position-npc.Position):Normalized()
            local pos = npc.Position
            while(pos:Distance(pl.Position)>20) do
                local particle = Isaac.Spawn(1000,111,0,pos,Vector.Zero,nil):ToEffect()
                particle.SpriteScale = Vector.One*((1-pos:Distance(pl.Position)/maxdist)*0.6+0.1)
                particle.Color = Color(0,0,0,1,200/255,0,0,2)
                particle:GetSprite():SetCustomShader("shaders_tb/pixelate")

                pos = pos+dir*20
            end

            local gulpEffect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, pl.Position, Vector.Zero, nil):ToEffect()
            gulpEffect.SpriteOffset = Vector(0, -14)

            sfx:Play(SoundEffect.SOUND_MEAT_JUMPS)
            sfx:Play(SoundEffect.SOUND_VAMP_GULP)
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, healOnBleedKill)