

local LightSys = Cyan.System("light", "pos")

-- shader consts.
local BASE_LIGHTING = {0, 0, 0, 1}
local MAX_LIGHT_STRENGTH = 0.8



local cam = require("src.misc.unique.camera")
local shader = require("src.misc.unique.shader")


local getW = love.graphics.getWidth
local getH = love.graphics.getHeight


local function send(e, light_positions, light_colours, light_distances, cam_pos)
    local vec3 = (e.pos - cam_pos)
    vec3.x = vec3.x + getW()/2
    vec3.y = vec3.y + getH()/2
    -- bad alloc, but who cares
    table.insert(light_positions, {vec3.x, vec3.y})
    table.insert(light_colours,   e.light.colour)
    table.insert(light_distances, e.light.distance)
end




function LightSys:update()
    local light_positions = {}
    local light_colours   = {}
    local light_distances = {}
    local cam_pos = math.vec3(cam.x, cam.y, 0)

    for _, e in ipairs(self.group)do
        if Tools.isOnScreen(e, cam) then
            send(e, light_positions, light_colours, light_distances, cam_pos)
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
    shader:send("num_lights", #self.group)
    shader:send("base_lighting", BASE_LIGHTING)
    shader:send("max_light_strength", MAX_LIGHT_STRENGTH)
end

