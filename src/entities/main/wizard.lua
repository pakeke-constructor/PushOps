






local enemy_shape = love.physics.newCircleShape(8)

local atlas = require "assets.atlas"
local Quads = atlas.Quads

local psys = love.graphics.newParticleSystem(atlas.image)
do
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
end
local _,_, pW, pH = psys:getQuads()[1]:getViewport( )
psys:setOffset(pW/2, pH/2)



local Q = EH.Quads
local up = {"up_1", "up_2"}
local down = {"down_1", "down_2"}
local left = {"left_1", "left_2"}
local right = {"right_1", "right_2"}
for i,tab in ipairs({up,down,left,right})do
    for ii, st in ipairs(tab)do
        tab[ii] = Q["wizard_"..st]
    end
end




local COLOUR={
    1,1,1
}

local BOLT_SPEED = 290


local Cam = require("src.misc.unique.camera")




local ccall = Cyan.call

local rand = love.math.random


local onDeath = function(e)
    local p = e.pos
    ccall("emit", "guts", p.x, p.y, p.z, rand(2,4))
    ccall("emit", 'dust', e.pos.x, e.pos.y,e.pos.z, 9)
    EH.TOK(e,rand(1,2))
end


local ai_types = { "ORBIT", "LOCKON" }


local ENT_DMG_SPEED = CONSTANTS.ENT_DMG_SPEED

local physColFunc = function(e1, e2, spd)
    if EH.PC(e1,e2,spd) then
        ccall("sound","thud")
    end
end





local Tree = EH.Node '_wizard behaviour tree'

local shoot = EH.Task("_wizard shoot")



function shoot:start(e)
    -- TODO: play wizard cast animation right here
    local vec = (math.vec3(Cam.x, Cam.y, 0) - e.pos)
    if vec:len() == 0 then
        return -- This should never happen tho
    end
    vec = vec:normalize()
    local dx = vec.x
    local dy = vec.y
    ccall("animate", "wizardcast", 0,0,0,
            0.04, 1, nil, e, true)
    ccall("shootbolt", e.pos.x+dx*15, e.pos.y + dy*15, dx*BOLT_SPEED, dy*BOLT_SPEED)
    ccall("shockwave", e.pos.x, e.pos.y, 4, 20, 3, 0.1, {0.4,0.05,0.6})
end

function shoot:update(e,dt)
    if not e.hidden then
        return "n"
    end
    return "r"
end


Tree.chase = {
    "move::ORBIT";
    "wait::2"
}

Tree.shoot = {
    "move::IDLE";
    shoot;
    shoot;
    shoot;
    shoot;
    shoot;
    shoot;
    "move::ORBIT";
    "wait::2"
}


Tree.choose = function(e)
    local r = rand()
    if r < 0.5 then
        return "shoot"
    end
    return "chase"
end




return function(x,y)
    local wiz = Cyan.Entity()
    :add("pos", math.vec3(x,y,0))
    :add("vel", math.vec3(0,0,0))
    :add("acc", math.vec3(0,0,0))
    :add("hp", {hp = 100, max_hp = 100})
    :add("speed", {speed = 145, max_speed = math.random(200,240)})
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

    :add("behaviour",{
            move = {
                type = "ORBIT",
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

    wiz:add("motion",
    {
        up = up;
        down = down;
        left = left;
        right = right;

        current = 0;
        interval = 0.3;
        required_vel = 20;
    })

    return wiz
end


