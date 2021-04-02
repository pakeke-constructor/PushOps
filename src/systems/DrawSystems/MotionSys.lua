

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

    if motion.sounds then
        motion.sounds.last_index = 1
    end
    
    ent:add("draw", {
        ox = motion.ox;
        oy = motion.oy;

        w = w;
        h = h
    }) -- tell that its a drawable entity
end






local function updateDirection(ent)
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
        updateDirection(ent)
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
                if motion.current >= interval_tot then
                    motion.current = 0
                end
            else
                motion.current = motion.current + increment
            end
        else
            if motion.sounds then
                motion.sounds.last_index = 1
            end
            motion.current = 0
        end
    end
end



local floor = math.floor
local default_bob =  { scale = 1,  oy=0}
local default_sway = { value = 0,  ox = 0}



local function doSound(ent, index)
    local motion = ent.motion
    local sounds = motion.sounds
    if index ~= sounds.last_index then
        if sounds[index] then
            ccall("sound", sounds[index], sounds.vol,
                            sounds.pitch, sounds.vol_v, sounds.pitch_v)
        end
    end
    sounds.last_index = index
end


local function drawEnt(ent)
    local index

    index = floor(ent.motion.current / ent.motion.interval) + 1 -- lua 1 indexed

    if ent.motion.sounds then
        doSound(ent, index)
    end

    local sway_comp = ent.swaying or default_sway
    local bob_comp = ent.bobbing or default_bob
    
    local motion = ent.motion
    local draw = ent.draw

    atlas:draw(
            motion[ent.motion.current_direction][index],
            ent.pos.x,
            ent.pos.y - ent.pos.z/2,
            ent.rot,1,
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






