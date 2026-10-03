ToyboxMod.ACHIEVEMENTS = {
    COMPLETION_MARKS = {},
    MISCELLANEOUS = {},
}

---@param playerType PlayerType
---@param mark CompletionType
---@param threshold Difficulty?
function ToyboxMod:completionMarkCondition(playerType, mark, threshold)
    return function()
        return (Isaac.GetCompletionMark(playerType, mark) or 0)>(threshold or Difficulty.DIFFICULTY_NORMAL)
    end
end
---@param playerType PlayerType
---@param threshold Difficulty?
function ToyboxMod:allMarkCondition(playerType, threshold)
    return function()
        return (Isaac.AllMarksFilled(playerType) or 0)>(threshold or Difficulty.DIFFICULTY_NORMAL)
    end
end

---@param achievement Achievement
---@param condition fun(pgd: PersistentGameData, pdt: table): boolean
---@param completionMarkUnlock boolean?
function ToyboxMod:addAchievement(achievement, condition, completionMarkUnlock)
    local achData = {
        Achievement = achievement,
        Condition = condition,
    }

    if(completionMarkUnlock==nil) then completionMarkUnlock=true end

    if(completionMarkUnlock) then
        table.insert(ToyboxMod.ACHIEVEMENTS.COMPLETION_MARKS, achData)
    else
        table.insert(ToyboxMod.ACHIEVEMENTS.MISCELLANEOUS, achData)
    end
end

include("scripts_toybox.util.achievements.enums")

---@param completionUnlocks boolean
---@param blockPaper boolean?
function ToyboxMod:checkUnlocks(completionUnlocks, blockPaper)
    local key = "MISCELLANEOUS"
    if(completionUnlocks) then
        key = "COMPLETION_MARKS"
    end

    local toyboxpersistentdata = ToyboxMod:getPersistentDataTable()
    local persistentdata = Isaac.GetPersistentGameData()

    for _, unlockData in ipairs(ToyboxMod.ACHIEVEMENTS[key]) do
        if(unlockData.Condition(persistentdata, toyboxpersistentdata)) then
            persistentdata:TryUnlock(unlockData.Achievement, blockPaper)
        else
            --Isaac.ExecuteCommand("lockachievement " .. unlockData.Achievement)
        end
    end
end

local function checkUnlockOnInit(_)
    ToyboxMod:checkUnlocks(true)
    ToyboxMod:checkUnlocks(false)
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, checkUnlockOnInit)

local function checkUnlocksOnCompletion(_, mark)
    ToyboxMod:checkUnlocks(true)
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_COMPLETION_EVENT, checkUnlocksOnCompletion)

local function checkUnlocksOnChallenge(_, mark)
    ToyboxMod:checkUnlocks(true)
    ToyboxMod:checkUnlocks(false)
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_CHALLENGE_DONE, checkUnlocksOnChallenge)