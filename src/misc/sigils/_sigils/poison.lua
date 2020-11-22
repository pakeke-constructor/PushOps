


local atlas = require("assets.atlas")
local Quads = atlas.Quads


local sigil = {}


local frames = {Quads.grass1}-- TODO:: ADD STUFF HERE!!


local cur_quad = frames[1]

local len = #frames

local counter = 0

local timestep = 0.3 -- 0.3 per frame



local tot_time = ((#frames) * timestep)



local floor = math.floor

function sigil.staticUpdate(dt)
    -- self in this case is the ent.
    counter = counter + dt
    local i = floor(counter / timestep)

    if i > len then
        i=1
    end

    cur_quad = frames[i]
end




function sigil:draw(ent)
    -- self in this case is the ent.
    atlas:draw(cur_quad, ent.pos.x, (ent.pos.y - draw.h)-ent.pos.z/2)
end


return sigil
