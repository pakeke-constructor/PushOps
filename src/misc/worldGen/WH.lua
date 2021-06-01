
--[[

world construction helper functions
(similar to EH.)


]]

local WH = setmetatable({},{__index=error})



local LIGHT_PLACEMENT_OFFSET = 200
local LIGHT_PLACEMENT_R_AMPLITUDE = 300
local rand = love.math.random

function WH.lights(world, worldMap, num_lights, light_distance)
    local size_x = world.x * 64
    local size_y = world.y * 64
    print("Sizes:" , size_x, size_y)
    assert(num_lights, "expected a number of lights")
    local ct =  math.ceil(math.sqrt(num_lights))
    for x = 1, ct do
        for y = 1, ct do
            local properwidth = size_x - (LIGHT_PLACEMENT_OFFSET*2)
            local properheight = size_y - (LIGHT_PLACEMENT_OFFSET*2)
            local x = (properwidth) * (x / ct) + LIGHT_PLACEMENT_OFFSET --+ (rand()-0.5)*2*LIGHT_PLACEMENT_R_AMPLITUDE
            local y = (properheight) * (y / ct) + LIGHT_PLACEMENT_OFFSET --+ (rand()-0.5)*2*LIGHT_PLACEMENT_R_AMPLITUDE

            local light = EH.Ents.light(x,y)
            light.distance = light_distance
        end
    end
end


function WH.zonenum(tier, px, py)
    local txt = "zone " .. math.roman(tier)
    ccall("spawnText", px, py - 60, txt, 600, 10)
end


return WH
