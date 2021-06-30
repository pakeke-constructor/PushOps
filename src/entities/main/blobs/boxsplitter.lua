



--[[

Recursively splits and reduces it's transparency until it
is only made up of small blobs

]]



local blob_shape = love.physics.newCircleShape(10)

local atlas = require "assets.atlas"
local Quads = atlas.Quads



local ai_types = { "ORBIT", "LOCKON" }


local COLOURS = {
    {0.4, 0.4,  0.4,   0.7};
    {0.35,0.5,  0.35,  0.7};
    {0.3, 0.6,  0.3,   0.6};
    {0.2, 0.7,  0.2,   0.6};
    {0.2, 1.0,  0.1,   0.6}
}


local SIGILS = {"crown"}

local MAX_GENERATIONS = #COLOURS

local ccall = Cyan.call



local ENT_DMG_SPEED = CONSTANTS.ENT_DMG_SPEED

local physColFunc = function(ent, oth, speed)
    EH.PC(ent,oth,speed)
end



local r = love.math.random

local function onDamage(e)
    local p = e.pos
    ccall("emit", "guts", p.x, p.y, p.z, r(1,4))
end


local function spawn2(pos, split_gen)
    local a = EH.Ents.boxsplitter(pos.x + 9, pos.y - 9)
    if r()<0.3 then
        EH.Ents.block(pos.x, pos.y)
    end
    local b = EH.Ents.boxsplitter(pos.x - 9, pos.y + 9)
    
    local sp = split_gen + 1
    b.split_generation = sp
    a.split_generation = sp
    b.colour = COLOURS[sp]
    a.colour = COLOURS[sp]
    a:remove("sigils")
    b:remove("sigils")
end


local floor = math.floor
local function spawnSmall(pos)
    EH.Ents.block(pos.x,pos.y)
    for i=1,1+floor(2*r()) do
        local r = (r()-0.5)*10
        local e = EH.Ents.bloblet(pos.x+r,pos.y-r)
        e.colour = COLOURS[#COLOURS]

        -- reduce the speed to make these little guys less annoying
        local sp = {}
        sp.max_speed = e.speed.max_speed / 2
        sp.speed = e.speed.speed / 2
        e.speed = sp
    end
end



local function onDeath(e)
    local p = e.pos
    ccall("emit", "guts", p.x, p.y, p.z, r(4,7))
    ccall("emit", "dust", p.x, p.y, p.z, r(3,5))
    EH.TOK(e,1,3)
    if e.split_generation < MAX_GENERATIONS-1 then
        ccall("await", spawn2, 0, e.pos, e.split_generation)
    end
end





local frames = {Quads.blob1, Quads.blob2, Quads.blob3, Quads.blob2, Quads.blob1, Quads.blob0}

return function(x,y)
    local bsplitter = Cyan.Entity()

    :add("pos", math.vec3(x,y,0))
    
    :add("vel", math.vec3(0,0,0))

    :add("hp", {hp = 100, max_hp = 100})

    :add("speed", {speed = 100, max_speed = math.random(150,200)})

    :add("strength", 40)

    :add("split_generation", 1)

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

    bsplitter:add("behaviour",{
            move = {
                type = Tools.rand_choice(ai_types),
                id="player",

                orbit_tick = 0,
                orbit_speed = 0.5
            }
    })

    :add("sigils",SIGILS)
    
    bsplitter:add("animation",
    {
        frames = frames;
        interval = 0.1;
        current = 1
    })

    EH.FR(bsplitter)

    :add("colour", COLOURS[1])

    return bsplitter
end

