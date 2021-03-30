
local player_shape = love.physics.newCircleShape(10)

local atlas = require "assets.atlas"
local Quads = atlas.Quads



local down = { Quads.red_player_down_1, Quads.red_player_down_2, Quads.red_player_down_3, Quads.red_player_down_4 }
local up = { Quads.red_player_up_1, Quads.red_player_up_2, Quads.red_player_up_3, Quads.red_player_up_4 }
local left = { Quads.red_player_left_1, Quads.red_player_left_2, Quads.red_player_left_3, Quads.red_player_left_4 }
local right = { Quads.red_player_right_1, Quads.red_player_right_2, Quads.red_player_right_3, Quads.red_player_right_4 }



local ccall = Cyan.call
local rand = love.math.random




local function onDamage(e)
    local p = e.pos
    ccall("emit", "guts", p.x, p.y, p.z, rand(7,11))
end



return function(x,y)

    local e = Cyan.Entity()

    EH.PV(e, x,y)
    
    :add("acc", math.vec3(0,0,0))
    
    :add("hp", {
        hp = 100,
        max_hp = 100,
        regen = 1,
        iframes = 0.5 -- we want iframes to be high to let player respond
    })

    :add("speed", {speed = 20, max_speed = 210})

    :add("strength", 100)

    :add("targetID", "player")

    :add("onDamage", onDamage)

    :add("pushable",true)

    :add("physics", {
        shape = player_shape;
        body  = "dynamic"
    })

    :add("bobbing", {magnitude = 0.32 , value = 0})

    EH.FR(e)

    :add("motion",
    {
        up = up;
        down = down;
        left = left;
        right = right;

        current = 0;
        interval = 0.15;
        required_vel = 120;
        sounds = {
            [2] = "footstep";
            [4] = "footstep";
            vol = 0.8;
            pitch=1;
            pitch_v = 0.2
        }
    })

    e:add("control",     {
        canPush = true;
        canPull = true;
        w = 'up';
        a = 'left';
        s = 'down';
        d = 'right';
        k = 'push';
        l = 'pull';
        i="zoomIn";
        j="zoomOut"
    })

    e:add('light',{
          colour = {1,1,1,1};
          distance = 30
    })

    :add("sigils", {"strength"})

    return e
end







