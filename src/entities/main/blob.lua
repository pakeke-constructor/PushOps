


local player_shape = love.physics.newCircleShape(10)

local atlas = require "assets.atlas"
local Quads = atlas.Quads



local ai_types = { "ORBIT", "LOCKON" }


local cols = {
    {0.9,0.1, 0.1};
    {0,0.8,0.7};
    {1,0.3,1};
    {0.5,1,0.1};
    {0.8,0.9,0.2};
    {0.9,0.1,0.9}
}


local frames = {Quads.blob1, Quads.blob2, Quads.blob3, Quads.blob2, Quads.blob1, Quads.blob0}

return function(x,y)
    local blob = Cyan.Entity()

    :add("pos", math.vec3(x,y,0))
    :add("vel", math.vec3(0,0,0))
    :add("acc", math.vec3(0,0,0))
    
    :add("hp", {hp = 100, max_hp = 100})

    :add("speed", {speed = 5, max_speed = math.random(50,100)})

    :add("strength", 40)

    :add("physics", {
        shape = player_shape;
        body  = "dynamic";
        friction = 0.9
    })

    :add("bobbing", {magnitude = 0.3 , value = 0})

    :add("targetID",2) -- is an enemy -> see components.md

    blob:add("behaviour",{
            move = {
                type = Tools.rand_choice(ai_types), id=1
            }
    })
    blob:add("animation",
    {
        frames = frames;
        interval = 0.1;
        current = 1
    })

    EH.FR(blob)

    :add("colour", Tools.rand_choice(cols))

    return blob
end
--[[
animation = {
    frames = { *quad array }
    interval = 0.7,  -- interval of animation (seconds)
    current = 0 -- the current value, when above `interval`, will go to next animation.
    -- `current` is incremented each frame by `interval * dt`. It determines
    -- what frame is drawn.

    ox = 10 -- offset x & y, will be set by system otherwise
    oy = 10

    animation_len = nil -- is automatically set by system
}]]
