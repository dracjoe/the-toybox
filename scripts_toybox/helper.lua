

function ToyboxMod:unlock(unlock, force)
    local pgd = Isaac.GetPersistentGameData()
    if(not force) then
        if(not ToyboxMod.GAME:AchievementUnlocksDisallowed()) then
            if(not pgd:Unlocked(unlock)) then
                pgd:TryUnlock(unlock)
            end
        end
    else
        pgd:TryUnlock(unlock)
    end
end

function ToyboxMod:cloneTable(t)
    local tClone = {}
    for key, val in pairs(t) do
        if(type(val)=="table") then
            tClone[key]={}
            for key2, val2 in pairs(ToyboxMod:cloneTable(val)) do
                tClone[key][key2]=val2
            end
        else
            tClone[key]=val
        end
    end
    return tClone
end
function ToyboxMod:cloneTableWithoutDeleteing(table1, table2)
    for key, val in pairs(table2) do
        if(type(val)=="table") then
            table1[key] = {}
            ToyboxMod:cloneTableWithoutDeleteing(table1[key], table2[key])
        else
            table1[key]=val
        end
    end
end

---@param v Vector
function ToyboxMod:vectorToVectorTable(v)
    return
    {
        X = v.X,
        Y = v.Y,
        IsVectorTable = true,
    }
end
---@param t table
function ToyboxMod:vectorTableToVector(t)
    return Vector(t.X, t.Y)
end

---@param c Color
function ToyboxMod:colorToColorTable(c)
    return
    {
        R = c.R,
        G = c.G,
        B = c.B,
        A = c.A,
        RO = c.RO,
        GO = c.GO,
        BO = c.BO,
        IsColorTable = true,
    }
end
---@param t table
function ToyboxMod:colorTableToColor(t)
    return Color(t.R, t.G, t.B, t.A, t.RO, t.GO, t.BO)
end

---@param col Color
function ToyboxMod:cloneColor(col)
    local newCol = Color()
    local ogTint = col:GetTint()
    local ogOffset = col:GetOffset()
    local ogColorize = col:GetColorize()

    newCol:SetTint(ogTint.R, ogTint.G, ogTint.B, ogTint.A)
    newCol:SetOffset(ogOffset.R, ogOffset.G, ogOffset.B)
    newCol:SetColorize(ogColorize.R, ogColorize.G, ogColorize.B, ogColorize.A)

    return newCol
end

---@param player EntityPlayer
function ToyboxMod:isMilcom(player)
    if(player:GetPlayerType()==ToyboxMod.PLAYER_MILCOM_A) then return true end
    if(player:GetPlayerType()==ToyboxMod.PLAYER_MILCOM_B) then return true end
    return false
end

---@param player EntityPlayer
function ToyboxMod:isAtlas(player)
    if(ToyboxMod:isAtlasA(player)) then return true end
    if(player:GetPlayerType()==ToyboxMod.PLAYER_ATLAS_B) then return true end
    return false
end

---@param val number Value to clamp
---@param upper number Upper bound of the range
---@param lower number Lower bound of the range
---@return number clampedVal The clamped value
---Clamps a given value into a range
function ToyboxMod:clamp(val, lower, upper)
    return math.min(upper, math.max(val, lower))
end

function ToyboxMod:lerp(a, b, f)
    return a*(1-f)+b*f
end

---@param rng RNG
---@param a number
---@param b number
function ToyboxMod:randomRange(rng, a, b)
    return a+rng:RandomFloat()*(b-a)
end

function ToyboxMod:sign(a)
    if(a<0) then return -1 end
    return 1
end

---@param t table The table to count
---@return number count The number of elements in the table
---Counts the number of elements in a table
function ToyboxMod:countElements(t)
    local count = 0
    for _, _ in pairs(t) do count = count+1 end

    return count
end

---@return EntityPlayer?
function ToyboxMod:getPlayerFromEnt(ent)
    if(not ent) then return end
    if(ent:ToPlayer()) then return ent:ToPlayer() end

    local sp = ent.SpawnerEntity
    if(sp==nil) then return nil end
    if(sp:ToPlayer()) then return sp:ToPlayer()
    elseif(sp:ToFamiliar() and sp:ToFamiliar().Player) then
        local fam = sp:ToFamiliar()
        if(ToyboxMod.TEAR_COPYING_FAMILIARS[fam.Variant]) then return fam.Player
        else return nil end
    end

    return nil
end

---@param player EntityPlayer
---@return number num
function ToyboxMod:getPlayerNumFromPlayerEnt(player)
    for i=0, ToyboxMod.GAME:GetNumPlayers()-1 do
        if(GetPtrHash(player)==GetPtrHash(Isaac.GetPlayer(i))) then return i end
    end
    return 0
end

function ToyboxMod:getScreenCenter()
    return (ToyboxMod.GAME:GetRoom():GetRenderSurfaceTopLeft()*2+Vector(442,286))/2
end
function ToyboxMod:getScreenBottomRight()
    return ToyboxMod.GAME:GetRoom():GetRenderSurfaceTopLeft()*2+Vector(442,286)
end

function ToyboxMod:addCustomStrawman(playerType, cIndex)
    playerType=playerType or 0
    cIndex=cIndex or 0
    local LastPlayerIndex=ToyboxMod.GAME:GetNumPlayers()-1
    if LastPlayerIndex>=63 then return nil else
        Isaac.ExecuteCommand('addplayer '..playerType..' '..cIndex)
        local strawman=Isaac.GetPlayer(LastPlayerIndex+1)
        strawman.Parent=Isaac.GetPlayer(0)
        ToyboxMod.GAME:GetHUD():AssignPlayerHUDs()
        return strawman
    end
end

---true players just means they're not strawman-like characters
function ToyboxMod:isTruePlayer(player)
    return (player.Parent==nil)
end

function ToyboxMod:getNumberOfTruePlayers()
    local c = 0
    for _, player in ipairs(Isaac.FindByType(1)) do
        if(ToyboxMod:isTruePlayer(player)) then c=c+1 end
    end
    return c
end

function ToyboxMod:getTruePlayers()
    local idx = 0
    local p = {}
    for i=0, ToyboxMod.GAME:GetNumPlayers()-1 do
        local player = Isaac.GetPlayer(i)
        if(ToyboxMod:isTruePlayer(player)) then
            p[idx] = player
            idx=idx+1
        end
    end

    return p
end

function ToyboxMod:getTruePlayerNumFromPlayerEnt(player)
    for pIdx, p in pairs(ToyboxMod:getTruePlayers()) do
        if(GetPtrHash(player)==GetPtrHash(p)) then return pIdx end
    end

    return -1
end

---@param f Font
---@param str string
---@param maxlength number
function ToyboxMod:separateStringIntoLines(f, str, maxlength)
    local fStrings = {}
    local splitStrings = {}

    for s in str:gmatch("([^ ]+)") do
        splitStrings[#splitStrings+1] = s
    end

    local st = ""

    for _, s in ipairs(splitStrings) do
        if(f:GetStringWidth(st.." "..s)>maxlength) then
            fStrings[#fStrings+1] = st
            st=s
        else
            st=st.." "..s
        end
    end

    fStrings[#fStrings+1] = st

    return fStrings
end

---@param pos Vector
function ToyboxMod:closestPlayer(pos)
	local entities = Isaac.FindByType(1)
	local closestEnt = Isaac.GetPlayer()
	local closestDist = 2^32
	for i = 1, #entities do
		if not entities[i]:IsDead() then
			local dist = (entities[i].Position - pos):LengthSquared()
			if dist < closestDist then
				closestDist = dist
				closestEnt = entities[i]:ToPlayer()
			end
		end
	end
	return closestEnt
end

function ToyboxMod:toTps(n)
    return 30/(n+1)
end
function ToyboxMod:toFireDelay(n)
    return (30/n)-1
end
function ToyboxMod:getTps(player)
    return 30/(player.MaxFireDelay+1)
end
function ToyboxMod:addTps(player, n)
    return (30/(30/(player.MaxFireDelay+1)+n))-1
end

function ToyboxMod:renderingAboveWater()
    local rmode = ToyboxMod.GAME:GetRoom():GetRenderMode()
    return rmode==RenderMode.RENDER_NORMAL or rmode==RenderMode.RENDER_WATER_ABOVE or rmode==RenderMode.RENDER_WATER_REFRACT
end

function ToyboxMod:getKeyFromVal(table, val)
    for key, v in pairs(table) do
        if(v==val) then return key end
    end
    return nil
end

function ToyboxMod:setBaited(e, s, d)
    e:AddBaited(EntityRef(s),1)
    e:AddEntityFlags(EntityFlag.FLAG_BAITED)
    e:SetBaitedCountdown(d)
end
function ToyboxMod:getBaitedFrames(e) return e:GetBaitedCountdown() end
function ToyboxMod:setBleeding(e, s, d)
    e:AddBleeding(EntityRef(s), 1)
    e:AddEntityFlags(EntityFlag.FLAG_BLEED_OUT)
    e:SetBleedingCountdown(d)
end
function ToyboxMod:getBleedingFrames(e) return e:GetBaitedCountdown() end
function ToyboxMod:setBrimstoneMark(e, s, d)
    e:AddBrimstoneMark(EntityRef(s),1)
    e:AddEntityFlags(EntityFlag.FLAG_BRIMSTONE_MARKED)
    e:SetBrimstoneMarkCountdown(d)
end
function ToyboxMod:getBrimstoneMarkFrames(e) return e:GetBaitedCountdown() end
function ToyboxMod:setBurn(e, s, d, dmg)
    e:AddBurn(EntityRef(s),1, dmg)
    e:AddEntityFlags(EntityFlag.FLAG_BURN)
    e:SetBurnCountdown(d)
end
function ToyboxMod:getBurnFrames(e) return e:GetBleedingCountdown() end
function ToyboxMod:setCharmed(e, s, d)
    e:AddCharmed(EntityRef(s),1)
    e:AddEntityFlags(EntityFlag.FLAG_CHARM)
    e:SetCharmedCountdown(d)
end
function ToyboxMod:getCharmedFrames(e) return e:GetCharmedCountdown() end
function ToyboxMod:setConfusion(e, s, d, ignoreBoss)
    e:AddConfusion(EntityRef(s),1,ignoreBoss or false)
    e:AddEntityFlags(EntityFlag.FLAG_CONFUSION)
    e:SetConfusionCountdown(d)
end
function ToyboxMod:getConfusionFrames(e) return e:GetConfusionCountdown() end
function ToyboxMod:setFear(e, s, d)
    e:AddFear(EntityRef(s),1)
    e:AddEntityFlags(EntityFlag.FLAG_FEAR)
    e:SetFearCountdown(d)
end
function ToyboxMod:getFearFrames(e) return e:GetFearCountdown() end
function ToyboxMod:setFreeze(e, s, d)
    e:AddFreeze(EntityRef(s),1)
    e:AddEntityFlags(EntityFlag.FLAG_FREEZE)
    e:SetFreezeCountdown(d)
end
function ToyboxMod:getFreezeFrames(e) return e:GetFreezeCountdown() end
function ToyboxMod:setIce(e, s, d)
    e:AddIce(EntityRef(s),1)
    e:AddEntityFlags(EntityFlag.FLAG_ICE)
    e:SetIceCountdown(d)
end
function ToyboxMod:getIceFrames(e) return e:GetIceCountdown() end
function ToyboxMod:setKnockback(e, s, d, direction, takeImpact)
    e:AddKnockback(s,direction,1,takeImpact)
    e:SetKnockbackCountdown(d)
end
function ToyboxMod:getKnockbackFrames(e) return e:GetKnockbackCountdown() end
function ToyboxMod:setMagnetized(e, s, d)
    e:AddMagnetized(EntityRef(s),1)
    e:AddEntityFlags(EntityFlag.FLAG_MAGNETIZED)
    e:SetMagnetizedCountdown(d)
end
function ToyboxMod:getMagnetizedFrames(e) return e:GetMagnetizedCountdown() end
function ToyboxMod:setMidasFreeze(e, s, d)
    e:AddMidasFreeze(EntityRef(s),d-e:GetMidasFreezeCountdown())
end
function ToyboxMod:getMidasFreezeFrames(e) return e:GetMidasFreezeCountdown() end
function ToyboxMod:setPoison(e, s, d, dmg)
    e:AddPoison(EntityRef(s), 1, dmg)
    e:AddEntityFlags(EntityFlag.FLAG_POISON)
    e:SetPoisonCountdown(d)
end
function ToyboxMod:getPoisonFrames(e) return e:GetPoisonCountdown() end
function ToyboxMod:setShrink(e, s, d)
    e:AddShrink(EntityRef(s),1)
    e:AddEntityFlags(EntityFlag.FLAG_SHRINK)
    e:SetShrinkCountdown(d)
end
function ToyboxMod:getShrinkFrames(e) return e:GetShrinkCountdown() end
function ToyboxMod:setSlowing(e, s, d, val, color)
    e:AddSlowing(EntityRef(s), 1, val, color)
    e:SetSlowingCountdown(d)
end
function ToyboxMod:getSlowingFrames(e) return e:GetSlowingCountdown() end
function ToyboxMod:setWeakness(e, s, d)
    e:AddWeakness(EntityRef(s), 1)
    e:AddEntityFlags(EntityFlag.FLAG_WEAKNESS)
    e:SetWeaknessCountdown(d)
end
function ToyboxMod:getWeaknessFrames(e) return e:GetWeaknessCountdown() end

function ToyboxMod:getHeartHudPosition(playerNum)
    if(playerNum==0) then
        return Vector(48,11)+Vector(20,12)*Options.HUDOffset
    elseif(playerNum==1) then
        return Vector(-111+Isaac.GetScreenWidth(), 11)+Vector(-24,12)*Options.HUDOffset
    elseif(playerNum==2) then
        return Vector(58,-28+Isaac.GetScreenHeight())+Vector(22,-6)*Options.HUDOffset
    elseif(playerNum==3) then
        return Vector(-111+Isaac.GetScreenWidth(),-28+Isaac.GetScreenHeight())+Vector(-24,-6)*Options.HUDOffset
    end
    return Vector(-100,-100)
end

---@param entity Entity
function ToyboxMod:isValidEnemy(entity)
    entity = entity:ToNPC()
    return entity and (entity:IsEnemy() and entity:IsActiveEnemy() and entity:IsVulnerableEnemy() and not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY))
end
function ToyboxMod:getAllValidEnemies()
    local t = {}
    for i, e in ipairs(Isaac.GetRoomEntities()) do
        if(ToyboxMod:isValidEnemy(e)) then table.insert(t, e:ToNPC()) end
    end
    return t
end

function ToyboxMod:closestEnemy(pos)
	local entities = Isaac.GetRoomEntities()
	local closestEnt = nil
	local closestDist = 2^32

	for i = 1, #entities do
		if ToyboxMod:isValidEnemy(entities[i]) then
			local dist = (entities[i].Position - pos):LengthSquared()
			if dist < closestDist then
				closestDist = dist
				closestEnt = entities[i]
			end
		end
	end
	return closestEnt
end

function ToyboxMod:closestVisibleEnemy(pos)
	local entities = Isaac.GetRoomEntities()
	local closestEnt = nil
	local closestDist = 2^32

	for i = 1, #entities do
		if(ToyboxMod:isValidEnemy(entities[i]) and ToyboxMod.GAME:GetRoom():CheckLine(pos, entities[i].Position, 1)) then
			local dist = (entities[i].Position - pos):LengthSquared()
			if dist < closestDist then
				closestDist = dist
				closestEnt = entities[i]
			end
		end
	end
	return closestEnt
end

function ToyboxMod:getEntFromPtrHash(entity)
	if entity then
		if entity.Entity then entity = entity.Entity end
		for _, e in pairs(Isaac.FindByType(entity.Type, entity.Variant, entity.SubType)) do
			if GetPtrHash(entity) == GetPtrHash(e) then
				return e
			end
		end
	end
	return nil
end

function ToyboxMod:getPlayerFromTear(tear)
	local pEnt = tear.Parent or tear.SpawnerEntity
	if(pEnt) then
		if(pEnt.Type==EntityType.ENTITY_PLAYER) then
			return ToyboxMod:getEntFromPtrHash(pEnt):ToPlayer(), false
		elseif(pEnt.Type==EntityType.ENTITY_FAMILIAR and pEnt.Variant==FamiliarVariant.INCUBUS) then
            if(pEnt.Variant==FamiliarVariant.INCUBUS) then
                return pEnt:ToFamiliar().Player:ToPlayer(), true
            elseif(pEnt.Variant==FamiliarVariant.TWISTED_BABY) then
                return pEnt:ToFamiliar().Player:ToPlayer(), true
            end
		end
	end
	return nil, false
end

function ToyboxMod:addInvincibility(player, amount)
    player:SetMinDamageCooldown(player:GetDamageCooldown()+amount)
end

---@param seed integer?
---@return RNG
function ToyboxMod:generateRng(seed)
    seed = seed or Random()
    if(seed<=0) then seed=1 end

    local rng = RNG()
    rng:SetSeed(seed)

    return rng
end

---@param luck number
---@param baseChance number
---@param maxLuck number
---@param maxChance number?
function ToyboxMod:getLuckAffectedChance(luck, baseChance, maxLuck, maxChance)
    local f = luck/maxLuck
    f = ToyboxMod:clamp(f, 0, 1)

    if(f==0) then return baseChance;
    elseif(f<0) then return ToyboxMod:lerp(baseChance,0,-f)
    else return ToyboxMod:lerp(baseChance,maxChance or 1,f) end
end

function ToyboxMod:getRandomFreePos(margin)
    margin = margin or 80

    local r = ToyboxMod.GAME:GetRoom()
    local p
    local failsafe = 1000

    repeat
        p = r:GetRandomPosition(margin)
        failsafe = failsafe-1
    until(failsafe<=0 or r:GetGridCollisionAtPos(p)==GridCollisionClass.COLLISION_NONE)

    return p
end

function ToyboxMod:isRoomClear()
    return (ToyboxMod.GAME:GetRoom():IsClear() and not ToyboxMod.GAME:GetRoom():IsAmbushActive())
end

function ToyboxMod:isTearCopyingFamiliar(fam)
    local copyFam = {
        [FamiliarVariant.INCUBUS]=true,
        [FamiliarVariant.SPRINKLER]=true,
        [FamiliarVariant.TWISTED_BABY]=true,
        [FamiliarVariant.BLOOD_BABY]=true, --clot
        [FamiliarVariant.UMBILICAL_BABY]=true, --gello
        [FamiliarVariant.CAINS_OTHER_EYE]=true,
    }

    return (copyFam[fam.Variant]==true)
end

function ToyboxMod:trinketIsTrinketType(pickup, trinkettype)
    return (pickup.SubType==trinkettype) or (pickup.SubType==trinkettype+TrinketType.TRINKET_GOLDEN_FLAG)
end

---@param player EntityPlayer
function ToyboxMod:isInHallowedAura(player)
    local hallowedAuraNums = 0
    local starAuraNums = 0

    for _, effect in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.HALLOWED_GROUND)) do
        if(effect.Parent and (effect.Parent.Type == EntityType.ENTITY_POOP or (effect.Parent.Type == EntityType.ENTITY_FAMILIAR and effect.Parent.Variant == FamiliarVariant.DIP))) then
            local scale = ((effect.SpriteScale.X + effect.SpriteScale.Y) * 70 / 2) + player.Size
            if(player.Position:Distance(effect.Position) < scale) then
                hallowedAuraNums = hallowedAuraNums+1
            end
        elseif(effect.Parent and effect.Parent.Type == EntityType.ENTITY_FAMILIAR and effect.Parent.Variant == FamiliarVariant.STAR_OF_BETHLEHEM) then
            local scale = 70 + player.Size
            if(player.Position:Distance(effect.Position) < scale) then
                starAuraNums = starAuraNums + 1
            end
        end
    end

    return {hallowedAuraNums,starAuraNums}
end
---@param player EntityPlayer
function ToyboxMod:isInHallowedCreep(player)
    local auranum = 0
    for _, effect in pairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_LIQUID_POOP)) do
        effect = effect:ToEffect()
        local scale = ((effect.SpriteScale.X + effect.SpriteScale.Y) * 36 / 2)
        if effect.State == 64 and player.Position:Distance(effect.Position) <= scale then
            auranum = auranum + 1
        end
    end
    return auranum
end

function ToyboxMod:getVanillaDamageMultAtPriority(player, priority)
    local mult = 1
    local auraData = ToyboxMod:isInHallowedAura(player)
    if(priority<=1) then
        if(player:HasCollectible(CollectibleType.COLLECTIBLE_ODD_MUSHROOM_THIN)) then mult = mult*0.9 end
    end
    if(priority<=4) then
        if(player:HasCollectible(CollectibleType.COLLECTIBLE_POLYPHEMUS) and not (player:HasCollectible(CollectibleType.COLLECTIBLE_20_20) or player:HasCollectible(CollectibleType.COLLECTIBLE_INNER_EYE) or player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER))) then mult = mult*2 end
        if(player:GetPlayerType()==PlayerType.PLAYER_EVE and not player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_WHORE_OF_BABYLON)) then mult = mult*0.75 end
        local playerMults = {
            [PlayerType.PLAYER_MAGDALENE_B] = 0.75,
            [PlayerType.PLAYER_BLUEBABY] = 1.05,
            [PlayerType.PLAYER_KEEPER] = 1.2,
            [PlayerType.PLAYER_CAIN] = 1.2,
            [PlayerType.PLAYER_CAIN_B] = 1.2,
            [PlayerType.PLAYER_EVE_B] = 1.2,
            [PlayerType.PLAYER_JUDAS] = 1.35,
            [PlayerType.PLAYER_AZAZEL] = 1.5,
            [PlayerType.PLAYER_THEFORGOTTEN] = 1.5,
            [PlayerType.PLAYER_AZAZEL_B] = 1.5,
            [PlayerType.PLAYER_THEFORGOTTEN_B] = 1.5,
            [PlayerType.PLAYER_LAZARUS2_B] = 1.5,
            [PlayerType.PLAYER_LAZARUS2] = 1.4,
            [PlayerType.PLAYER_THELOST_B] = 1.3,
            [PlayerType.PLAYER_BLACKJUDAS] = 2,
        }
        mult = mult*(playerMults[player:GetPlayerType()] or 1)
    end
    if(priority<=6) then
        if(player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_MEGA_MUSH)) then mult = mult*4 end
    end
    if(priority<=8) then
        if((player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BRIMSTONE)>=2 and not player:HasCollectible(CollectibleType.COLLECTIBLE_HAEMOLACRIA))) then mult=mult*1.2 end
        if((player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_CROWN_OF_LIGHT))) then mult=mult*2 end
        if((player:HasCollectible(CollectibleType.COLLECTIBLE_SACRED_HEART))) then mult=mult*2.3 end
    end
    if(priority<=10) then
        if((player:GetPlayerType()==PlayerType.PLAYER_JUDAS or player:GetPlayerType()==PlayerType.PLAYER_BLACKJUDAS) and player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) and player:HasCollectible(CollectibleType.COLLECTIBLE_DAMOCLES_PASSIVE)) then mult=mult*1.4 end
    end
    if(priority<=12) then
        if(player:HasCollectible(CollectibleType.COLLECTIBLE_IMMACULATE_HEART) or auraData[1]>0 or auraData[2]>0) then mult=mult*1.2 end
    end
    if(priority<=14) then
        if((player:GetPlayerType()==PlayerType.PLAYER_AZAZEL or player:GetPlayerType()==PlayerType.PLAYER_AZAZEL_B) and player:HasCollectible(CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE)) then mult=mult*0.5 end
        if(player:HasCollectible(CollectibleType.COLLECTIBLE_HAEMOLACRIA) or (player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BRIMSTONE)==1 and player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY))) then mult = mult*1.5 end
    end
    if(priority<=16) then
        if(player:HasCollectible(CollectibleType.COLLECTIBLE_20_20)) then mult = mult*0.8 end
        if(player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK)) then mult=mult*0.3 end
        if(player:HasCollectible(CollectibleType.COLLECTIBLE_CRICKETS_HEAD) or (player:HasCollectible(CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM) or player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM)) or (player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL) and player:HasCollectible(CollectibleType.COLLECTIBLE_BLOOD_OF_THE_MARTYR))) then mult=mult*1.5 end
        mult = mult*player:GetD8DamageModifier()*(1+0.125*player:GetDeadEyeCharge())
        if(player:HasCollectible(CollectibleType.COLLECTIBLE_EVES_MASCARA)) then mult = mult*2 end
        if(player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) and not player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK)) then mult=mult*0.2 end
        if(auraData[2]>0) then mult=mult*1.5 end
        local counter = 0
        for _, fam in ipairs(Isaac.FindByType(3, FamiliarVariant.SUCCUBUS)) do
            if(fam.Position:Distance(player.Position)<=97.5) then counter = counter+1 end
        end
        mult = mult*(1.5^counter)
    end
    if(priority<=17) then
        if(player.Damage>3.5) then
            local crownMult = player:GetTrinketMultiplier(TrinketType.TRINKET_CRACKED_CROWN)*0.2
            if(crownMult>0) then
                mult = mult*(1+crownMult)*(player.Damage/(player.Damage+crownMult*3.5))
            end
        end
    end
    return mult
end
function ToyboxMod:addBasicDamageUp(player, dmg)
    player.Damage = player.Damage+dmg*ToyboxMod:getVanillaDamageMultAtPriority(player,0)
end

--thank you rat rat rat rat rat rat rat rat!!!!
---@param player EntityPlayer
function ToyboxMod:getVanillaTearMultiplier(player)
    local mult = 1.0

    if player:HasWeaponType(2) then
        if(player:GetPlayerType() == PlayerType.PLAYER_AZAZEL and not player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE)) then mult = mult*0.267
        else mult = mult*0.33 end
    end
    if(player:HasWeaponType(5)) then mult = mult*0.4 end
    if(player:HasWeaponType(7)) then mult = mult*0.23 end
    if(player:HasWeaponType(9) and player:HasCollectible(CollectibleType.COLLECTIBLE_MONSTROS_LUNG)) then mult = mult*0.32 end
    if player:HasWeaponType(10) then mult = mult*0.5 end
    if player:GetCollectibleNum(CollectibleType.COLLECTIBLE_IPECAC) > 0 then
        if not player:HasWeaponType(2) and
        not player:HasWeaponType(4) and
        not player:HasWeaponType(5) and
        not player:HasWeaponType(6) and
        not player:HasWeaponType(8) and
        not player:HasWeaponType(9) and
        not player:HasWeaponType(10) and
        not player:HasWeaponType(13) and
        not player:HasWeaponType(14) then
            mult = mult/3
        end
    end
    if(player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK)) then mult = mult*4
    elseif(player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK)) then mult = mult*5.5 end
    if(player:GetPlayerType() == PlayerType.PLAYER_EVE_B) then mult=mult*0.66 end
    if(player:HasCollectible(CollectibleType.COLLECTIBLE_EVES_MASCARA)) then mult = mult*0.66 end
    if(player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY_2)) then mult = mult*0.66 end
    if(not player:HasCollectible(CollectibleType.COLLECTIBLE_20_20)) then
        if(player:HasCollectible(CollectibleType.COLLECTIBLE_INNER_EYE) or player:GetEffects():HasNullEffect(NullItemID.ID_REVERSE_HANGED_MAN)) then mult = mult*0.51
        elseif(player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER)) then mult = mult*0.42
        elseif(player:HasCollectible(CollectibleType.COLLECTIBLE_POLYPHEMUS) and not player:HasWeaponType(14)) then mult = mult*0.42 end
    end
    if(player:GetEffects():HasNullEffect(NullItemID.ID_REVERSE_CHARIOT)) then mult = mult*4 end
    if(player:GetPlayerType() == PlayerType.PLAYER_JUDAS and player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BIRTHRIGHT) > 0 and player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_DECAP_ATTACK)) then mult = mult*3 end
    local epiphora = player:GetEpiphoraCharge()
    if(epiphora>=270) then mult = mult*2
    elseif(epiphora>=180) then mult = mult*(5/3)
    elseif(epiphora>=90) then mult = mult*(4/3) end
    mult = mult*player:GetD8FireDelayModifier()

    local creepdata = ToyboxMod:isInHallowedCreep(player)
    local auraData = ToyboxMod:isInHallowedAura(player)
    if(auraData[1]>0 or auraData[2]>0 or creepdata>0) then mult = mult*2.5 end

    return mult
end
function ToyboxMod:addBasicTearsUp(player, tears)
    player.MaxFireDelay = ToyboxMod:addTps(player, tears*ToyboxMod:getVanillaTearMultiplier(player))
end

local SPEED_MULT = 10

---@param entity Entity
function ToyboxMod:isScared(entity)
    return (entity:HasEntityFlags(EntityFlag.FLAG_FEAR) or entity:HasEntityFlags(EntityFlag.FLAG_SHRINK))
end

---@param entity Entity
function ToyboxMod:isConfused(entity)
    return (entity:HasEntityFlags(EntityFlag.FLAG_CONFUSION))
end

function ToyboxMod:getWalkAnimPlaybackSpeed(entity, speed, isMoving)
    if(not isMoving) then return 1 end

    return entity.Velocity:Length()/(speed)
end

---@param entity EntityNPC
---@param speed number
function ToyboxMod:walkAnimLogic(entity, speed, walkAnimTb)
    local isWalking = ToyboxMod:isNpcWalking(entity)
    if(isWalking and entity.Velocity:LengthSquared()>0.01) then
        local currAnim = entity:GetSprite():GetAnimation()

        local selAnim = ""

        if(math.abs(entity.Velocity.Y)>math.abs(entity.Velocity.X)) then
            if(entity.Velocity.Y>0) then selAnim=(walkAnimTb[1] or walkAnimTb)
            else selAnim=(walkAnimTb[3] or walkAnimTb[1] or walkAnimTb) end
        else
            if(entity.Velocity.X>0) then selAnim=(walkAnimTb[2] or walkAnimTb[1] or walkAnimTb)
            else selAnim=(walkAnimTb[4] or walkAnimTb[2] or walkAnimTb[1] or walkAnimTb) end
        end

        if(selAnim~=currAnim) then
            entity:GetSprite():Play(selAnim,true)
        end
    end

    entity:GetSprite().PlaybackSpeed = ToyboxMod:getWalkAnimPlaybackSpeed(entity, speed, isWalking)
end

---@param entity EntityNPC
function ToyboxMod:isNpcWalking(entity)
    local anim = entity:GetSprite():GetAnimation()

    if(string.sub(anim,1,4)~="Walk" or entity.FrameCount==1) then return false end
    return true
end

---@param entity EntityNPC
---@param target Entity|Vector
---@param speed number
function ToyboxMod:pathfindingEnemyLogic(entity, target, speed, lerpVal, shouldCheckDist, isConstantlyAfraid)
    if(ToyboxMod:isNpcWalking(entity)) then
        local targetPos = ((target.X~=nil) and target) or target.Position
        local newPos = ToyboxMod:getEntityData(entity, "targetPos")

        local isScared = ToyboxMod:isScared(entity)
        local isConfused = ToyboxMod:isConfused(entity)

        if(isConstantlyAfraid) then
            if(shouldCheckDist) then
                if(targetPos:Distance(entity.Position)<60) then
                    isScared=true
                else
                    isConfused=true
                    speed=speed*0.5
                end
            else
                isScared=true
            end
        end

        local gridCountdown = ToyboxMod:getEntityData(entity, "gridCountdown") or 0

        if(isScared) then
            newPos = entity.Position+(entity.Position-targetPos)
        elseif(isConfused) then
            if(not newPos or entity:IsFrame(25, 0)) then
                newPos = ToyboxMod.GAME:GetRoom():GetRandomPosition(0)
            end
        else
            newPos = target.Position
        end

        ToyboxMod:setEntityData(entity, "targetPos", newPos)

        if(entity.Pathfinder:HasPathToPos(newPos, false) or (isScared or isConfused)) then
            local distCheck = true
            if(shouldCheckDist) then
                local dist = newPos:Distance(entity.Position)
                distCheck=((dist>=100) or (dist<100 and not ToyboxMod.GAME:GetRoom():CheckLine(entity.Position, newPos, 0, 0, false, false)))
            end

            if((entity:CollidesWithGrid() or gridCountdown>0) and distCheck) then

                entity.Pathfinder:FindGridPath(newPos, speed, 1, false)
                ToyboxMod:setEntityData(entity, "gridCountdown", gridCountdown)
            else return ToyboxMod:lerp(entity.Velocity, (newPos - entity.Position):Resized(speed*SPEED_MULT), lerpVal) end
        else return entity.Velocity*0.5 end
    end

    ToyboxMod:walkAnimLogic(entity, speed)
end

function ToyboxMod:angleDifference(a1, a2)
    local dif = (a2-a1)%360
    if(dif>180) then return dif-360 end
    return dif
end

local SHOOT_ACTIONS = {
    ButtonAction.ACTION_SHOOTDOWN,
    ButtonAction.ACTION_SHOOTLEFT,
    ButtonAction.ACTION_SHOOTUP,
    ButtonAction.ACTION_SHOOTRIGHT,
}
function ToyboxMod:isHoldingShootingInput(player)
    local idx = player.ControllerIndex
    for _, action in pairs(SHOOT_ACTIONS) do
        if(Input.IsActionPressed(action, idx)) then
            return true
        end
    end
    return false
end

function ToyboxMod:isPlayerShooting(p)
    return p:GetFireDirection()~=Direction.NO_DIRECTION or p:GetShootingInput():Length()>0.01 or ToyboxMod:isHoldingShootingInput(p)
end

---@param bomb EntityBomb
function ToyboxMod:getBombRadius(bomb)
    local radius
    if(bomb.Variant==BombVariant.BOMB_GIGA or bomb.Variant==BombVariant.BOMB_ROCKET_GIGA or bomb.Flags & TearFlags.TEAR_GIGA_BOMB ~= TearFlags.TEAR_NORMAL) then
        radius = 130.0
    else
        if(bomb.ExplosionDamage>=175.0) then
            radius = 105.0
        else
            if(bomb.ExplosionDamage<=140.0) then
                radius = 75.0
            else
                radius = 90.0
            end
        end
    end

    return radius*bomb.RadiusMultiplier
end

---@param tear EntityTear
function ToyboxMod:getTearAnimSuffix(tear)
    local scale = tear.Scale

	if(scale <= 0.3) then return 1
	elseif(scale <= 0.55) then return 2
	elseif(scale <= 0.675) then return 3
	elseif(scale <= 0.8) then return 4
	elseif(scale <= 0.925) then return 5
	elseif(scale <= 1.05) then return 6
	elseif(scale <= 1.175) then return 7
	elseif(scale <= 1.425) then return 8
	elseif(scale <= 1.675) then return 9
	elseif(scale <= 1.925) then return 10
	elseif(scale <= 2.175) then return 11
	elseif(scale <= 2.55) then return 12
    else return 13 end
end

---@param tear EntityTear
---@param forcePlay boolean?
---@param animPrefix string?
function ToyboxMod:playTearScaleAnim(tear, forcePlay, animPrefix)
    animPrefix = animPrefix or "RegularTear"
    local resAnim = animPrefix..tostring(ToyboxMod:getTearAnimSuffix(tear))
    local sp = tear:GetSprite()

    if(sp:GetAnimation()~=resAnim) then
        if(forcePlay) then
            sp:Play(resAnim, true)
        else
            sp:SetAnimation(resAnim, false)
        end
    end
end

function ToyboxMod:getTearPoofVariantFromTear(tear)
    local s = tear:ToTear().Scale
    local h = tear:ToTear().Height

	if(s > 0.8) then
		if(h < -5) then
			return EffectVariant.TEAR_POOF_A    -- Wall impact
		else
			return EffectVariant.TEAR_POOF_B    -- Floor impact
		end
	elseif(s > 0.4) then
		return EffectVariant.TEAR_POOF_SMALL
	else
		return EffectVariant.TEAR_POOF_VERYSMALL
	end
end

---@param v1 Vector
---@param v2 Vector
function ToyboxMod:dotProduct(v1, v2)
    return v1.X*v2.X+v1.Y*v2.Y
end

local entityPickupGroups = {
    ["5.10.-1"] = "heart",
    ["5.20.-1"] = "coin",
    ["5.30.-1"] = "key",
    ["5.40.-1"] = "bomb",
    ["5.42.-1"] = "poop",
    ["5.50.-1"] = "chest",
    ["5.51.-1"] = "chest",
    ["5.52.-1"] = "chest",
    ["5.53.-1"] = "chest",
    ["5.54.-1"] = "chest",
    ["5.55.-1"] = "chest",
    ["5.56.-1"] = "chest",
    ["5.57.-1"] = "chest",
    ["5.58.-1"] = "chest",
    ["5.60.-1"] = "chest",
    ["5.69.-1"] = "chest",
    ["5.360.-1"] = "chest",
    ["5.70.-1"] = "pill",
    ["5.90.-1"] = "battery",
    ["5.100.-1"] = "item",
    ["5.350.-1"] = "trinket",
    ["6.4.-1"] = "beggar",
    ["6.5.-1"] = "beggar",
    ["6.6.-1"] = "beggar",
    ["6.7.-1"] = "beggar",
    ["6.9.-1"] = "beggar",
    ["6.13.-1"] = "beggar",
    ["6.15.-1"] = "beggar",
    ["6.18.-1"] = "beggar",
    ["6.1.-1"] = "slot",
    ["6.2.-1"] = "slot",
    ["6.3.-1"] = "slot",
    ["6.8.-1"] = "slot",
    ["6.10.-1"] = "slot",
    ["6.12.-1"] = "slot",
    ["6.16.-1"] = "slot",
    ["6.17.-1"] = "slot",
    ["6.19.-1"] = "slot",
    ["1000.161.980"] = "portal",
}
local gridEntityGroups = {
    ["18.-1"] = "ladder",
}

---@param roomDesc RoomDescriptor
function ToyboxMod:getNumPickupGroupsInRoom(roomDesc)
    roomDesc = roomDesc or ToyboxMod.GAME:GetLevel():GetCurrentRoomDesc()

    local numgroups = 0
    local seenGroups = {}

    local entState = roomDesc:GetEntitiesSaveState()
    local gridState = roomDesc:GetGridEntitiesSaveState()

    for i=0, #entState-1 do
        local ent = entState:Get(i)
        if(ent) then
            local str1 = tostring(ent:GetType())
            local str2 = str1.."."..tostring(ent:GetVariant())
            local str3 = str2.."."..tostring(ent:GetSubType())
            str2 = str2..".-1"
            str1 = str1..".-1.-1"

            local group = entityPickupGroups[str1] or entityPickupGroups[str2] or entityPickupGroups[str3] or nil

            if(group and not seenGroups[group]) then
                seenGroups[group] = true
                numgroups = numgroups+1
            end
        end
    end
    for i=0, #gridState-1 do
        local ent = gridState:Get(i)
        if(ent) then
            local str1 = tostring(ent.Type)
            local str2 = str1.."."..tostring(ent.Variant)
            str1 = str1..".-1"

            local group = gridEntityGroups[str1] or gridEntityGroups[str2] or nil

            if(group and not seenGroups[group]) then
                seenGroups[group] = true
                numgroups = numgroups+1
            end
        end
    end

    return numgroups
end

function ToyboxMod:getRoomIconPosOffset(room)
    local numgroups = ToyboxMod:getNumPickupGroupsInRoom(room)+1
    if(numgroups==2) then
        return Vector(-4,0)
    end
    if(numgroups>2) then
        return Vector(-4,-4)
    end
    return Vector(0,0)
end

---@generic T
---@param tbl T
---@param deeperCopy? boolean
---@param seen? table<table, table>
---@param initTable? T
---@return T
function ToyboxMod:deepCopy(tbl, deeperCopy, seen, initTable)
    seen = seen or {}

    if seen[tbl] then
        return seen[tbl]
    end

    initTable = initTable or {}
    local copy = initTable

    seen[tbl] = copy

    for k, v in pairs(tbl) do
        local newK = deeperCopy and type(k) == "table" and ToyboxMod:deepCopy(k, true, seen) or k
        local newV = deeperCopy and type(v) == "table" and ToyboxMod:deepCopy(v, true, seen, initTable[k]) or v

        copy[newK] = newV
    end

    return copy
end

---@param dest Entity
---@param source Entity
function ToyboxMod:copyEntityData(dest, source)
    local copiedData = ToyboxMod:deepCopy(source:GetData(), true)
    for key, val in pairs(copiedData) do
        dest:GetData()[key] = val
    end
end

function ToyboxMod:getExtraHudOffset()
    local pos = Vector(20,12)*Options.HUDOffset
    local pl = Isaac.GetPlayer()

    if(pl:GetPlayerType()==PlayerType.PLAYER_ISAAC_B or pl:GetPlayerType()==PlayerType.PLAYER_BLUEBABY_B) then
        pos = pos+Vector(0,26)
    end
    if(pl:HasCollectible(ToyboxMod.COLLECTIBLE_PEZ_DISPENSER)) then
        pos = pos+Vector(0,16)
    end

    return pos
end

--- stolen from Foks <3 thank you
function ToyboxMod:getBloodTearVariant(tear)
	local bloodVariant = {
		[TearVariant.BLUE] = TearVariant.BLOOD,
		[TearVariant.CUPID_BLUE] = TearVariant.CUPID_BLOOD,
		[TearVariant.NAIL] = TearVariant.NAIL_BLOOD,
		[TearVariant.PUPULA] = TearVariant.PUPULA_BLOOD,
		[TearVariant.GODS_FLESH] = TearVariant.GODS_FLESH_BLOOD,
		[TearVariant.GLAUCOMA] = TearVariant.GLAUCOMA_BLOOD,
		[TearVariant.EYE] = TearVariant.EYE_BLOOD,
		--[TearVariant.KEY] = TearVariant.KEY_BLOOD,
	}
	return bloodVariant[type(tear) == "number" and tear or tear.Variant] -- You can either just put the tear entity there or get the variant from a number
end

---@param col Color
function ToyboxMod:colorInverse(col)
    local colorize = col:GetColorize()
    return Color(1/col.R, 1/col.G, 1/col.B, 1/col.A, -col.RO, -col.GO, -col.BO, -colorize.R, -colorize.G, -colorize.B, -colorize.A)
end

---@param roomType RoomType|string
---@param roomVariant integer?
---@param rng RNG
---@param visited boolean? If `nil`, ignores whether the destination room should be visited or not
---@param ignoreGroup boolean?
function ToyboxMod:getRandomSpecialRoom(roomType, rng, roomVariant, visited, ignoreGroup)
    if(roomType==ToyboxMod.SPECIAL_ROOM_TYPE_TEMPLATE and type(roomVariant)=="string") then
        roomVariant = ToyboxMod.ROOM_TYPE_DATA[roomVariant].Id
    elseif(type(roomType)=="string") then
        roomVariant = ToyboxMod.ROOM_TYPE_DATA[roomType].Id
        roomType = ToyboxMod.SPECIAL_ROOM_TYPE_TEMPLATE
    end

    local level = ToyboxMod.GAME:GetLevel()

    local currentGroup = level:GetCurrentRoomDesc():GetGroup()
    local foundRooms = {}
    for i=0, 168 do
        local room = level:GetRoomByIdx(i)
        if(room.Data and room.Data.Type==roomType and (roomVariant==nil or room.Data.Subtype==roomVariant)) then
            if(ignoreGroup or room:GetGroup()==currentGroup) then
                if((visited==nil) or (room.VisitedCount~=0)==(visited or false)) then
                    table.insert(foundRooms, room.SafeGridIndex)
                end
            end
        end
    end

    if(#foundRooms>0) then
        return foundRooms[rng:RandomInt(1,#foundRooms)]
    end
end

---@param r number
---@param g number
---@param b number
---@return hue number, sat number, lum number
function ToyboxMod:rgb2Hsl(r, g, b)
    local hue, sat, lum = 0, 0, 0
    local colMax, colMin = math.max(r, g, b), math.min(r, g, b)
    local colDif = colMax-colMin

    lum = (colMax+colMin)/2;
    if(math.abs(colDif)>0.01) then
        sat = colDif/(1-math.abs(2*lum-1))

        if(colMax==r) then
            hue = ((g-b)/colDif)%6
        elseif(colMax==g) then
            hue = ((b-r)/colDif+2)
        else
            hue = ((r-g)/colDif+4)
        end
    end

    return hue/6, sat, lum
end

---@param h number
---@param s number
---@param l number
---@return red number, green number, blue number
function ToyboxMod:hsl2Rgb(h, s, l)
    h = h*6

    local red, grn, blu = 0, 0, 0
    local c = (1-math.abs(2*s-1))*l
    local x = c*(1-math.abs(h%2)-1)

    if(h<=1) then red = c; grn = x
    elseif(h<=2) then red = x; grn = c
    elseif(h<=3) then grn = c; blu = x
    elseif(h<=4) then grn = x; blu = c
    elseif(h<=5) then red = x; blu = c
    else red = c; blu = x end

    return red+(s-c/2), grn+(s-c/2), blu+(s-c/2)
end



---@param topLeft Vector
---@param bottomRight Vector
---@param sourceQuad boolean? default: true
---@param uv boolean?
---@param render boolean?
function ToyboxMod:makeQuadFromCorners(topLeft, bottomRight, sourceQuad, uv, render)
    local topRight = Vector(bottomRight.X, topLeft.Y)
    local bottomLeft = Vector(topLeft.X, bottomRight.Y)

    if(render) then
        topLeft = Isaac.WorldToRenderPosition(topLeft)
        topRight = Isaac.WorldToRenderPosition(topRight)
        bottomLeft = Isaac.WorldToRenderPosition(bottomLeft)
        bottomRight = Isaac.WorldToRenderPosition(bottomRight)
    end

    if(sourceQuad or sourceQuad==nil) then
        return SourceQuad(topLeft, topRight, bottomLeft, bottomRight, uv)
    else
        return DestinationQuad(topLeft, topRight, bottomLeft, bottomRight)
    end
end

---@param center Vector
---@param radius number|Vector
---@param rotation number? default: 0
---@param sourceQuad boolean? default: true
---@param uv boolean?
---@param render boolean?
function ToyboxMod:makeQuadFromCenterRadius(center, radius, rotation, sourceQuad, uv, render)
    radius = Vector(1,1)*radius
    rotation = rotation or 0

    local topLeft = center+radius:Rotated(-180+rotation)
    local topRight = center+radius:Rotated(-90+rotation)
    local bottomLeft = center+radius:Rotated(90+rotation)
    local bottomRight = center+radius:Rotated(0+rotation)

    if(render) then
        topLeft = Isaac.WorldToRenderPosition(topLeft)
        topRight = Isaac.WorldToRenderPosition(topRight)
        bottomLeft = Isaac.WorldToRenderPosition(bottomLeft)
        bottomRight = Isaac.WorldToRenderPosition(bottomRight)
    end

    if(sourceQuad or sourceQuad==nil) then
        return SourceQuad(topLeft, topRight, bottomLeft, bottomRight, uv)
    else
        return DestinationQuad(topLeft, topRight, bottomLeft, bottomRight)
    end
end