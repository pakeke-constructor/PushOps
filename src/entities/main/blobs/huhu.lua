



local shape = love.physics.newCircleShape(8)

local atlas = require "assets.atlas"
local Quads = atlas.Quads



local ai_types = { "ORBIT", "LOCKON" }

local ccall = Cyan.call


local COLOUR = {0.8,0.6,0.5}


local physColFunc = function(ent, oth, speed)
    EH.PC(ent,oth,speed)
end




local psys = love.graphics.newParticleSystem(atlas.image)
psys:setQuads(Quads.beet, Quads.bat, Quads.bot)
psys:setParticleLifetime(0.2, 0.4)
--psys:setLinearAcceleration(0,0,200,200)
psys:setDirection(180)
psys:setSpeed(5,15)
psys:setEmissionRate(90)
psys:setSpread(math.pi/2)
psys:setEmissionArea("uniform", 6,0)
psys:setColors({1,1,1}, {1,1,1,0})
psys:setRotation(0, 2*math.pi)
psys:setRelativeRotation(false)
local _,_, pW, pH = psys:getQuads()[1]:getViewport( )
psys:setOffset(pW/2, pH/2)





local r = love.math.random

local function onDamage(e)
    local p = e.pos
    ccall("emit", "guts", p.x, p.y, p.z, r(1,4))
end


local function onDeath(e)
    local p = e.pos
    ccall("emit", "guts", p.x, p.y, p.z, r(6,7))
    ccall("emit", "dust", p.x, p.y, p.z, 3)
    ccall("sound", "splat", 0.25, 1, 0.15, 0.5)
    EH.TOK(e,1)
end




local frames = {1,2,3,2}
for i,v in ipairs(frames) do
    frames[i] = Quads["huhu"..tostring(v)]
end



return function(x,y)
    local huhu = Cyan.Entity()

    :add("pos", math.vec3(x,y,0))
    
    :add("vel", math.vec3(0,0,0))

    :add("hp", {hp = 100, max_hp = 100})

    :add("speed", {speed = 140, max_speed = math.random(200,250)})

    :add("strength", 15)

    :add("physics", {
        shape = shape;
        body  = "dynamic";
        friction = 0.9
    })

    :add("collisions", {
        physics = physColFunc
    })

    :add("onDamage", onDamage)

    :add("onDeath", onDeath)

    :add("bobbing", {magnitude = 0.3 , value = 0})

    :add("targetID", "enemy") -- is an enemy

    huhu:add("behaviour",{
            move = {
                type = Tools.rand_choice(ai_types),
                id="player",

                orbit_tick = 0,
                orbit_speed = 0.5
            }
    })

    huhu:add("animation",
    {
        frames = frames;
        interval = 0.1;
        current = 1
    })

    huhu:add("friction", {
        amount = 6;
        emitter = psys:clone();
        required_vel = 10
    })

    :add("colour", COLOUR)

    return huhu
end





