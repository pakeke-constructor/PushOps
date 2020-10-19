


local player_shape = love.physics.newCircleShape(10)

local atlas = require "assets.atlas"
local Quads = atlas.Quads

local psys = love.graphics.newParticleSystem(atlas.image)
psys:setQuads(Quads.bat, Quads.bot, Quads.bit)
psys:setParticleLifetime(0.4, 0.6)
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


local motion_down = { Quads.player_down_1, Quads.player_down_2, Quads.player_down_3, Quads.player_down_4 }
local motion_up = { Quads.player_up_1, Quads.player_up_2, Quads.player_up_3, Quads.player_up_4 }
local motion_left = { Quads.player_left_1, Quads.player_left_2, Quads.player_left_3, Quads.player_left_4 }
local motion_right = { Quads.player_right_1, Quads.player_right_2, Quads.player_right_3, Quads.player_right_4 }





local ai_types = { "ORBIT", "LOCKON","HIVE" }



return function(x,y)
    local enemy = Cyan.Entity()

    :add("pos", math.vec3(x,y,0))
    :add("vel", math.vec3(0,0,0))
    :add("acc", math.vec3(0,0,0))
    
    :add("hp", {hp = 100, max_hp = 100})

    :add("speed", {speed = 4, max_speed = math.random(40,160)})

    :add("strength", 40)

    :add("physics", {
        shape = player_shape;
        body  = "dynamic"
    })

    :add("bobbing", {magnitude = 0.25 , value = 0})
    
    :add("friction", {
        amount = 6; -- The amount of friction given to this entity
        emitter = psys:clone();
        required_vel = 10;
    })

    enemy:add("behaviour",{
            move = {type = Tools.rand_choice(ai_types), id=1}
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

    :add("sigils", {"strength"})

    return enemy
end

