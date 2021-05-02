
--[[

This system deals with the splat effect
seen when there are multiple blocks in an area


Comes with component "splatted"


Question: Is it possible to remove splatted blocks from the physics
partition?
This would make this operation 1000 times faster...

]]



local SPLAT_TIME = 0.2

local SPLAT_TIME_VAR = 0.15


local DEFAULT_SPLAT_DIST = 70


local PartitionTargets = require("src.misc.unique.partition_targets")

local PhysPartition = PartitionTargets.physics
assert(PhysPartition, "problem, housten")

local dist = Tools.dist
local ccall = Cyan.call


local SPLAT_COLOUR = CONSTANTS.SPLAT_COLOUR-- Change this if you want



local SplatSys = Cyan.System()




local function endSplat(ent)
    -- TODO: play a sound here
    ccall("emit", "splat", ent.pos.x, ent.pos.y, ent.pos.z, 16)
    ccall("splat", ent.pos.x, ent.pos.y, nil)
    ccall("kill",ent)
end


local rand = love.math.random
local WHITE = {1,1,1,1}


local function splat(ent)
    -- splats an ent

    if ent.splatImmune then
        -- its already been splatted
        return
    end

    ent.splatImmune = true

    ent:remove("targetID") -- this physics obj is gonna die anyway.
    -- we can save some time in the loop by removing from phys partition

    -- TODO: play a sound here too

    local colour = ent.colour or WHITE
    ent.colour = {colour[1] * SPLAT_COLOUR[1],
                  colour[2] * SPLAT_COLOUR[2],
                  colour[3] * SPLAT_COLOUR[3]}
    ccall("await", endSplat, SPLAT_TIME + (rand()-0.5)*SPLAT_TIME_VAR, ent)
end



function SplatSys:splat(x,y, range)
    range = range or DEFAULT_SPLAT_DIST
    local ct = 0
    
    for ent in PhysPartition:iter(x,y)do
        local pos = ent.pos
        if (pos.y ~= y) and (pos.x ~= x) then
            -- it has infected one entity
            if dist(x - pos.x, y - pos.y) < range then
                ct = ct + 1
                splat(ent)
            end
        end
    end
    if ct > 0 then
        ccall("shockwave", x, y, 0, range * 1.5, 8, 0.14,
            {SPLAT_COLOUR[1],
            SPLAT_COLOUR[2],
            SPLAT_COLOUR[3]})
    end
end




