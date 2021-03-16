
local atlas = require 'assets.atlas'


local ImageSys = Cyan.System("image", "pos")




function ImageSys:added(ent)
    if type(ent.image) == "userdata" then
        if ent.image:type() == "Quad" then
            -- Assume ent.image is a quad.
            ent.image = {
                quad = ent.image
            }
        else
            error("ent.image: expected quad or table, got: "..ent.image:type())
        end
    end

    local image = ent.image
    local _,_, w,h = image.quad:getViewport( )

    if not image.ox then
        image.ox = w/2
    end
    if not image.oy then
        image.oy = h/2
    end

    ent:add("draw", {
        ox = image.ox;
        oy = image.oy;
        
        w = w;
        h = h
    }) -- tell that its a drawable entity
end



local default_bob = {value = 1, magnitude = 0, oy = 0}

local default_sway = {value = 0, magnitude = 0, ox = 0}


function ImageSys:drawEntity(ent)
    --[[
        Draws the entity
    ]]
    if self:has(ent) then
        local bob_comp = ent.bobbing or default_bob
        local sway_comp = ent.swaying or default_sway

        if not (ent.animation or ent.motion) then -- Else, other systems will do the drawing.
            local img = ent.image
            local draw = ent.draw
            local pos = ent.pos

            atlas:draw(img.quad, pos.x, pos.y - pos.z/2,
                ent.rot or 0, 1,
                bob_comp.scale,
                draw.ox + sway_comp.ox, 
                draw.oy + bob_comp.oy,
                sway_comp.value
            )
        end
    end
end


function ImageSys:drawTrivial(ent)
    local bob_comp = ent.bobbing or default_bob
    local sway_comp = ent.swaying or default_sway

    local img = ent.image
    local draw = ent.draw

    atlas:draw(img.quad, ent.pos.x, ent.pos.y - ent.pos.z/2,
                ent.rot or 0, 1,
                bob_comp.scale,
                draw.ox + sway_comp.ox, 
                draw.oy + bob_comp.oy,
                sway_comp.value
    )
end


