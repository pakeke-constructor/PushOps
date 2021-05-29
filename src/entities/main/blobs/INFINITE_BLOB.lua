
--[[

INFIIIIIIINITYYYYY

(This is actually really funny until it hits 4 fps)

]]


local blob_shape = love.physics.newCircleShape(10)

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
local cols = {{1,0.2,0.2,0.6}}

local ccall = Cyan.call



local ENT_DMG_SPEED = CONSTANTS.ENT_DMG_SPEED

local physColFunc = function(ent, oth, speed)
    EH.PC(ent,oth,speed)
end



local r = love.math.random

local function onDamage(INF_BLOB)
    local p = INF_BLOB.pos
    ccall("emit", "guts", p.x, p.y, p.z, r(1,4))
end


local function spawn2(pos)
    EH.Ents.INFINITE_BLOB(pos.x + 5, pos.y - 5)
    EH.Ents.INFINITE_BLOB(pos.x - 5, pos.y + 5)
end

local function onDeath(INF_BLOB)
    local p = INF_BLOB.pos
    ccall("emit", "guts", p.x, p.y, p.z, r(4,7))
    ccall("emit", "smoke", p.x, p.y, p.z, r(3,5))
    EH.TOK(INF_BLOB,1,3)
    ccall("await", spawn2, 0, INF_BLOB.pos)
end




local frames = {Quads.blob1, Quads.blob2, Quads.blob3, Quads.blob2, Quads.blob1, Quads.blob0}

return function(x,y)
    local INFINITE_BLOB = Cyan.Entity()

    :add("pos", math.vec3(x,y,0))
    :add("text", "GOD")
    :add("vel", math.vec3(0,0,0))

    :add("hp", {hp = 100, max_hp = 100})

    :add("speed", {speed = 140, max_speed = math.random(200,250)})

    :add("strength", 40)

    :add("physics", {
        shape = blob_shape;
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

    INFINITE_BLOB:add("behaviour",{
            move = {
                type = Tools.rand_choice(ai_types),
                id="player",

                orbit_tick = 0,
                orbit_speed = 0.5
            }
    })
    
    INFINITE_BLOB:add("animation",
    {
        frames = frames;
        interval = 0.1;
        current = 1
    })

    EH.FR(INFINITE_BLOB)

    :add("colour", Tools.rand_choice(cols))

    return INFINITE_BLOB
end

