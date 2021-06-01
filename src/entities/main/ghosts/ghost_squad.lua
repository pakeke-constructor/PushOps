
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call
local rand = love.math.random

local GHOST_COL = {0.9,0.9,1,0.9}
local GHOST_CHILD_COL = {0.9,0.9,1, 0.75}

local GHOST_CHILD_DMG = 10



local GHOST_FRAMES = {}
for iii=1, 9 do
    table.insert(GHOST_FRAMES, Quads["ghost"..tostring(iii)])
end



local function invisGhostColFunc(e,player)
    ccall("damage", player, 10)
end

local function invisGhostOnDeath(e)
    ccall("emit", 'dust', e.pos.x,e.pos.y,e.pos.z, 10)
end


local function invisGhost(x,y, parent)
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
    e.ghost_parent_e = parent
    e.behaviour = {
        move = {
            type = "VECORBIT"; -- We keep still until parent ghost
                            -- is unobstructed to player
            orbit_speed = rand()*2;
            orbit_tick=0;
            orbit_radius = rand(30,100);
            target = parent.pos  -- this is allowed, because VECORBIT is safely mutable
        }}
    e.animation = {
        frames = GHOST_FRAMES;
        interval = 0.05
    }
    e.onDeath = invisGhostOnDeath
    e.collisions = {
        area = {
            player = invisGhostColFunc
        }
    }
    e.colour = GHOST_CHILD_COL
    return e
end



--[[
    it was better without the child ghosts being on their own
]]


local Tree = EH.Node("_ghost behaviour tree")

Tree.angry = {
    "move::ORBIT";
    "wait::10"
}

Tree.normal = {
    "move::RAND";
    "wait::3"
}

function Tree:choose(ent)
    if ent.hp.hp < ent.hp.max_hp or rand()<0.2 then
        return "angry"
    end
    return "normal"
end


local onDeath = function(e)
    ccall("shockwave", e.pos.x,e.pos.y, 4,140,4, 0.3, {1,0.1,0.1})
    for _,u in ipairs(e.child_ghost_ents)do
        ccall("kill",u)
    end
    EH.TOK(e,rand(2,3))
end


local function pCF(e,e1,s)
    if EH.PC(e,e1,s) then
        ccall("sound","thud")
    end
end


return function(x, y)
    local e = Cyan.Entity()
    EH.PV(e,x,y)
    EH.PHYS(e,10)
    local spd = rand(80,100)
    e.speed = {
        speed=spd;
        max_speed = spd
    }
    e.behaviour = {
        tree=Tree;
        move={
            orbit_radius = 50;
            orbit_tick = 0;
            orbit_speed = rand()*4;
            id='player'
        }
    }
    e.hp = {
        hp=400;
        max_hp=400
    }
    e.animation = {
        frames = GHOST_FRAMES;
        interval = 0.05
    }
    e.targetID = "enemy"
    e.sigils ={
        "crown"
    }
    e.child_ghost_ents = { }
    for u=1,rand(4,7)do
        -- constructing children
        table.insert(e.child_ghost_ents,
            invisGhost(x, y, e)
        )
    end
    assert(e.child_ghost_ents~=0,"?????????")
    e.collisions = {physics=pCF}
    e.onDeath=onDeath
    e.colour = GHOST_COL
end

