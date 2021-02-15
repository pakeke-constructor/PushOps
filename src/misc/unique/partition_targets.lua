
--[[


Spacial partitions exclusively for targettable entities.



Although un-elegant, these structures bring down the AI time complexity by a lot

The system in charge of running this is `TargetSys`,
inside the file `MoveBehaviourSys.lua`.



]]



local MAX_VEL = CONSTANTS.MAX_VEL

--[[
Target groups: 


-- "player" :: player / ally
-- "enemy" :: enemy
-- "neutral" :: neutral / weak mob
-- "physics" :: physics object
-- "coin"    :: coin
-- "interact" :: shop, portal, artefact


]]


local Partitions = {}

for _, val in ipairs(CONSTANTS.TARGET_GROUPS) do
    Partitions[val] = require("libs.spacial_partition.partition")(MAX_VEL * CONSTANTS.MAX_DT, MAX_VEL * CONSTANTS.MAX_DT)
end



return Partitions



