
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call
local rand = love.math.random

local onDeath = function(e)
    EH.TOK(e,1)
end


local colComp={
    physics = function(e,e2,s)
        if EH.PC(e,e2,s) then
            -- blah
        end
    end
}


local colour = {0.75,1,0.75}

local f = {Quads.bloblet1, Quads.bloblet2}


local speed = {
    speed = 80;
    max_speed = 100
}


return function(x, y)
    local e = Cyan.Entity()
    EH.PV(e,x,y)
    EH.PHYS(e,7) -- Q: 'why is the bloblet so big???'
                 -- A: small bloblets are super annoying to hit, especially since
                -- they run super fast
    e.collisions = colComp
    e.targetID="enemy"
    e.speed = speed
    e.strength = 5
    e.hp = {
        hp=50;
        max_hp=50
    }
    e.onDeath=onDeath
    e.behaviour={
        move={
            type="LOCKON"; -- changing to LOCKON, ORBIT was annoying
            id="player"
        }
    };
    e.animation = {
        frames = f;
        interval= (rand()/2)+0.5
    }
    EH.BOB(e)
    e.colour = colour

    return e
end

