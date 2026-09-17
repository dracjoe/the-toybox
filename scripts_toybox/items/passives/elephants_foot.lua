local function postNewRoom(_)
    local room = ToyboxMod.GAME:GetRoom()
    if(room:IsFirstVisit() and not room:IsClear()) then
        for _=1, PlayerManager.GetNumCollectibles(ToyboxMod.COLLECTIBLE_ELEPHANTS_FOOT) do
            local failsafe = 100
            local pos = nil
            while(failsafe>0 and not pos) do
                local idx = room:GetGridIndex(room:GetRandomPosition(0))
                if(room:CanSpawnObstacleAtPosition(idx, false) and room:GetGridCollision(idx)==GridCollisionClass.COLLISION_NONE) then
                    pos = room:GetGridPosition(idx)
                    if(pos:Distance(room:GetClampedPosition(pos, 40))>0) then pos = nil end
                end
                failsafe = failsafe-1
            end

            local poop = Isaac.Spawn(1000, ToyboxMod.EFFECT_GRID_HELPER, ToyboxMod.GRID_NUCLEAR_POOP, pos, Vector.Zero, nil):ToEffect()
        end
    end
end
ToyboxMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, postNewRoom)