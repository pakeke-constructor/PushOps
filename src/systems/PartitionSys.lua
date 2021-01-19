



local PartitionSys = Cyan.System("pos", "vel")

local partition = require("src.misc.partition")


function PartitionSys:added(ent)
    partition:add( ent )
end


function PartitionSys:_setPos(ent, x, y)
    --[[
        Why the underscore?  See MoveSys:setPos(e, x, y).
            (This is a private callback)

        reasoning:
        direct ent position must be set AFTER all the setPosition calls go through,
        for every partition, or else the ent position will be too volatile for other
        partitions to find
    ]]
    partition:setPosition(ent,x,y)
end


function PartitionSys:removed( ent )
    partition:remove( ent )
end


function PartitionSys:update(dt)
    partition:update()
end

