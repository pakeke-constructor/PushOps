


local shape = love.physics.newCircleShape(10)

local atlas = require "assets.atlas"
local Quads = atlas.Quads



local ai_types = { "ORBIT", "LOCKON" }

--[[
local cols = {
    {0.9,0.1, 0.1};
    {0,0.8,0.7};
    {1,0.3,1};
    {0.5,1,0.1};
    {0.8,0.9,0.2};
    {0.9,0.1,0.9}
}]]
local cols = {{0.75,1,0.75,0.8}}

local ccall = Cyan.call



local physColFunc = function(ent, oth, speed)
    EH.PC(ent,oth,speed)
end



local r = love.math.random

local function onDamage(e)
    local p = e.pos
    ccall("emit", "guts", p.x, p.y, p.z, r(1,4))
end


local function onDeath(e)
    local p = e.pos
    ccall("emit", "guts", p.x, p.y, p.z, r(8,11))
    ccall("emit", "dust", p.x, p.y, p.z, 8)
    EH.TOK(e,r(1,3))
end




local frames = {Quads.blob1, Quads.blob2, Quads.blob3, Quads.blob2, Quads.blob1, Quads.blob0}

return function(x,y)
    local blob = Cyan.Entity()

    :add("pos", math.vec3(x,y,0))
    
    :add("vel", math.vec3(0,0,0))

    :add("hp", {hp = 100, max_hp = 100})

    :add("speed", {speed = 140, max_speed = math.random(200,250)})

    :add("strength", 40)

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

    blob:add("behaviour",{
            move = {
                type = Tools.rand_choice(ai_types),
                id="player",

                orbit_tick = 0,
                orbit_speed = 0.5
            }
    })
    
    blob:add("animation",
    {
        frames = frames;
        interval = 0.1;
        current = 1
    })

    EH.FR(blob)

    :add("colour", Tools.rand_choice(cols))

    return blob
end

