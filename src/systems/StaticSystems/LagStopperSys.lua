
local LSSys = Cyan.System(
    --[[
This is a system that automatically kills physics objects if there are too
many in a small area.

(Make sure to do `ccall(kill)` as opposed to just deleting, so we get cool
death effects)
    ]]
)


-- spatial partition size
local P_SIZE = CONSTANTS.MAX_VEL * CONSTANTS.MAX_DT

-- the max num of physics objs in a partition bucket
local PHYS_CAP = CONSTANTS.PHYS_CAP 


local Cam = require("src.misc.unique.camera")

local BlockPartition = require("src.misc.unique.partition_targets").physics


function LSSys:update(dt)
    for x=-1,1 do
        for y=-1,1 do
            local X, Y = Cam.x + x*P_SIZE, Cam.y + y*P_SIZE

            local len = BlockPartition:size(X,Y)
            if len > PHYS_CAP then
                local ct = 0
                for ent in BlockPartition:iter(X,Y) do
                    if ct >= (len - PHYS_CAP) then
                        break
                    end
                    ct = ct + 1
                    ccall("kill", ent)
                end
            end
        end
    end
end


