

local LightSys = Cyan.System("light")

-- shader consts.
local BASE_LIGHTING = {0.73,0.73,0.73,1}--{0.4, 0.4, 0.4, 1}
local MAX_LIGHT_STRENGTH = 0.65
local NUM_LIGHTS = 12 -- max N
local BRIGHTNESS_MODIFIER = 4 -- all light strengths divided by 4

local DEFAULT_HEIGHT = 0.5


local cam = require("src.misc.unique.camera")
-- X, Y  =  cam:toCameraCoords(x,y)

local shader = require("src.misc.unique.shader").light


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



local function send(e, light_positions, light_colours, 
                        light_distances, light_heights)
    local x,y = cam:toCameraCoords(
        e.pos.x,
        e.pos.y
    )

    local sf = CONSTANTS.SHADER_LIGHT_DOWNSCALE_FACTOR
    table.insert(light_positions, {x / sf, y / sf})
    table.insert(light_colours,   e.light.colour)
    table.insert(light_distances, e.light.distance * cam.scale / sf)
    table.insert(light_heights,   e.light.height or DEFAULT_HEIGHT)
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


local function less(e1, e2)
    return Tools.distToPlayer(e1, cam) < Tools.distToPlayer(e2, cam)
end


function LightSys:update()
    local light_positions = {}
    local light_colours   = {}
    local light_distances = {}
    local light_heights   = {}

    local num_lights = 0
    local cand_lights = {}
    for _, e in ipairs(self.group)do
        if Tools.distToPlayer(e, cam) < 1000 then
            num_lights = math.min(NUM_LIGHTS, num_lights + 1)
            table.insert(cand_lights, e)        
        end
    end

    table.stable_sort(cand_lights, less) -- Sorts by closest lights,
        -- closest first.

    for i=1,num_lights do
        if cand_lights[i] then
            send(cand_lights[i], light_positions, light_colours, 
                        light_distances, light_heights)
        end
    end
    
    -- This sucks.
    --TODO: Convert this to a matrix so you can do it efficiently please
    for i=1, NUM_LIGHTS - num_lights do
        table.insert(light_positions, {0,0})
        table.insert(light_colours  , {0,0,0,0})
        table.insert(light_distances, 0)
        table.insert(light_heights, 0)
    end

    local unpack = table.unpack or unpack -- F**CK. This breaks JIT, I didnt want to do this. No choice tho
    -- future oli here: Why did I care about JIT breaking here?
    -- it doesn't even matter  (:

    shader:send("light_positions", unpack(light_positions))
    shader:send("light_colours"  , unpack(light_colours))
    shader:send("light_distances", unpack(light_distances))
    shader:send("light_heights",   unpack(light_heights))
    shader:send("num_lights", num_lights)
    shader:send("base_lighting", BASE_LIGHTING)
    --shader:send("max_light_strength", MAX_LIGHT_STRENGTH)
    --shader:send("brightness_modifier", BRIGHTNESS_MODIFIER)
end


