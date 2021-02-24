
--[[

Main spacial partition scheme.

Note that there is an extra, smaller partitioning scheme directly
created in `MoveBehaviourSys`.
This smaller partitioner only involves ents with `target` components, and
there is one of them for each target group.


]]

local MAX_VEL = CONSTANTS.MAX_VEL;


-- We add 0.01 off to account for floating point errors. A missed entity search due to
-- ent skipping a cell would be catastrophic and crash program
local p_MAX_VEL = MAX_VEL + 0.01





local partition = require("libs.spatial_partition.partition")(
    p_MAX_VEL * CONSTANTS.MAX_DT,  p_MAX_VEL * CONSTANTS.MAX_DT
)






return partition
