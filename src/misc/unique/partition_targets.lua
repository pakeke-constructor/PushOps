
--[[


Spacial partitions exclusively for targettable entities.



Although un-elegant, these structures bring down the AI time complexity by a lot

The system in charge of running this is `TargetSys`,
inside the file `MoveBehaviourSys.lua`.



]]


local MAX_VEL = CONSTANTS.MAX_VEL

local IDS = {
    1, -- Players / Allies
    2, -- enemy
    3, -- Neutral weak mob
    4  -- physics obj
}

local Partitions = {}

for _, val in pairs(IDS) do
    Partitions[val] = require("libs.spacial_partition.partition")(MAX_VEL * CONSTANTS.MAX_DT, MAX_VEL * CONSTANTS.MAX_DT)
end



return Partitions



