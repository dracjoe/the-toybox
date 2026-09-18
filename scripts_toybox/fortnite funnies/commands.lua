local COMMANDS = {
    EVALCACHE = {
        Name = "evalcache",
        Description = "Re-evaluates cache for all players",
        Function = function(data, params)
            for _, pl in ipairs(PlayerManager.GetPlayers()) do
                pl:AddCacheFlags(CacheFlag.CACHE_ALL)
                pl:EvaluateItems()
            end
        end
    },
    FULLMAP = {
        Name = "fullmap",
        Description = "Macro for granting the map-revealing items",
        Function = function(data, params)
            for _, pl in ipairs(PlayerManager.GetPlayers()) do
                pl:AddCollectible(CollectibleType.COLLECTIBLE_MIND)
                pl:AddCollectible(CollectibleType.COLLECTIBLE_BLACK_CANDLE)
            end
        end
    },
    LIONSKULL = {
        Name = "lionskull",
        Description = "Spawns a special Lion Skull",
        Function = function(data, params)
            
        end
    },
    HYBRID = {
        Name = "hybrid",
        Description = "Spawns a hybrid item pedestal",
        Help = "Spawns a hybrid item pedestal;\n First param is a comma-separated list of desired collectible/trinket IDs; Second param (optional) is the desired grid index to spawn the pedestal at. (e.g \"hybrid c1,c2,t1,T2 71\")",
        Function = function(data, params)
            local findSpace = string.find(params, " ")
            local firstParam = string.sub(params, 1, (findSpace or 0)-1)

            local stored = {}

            while(firstParam~="") do
                local findComma = string.find(firstParam, ",")

                local sub = string.sub(firstParam, 1, (findComma or 0)-1)
                
                local hybridData = {}
                hybridData.ID = tonumber(string.sub(sub, 2, -1)) or 1
                if(string.sub(sub, 1,1)=="c") then
                    hybridData.IsTrinket = false
                elseif(string.sub(sub, 1,1)=="T") then
                    hybridData.ID = hybridData.ID | TrinketType.TRINKET_GOLDEN_FLAG
                end
                table.insert(stored, hybridData)

                if(not findComma) then break end
                firstParam = string.sub(firstParam, findComma+1, -1)
            end

            local room = ToyboxMod.GAME:GetRoom()
            local desiredPos = room:GetCenterPos()
            if(findSpace) then
                local secondParam = string.sub(params, findSpace+1, -1)
                if(tonumber(secondParam)) then
                    desiredPos = room:GetGridPosition(tonumber(secondParam))
                end
            end
            desiredPos = room:FindFreePickupSpawnPosition(desiredPos, 0)

            local firstItem
            for i=1, #stored do
                if(stored[i].IsTrinket==false) then
                    firstItem = stored[i].ID
                    table.remove(stored, i)
                    break
                end
            end

            if(not firstItem) then return end

            local item = Isaac.Spawn(5,100,firstItem,desiredPos,Vector.Zero,nil):ToPickup()
            if(#stored>0) then
                ToyboxMod:addHybridPedestal(item, stored)
            end
        end,
        --[[] ]
        Autocomplete = function(data, command, params)
            return data.List
        end,
        List = {},
        Init = function(self)
            local conf = Isaac.GetItemConfig()
            for i=1, conf:GetCollectibles().Size-1 do
                local item = conf:GetCollectible(i)
                if(item) then
                    local localizedName = Isaac.GetString("Items", item.Name)
                    local name = (localizedName=="StringTable::InvalidKey" and item.Name or localizedName)

                    table.insert(self.List, {name, "c"..tostring(item.ID)})
                end
            end
            for i=1, conf:GetTrinkets().Size-1 do
                local item = conf:GetTrinket(i)
                if(item) then
                    local localizedName = Isaac.GetString("Items", item.Name)
                    local name = (localizedName=="StringTable::InvalidKey" and item.Name or localizedName)

                    table.insert(self.List, {name, "t"..tostring(item.ID)})
                end
            end
        end
        --]]
    },
}

for _, data in pairs(COMMANDS) do
    if(data.Init) then
        data:Init()
    end
    Console.RegisterCommand(data.Name, data.Description or "", data.Help or data.Description or "", true, data.Autocomplete and (type(data.Autocomplete)=="function" and AutocompleteType.CUSTOM or data.Autocomplete) or AutocompleteType.NONE)
end

local function executeCmd(_, cmd, params)
    for _, data in pairs(COMMANDS) do
        if(cmd==data.Name) then
            data:Function(params)
            return
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, executeCmd)

local function autocompleteCmd(_, cmd, params)
    for _, data in pairs(COMMANDS) do
        if(cmd==data.Name and type(data.Autocomplete)=="function") then
            return data:Autocomplete(cmd, params)
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_CONSOLE_AUTOCOMPLETE, autocompleteCmd)