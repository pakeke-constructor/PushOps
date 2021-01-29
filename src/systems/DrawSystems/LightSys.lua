

local LightSys = Cyan.System("light")

local cam = require("src.misc.unique.camera")


local function send(e, light_positions, light_colours, cam_pos)
    table.insert(light_positions, e.pos - cam_pos)
    table.insert(light_colours,   e.light)
end


function LightSys:update(dt)
    local light_positions = {}
    local light_colours   = {} 
    local cam_pos = math.vec3(cam.x, cam.y, 0)

    for _, e in ipairs(self.group)do
        if Tools.isOnScreen(cam, e) then
            send(e, light_positions, light_colours, cam_pos)
        end
    end
end