


local Anim = {}
local Anim_mt = {__index = Anim}


--[[


Animation objects :::
Each animation object must have the following:

:play(x, y, z, frame_speed, ent_to_track=nil)     // ent_to_track allows anim object to follow an entity    
:draw()  draws animation
:update(dt)
:isFinished() check if finished animation
:clone() to clone itself
:release() to free it's individual memory

Fields:
.type     the type, must be same as filename!!!
.current    the current frame its at
.x, y, z     the position
.tracking     the entity its tracking (if any)
.frames   the entity frame quads
.frame_speed   frame speed in seconds
.time   the time spent running this frame
.len    the length of frame array
]]


-- Field init ==>
Anim.frames = { } --overwrite this
Anim.frame_speed = 0.1
Anim.time = 0 -- The time spent running this frame
Anim.x = 0
Anim.y = 0
Anim.z = 0
Anim.type = "BASE"
Anim.current = 1
Anim.tracking = nil
Anim.len = (# Anim.frames)
Anim.finished = false
Anim.ox = 10
Anim.oy = 10 -- offset X, offset Y

-- ^^^^^^ These fields are just kept for reference!!! Unused.



local floor=math.floor
local function getZIndex(y,z)
    return floor((y+z)/2)
end


local weak_mt = {__mode="kv"}


local setColour = love.graphics.setColor

local image = require("assets.atlas").image
local draw=love.graphics.draw
local cexists = Cyan.exists


function Anim:draw()
    if self.finished then return end
    --    love.graphics.draw(drawable,x,y,r,sx,sy,ox,oy)
    
    setColour(self.colour)

    if self.tracking then
        if (not cexists(self.tracking)) then
            -- The ent has been deleted mid-track! stop the count!
            self:finish()
            return
        end
        local pos = self.tracking.pos
        if pos then
            -- In case entity position component has been deleted
            draw(image, self.frames[self.current], self.x + pos.x, (self.y + pos.y) - (self.z+pos.z)/2, 0, 1, 1, self.ox, self.oy)
            return
        end
    end

    draw(image, self.frames[self.current],
        self.x, self.y - self.z/2, 0, 1, 1, self.ox, self.oy)
end


function Anim:update(dt)
    if self.finished then return end

    self.time = self.time + dt
    if self.time > self.frame_speed then
        self.time = 0
        self.current = self.current + 1
        if self.current > (#self.frames) then
            self.current = 1
            self.cycles = self.cycles - 1
            if self.cycles == 0 then
                self:finish( )
            end
        end
    end
end



function Anim:clone()
    local new = setmetatable({}, getmetatable(self))

    -- Allows for method overriding
    new.update=self.update
    new.draw=self.draw
    new.finish=self.finish
    new.isFinished=self.isFinished
    new.play=self.play

    new.time = 0
    new.current = 1
    new.frames = self.frames
    new.type = type
    new.frame_speed = self.frame_speed
    new.len = self.len
    new.finished = true
    new.ox = self.ox
    new.oy = self.oy

    new.ent_original_hidden = false -- was the entity being tracked originally hidden?

    return new
end



function Anim:new( type )
    self.frames = self.frames or error("animation obj "
                                        ..tostring(type)
                                        .." not given a `frames` field!")
    self.frame_speed = 0.1
    self.time = 0 -- The time spent running this frame
    self.x = 0
    self.y = 0
    self.z = 0
    self.type = type
    self.current = 1
    self.tracking = nil
    self.ent_original_hidden = false
    self.len = (#self.frames)
    self.finished = true
    self.colour = nil
    self.cycles = 1 -- how many times this AnimObj plays

    local _,_, W, H = self.frames[1]:getViewport( )
    self.ox = W/2
    self.oy = H/2

    return setmetatable(self, Anim_mt)
end


function Anim:removed(ent)
    -- for when the entity is destroyed halfway thru, and the
    -- anim object is still tracking it.

    -- future oli here, this is dumb, dont do this stuff again.
    -- In fact, dont do any weird stuff where helper objects hold entities 
    -- EVER again! its a really bad idea
    self.tracking = nil
end



function Anim:release()
    self.frames = nil
    self.tracking = nil
end


function Anim:finish()
    self.finished = true

    if self.tracking then
        self.tracking.hidden = self.ent_original_hidden
        self.tracking = nil
    end
    
    self.current = 1
    self.time = 0
    self.cycles = 1
end


function Anim:isFinished()
    return self.finished
end


local er_no_ent = "ccall('animate' ...), expected entity to hide, got none!"

function Anim:play(x, y, z, frame_speed, cycles,
                    colour, ent_to_track, should_hide_ent)
    if (not self.finished) then
        error("Attempted to play an animation that wasn't already finished. This is a problem with AnimationSys, not the callback itself.")
    end

    self.finished = false
    self.colour = colour
    self.frame_speed = frame_speed or self.frame_speed
    self.cycles = cycles or 1

    if ent_to_track then
        if type(ent_to_track) ~= "table" then
            error("Expected entity to track, got :: " .. tostring(type(ent_to_track)))
        end
        local e = ent_to_track

        self.ent_original_hidden = e.hidden
        
        if should_hide_ent then
            assert(e, er_no_ent)
            e.hidden = true
        end
        self.tracking = e
    end

    self.x = x
    self.y = y
    self.z = z
end






return Anim.new