





local enemy_shape = love.physics.newCircleShape(8)

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
psys:setColors({0.43,0,0.52,0.6}, {0.43,0,0.52,0})
psys:setSpin(-40,40)
psys:setRotation(0, 2*math.pi)
psys:setRelativeRotation(false)
local _,_, pW, pH = psys:getQuads()[1]:getViewport( )
psys:setOffset(pW/2, pH/2)



local motion_down = { Quads.enemy_down_1, Quads.enemy_down_2, Quads.enemy_down_3, Quads.enemy_down_4 }
local motion_up = { Quads.enemy_up_1, Quads.enemy_up_2, Quads.enemy_up_3, Quads.enemy_up_4 }
local motion_left = { Quads.enemy_left_1, Quads.enemy_left_2, Quads.enemy_left_3, Quads.enemy_left_4 }
local motion_right = { Quads.enemy_right_1, Quads.enemy_right_2, Quads.enemy_right_3, Quads.enemy_right_4 }



local COLOUR={0.43,0,0.52,0.6}


local ccall = Cyan.call

local r = love.math.random


local onDeath = function(e)
    local p = e.pos
    ccall("emit", "guts", p.x, p.y, p.z, r(2,4))
    ccall("emit", 'dust', e.pos.x,e.pos.y,e.pos.z, 9)
    EH.TOK(e,r(1,2))
end


local ai_types = { "ORBIT", "LOCKON" }


local ENT_DMG_SPEED = CONSTANTS.ENT_DMG_SPEED

local physColFunc = function(e1, e2, speed)
    if EH.PC(e1,e2,speed) then
        ccall("sound","thud")
    end
end


local RAND_or_IDLE = {"RAND", "IDLE"}



local Tree = EH.Node '_enemy behaviour tree'

Tree.choose = function(node, e)
        return "angry" -- we removed tree, no point. `LOCKON` and `ORBIT` is just better.
end

local rand_move_task = EH.Task("_enemy move task")
rand_move_task.start = function(t,e)
    ccall("setMoveBehaviour", e, Tools.rand_choice(ai_types))
end
rand_move_task.update=function(t,e)
    return "n"
end


Tree.angry = {
    rand_move_task,
    "wait::10"
}




Tree:on("damage", function(n,e)
    return "angry"
end)





return function(x,y)
    local enemy = Cyan.Entity()
    :add("pos", math.vec3(x,y,0))
    :add("vel", math.vec3(0,0,0))
    :add("acc", math.vec3(0,0,0))
    :add("hp", {hp = 100, max_hp = 100})
    :add("speed", {speed = 145, max_speed = math.random(200,240)})
    :add("fade", 225)

    if r() < 0.3 then
        enemy:add("sigils",{"poison"})
        enemy.speed.max_speed = 300
        enemy.speed.speed = 210
    end

    enemy
    :add("strength", 40)

    :add("physics", {
        shape = enemy_shape;
        body  = "dynamic"
    })

    :add("colour", COLOUR)

    :add("bobbing", {magnitude = 0.25 , value = 0})
    
    :add("friction", {
        amount = 6; -- The amount of friction given to this entity
        emitter = psys:clone();
        required_vel = 10;
    })

    :add("targetID", "enemy") -- is an enemy

    enemy:add("behaviour",{
            move = {
                type = Tools.rand_choice(ai_types),
                id="player", -- targetting player.
                
                orbit_speed = 2;
                orbit_tick = 0
            };
            tree=Tree
    })

    :add("onDeath", onDeath)

    :add("collisions",{
        physics = physColFunc
    })

    enemy:add("motion",
    {
        up = motion_up;
        down = motion_down;
        left = motion_left;
        right = motion_right;

        current = 0;
        interval = 0.1;
        required_vel = 20;
    })

    return enemy
end

