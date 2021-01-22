
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call
local rand = love.math.random

-- motion animation 
local up,down,left,right
up={}
down={}
left={}
right={}
local ti = table.insert
for i=1,4 do
    ti(down, EH.Quads["mallow_down_"..tostring(i)])
    ti(up, EH.Quads["mallow_up_"..tostring(i)])
    ti(left, EH.Quads["mallow_left_"..tostring(i)])
    ti(right, EH.Quads["mallow_right_"..tostring(i)])
end


local Tree = EH.Node("mallow behaviour tree")

function Tree.choose(tree, e)
    if e.hp.hp < e.hp.max_hp then
        if rand() < 0.5 then
            --print("mallow tree: angry")
            return "angry"
        else
            --print("mallow tree: spin")
            return "spin"
        end
    else
        --print("mallow tree: idle")
        return "idle"
    end
end



local mallow_spin_task = EH.Task("mallow spin task")

mallow_spin_task.start = function(t,e)
    ccall("setMoveBehaviour", e,"IDLE")
    local p=e.pos
    ccall("animate", 'mallowspin', p.x, p.y, p.z, 0.1*9, e, true)
end

mallow_spin_task.update=function(t,e)
    if not e.hidden and t:runtime(e)<3 then
        -- Repeat animation for 5 seconds.
        -- (last arg=true -> this will hide the entity. We can then 
        -- check if the anim is still running by checking whether ent is hidden)
        return "n"
    else
        local p = e.pos
        if not e.hidden then
            ccall("animate", 'mallowspin', p.x, p.y, p.z, 0.1, e, true)
        end
        return "r"
    end
end

Tree.spin = {
    mallow_spin_task
}

Tree.angry = {
    "move::ORBIT",
    "wait::5"
}

Tree.idle = {
    "move::RAND",
    "wait::3"
}


Tree:on("damage",function(e)
    return "angry"
end)

local colour={0.7,1,0.7}


local physColFunc = function(e1, e2, speed)
    if speed > CONSTANTS.ENT_DMG_SPEED then
        Cyan.emit("sound", "thud")
        Cyan.emit("damage", e1, (speed - e1.vel:len()))
    end
end


-- ctor
return function(x, y)

    local e = Cyan.Entity()
    EH.PV(e,x,y)

    e.hp={hp=2000,max_hp=2000}
        
    e.bobbing={magnitude=0.25}

    e.speed = {speed = 90, max_speed = 100}

    e.pushable=false

    e.targetID = "enemy"

    EH.PHYS(e,5,"dynamic")
    EH.FR(e)

    e.collisions = {
        physics = physColFunc
    }

    e.motion = {
        up=up;
        down=down;
        left=left;
        right=right;

        current=0;
        interval=0.8;
        required_vel=1
    }

    e.colour = colour

    e.behaviour = {
        move={type="IDLE", id="player"};
        tree=Tree
    }

    return e
end

