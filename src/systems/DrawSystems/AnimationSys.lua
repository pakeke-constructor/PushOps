

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



function AnimationSys:removed(ent)
    if ent.anim then
        local a = ent.anim
        for i = 1, #a.frames do
            a.frames[i] = nil
        end
    end
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






--[[
*****
*****
*****
*****
*****
*****
*****
*****

Static callbacks :::

    Inducing animations regardless of entity.
    (See src.misc.animation.types for a list of possible animations. ) 

*****
*****
*****
*****
*****
*****
*****
*****

Animation objects :::
Each animation object must have the following:

:play(x, y, z, frame_speed, ent_to_track=nil)     // ent_to_track allows anim object to follow an entity    
:draw()  draws animation
:update(dt)
:isFinished() check if finished animation
:clone() to clone itself
:release() to free it's individual memory
It must have a `.type` field that tells what type it is. (This MUST also be the file name!!!)



]]
local AnimTypes = require("src.misc.animation.types")

--[[

Remember `AnimTypes` holds keyworded references to
"anim objects", not love2d particleSystem objects!!!

]]


-- just quick checking ::::
for type, anim in pairs(AnimTypes) do
    assert(type == anim.type, "Animation.type confliction with filename for anim.\nMake sure the anim .type field has same name as the file!\n( See src.misc.animations.types )")
end




local available_anim_objs = setmetatable(
    {}, {__index = function(t,k) t[k] = {} return t[k] end}
    -- Arrays of available animation objs, keyworded by type
)


local sset = Tools.set
local in_use_anim_objs = setmetatable(
    -- `k` is the z depth of this in-use anim object
    {}, {__index = function(t,k) t[k] = sset() return t[k] end}
)


local in_use = Tools.set()


local floor = math.floor

local function get_z_index(y,z)
    return floor((y+z)/2)
end



local function get_anim_obj(type)
    --[[
        gets anim of certain type from the queue of that type.
        (also removes from queue)
    ]]
    local anim

    local availables = available_anim_objs[type]
    if #availables > 0 then
        -- there is an available system to use!
        anim = availables[#availables]
        availables[#availables] = nil
    else
        -- Else we gotta clone.
        anim = AnimTypes[type]:clone()
    end

    return anim
end



local t_insert = table.insert

function AnimationSys:animate(type, x, y, z, frame_len, track_ent)    
    if not AnimTypes[type] then
        error("AnimationSys:animate(type, x,y,z, frame_len, track_ent=nil) ==> Unrecognised anim type ==> "..tostring(type))
    end

    local anim = get_anim_obj(type)

    anim:play(x,y,z, frame_len, (track_ent or nil))
    in_use:add(anim)
    
    local z_dep = get_z_index(y,z)

    in_use_anim_objs[z_dep]:add(anim)
end



function AnimationSys:drawIndex( z_dep )
    for _, anim in ipairs(in_use_anim_objs[z_dep].objects) do
        anim:draw()
    end
end



function AnimationSys:update(dt)
    for i, anim in ipairs(in_use.objects) do
        anim:update(dt)
        if anim:isFinished() then
            in_use:remove(anim)
            in_use_anim_objs[anim.z_dep]:remove(anim)
            anim.runtime = 0

            t_insert(available_anim_objs[anim.type], anim)
        end
    end
end



function AnimationSys:purge()
    --
    -- Releases all memory
    --
    for i,v in ipairs(in_use.objects)do
        in_use.objects[i]:release()
    end
    in_use:clear()

    --[[   Your using `pairs`???
    With this we don't care about JIT breaking. 
    This will only be called once when mass deletions need to happen
    ]]
    for k,v in pairs(in_use_anim_objs)do
        local ar = in_use_anim_objs[k].objects
        for i=1,#ar do
            ar[i]:release( )
        end
        in_use_anim_objs[k]:clear()
    end

    for k,v in pairs(available_anim_objs)do
        local ar = available_anim_objs[k]
        for i=1,#ar do
            ar[i]:release()
            ar[i] = nil
        end
    end
end



