
```lua

-- This file is only kept as a reference for what components look like.

-- CURRENTLY  12 / 32   BITS OF COMPONENT MASK HAVE BEEN USED!!!
-- KEEP THIS NUMBER DOWN



hp = { hp = 10, max_hp = 100 }

pos = vec3(0 , 0 , 0) --> vec3

vel = vec3(vel_x, vel_y, vel_z) -->  {vel = vec3, max_vel = 123}

acc = vec3(acc_x, acc_y, acc_z) --> vec3

rot = 0 -- rotation in rads

pushable = true


speed = {speed = 10, max_speed = 100} -- entity speed

strength = 10 -- entity strength (how far can push other entities. Also the range of a push.)


toughness = 300
-- The speed an entity can collide at before a :hit() callback is envoked.


draw = { ox = 10, oy = 20 } -- Automatic component.
            -- NOTE: This component is given automatically by
            -- `image`, `animation`, and `motion` systems!!


image = { quad (from atlas), ox = 100,  oy = 100 } 
        -- ox and oy are offset x and offset y


animation = {
    frames = { *quad array }
    interval = 0.7,  -- interval of animation (seconds)
    current = 0 -- the current value, when above `interval`, will go to next animation.
    -- `current` is incremented each frame by `interval * dt`. It determines
    -- what frame is drawn.

    ox = 10 -- offset x & y, will be set by system otherwise
    oy = 10

    animation_len = nil -- is automatically set by system
}



motion ={ 
    up    =  { *quad array }
    down  =  { *quad array }
    left  =  { *quad array }
    right =  { *quad array }

    current = 0 -- the current value of the incrementer.
    interval = 0.7
    required_vel = 1 -- required velocity to invoke animation change


        -- OPTIONAL:: The system will do the rest of these even if not done.
    ox = 10 -- offset x & y, by default is half
    oy = 10
    animation_len = nil -- Is automatically set by system.
}





--[[
    NOTE: Physics component does things differently. Upon being added to the
    phy_sics system, the `body` string will be reassigned to a `body` object,
    and the X and Y positions will be assigned appropriately.
    For example:

    ent.physics = {body = "static", shape = shape}

    upon being added to physics system  ---->

    ent.physics = {body = love.physics.newBody(world, x,y "static"),
                    shape = shape}
]]
physics = {
        body = "dynamic";
        shape = shapeRef
    }




-- bobbing provides support for objects bobbing in Y directions.
bobbing =  { magnitude = 0.1, value = 0 } -- magnitude is 0.1.  The bobbing system will automatically 
--convert into a better version
swaying =  {magnitude = 0.3 value = 0 } --Same as bobbing, but swaying


hidden = true / false


emitter = love.graphics.newParticleSystem()


friction = {
    emitter = <emitter comp>
    reqiured_vel = 9 -- the required velocity to emit particles.
    amount = 0.5 -- The friction imposed on the rigidbody.

    on = true -- Set by system. Turned off if ent is airborne
}



-- Player controller
control = {
        w = 'up'
        a = 'left'
        s = 'down'
        d = 'right'

        k = 'push'
        l = 'pull'

        --!!! These fields are automatically added: !!!
        up = false
        left = false
        down = false
        right = false

        push = false
        pull = false
}


-- Camera tracks this ent
track = true / false


-- Behaviour (complex component)
behaviour = { 
    move = {type="LOCKON", id=1} -- See MoveBehaviourSys
}


-- The target id that this entity holds.
-- Used by MoveBehaviourSys and TargetSys.
targetID = 1  
-- 1 :: player / ally
-- 2 :: enemy
-- 3 :: neutral, weak mob
-- 4 :: physics object





-- Each must be a valid sigil object.
-- Note that other keyworded fields may or may not be added by the System/
sigils = { "poison", "strength" }



```


