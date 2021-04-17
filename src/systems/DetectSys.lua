

--[[

For detecting collisions/ent detections within certain ranges.

A good way to do this would be to have the components point to functions somehow.
But how to store the data...? Not sure. Definitely use targetID tho


]]

local DetectSys = Cyan.System("pos", "collisions")


local PartitionTargets = require("src.misc.unique.partition_targets") 





function DetectSys:added(e)
    if e.collisions[1] then
        error("You are using `collisions` component incorrectly, see `components.md`")
    end

    if e.collisions.area then
        local targets = { }

        for k,v in pairs(e.collisions.area) do
            if not PartitionTargets[k] then
                error("Misuse of e.collisions component. See components.md")
            end
            table.insert(targets, k)
        end

        e.collisions.areaTargets = targets
    end

    -- Backref so pairs doesn't need to be done.
    -- Note that this also makes it so that component `collisions` 
    -- cannot be modified at runtime.
end



local dist = Tools.dist



local er1 = "Collision entity had no position component, WAT?????? why is this in the partition"




function DetectSys:collide(e1, e2, speed)
    local collisions = e1.collisions
    
    if collisions.physics then
        collisions.physics(e1,e2,speed)
    end
end



local function S_update(e, dt)
    --[[
        We don't need to worry about `collisions.physics`,
        that is handled seperately by the physics system;
        we just need to listen for any ccall("collide") events.
    ]]
    local pos = e.pos
    local collisions = e.collisions
    local area = collisions.area

    if collisions.areaTargets then
        for _, targetID in ipairs(collisions.areaTargets)do
            if not PartitionTargets[targetID] then
                error("unknown target ID:  " .. tostring(targetID))
            end
            for col_ent in PartitionTargets[targetID]:iter(pos.x, pos.y) do
                
                if not(col_ent == e) then
                -- Ent shouldn't interact with itself
                    
                    local colpos = col_ent.pos

                    local d = dist(pos.x - colpos.x,  pos.y - colpos.y)

                    if d < ((e.size or 5) + (col_ent.size or 5)) then
                        area[targetID](e, col_ent, dt)
                    end
                end
            end
        end
    end
end




function DetectSys:update(dt)
    for _, e in ipairs(self.group) do
        S_update(e, dt)
    end
end





