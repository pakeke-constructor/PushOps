
--[[

Future Oli here:
These little buggers are the funniest little things in the game.
What a brilliant idea to put them in.


Block entity that turns into an enemy when provoked
(current trigger is when player moves close)

When it gets low on health, it runs away and tries 
to hide as a block again.

]]



local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call
local cexists = Cyan.exists
local cam = require("src.misc.unique.camera")


local HP = 1600

local SPEED = 140

local MAX_SPEED = 150

local COLOUR = {0.63,0.72,0.66}


-- animaiton component
local frames = {1,2,3,4,3,2}
for i,v in ipairs(frames) do
    frames[i] = Quads["trick_block"..tostring(v)]
end

-- motion component
local down = { Quads.enemy_down_1, Quads.enemy_down_2, Quads.enemy_down_3, Quads.enemy_down_4 }
local up = { Quads.enemy_up_1, Quads.enemy_up_2, Quads.enemy_up_3, Quads.enemy_up_4 }
local left = { Quads.enemy_left_1, Quads.enemy_left_2, Quads.enemy_left_3, Quads.enemy_left_4 }
local right = { Quads.enemy_right_1, Quads.enemy_right_2, Quads.enemy_right_3, Quads.enemy_right_4 }




local function physColFunc(e1,e2,speed)
    if EH.PC(e1, e2, speed) then
        ccall("sound", "hit")
    end
end



local EPSILON = 0.0001 -- good enough XD
-- (Yes, this is spagetti code. I dont care anymore, this needs to be RELEASED)


local Tree = EH.Node("trickblock BehaviourTree")


function Tree:choose(e)
    if e._is_block then
        local d = Tools.distToPlayer(e,cam)
        if (d < 150) then
            e._is_scared = false
            return "turnIntoEnemy"
        end
    else
        if e._is_scared then
            if Tools.distToPlayer(e, cam) > 200 then
                return "turnIntoBlock"
            end
        else
            -- its not scared, its attacking
            if e.hp.hp < e.hp.max_hp/3 then
                -- I know we REALLY shouldnt be mutating the ent inside
                -- the BT like this, but im too lazy
                e._is_scared = true
                return "scared"
            end
        end
    end
    return 'wait'
end



local TE_task = EH.Task("_ turn into enemy task")
function TE_task:start(e)
    ccall("setMoveBehaviour", e, "LOCKON")
    e.speed.speed = SPEED
    e.speed.max_speed = MAX_SPEED
    e.motion = e._motion
    e:remove("animation")
    e._is_block = false
end
function TE_task:update(e)
    return'n'
end


local TB_task = EH.Task("_ turn into block task")

function TB_task:start(e)
    e.speed.speed = EPSILON -- welp, spagetti code here! :)
    e.speed.max_speed = EPSILON -- we can't set speed to 0 or 
                           -- else MoveSys will get angry at NaNs.
    e:remove("motion")
    e.animation = e._animation
    e._is_block = true
end

function TB_task:update(e)
    return'n'
end


Tree.turnIntoEnemy = {
    -- turns into enemy
    TE_task
}


Tree.turnIntoBlock = {
    -- turns back into block when it is a safe distance from player,
    -- and regains HP
    TB_task
}



Tree.scared = {
    "move::SOLO",
    "wait::4"
}

Tree.wait={
    "wait::1"
}


local r = love.math.random

local function spawnBlock(p)
    -- p is position vector
    EH.Ents.block(p.x, p.y)
end

local function onDeath(e)
    local p = e.pos
    ccall("emit","rocks", e.pos.x, e.pos.y, 10, 2)
    ccall("emit", "dust", p.x, p.y, p.z, r(4,6))
    ccall("sound","crumble",0.6, 0.6)
    ccall("await", spawnBlock, 0, p)
    EH.TOK(e,1)
end



return function(x, y)

    local e = Cyan.Entity()
    EH.PV(e,x,y)

    e._is_block = true --whether this entity is a block or not
        -- (unique to this ent type)

    -- note the underscores. This is done because each trickblock
    -- needs a memory unique anim/motion component. We can do it by privatizing
    -- a the fields, and have the proper one point to whatever one is being used
    e._motion = {
        up = up;
        down = down;
        left = left;
        right = right;

        current = 0;
        interval = 0.2;
        required_vel = 40
    }
    e._animation = {
        frames = frames;
        interval = 0.06;
        current=0
    }
    e.colour=COLOUR
    e.collisions = {
        physics = physColFunc
    }

    e.onDeath = onDeath

    e.animation = e._animation
    
    e.hp = {
        hp=HP;
        max_hp = HP
    }

    e.targetID="enemy"

    EH.PHYS(e, 8)
    EH.FR(e)

    e.pushable = true

    e.behaviour = {
        move = {
            id = "player";
            type = "LOCKON"
        };
        tree = Tree
    }

    e.speed = {
        speed=EPSILON;
        max_speed=EPSILON -- starts off with close to 0 speed; blocks cannot move!
    }
end


