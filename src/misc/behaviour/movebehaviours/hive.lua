


local HIVE={}

local Partitions = require("src.misc.unique.partition_targets")



function HIVE:init(e)
    local move = e.behaviour.move

    local sum_x = 0
    local sum_y = 0
    local tot = 0

    for ent in Partitions[move.id]:foreach(e.pos.x, e.pos.y) do
        sum_x = sum_x + ent.pos.x
        sum_y = sum_y + ent.pos.y
        tot = tot + 1
    end

    if tot ~= 0 then
        move.target = math.vec3(sum_x/tot, sum_y/tot, 0)
    else
        move.target = nil
    end
end


function HIVE:update(e,dt)
    local target = e.behaviour.move.target
    if target then
        self.updateGotoTarget(e, target.x, target.y, dt)
    else
        -- If no goto target, stay still. (Behaviour tree should sort this shit out :/ )
        self.updateGotoTarget(e, e.pos.x, e.pos.y, dt)
    end
end


function HIVE:h_update(e)
    local move = e.behaviour.move

    local sum_x = 0
    local sum_y = 0
    local tot = 0

    for ent in Partitions[move.id]:foreach(e.pos.x, e.pos.y) do
        sum_x = sum_x + ent.pos.x
        sum_y = sum_y + ent.pos.y
        tot = tot + 1
    end

    if tot > 0 then
        move.target = math.vec3(sum_x/tot, sum_y/tot, 0)
    else
        move.target = nil 
    end
end


return setmetatable(HIVE, require(Tools.Path(...)..".base"))
