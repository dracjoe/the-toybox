local sfx = SFXManager()

local BREATH_CHANCE = 0.1
local BREATH_MAXCHANCE = 0.2
local BREATH_MAXLUCK = 20

local FLAGS_TO_ADD = {
    TearFlags.TEAR_RAINBOW,
    TearFlags.TEAR_BAIT,
    TearFlags.TEAR_BURN,
    TearFlags.TEAR_CHARM,
    TearFlags.TEAR_FEAR,
    TearFlags.TEAR_SLOW,
    TearFlags.TEAR_ICE,
    TearFlags.TEAR_FREEZE,
    TearFlags.TEAR_POISON,
    TearFlags.TEAR_HOMING,
    TearFlags.TEAR_SHRINK
}
local DMG_MULT = 3

ToyboxMod:registerTearVariant(
    ToyboxMod.TEAR_AIDS,
    nil, nil, function(tear, splat)
        splat:GetSprite():SetCustomShader("shaders_tb/rainbow")

        local col = Color(0,0,0,1,0,0,0,ToyboxMod.GAME:GetFrameCount()/15+(tear.Position.X+tear.Position.Y)/250,0,0,0)
        splat:GetSprite().Color = col
    end, false, false, nil
)

---@param pl EntityPlayer
---@param params TearParams
local function evalParams(_, pl, params, weap, dmg, tearDisp, source)
    if(not pl:HasCollectible(ToyboxMod.COLLECTIBLE_AIDS)) then return end

    local c = ToyboxMod:getLuckAffectedChance(pl.Luck, BREATH_CHANCE, BREATH_MAXLUCK, BREATH_MAXCHANCE)
    if(math.random()<c) then
        local totalFlag = 0
        for _, flag in ipairs(FLAGS_TO_ADD) do
            totalFlag = totalFlag | flag
        end
        params.TearFlags = params.TearFlags | totalFlag
        params.TearDamage = params.TearDamage*DMG_MULT
        params.TearColor = Color.Default
        params.TearScale = params.TearScale*1.1
        params.TearVariant = ToyboxMod.TEAR_AIDS
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_EVALUATE_TEAR_HIT_PARAMS, evalParams)