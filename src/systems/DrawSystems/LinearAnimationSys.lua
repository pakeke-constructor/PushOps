

local atlas = require("assets.atlas")

--[[
This is a really dumb fix....

But I had to rename this filename and system to `LinearAnimationSys` so
FrictionSys would be drawn before this.


Future oli here:
This whole File is dumb. Tjhis whole idea is dumb! Dont give crappy animation
objects control over every single entity. Next time, pass the position only
and make it so the animObjs do all the work. AnimationSys should not have to do
field checks!!!! I mean this is literal spagetti

]]

local LinearAnimationSys = Cyan.System("animation", "pos")



-- { [ent] : anim_obj } table, this is for entities that are being tracked by
-- anim objects. The reason we need this is because if an entity is destroyed,
-- we need to let the animation object know.
local ents_being_tracked = setmetatable({ }, {__mode="kv"})
-- (this is for ccall("animate", ...) btw)

local cexists = Cyan.exists


function LinearAnimationSys:added(ent)
    local anim = ent.animation
    anim.animation_len = #anim.frames
    anim.current = 0

    local _,_, w,h = anim.frames[1]:getViewport( )
    
    if not anim.ox then
        anim.ox = w/2
    end
    if not anim.oy then
        anim.oy = h/2
    end

    if anim.sounds then
        anim.sounds.last_index = 1
    end

    ent:add("draw",{
        ox=anim.ox;
        oy=anim.oy;
        w=w;
        h=h
    })
end



function LinearAnimationSys:removed(ent)
    if ent.anim then
        local a = ent.anim
        for i = 1, #a.frames do
            a.frames[i] = nil
        end
    end
    
    if ents_being_tracked[ent] then
        ents_being_tracked[ent]:removed(ent)
    end
end






local floor = math.floor
local default_bob = {scale = 1, magnitude = 0, oy=0}
local default_sway = {value = 0, ox=0}


local function doSounds(ent, index)
    local anim = ent.animation
    local sounds = anim.sounds
    if index ~= sounds.last_index then
        if sounds[index] then
            ccall("sound", sounds[index], sounds.vol,
                            sounds.pitch, sounds.vol_v, sounds.pitch_v)
        end
    end
    sounds.last_index = index
end


function LinearAnimationSys:drawEntity( ent )
    if self:has(ent) then
        local index

        local anim = ent.animation
        local draw = ent.draw

        index = (floor(anim.current / (anim.interval))) + 1
        if anim.sounds then
            doSounds(ent, index)
        end

        local bob_comp = ent.bobbing or default_bob
        -- img.oy must be modified for bobbing entities
        local sway_comp = ent.swaying or default_sway
        local oy = ent.animation.oy
        atlas:draw(
            anim.frames[index],
            ent.pos.x,
            ent.pos.y - ent.pos.z/2,
            ent.rot,1,
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
:finish()  to reset fields and mark finish flag
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

-- Holds all the anim objects that are tracking an entity
local tracking_anim_objs = sset()


local in_use_anim_Z_index = setmetatable(
    -- `k` is the z depth of this in-use anim object
    {}, {__index = function(t,k) t[k] = sset() return t[k] end}
)

-- A SSet of all the animation objects in use.
-- (in_use_anim_Z_index is sorted by Z depth.)
local in_use_anim_objs = Tools.set()



local floor = math.floor

local function getZIndex(y,z)
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
local WHITE = {1,1,1}


function LinearAnimationSys:animate(anim_type, x, y, z, frame_len, cycles,
                              colour, track_ent, hide_ent)
    if colour and colour.pos then
        -- colours should not have a position! This is an entity instead
        error[[Incorrect signature for ccall('animate'). 
Expected  ccall('animate', x, y, z, frame_len, cycles, colour = WHITE, track_ent = nil, hide_ent = false)]]
    end

    if not AnimTypes[anim_type] then
        error("LinearAnimationSys:animate(type, x,y,z, frame_len, track_ent=nil) ==> Unrecognised anim type ==> "..tostring(anim_type))
    end

    local anim = get_anim_obj(anim_type)

    anim:play(x,y,z, frame_len, cycles, (colour or WHITE), track_ent, (hide_ent or false))
    in_use_anim_objs:add(anim)

    local z_dep 
    if track_ent then
        assert(track_ent.pos, "Track entity not given position. Is this even an entity?")
        ents_being_tracked[track_ent] = anim
        tracking_anim_objs:add(anim)
        z_dep = getZIndex(y + track_ent.pos.y, z + track_ent.pos.z)
    else
        z_dep = getZIndex(y,z)
    end

    anim.z_dep = z_dep
    in_use_anim_Z_index[z_dep]:add(anim)
end



function LinearAnimationSys:drawIndex( z_dep )
    for _, anim in ipairs(in_use_anim_Z_index[z_dep].objects) do
        anim:draw()
    end
end


local function updateEnt(ent, dt)
    local anim = ent.animation

    local interval_tot = anim.interval * anim.animation_len
    local increment =  dt

    if anim.current + increment >= interval_tot then
        anim.current = (anim.current + increment) - interval_tot

        if anim.current >= interval_tot then
            anim.current = 0
        end
    else
        anim.current = anim.current + increment
    end
end


local temp_stack = {}

function LinearAnimationSys:update(dt)
    
    for _, ent in ipairs(self.group) do
        updateEnt(ent, dt)
    end


    --[===[
        Static update workings here.
        (unrelated to animation component)
    ]===]
    for i, anim in ipairs(in_use_anim_objs.objects) do
        anim:update(dt)
        if anim:isFinished() then
            tracking_anim_objs:remove(anim)
            table.insert(temp_stack, anim)
            in_use_anim_Z_index[anim.z_dep]:remove(anim)
            anim.runtime = 0
            t_insert(available_anim_objs[anim.type], anim)
        end
    end
    for i,a in ipairs(temp_stack) do
        -- Cannot remove from set halfway thru ipairs loop
        in_use_anim_objs:remove(a)
        temp_stack[i] = nil
    end
    assert(#temp_stack == 0,"huh")


    for _, anim in ipairs(tracking_anim_objs.objects) do
        -- For tracking animations that need to track their objects
        in_use_anim_Z_index[anim.z_dep]:remove(anim)
        local new_z_dep
        if (not anim.tracking) then
            --  we're no longer tracking.
            -- (anim_base.lua =>  :removed() btw, smh. horrible code structure)
            table.insert(temp_stack, anim)
            new_z_dep = anim.z_dep --cant afford anything else.
            anim:finish()
        else
            local tpos = anim.tracking.pos
            new_z_dep = getZIndex(anim.y + tpos.y, anim.z + tpos.z)
        end
        anim.z_dep = new_z_dep
        in_use_anim_Z_index[anim.z_dep]:add(anim)
    end
    for i,a in ipairs(temp_stack) do
        -- Cannot remove from set halfway thru ipairs loop
        tracking_anim_objs:remove(a)
        temp_stack[i]=nil
    end
    assert(#temp_stack == 0,"SCUSE ME?????")

end





function LinearAnimationSys:purge()
    --
    -- Releases all memory
    --
    for i,v in ipairs(in_use_anim_objs.objects)do
        in_use_anim_objs.objects[i]:release()
    end
    in_use_anim_objs:clear()

    --[[   Your using `pairs`???
    With this we don't care about JIT breaking. 
    This will only be called once when mass deletions need to happen
    (i.e. world resets)
    ]]
    for k,v in pairs(in_use_anim_Z_index)do
        local ar = in_use_anim_Z_index[k].objects
        for i=1,#ar do
            ar[i]:release( )
        end
        in_use_anim_Z_index[k]:clear()
    end

    tracking_anim_objs:clear()

    for k,v in pairs(available_anim_objs)do
        local ar = available_anim_objs[k]
        for i=1,#ar do
            ar[i]:release()
            ar[i] = nil
        end
    end
end





