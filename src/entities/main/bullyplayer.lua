

local player_shape = love.physics.newCircleShape(10)

local atlas = require "assets.atlas"
local Quads = atlas.Quads


local down,left,right,up
do 

    local ii = {1,2,1,3}
    up = {}
    down = {}
    right = {}
    left = {}
    local ti = table.insert
    local ts = tostring
    for _,i in ipairs(ii) do
        ti(up, Quads['bully_up_'..ts(i)])
        ti(down, Quads['bully_down_'..ts(i)])
        ti(right, Quads['bully_right_'..ts(i)])
        ti(left, Quads['bully_left_'..ts(i)])
    end
end

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
        hp = 0xffffffffffffffffff,
        max_hp = 0xffffffffffff,
        regen = 0xffffffffff,
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
        interval = 0.3;
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







