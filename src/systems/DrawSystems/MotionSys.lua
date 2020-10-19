

--[[

System for running animation components that have directional states.

(I.e. player has animations for going up, down, left, right,
so this system is used for exactly that! )

NOTE::  
This system recieved a `Cyan.call("drawEntity", ent)` from DrawSys.

]]


local MotionSys = Cyan.System("motion", "pos", "vel")

local atlas = require 'assets.atlas'


function MotionSys:added(ent)
    local motion = ent.motion
    motion.current_direction = "down"
    motion.animation_len = #motion.up -- gets length of animation
    
    local len = motion.animation_len
    assert(#motion.up == len, "Inconsistent animation lengths for motion comp")
    assert(#motion.down == len, "Inconsistent animation lengths for motion comp")
    assert(#motion.left == len, "Inconsistent animation lengths for motion comp")
    assert(#motion.right == len, "Inconsistent animation lengths for motion comp")

    local _,_, w,h = motion.up[1]:getViewport( )

    if not motion.ox then
        motion.ox = w/2
    end
    if not motion.oy then
        motion.oy = h/2
    end

    
    ent:add("draw", {
        ox = motion.ox;
        oy = motion.oy;

        w = w;
        h = h
    }) -- tell that its a drawable entity
end






local function update_direction(ent)
    local motion = ent.motion
    local rvel = motion.required_vel/2
    local dir = motion.current_direction

    if ent.vel.x > rvel then
        dir = "right"
        rvel = ent.vel.x
    elseif ent.vel.x < -rvel then
        dir = "left"
        rvel = -ent.vel.x
    end

    if ent.vel.y > rvel then
        dir = "down"
    elseif ent.vel.y < -rvel then
        dir = "up"
    end

    motion.current_direction = dir
end



local min = math.min

function MotionSys:update( dt )
    for _, ent in ipairs(self.group) do
        local motion = ent.motion
        update_direction(ent)
        if ent.vel:len() > motion.required_vel then
            -- update the motion state of our entity
            --[[
                Why do we multiply the interval by #?

                The total length of the animation loop is `interval_tot` seconds,
                because the number of frames is 4, and each animation lasts
                0.7 seconds.
            ]]
            local interval_tot = motion.interval * motion.animation_len
            local increment =  dt

            if motion.current + increment >= interval_tot then
                motion.current = (motion.current + increment) - interval_tot
                
                -- We must check again to account for freak `dt` spikes.
                if motion.current + increment >= interval_tot then
                    motion.current = 0
                end
            else
                motion.current = motion.current + increment
            end
        else
            motion.current = 0
        end
    end
end



local floor = math.floor
local default_bob =  { scale = 1,  oy=0}
local default_sway = { value = 0,  ox = 0}



local function drawEnt(ent)
    local index

    local interval4 = ent.motion.interval * 4
    index = floor(ent.motion.current / ent.motion.interval) + 1 -- lua 1 indexed

    local sway_comp = ent.swaying or default_sway
    local bob_comp = ent.bobbing or default_bob
    
    local motion = ent.motion
    local draw = ent.draw

    atlas:draw(
            motion[ent.motion.current_direction][index],
            ent.pos.x,
            ent.pos.y - ent.pos.z/2,
            0,1,
            bob_comp.scale,
            draw.ox + sway_comp.ox,
            draw.oy + bob_comp.oy,
            sway_comp.value
        )
end




function MotionSys:drawEntity( ent )
    if self:has(ent) then
        drawEnt(ent)
    end
end






