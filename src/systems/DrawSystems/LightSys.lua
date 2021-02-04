

local LightSys = Cyan.System("light")

-- shader consts.
local BASE_LIGHTING = {0.5, 0.5, 0.5, 1}
local MAX_LIGHT_STRENGTH = 0.5
local NUM_LIGHTS = 20 -- max N



local cam = require("src.misc.unique.camera")
-- X, Y  =  cam:toCameraCoords(x,y)

local shader = require("src.misc.unique.shader")


local getW = love.graphics.getWidth
local getH = love.graphics.getHeight


function LightSys:added(e)
    if (not e.light.colour) or (not e.light.distance) then
        error("LightSys: entity added is missing a required field")
    end
    if #e.light.colour ~= 4 then
        error("ent.light.colour expected to be a 4d vector")
    end
end



local function send(e, light_positions, light_colours, light_distances)
    local x,y = cam:toCameraCoords(
        e.pos.x,
        e.pos.y
    )
    table.insert(light_positions, {x,y})
    table.insert(light_colours,   e.light.colour)
    table.insert(light_distances, e.light.distance * cam.scale)
end




function LightSys:update()
    local light_positions = {}
    local light_colours   = {}
    local light_distances = {}

    for _, e in ipairs(self.group)do
        if Tools.isOnScreen(e, cam) then
            send(e, light_positions, light_colours, light_distances)
        end
    end

    assert((#light_positions == #light_colours)
        and (#light_positions == #light_distances), "???")

    -- This sucks.
    --TODO: Convert this to a matrix so you can do it efficiently please
    for i=1, 20-#light_positions do
        table.insert(light_positions, {0,0})
        table.insert(light_colours  , {0,0,0,0})
        table.insert(light_distances, 0)
    end

    local unpack = table.unpack or unpack -- F**CK. This breaks JIT, I didnt want to do this. No choice tho
    shader:send("light_positions", unpack(light_positions))
    shader:send("light_colours"  , unpack(light_colours))
    shader:send("light_distances", unpack(light_distances))
    shader:send("num_lights", NUM_LIGHTS)
    shader:send("base_lighting", BASE_LIGHTING)
    shader:send("max_light_strength", MAX_LIGHT_STRENGTH)
end

