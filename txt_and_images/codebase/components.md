

```lua

-- This file is only kept as a reference for what components look like.



hp = { 
    hp = 10,
    max_hp = 100,
    regen = 0, -- default=0
    draw_hp = true -- Draws an HP bar if true  (NOT CURRENTLY IMPLIMENTED.)
    iframes = 0.5 -- How long the entity is invincible for after getting damaged
                -- (default 0)
}



-- The target id that this entity holds.   MUST BE CONSTANT!!!
-- Used by MoveBehaviourSys and TargetSys.
targetID = "player"  
-- "player" :: player / ally
-- "enemy" :: enemy
-- "neutral" :: neutral / weak mob
-- "physics" :: physics object
-- "coin"    :: coin
-- "interact" :: shop, portal, artefact



pos = vec3(0 , 0 , 0) --> position is a vec3

vel = vec3(vel_x, vel_y, vel_z) -->  velocity is a vec3

acc = vec3(acc_x, acc_y, acc_z) --> accelleration is a vec3

rot = 0 -- rotation in rads
avel = 0 -- rot velocity (rad/s)
rfriction = 0.1 -- rotational friction. Loses 10% of rot speed per second

speed = {speed = 10, max_speed = 100} -- entity speed

strength = 10 -- entity strength, determines push/pull strength for player.
-- for enemies, player is damaged by ent.strength when hit.


toughness = 300
-- The speeed an entity can collide at before a :hit() callback is envoked.
-- (THIS ISN'T REALLY USED!!!!)


hardness = 10
-- (THIS ISN'T REALLY USED EITHER!!!)
-- If an entity is `hit` by an entity with a higher hardness than itself,
-- It will take damage equal to the difference in hardness.
-- default: 0
-- players: 100   -- physics: 99    -- TODO: is this used anymore?? idk
-- (THIS ISN'T REALLY USED EITHER!!!)


light = {
    colour = {1,1,1,1};
    distance = 100; -- radius of 100 pixels
    height = 0.7; -- "height" of the light, defaults to 0.5
}


draw = { ox = 10, oy = 20 } -- Automatic component.
            -- NOTE: This component is given automatically by
            -- `image`, `animation`, and `motion` systems!!

colour = {1,1,1} -- Colour used with lg.setColor

fade = 100 -- fades into invisibility when this far away from player
minfade = 0.3 -- ent wont fade below 0.3 alpha

trivial = true/false -- `true` if the entity is a basic image.
                    -- This speeds things up a bit.


image = { quad = quad_from_atlas, ox = 100,  oy = 100 } 
        -- ox and oy are offset x and offset y


-- For animating entities
animation = {
    frames = { *quad array }
    interval = 0.7,  -- interval of animation (seconds)
    current = 0 -- the current value, when above `interval`, will go to next animation.
    -- `current` is incremented each frame by `interval * dt`. It determines
    -- what frame is drawn.

    ox = 10 -- offset x & y, will be set by system otherwise
    oy = 10

    -- optional arg:
    sounds = {  -- plays a sound "soundName" whenever frame 1 ends.
        [1] = "soundName"; -- Good for footsteps!
        [2] = nil;
        [3] = nil;
            last_index = nil; -- private field (set by sys)
            vol = nil; vol_v = nil; -- vol, vol variance
            pitch = nil; pitch_v = nil -- pitch, pitch variance
    }

    animation_len = nil -- is automatically set by system
}



-- For 4 directional movement animations (like player.)
motion ={ 
    up    =  { *quad array }
    down  =  { *quad array }
    left  =  { *quad array }
    right =  { *quad array }

    current = 0 -- the current value of the incrementer.
    interval = 0.7
    required_vel = 1 -- required velocity to invoke animation change

    sounds = { } --<<< same as `animation` component >>> 

        -- OPTIONAL:: The system will do the rest of these even if not done.
    ox = 10 -- offset x & y, by default is half
    oy = 10
    animation_len = nil -- Is automatically set by system.
}

text = "abcde" -- draws the text `abcde` at ent's position



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

    friction = 0.1 -- OPTIONAL!
    --  This is for when you want friction without particles.
}

physicsImmune=true/false -- whether this entity is immune
    --  to splats and being deleted  (physics objs ONLY!)



collisions = {
    -- Area for non-physics objects, collision depends on `size` components of
    -- the interacting entities
    area = {
        player = function(ent, collide_ent, dt)
            ... -- Collides with targetgroup "player"!!
        end,
        enemy = function(ent, collide_ent, dt)
            ...-- callback upon overlap with ent from targetgroup "enemy".
        end 
    }

    -- Physics callback based collisions
    physics = function(ent, collide_ent, speed)
    end -- THIS IS USED A LOT!!!
}




-- if an ent has this field, they can go underground
dig = {
    digging = false/true -- whether this ent is digging or nah
    onSurface = function(ent)end -- ent surfaces
    onGround  = function(ent)end -- ent goes into ground;
    z_min = -1 -- doesnt go below z=-1 (default = -1)
}

grounded = true/false -- read-only field used by gravitySys. 
                    -- false if ent is in the air

gravitymod = 1 -- modifies the gravity (-1 means ent goes up, 0.5 = half grav)



-- This entity is now pushing another entity.
-- MAKE SURE TO USE ent:remove("pushing")!!! not `ent.pushing = nil`
pushing = other_ent

-- Whether this ent can be pushed or nah
pushable = true/false

follow = {
    -- For when an entity is following another ent. NOTE: THIS KINDA EXPENSIVE
    following = e;
    distance = 10;   -- Follows 10 units behind `e`.

    detatch = function(e)
        -- called when ent detatches from following ent.
        -- (I.e. when following ent gets deleted)
    end
}


size = 10.5 -- Determines how much 'area of affect' an object has.
-- (By default, entities will have a size of 5.)




-- bobbing provides support for objects bobbing in Y directions.
bobbing =  { magnitude = 0.1, value = 0 } -- magnitude is 0.1.  The bobbing system will automatically 
--convert into a better version
swaying =  {magnitude = 0.3 value = 0 } --Same as bobbing, but swaying


hidden = true / false


emitter = love.graphics.newParticleSystem()-- TOOD: is this actually used?


friction = {
    emitter = particleSys:clone()    -- MUST be cloned!
    reqiured_vel = 9 -- the required velocity to emit particles.
    amount = 0.5 -- The friction imposed on the rigidbody.

    on = true -- Set by system. Turned off if ent is airborne
}



-- Player controller
control = {
        canPush = false -- is push on cooldown, or nah?
        canPull = false -- is pull on cooldown

        w = 'up'
        a = 'left'
        s = 'down'
        d = 'right'

        k = 'push'
        l = 'pull'

        i = 'maximise' -- zooms in and out
        j = 'minimise'

        --!!! These fields are automatically added: !!!
        up = false
        left = false
        down = false
        right = false

        push = false
        pull = false
}

playerType = "red" -- The type of player 


-- Camera tracks this ent
track = true / false


-- Behaviour (complex component)
behaviour = { 
    move = {
        type="LOCKON"  -- See MoveBehaviourSys for custom params
        id=1        -- ( Also see src/misc/behaviour/movebehaviours/ )
        initialized=false -- whether the moveBehaviour has been :init'd.
    }
    tree = Node() -- node object (from libs/BehaviourTree.lua)
}



-- Each must be a valid sigil object.
-- Note that other keyworded fields may or may not be added by the System/
sigils = { "poison", "strength" }



buff = {
    buffs = {"speed", "tint"} -- must be valid buff types

    speed = 30 -- 30 seconds left for speed
    strength = 15.32
}
--[[
    NOTE::: Do not add `buff` component directly!!!!
    See `ccall("buff" ...)`
]]


armour = 2; -- Damage reduced by 2 times (defaults to 1.)

onDeath = function(ent) end -- callback for when ent dies.
onDamage = function(ent, dmg) end -- callback for taking dmg
onBoom   = function(ent, x,y, strength) end -- callback for `boom`.
onMoob = function(ent, x,y, strength) end -- callback for `moob`.

onInteract = function(ent, interacting_ent, type)
-- Only for entities with ent.targetID = "interact"

-- when player `push` or `pull` next to  targetID = "interact"
-- type is either `pull` or `push`.
-- ALSO, ent.size must be bigger than interacting distance!  (done in ControlSys)
-- If boolean `true` is returned, the push or pull is cancelled.
end



hybrid = true -- Added to `HybridSys`. This bridges the gap, 
             -- allows for OOP-ECS hybrid architecture

onUpdate = function(e,dt)end -- part of hybridsys
onHeavyUpdate = function(e,dt)end -- part of hybridsys
onDraw = function(e,dt)end -- part of hybridsys

-- These components must be added BEFORE .hybrid is added,
-- Or else the system won't pick the entities up.



 -- for portals. This component should be overridden as portal is created
portalDestination = {
    x = 20 -- world width
    y = 35 -- world height
    tier = 1
    type = "basic"
    
    map = nil -- The world map, (OPTIONAL)
    minimap = nil -- the custom minimap (as an atlas quad)
}



```

