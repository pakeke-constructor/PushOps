
local player_shape = love.physics.newCircleShape(10)

local atlas = require "assets.atlas"
local Quads = atlas.Quads

local psys = love.graphics.newParticleSystem(atlas.image)
psys:setQuads(Quads.beet, Quads.bat, Quads.bot, Quads.bit)
psys:setParticleLifetime(0.4, 0.8)
--psys:setLinearAcceleration(0,0,200,200)
psys:setDirection(180)
psys:setSpeed(5,15)
psys:setEmissionRate(90)
psys:setSpread(math.pi/2)
psys:setEmissionArea("uniform", 6,0)
psys:setColors({1,1,1}, {1,1,1,0})
psys:setSpin(-40,40)
psys:setRotation(0, 2*math.pi)
psys:setRelativeRotation(false)
local _,_, pW, pH = psys:getQuads()[1]:getViewport( )
psys:setOffset(pW/2, pH/2)


local motion_down = { Quads.red_player_down_1, Quads.red_player_down_2, Quads.red_player_down_3, Quads.red_player_down_4 }
local motion_up = { Quads.red_player_up_1, Quads.red_player_up_2, Quads.red_player_up_3, Quads.red_player_up_4 }
local motion_left = { Quads.red_player_left_1, Quads.red_player_left_2, Quads.red_player_left_3, Quads.red_player_left_4 }
local motion_right = { Quads.red_player_right_1, Quads.red_player_right_2, Quads.red_player_right_3, Quads.red_player_right_4 }






return function(x,y)
    return Cyan.Entity()

    :add("pos", math.vec3(x,y,0))
    :add("vel", math.vec3(0,0,0))
    :add("acc", math.vec3(0,0,0))
    
    :add("hp", {hp = 100, max_hp = 100})

    :add("speed", {speed = 12, max_speed = 160})

    :add("strength", 70)

    :add("targetID", 1)

    :add("physics", {
        shape = player_shape;
        body  = "dynamic"
    })

    :add("bobbing", {magnitude = 0.32 , value = 0})
    
    :add("friction", {
        amount = 6; -- The amount of friction given to this entity
        emitter = psys:clone();
        required_vel = 10;
    })

    :add("motion",
    {
        up = motion_up;
        down = motion_down;
        left = motion_left;
        right = motion_right;

        current = 0;
        interval = 0.1;
        required_vel = 20;
    })

    -- Player controller
    :add("control",{
    w = 'up';
    a = 'left';
    s = 'down';
    d = 'right';
    k = 'push';
    l = 'pull'
    })

    :add("sigils", {"strength"})
end







