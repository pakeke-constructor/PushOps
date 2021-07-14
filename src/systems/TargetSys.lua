


local TargetSys = Cyan.System("targetID", "pos")

local set = Tools.set


-- Hasher of spacial partitions for each target group
local Partitions = require("src.misc.unique.partition_targets") 

-- Hasher of sets for SOME target groups. (NOT ALL!!  see the below file:    )
-- (As in, each set contains the ents for one target group)
local Sets = require("src.misc.unique.sset_targets")


-- a hasher { [ent] => set() } 
-- that lists all the entities that are targetting another entity
local TargettedEntities = require("src.misc.behaviour.movebehaviours.targetted_entities")



local valid_targetIDs--[[ = {
    player    =true,
    enemy     =true,
    physics   =true,
    neutral   =true,
    coin      =true,
    interact  =true
}]]
valid_targetIDs = {}
for _,t_group in ipairs(CONSTANTS.TARGET_GROUPS) do
    valid_targetIDs[t_group] = true
end


local er1 = "Target component is not valid:  "
function TargetSys:added(ent)
    if not valid_targetIDs[ent.targetID] then
        error(er1 .. tostring(ent.targetID))
    end

    local tid = ent.targetID

    Partitions[tid]:add(ent) -- Adds to the correct spatial partition

    if Sets[tid] then
        Sets[tid]:add(ent)
    end
end



local partition_keys = {}
for t_id, _ in pairs(Partitions) do
    table.insert(partition_keys, t_id)
end


function TargetSys:update(dt)
    local partition
    for _, p_key in ipairs(partition_keys) do
        partition = Partitions[p_key]
        partition:update(dt)
    end
end


function TargetSys:_setPos(ent,x,y)
    --[[
        Why the underscore?  See MoveSys:setPos(e, x, y).
            (This is a private callback)

        reasoning:
        direct ent position must be set AFTER all the setPosition calls go through,
        for every partition, or else the ent position will be too volatile PartitionSys
        to find.
    ]]
    if ent.targetID then
        Partitions[ent.targetID]:setPosition(ent,x,y)
    end
end


function TargetSys:removed(ent)
    local tid = ent.targetID

    Partitions[tid]:remove(ent)

    if rawget(TargettedEntities, ent) then
        -- This means we still got entities targetting this ent,
        -- So we must re-initialize all the entities that were targetting
        -- this ent.
        for _, e in ipairs(TargettedEntities[ent].objects) do
            local move = e.behaviour.move
            move.initialized = false
            --MoveTypes[move.type]:init(e)  -- We shouldn't call :init directly like this!
            TargettedEntities[ent]:remove(e)
        end
        rawset(TargettedEntities, ent, nil)
    end

    if Sets[tid] then
        Sets[tid]:remove(ent)
    end
end


