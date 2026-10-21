local DELAY_FRAMES = 6

local HOOK_TO_FUNC = {
    [InputHook.IS_ACTION_PRESSED] = "IsActionPressed",
    [InputHook.IS_ACTION_TRIGGERED] = "IsActionTriggered",
    [InputHook.GET_ACTION_VALUE] = "GetActionValue",
}

local function inputDiddy(_, ent, hook, action)
    local player = ent and ent:ToPlayer()
    if(not player) then return end

    local data = ToyboxMod:getEntityDataTable(player)
    if(not data.DELAYED_INPUTS) then return end

    local str = tostring(hook).."."..tostring(action)

    if(data.DELAYED_INPUTS[1] and data.DELAYED_INPUTS[1][str] ~= nil) then
        return data.DELAYED_INPUTS[1][str]
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_INPUT_ACTION, inputDiddy)

local function playerUpdate(_, player)
    local data = ToyboxMod:getEntityDataTable(player)
    if(not player:HasCollectible(ToyboxMod.COLLECTIBLE_BLOODY_VINE)) then
        data.DELAYED_INPUTS = nil
        return
    end

    if(not data.DELAYED_INPUTS or #data.DELAYED_INPUTS<DELAY_FRAMES) then
        data.DELAYED_INPUTS = {}
        for i=1, DELAY_FRAMES do
            data.DELAYED_INPUTS[i] = {}
        end
    end

    table.remove(data.DELAYED_INPUTS, 1)

    data.DELAYED_INPUTS[DELAY_FRAMES] = {}
    for _, hook in pairs(InputHook) do
        for _, action in pairs(ButtonAction) do
            local val = Input[HOOK_TO_FUNC[hook]](action, player.ControllerIndex)
            local str = tostring(hook).."."..tostring(action)

            data.DELAYED_INPUTS[DELAY_FRAMES][str] = val
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, playerUpdate)