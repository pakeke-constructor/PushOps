



local PartitionSys = Cyan.System("pos", "vel")


local partition = require("src.misc.partition")



function PartitionSys:added(ent)
    partition:add( ent )
end


function PartitionSys:removed( ent )
    partition:remove( ent )
end


function PartitionSys:update(dt)
    partition:update()
end

