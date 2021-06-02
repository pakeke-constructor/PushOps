
local player_shape = love.physics.newCircleShape(10)

local atlas = require "assets.atlas"
local Quads = atlas.Quads





local prefix = "blank_player_"
local down={}
local up={}
local left={}
local right={}
for _,i in ipairs{1,2,1,4} do
    table.insert(down, Quads[prefix.."down_"..tostring(i)])
    table.insert(up,Quads[prefix.."up_"..tostring(i)])
    table.insert(left,Quads[prefix.."left_"..tostring(i)])
    table.insert(right, Quads[prefix.."right_"..tostring(i)])
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
    
    e:add("acc", math.vec3(0,0,0))
    
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

    :add("colour",{0.6,0.05,0.05})

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
        w = 'move_up';
        a = 'move_left';
        s = 'move_down';
        d = 'move_right';
        right = 'push';
        left = 'pull';
        up = "push";
        down = "pull"
    })

    e:add('light',{
          colour = {1,1,1,1};
          distance = 5
    })

    :add("sigils", {"strength"})

    return e
end







