
--[[


Spacial partitions exclusively for targettable entities.



Although un-elegant, these structures bring down the AI time complexity by a lot

The system in charge of running this is `TargetSys`,
inside the file `MoveBehaviourSys.lua`.



]]



local MAX_VEL = CONSTANTS.MAX_VEL

local IDS = {
    "player", -- Players / Allies
    "enemy", -- enemy
    "neutral", -- Neutral weak mob
    "physics", -- physics obj
    "coin", -- coin

    "teleporter", -- teleporter
    "key", -- key 
}


local Partitions = {}

for _, val in ipairs(IDS) do
    Partitions[val] = require("libs.spacial_partition.partition")(MAX_VEL * CONSTANTS.MAX_DT, MAX_VEL * CONSTANTS.MAX_DT)
end



return Partitions



