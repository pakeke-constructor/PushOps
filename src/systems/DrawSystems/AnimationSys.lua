
local atlas = require("assets.atlas")

local AnimationSys = Cyan.System("animation", "position")


function AnimationSys:added(ent)
    ent.draw = {}

    local draw = ent.draw
    local anim = ent.animation

    anim.animation_len = #anim.frames

    local _,_, w,h = anim.frames[1]:getViewport( )

    if not anim.ox then
        anim.ox = w/2
    end
    if not anim.oy then
        anim.oy = h/2
    end

    draw.ox = anim.ox
    draw.oy = anim.oy

    draw.w = w
    draw.h = h
end




function AnimationSys:update(dt)
    for _, ent in ipairs(self.group) do
        local anim = ent.animation

        local interval_tot = anim.interval * anim.animation_len
        local increment =  dt

        if anim.current + increment >= interval_tot then
            anim.current = (anim.current + increment) - interval_tot
        else
            anim.current = anim.current + increment
        end
    end
end




local floor = math.floor
local default_bob = {scale = 1, magnitude = 0, oy=0}
local default_sway = {value = 1, ox=0}


function AnimationSys:drawEntity( ent )
    if self:has(ent) then
        local index

        local anim = ent.animation
        local draw = ent.draw

        index = (floor(anim.current / (anim.interval*2)) * 2) + 1

        local bob_comp = ent.bobbing or default_bob
        -- img.oy must be modified for bobbing entities
        local sway_comp = ent.swaying or default_sway
        local oy = ent.animation.oy

        atlas:draw(
            anim.frames[index],
            ent.pos.x,
            ent.pos.y - ent.pos.z/2,
            0,1,
            bob_comp.scale,
            draw.ox + sway_comp.ox,
            oy + bob_comp.oy,
            sway_comp.value
        )
    end
end







