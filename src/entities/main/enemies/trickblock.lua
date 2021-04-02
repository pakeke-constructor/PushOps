

--[[

Block entity that turns into an enemy when provoked
(current trigger is when player moves close)


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
    if e2.targetID=="player" then
        if e1.targetID=="enemy" then
            ccall("damage", e2, (e1.strength or 20))
        end
    end

    if speed > CONSTANTS.ENT_DMG_SPEED and (not e1._is_block) then
        if e1.vel then
            ccall("damage", e1, (speed - e1.vel:len()))
        else
            ccall("damage",e1,speed)
        end
        --[[
            TODO:
            sound FX and particles here!
        ]]
    end
    -- no collision, thx
end





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
            if Tools.distToPlayer(e, cam) > 400 then
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
    e.speed.speed = 0
    e.speed.max_speed = 0
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


local function onDeath(e)
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
        speed=0;
        max_speed=0 -- starts off with 0 speed; blocks cannot move!
    }
end


