
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call
local rand = love.math.random

local GHOST_COL = {0.9,1,0.9}
local GHOST_CHILD_COL = {0.9,1,0.9, 0.4}

local GHOST_CHILD_DMG = 10


local function invisGhostColFunc(e,player)
    ccall("damage",player, 10)
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
    e.speed = {
        speed = rand(70,110);
        max_speed = rand(90,120)
    }
    e.ghost_parent_e = parent
    e.behaviour = {
        move = {
            type = "VECORBIT"; -- We keep still until parent ghost
                            -- is unobstructed to player
            id="player";
            orbit_speed = rand()*2;
            orbit_tick=0;
            orbit_radius = rand(30,100);
            target = parent.pos  -- this is allowed, because VECORBIT is safely mutable
        }}
    e.onDeath = invisGhostOnDeath
    e.collisions = {
        area = {
            player = invisGhostColFunc
        }
    }
    e.colour = GHOST_CHILD_COL
    return e
end




local angerChildGhosts = EH.Task("_anger child ghosts")
function angerChildGhosts:start(e)
    --TODO: play a sound here as well
    ccall("shockwave", e.pos.x,e.pos.y, 3, 80, 4, 0.3, {0.9,0.1,0.1})
    for _,c in ipairs(e.child_ghost_ents) do
        ccall("setMoveBehaviour", c, "ORBIT", "player")
    end
end
function angerChildGhosts:update(e,dt)
    return "n"
end


local pacifyChildGhosts = EH.Task("_pacify child ghosts")
function pacifyChildGhosts:start(e)
    for _,c in ipairs(e.child_ghost_ents) do
        ccall("setMoveBehaviour", c, "VECORBIT")
        c.behaviour.move.target = e.pos
        -- assert that child ghosts go back to their parent
    end
end
function pacifyChildGhosts:update(e,dt)
    return "n"
end



local Tree = EH.Node("_ghost behaviour tree")

Tree.angry = {
    "move::ORBIT";
    angerChildGhosts;
    "wait::10"
}

Tree.normal = {
    "move::RAND";
    pacifyChildGhosts;
    "wait::3"
}

function Tree:choose(ent)
    if ent.hp.hp < ent.hp.max_hp or rand()<0.2 then
        return "angry"
    end
    return "normal"
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
        move={
            orbit_radius = 100;
            orbit_tick = 0;
            orbit_speed = rand()*4
        }
    }
    e.hp = {
        hp=1000;
        max_hp=1000
    }

    e.child_ghost_ents = { }
    for u=1,rand(4,7)do
        -- constructing children
        table.insert(e.child_ghost_ents,
            invisGhost(x + 5*rand(), y+ 5*rand(), e)
        )
    end

    e.colour = GHOST_COL
end

