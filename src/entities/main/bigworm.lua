




--[[


!!! DO REALLY GOOD ART FOR THIS !!!!
I would recommend switching from 32x32 to
64x64 pixels btw. Just so you can afford to have slightly larger,
and different shaped rocks with jagged edges etc


Idea: since follow ents cant really have a physics body,
make it so there are beating hearts following the rockworm around.
If the player kills all 3 beating hearts, the worm dies.
Give good visual feedback for this; i.e, draw opaque lines towards
the worm head from the worm-hearts.
Also, make sure to have an animation of them beating. Speed up the
beating animation when there is only 1 heart left

(If the hearts are all killed really easily, make a phase-two,
where the worm spawns 3 more hearts that shoot out bullets, and the worm
splits into two or something)

]]
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call

local Entity = Cyan.Entity

local DISTANCE = 22 -- The distance between worm nodes


local MIN_LEN = 30
local MAX_LEN = 32 -- min and max lengths for worm.


local JUMP_VEL = 18000 -- velocity of worm jump
local REQ_SPEED = 120 -- required to be moving at `X` speed to initiate a jump

local Z_MIN = -(MAX_LEN * (DISTANCE+5))

local GRAVITYMOD = 0.5


local bigrocks = {}
for x=1,3 do
    local quad_name = 'bigrock' .. tostring(x)
    table.insert(bigrocks, Quads[quad_name])
end


local function onDetatch(worm)
    -- yeah just kill em
    ccall("kill",worm)
end





local WormTree = EH.Node("_worm behaviour tree")



local wormJump = EH.Task("_worm jump node")
function wormJump:start(worm)
    worm.vel.z = JUMP_VEL
    worm.pos.z = -1
end
function wormJump:update(worm,dt)
    if worm.pos.z < 0 then
        return "n"
    end
    return "r"
end



WormTree.jump = {
    wormJump,
    "wait::5"
}

WormTree.wait = {
    "wait::1"
}


function WormTree:choose(worm)
    local targ_ent = worm.behaviour.move.target_ent
    if targ_ent then
        -- then check if we are at required speed and are moving
        -- towards the player.
        local vel = worm.vel
        local to = targ_ent.pos - worm.pos
        local proj = vel:project(to)
        
        if (proj + to):len() < to:len() then
            -- projection vector + worm -> target vector is less than
            -- worm -> target vector. 
            return "wait" -- So the worm is moving away from player. ret wait.
        end

        if proj:len() > REQ_SPEED then
            --[[
                yup! head worm node is moving towards the player at
                the required speed. 
                signal a jump
            ]]
            return "jump"
        end
    end
    return "wait"
end




local rand = love.math.random
local floor = math.floor


local function onSurface(e)
    -- TODO: play sound in these callbacks
    local p=e.pos
    ccall("emit","rocks", p.x,p.y,p.z, floor(rand()*4))
end

local function onGround(e)
    local p=e.pos
    ccall("emit","rocks", p.x,p.y,p.z, floor(rand()*4))
end



local function wormNodeCtor(worm)
    local wn = Entity()
    local epos=worm.pos

    wn.gravitymod = 0 -- must get pulled down; 0 gravity
    wn.rot = rand()*math.pi*2
    wn.pos = math.vec3(epos.x,epos.y,epos.z)
    wn.follow = {
        following = worm;
        distance = DISTANCE;
        onDetatch = onDetatch
    }
    wn.vel = math.vec3(0,0,0)
    wn.dig = {
        digging = false;
        z_min = Z_MIN;
        onSurface = onSurface;
        onGround = onGround
    }
    wn.image = Tools.rand_choice(bigrocks)
    return wn
end





return function(x,y)
    --[[
        note that this entity just represents
        the head of the worm.

        There are many entities that follow behind the worm
        as constructed by wormNodeCtor
    ]]
    local worm = Entity()
    EH.PV(worm,x,y)

    local len = math.floor(love.math.random(MIN_LEN, MAX_LEN))

    -- Create big chain of worm nodes.
    local last = worm
    for x=1,len do
        last = wormNodeCtor(last)
    end

    worm.dig = {
        digging = false;
        z_min = Z_MIN;
        onSurface = onSurface;
        onGround = onGround
    }

    worm.gravitymod=GRAVITYMOD

    worm.speed = {
        speed = 230 + rand()*50;
        max_speed = 270 + rand()*50
    }

    worm.behaviour = {
        --WormTree = WormTree;
        move = {
            id="player";
            type="LOCKON"
        };
        tree=WormTree
    }
    return worm
end

