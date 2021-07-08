


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
psys:setColors({1,1,1}, {1,1,1,0})
psys:setSpin(-40,40)
psys:setRotation(0, 2*math.pi)
psys:setRelativeRotation(false)
local _,_, pW, pH = psys:getQuads()[1]:getViewport( )
psys:setOffset(pW/2, pH/2)



local down = {}
local up = {}
local left = {}
local right = {}

local order = {1,2,1,4}

local ti = table.insert
local im = "spotted_enemy_"

for _,i in ipairs(order)do
    ti(up, Quads[im.."up_"..tostring(i)])
end

for _,i in ipairs(order)do
    ti(left, Quads[im.."left_"..tostring(i)])
end
for _,i in ipairs(order)do
    ti(right, Quads[im.."right_"..tostring(i)])
end
for i=1,4 do
    ti(down, Quads[im.."down_"..tostring(i)])
end




local ccall = Cyan.call

local r = love.math.random


local onDeath = function(e)
    local p = e.pos
    ccall("emit", "guts", p.x, p.y, p.z, r(2,4))
    ccall("emit", 'dust', p.x, p.y, p.z, 9)
    ccall("splat", p.x, p.y, 70)
    EH.TOK(e,r(1,2))
end


local ai_types = { "ORBIT", "LOCKON" }


local ENT_DMG_SPEED = CONSTANTS.ENT_DMG_SPEED

local physColFunc = function(e1, e2, speed)
    if EH.PC(e1,e2,speed) then
        ccall("sound","hit")
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

    enemy
    :add("strength", 40)

    :add("physics", {
        shape = enemy_shape;
        body  = "dynamic"
    })

    :add("colour", CONSTANTS.SPLAT_COLOUR)

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
        up = up;
        down = down;
        left = left;
        right = right;

        current = 0;
        interval = 0.1;
        required_vel = 20;
    })

    return enemy
end

