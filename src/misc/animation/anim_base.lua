


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
local function get_z_index(y,z)
    return floor((y+z)/2)
end





local image = require("assets.atlas").image
local draw=love.graphics.draw

function Anim:draw()
    if self.finished then return end
    --    love.graphics.draw(drawable,x,y,r,sx,sy,ox,oy)

    if self.tracking then
        local pos = self.tracking.pos
        if pos then
            -- In case entity position component has been deleted
            draw(image, self.frames[self.current], self.x + pos.x, (self.y + pos.y) - (self.z+pos.z)/2, 0, 1, 1, self.ox, self.oy)
            return
        end
    end
    
    draw(image, self.frames[self.current], self.x, self.y - self.z/2, 0, 1, 1, self.ox, self.oy)
end

function Anim:update(dt)
    if self.finished then return end

    self.time = self.time + dt
    if self.time > self.frame_speed then
        self.time = 0
        self.current = self.current + 1
        if self.current > (#self.frames) then
            self:finish( )
        end
    end
end



function Anim:clone()
    local new = setmetatable({}, getmetatable(self))

    new.time = 0
    new.current = 1
    new.frames = self.frames
    new.type = type
    new.frame_speed = self.frame_speed
    new.len = self.len
    new.finished = true
    new.ox = self.ox
    new.oy = self.oy

    return new
end


function Anim:new( type, frames )
    self.frames = frames
    self.frame_speed = 0.1
    self.time = 0 -- The time spent running this frame
    self.x = 0
    self.y = 0
    self.z = 0
    self.type = type
    self.current = 1
    self.tracking = nil
    self.len = (#self.frames)
    self.finished = true

    local _,_, W, H = frames[1]:getViewport( )
    self.ox = W/2
    self.oy = H/2

    return setmetatable(self, Anim_mt)
end


function Anim:release()
    self.frames = nil
    self.tracking = nil
end


function Anim:finish()
    self.finished = true
    self.tracking = nil
    self.current = 1
    self.time = 0
end


function Anim:isFinished()
    return self.finished
end



function Anim:play(x, y, z, frame_speed, ent_to_track)
    if (not self.finished) then
        error("Attempted to play an animation that wasn't already finished. This is a problem with AnimationSys, not the callback itself.")
    end
    self.finished = false

    if ent_to_track then
        if type(ent_to_track) ~= "table" then
            error("Expected entity to track, got :: " .. tostring(type(ent_to_track)))
        end
        self.tracking = ent_to_track
    end
    self.x = x
    self.y = y
    self.z = z

    self.z_dep = get_z_index(y,z)
end


return Anim.new