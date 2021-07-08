


local player_shape = love.physics.newCircleShape(15)

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


local function physColFunc(ent, your_dead, speed)
    if your_dead.hp then
        ccall("damage", your_dead, 0xffffffffffffffff)
        if your_dead.hp.hp <= 0 then
            local x, y, z = ent.pos.x, ent.pos.y, ent.pos.z
            -- boom will be biased towards enemies with 1.2 radians
            ccall("boom", x, y, ent.strength, 100, 0,0, "enemy", 1.2)
            ccall("animate", "push", x,y+25,z, 0.03) 
            ccall("shockwave", x, y, 4, 130, 7, 0.3)
            ccall("sound", "boom")
        end
    end
end



return function(x,y)
    local e = Cyan.Entity()

    EH.PV(e, x,y)
    
    :add("acc", math.vec3(0,0,0))
    
    :add("hp", {
        hp = 0xfff,
        max_hp = 0xfff,
        regen = 20,
        iframes = 0
    })

    :add("speed", {speed = 300, max_speed = 300})

    :add("strength", 50)

    :add("targetID", "player")

    :add("onDamage", onDamage)

    :add("pushable",true)

    :add("physics", {
        shape = player_shape;
        body  = "dynamic"
    })

    :add("collisions",{
        physics = physColFunc
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
        w = 'move_up';
        a = 'move_left';
        s = 'move_down';
        d = 'move_right';
        right = 'push';
        left = 'pull';
        up = "push";
        down = "pull"
    })

    :add("sigils", {"strength"})

    return e
end







