local DAMAGE_MULT = 1/3

---@param ent Entity
---@param dmg number
---@param flags DamageFlag
---@param source EntityRef
---@param cooldown integer
local function dealDamageToAll(_, ent, dmg, flags, source, cooldown)
    if(flags & DamageFlag.DAMAGE_CLONES ~= 0) then return end

    local player = ToyboxMod:getPlayerFromEnt(source.Entity)
    if(not (player and player:HasTrinket(ToyboxMod.TRINKET_BUG_SPRAY))) then return end

    if(not ToyboxMod:isValidEnemy(ent)) then return end

    local mult = DAMAGE_MULT*player:GetTrinketMultiplier(ToyboxMod.TRINKET_BUG_SPRAY)
    local damage = dmg*mult

    local entConf = EntityConfig
    local ogHash = GetPtrHash(ent)
    for _, other in ipairs(Isaac.GetRoomEntities()) do
        if(ogHash~=GetPtrHash(other)) then
            local conf = entConf.GetEntity(other.Type, other.Variant, other.SubType)
            if(conf and (conf:HasEntityTags(EntityTag.FLY) or conf:HasEntityTags(EntityTag.SPIDER))) then
                other:TakeDamage(damage, flags | DamageFlag.DAMAGE_CLONES, source, cooldown)
            end
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, dealDamageToAll)