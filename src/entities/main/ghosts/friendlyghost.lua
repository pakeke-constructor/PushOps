




local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call

local rand = love.math.random


local COLOUR = {0.3,0.3,0.95,0.75}


local GHOST_FRAMES = {}
for iii=1, 9 do
    table.insert(GHOST_FRAMES, Quads["ghost"..tostring(iii)])
end


local COOLDOWN = 0.5


local function enemyColFunc(e,enemy)
    if e._current_cooldown <= 0 then
        ccall("damage", enemy, 20)
        ccall("sound", "hit", 1, 2, 0.2, 0.2)
        ccall("animate", "hit", p.x, p.y, p.z, 0.07, nil)
        e._current_cooldown = COOLDOWN
    end
end


local function invisGhostOnDeath(e)
    ccall("emit", 'dust', e.pos.x,e.pos.y,e.pos.z, 10)
end


local function onUpdate(e,dt)
    e._current_cooldown = e._current_cooldown - dt
end


return function (x,y)
    --[[
        A `child` ghost that orbits around parent,
        and lives on until parent ghost dies.

        When parent ghost is angered, this ghost will attack player
    ]]
    local e = Cyan.Entity()
    EH.PV(e,x,y)
    local spd = rand(110,200)
    e.speed = {
        speed = spd;
        max_speed = spd
    }
    e.behaviour = {
        move = {
            type = "ORBIT";
            id = "player";
            orbit_speed = rand()*2;
            orbit_tick=0;
            orbit_radius = rand(20,40);
        }}
    e.animation = {
        frames = GHOST_FRAMES;
        interval = 0.05
    }
    e.targetID="neutral"
    e.onDeath = invisGhostOnDeath
    e.collisions = {
        enemy = enemyColFunc
    }
    e.colour = COLOUR
    e.hp = {
        hp=100;
        max_hp=100
    }
    e._current_cooldown = 0 
    e.onUpdate = onUpdate
    e.hybrid = true
    return e
end



