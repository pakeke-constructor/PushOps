

local Atlas = require("assets.atlas")

local CROWN_OFFSET=13/2 -- crown is 13 pixels wide
local RED = {0.6,0,0}

local ADDED_HEIGHT = 6 -- add some height to crown to make it floating
                       --  ((by default tho, this sigil will use `ent.size`.))

local setColour = love.graphics.setColor

return {
    draw = function(ent)
        local h,w2
        if ent.draw then
            h = ent.draw.h
            w2 = ent.draw.w/2
        else
            h = 0
            w = 0
        end
        setColour(RED)
        Atlas:draw(Atlas.Quads.crown, (ent.pos.x - (CROWN_OFFSET)), ((ent.pos.y - h) - ent.pos.z / 2)-(e.size or ADDED_HEIGHT))
    end
}


