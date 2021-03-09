



local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call

local rand = love.math.random


local COLOUR = {0.85,0.85,0.95,0.8}


local GHOST_FRAMES = {}
for iii=1, 9 do
    table.insert(GHOST_FRAMES, Quads["ghost"..tostring(iii)])
end


local function physColFunc(e,oth,speed)
    if EH.PC(e,oth,speed) then
        -- TODO :
        -- make sound or something, idk. feedback!
    end
end


local function invisGhostOnDeath(e)
    ccall("emit", 'dust', e.pos.x,e.pos.y,e.pos.z, 10)
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
    EH.PHYS(e, 8)
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
    e.onDeath = invisGhostOnDeath
    e.collisions = {
        physics = physColFunc
    }
    e.colour = COLOUR
    e.hp = {
        hp=100;
        max_hp=100
    }
    return e
end



