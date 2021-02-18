
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call
local rand = love.math.random



local function invisGhostColFunc(e,player)

end

local function invisGhostOnDeath(e)
    ccall("emit")
end


local function invisGhost(x,y)
    local e = Cyan.Entity()

    EH.PV(e,x,y)

    e.speed = {
        speed = rand(40,80);
        max_speed = rand(70,100)
    }

    e.behaviour = {
        move = {
            type = "ORBIT"; -- We keep still until parent ghost
                            -- is unobstructed to player
            id="player";
            orbit_speed = 2;
            orbit_tick=0;
            orbit_radius = rand(10,70)
        }
    }

    e.onDeath = invisGhostOnDeath

    e.collisions = {
        area = {
            player = invisGhostColFunc
        }
    }

    return e
end


local Tree = EH.Node("_ghost behaviour tree")

Tree.angry = {
    "move::orbit"
}

Tree.normal = {
    "move::rand";
    "wait::3"
}

function Tree:choose(ent)
    error("NOT YET DONE")
end



return function(x, y)
    local e = Cyan.Entity()
    EH.PV(e,x,y)
    EH.PHYS(e,10)
    e.speed = {
        speed=rand(80,160);
        max_speed = rand(100,200)
    }

 

    e.behaviour = {
        tree=Tree;
    }
    
    

end

