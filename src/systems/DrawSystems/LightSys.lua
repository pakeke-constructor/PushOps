

local LightSys = Cyan.System("light")

-- shader consts.
local BASE_LIGHTING = {0.7, 0.7, 0.7, 1}
local MAX_LIGHT_STRENGTH = 0.45
local NUM_LIGHTS = 20 -- max N
local BRIGHTNESS_MODIFIER = 4 -- all light strengths divided by 100



local cam = require("src.misc.unique.camera")
-- X, Y  =  cam:toCameraCoords(x,y)

local shader = require("src.misc.unique.shader")


local getW = love.graphics.getWidth
local getH = love.graphics.getHeight


function LightSys:setBaseLighting(newValue)
    BASE_LIGHTING = newValue
end


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




local function makeLight(ent, distance, time, colour, fade)
    --[[
        constructs the rest of fields for light source
    ]]
    ent.hp.hp = time
    ent.hp.max_hp = time
    ent.hp.regen = -1 -- gets -1 hp per second
    ent.light.distance=distance

    if fade then
        ent.hybrid = true
        -- onUpdate function is specified in `ents -> light.lua`

        -- cache original distance of light
        ent.original_distance = distance
    end
end

local DEFAULT_LIGHT_COL = {1,1,1,1}

function LightSys:light(x, y, distance, time, colour, fade)
    --[[
        colour is colour of light
        distance is distance

        time is how long it exists for

        fade = true/false
            If fade is true, the light will linearly fade to black
    ]]
    colour = colour or DEFAULT_LIGHT_COL
    assert(#colour == 4, "must be 4d vector for colour thx")

    time = time or 0xffffffffffffffff -- else it exists forever
    local u = EH.Ents.light(x,y)
    makeLight(u,distance,time,colour,fade)
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
    -- TODO:
    -- NOTE: You can fix this unpacking by packing values into a matrix!
    -- maybe leave it for now, see how this game performs on machines with slower pipeline
    shader:send("light_positions", unpack(light_positions))
    shader:send("light_colours"  , unpack(light_colours))
    shader:send("light_distances", unpack(light_distances))
    shader:send("num_lights", NUM_LIGHTS)
    shader:send("base_lighting", BASE_LIGHTING)
    shader:send("max_light_strength", MAX_LIGHT_STRENGTH)
    shader:send("brightness_modifier", BRIGHTNESS_MODIFIER)
end

