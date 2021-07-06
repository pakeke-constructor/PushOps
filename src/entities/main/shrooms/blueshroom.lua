
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call
local rand = love.math.random


local COLOUR = {1,1,1}


local up={}
local down={}
local right={}
local left={}


local ti = table.insert
local function ins(t, dir)
    ti(t, Quads["shroom_" .. dir .. "_1"])    
    ti(t, Quads["shroom_" .. dir .. "_2"])    
    ti(t, Quads["shroom_" .. dir .. "_1"])    
    ti(t, Quads["shroom_" .. dir .. "_3"])    
end

ins(up,"up")
ins(down,"down")
ins(right,"right")
ins(left,"left")



local function physColF(e,u,sp)
    if (EH.PC(e,u,sp)) then
        -- TODO
        -- particles and stuff here eetc.
    end
end


local function onDeath(e)
    ccall("emit", "blue_mushroom", e.pos.x, e.pos.y, e.pos.z, 1)
    EH.TOK(e,1)
end


local COLOUR = {101/255, 194/255, 191/255}


return function(x, y)

    --[[

    Todo:

    Shroom entity. 

    Explodes on contact with player

    ]]
    local e = Cyan.Entity()
    
    EH.PV(e,x,y)

    :add("motion",
    {
        up=up;
        down=down;
        left=left;
        right=right;
        
        current = 0;
        interval = 0.12;
        required_vel = 50
    })

    :add("speed",{
        speed = 120;
        max_speed = 120
    })

    :add("collisions",{
        physics = physColF
    })

    EH.PHYS(e,6)
    EH.FR(e)

    :add("colour", COLOUR)

    :add("targetID","enemy")

    :add("hp",{
        hp=100;
        max_hp = 100
    })

    :add("onDeath",onDeath)

    :add("behaviour",{
        move={
            id = "player";
            type = "ORBIT";
            orbit_speed = rand()+0.5;
            orbit_tick = rand()*3;
            orbit_radius = 140 * (rand()+0.5)
        }
    })

    :add("colour",COLOUR)
    
    return e
end

