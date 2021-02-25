
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call
local rand = love.math.random




local COLOUR = {0.75,1,0.75,0.8}
local COLOUR_F = {80/256,38/256,99/256,0}



local emitter,_,pW,pH
do
    emitter=love.graphics.newParticleSystem(Atlas.image,400)
    emitter:setQuads(Quads.circ4, Quads.circ3, Quads.circ3, Quads.circ2)
    emitter:setParticleLifetime(0.7, 1.2)
    --emitter:setLinearAcceleration(0,0,200,200)
    emitter:setDirection(180)
    emitter:setSpeed(0.5,1)
    emitter:setEmissionRate(200)
    emitter:setSpread(math.pi/2)
    emitter:setColors(COLOUR,COLOUR_F)
    emitter:setSpin(0,0)
    emitter:setEmissionArea("uniform", 22,12)
    emitter:setRotation(0, 2*math.pi)
    emitter:setRelativeRotation(false)
    _,_, pW, pH = emitter:getQuads()[1]:getViewport( )
    emitter:setOffset(pW/2, pH/2)
end


local function colF(e,e2,s)
    if EH.PC(e,e2,s) then
        -- TODO: noise or something
    end
end


local function splitterOnDeath(e)
    local p = e.pos
    ccall("emit", "guts", p.x, p.y, p.z, rand(4,7))
    ccall("emit", "smoke", p.x, p.y, p.z, rand(3,5))
    EH.TOK(e,1,3)
    for i=1,rand(2,3) do
        local w=EH.Ents.bloblet(e.pos.x + 10*(rand()-0.5), e.pos.y + 10*(rand()-0.5))
        w.colour=e.colour
    end
end

local spawnLittleBlobs = function(e)
    local x,y = e.pos.x,e.pos.y
    for i=1,rand(4,5) do
        local u=EH.Ents.blob(x + 20*(rand()-0.5), y + 20*(rand()-0.5))
        u.onDeath = splitterOnDeath
        u.colour = COLOUR
    end
end

local onDeath = function(e)
    -- TODO: roar and stuff, big shockwave, big deal yada yada.
    -- player just killed a boss!
    ccall("await", spawnLittleBlobs, 0, e)
end


local col_comp = {
    physics=colF
}


local f={1,2,3,4,3,2} -- generate frames
for i,n in ipairs(f) do
    f[i] = Quads["bigblob"..tostring(n)]
end


local speed = {
    speed=1170;
    max_speed = 1185
}


local Tree=EH.Node("_bigblob node.")

local wallbreak_task = EH.Task("_bigblob wallbreak task")

function Tree:choose(e)
    if rand()<0.5 then
        return "wallbreak"
    end
    return "chase"
end

function wallbreak_task:start(e)
    ccall("setMoveBehaviour",e,"IDLE")
    ccall("shockwave",e.pos.x,e.pos.y,130,4,7,0.3)
end

function wallbreak_task:update(e,dt)
    if self:runtime(e)>0.6 then
        return"n"
    end
    return"r"
end


local function boomTime(x,y,z)
    --[[
        Creates explosion
    ]]
    Cyan.call("boom", x, y, 40, 100, 0,0, "player", 1.2)
    Cyan.call("animate", "push", x,y+25,z, 0.03) 
    Cyan.call("shockwave", x, y, 4, 130, 7, 0.3)
    Cyan.call("sound", "boom")
end


function wallbreak_task:finish(e)
    local x,y,z = e.pos.x,e.pos.y,e.pos.z
    for i=1,rand(9,13) do -- do a random number of explosions, 9->13
        ccall("await", boomTime, i/(6+ (4*rand())), x + 300*(rand()-0.5), y + 300*(rand()-0.5), z)
    end
end


Tree.chase={
    "move::LOCKON",
    "wait::8"
}


Tree.wallbreak = {
    wallbreak_task;
    "wait::2"
}



return function(x, y)
    local e = Cyan.Entity()
    EH.PV(e,x,y)
    EH.PHYS(e,30)
    e.friction = {
        emitter=emitter:clone();
        amount=3;
        required_vel=10
    }
    e.animation = {
        frames=f;
        interval=0.15
    }
    e.bobbing = {
        value=0;
        magnitude=0.3
    }
    e.hp={
        hp=100;
        max_hp=100
    }
    e.speed = speed
    e.behaviour={
        move={
            move="LOCKON";
            id="player"
        };
        tree=Tree
    }
    e.onDeath=onDeath
    e.colour=COLOUR
    e.targetID = "enemy"
    e.collisions=col_comp
end




