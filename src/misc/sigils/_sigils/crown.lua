

local Atlas = require("assets.atlas")

local CROWN_OFFSET=13/2 -- crown is 13 pixels wide
local GOLD = {1,0.83984375,0}

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
        setColour(GOLD)
        Atlas:draw(Atlas.Quads.crown, (ent.pos.x - (CROWN_OFFSET)), (ent.pos.y - h) - ent.pos.z / 2)
    end
}


