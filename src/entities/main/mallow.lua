
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
    print("HELLO???????")
    if e.hp.hp < e.hp.max_hp then
        if rand() < 0.5 then
            return "angry"
        else
            return "spin"
        end
    else
        return "idle"
    end
end

Tree.spin = {
    EH.Task{
        start=function(t,e)
            ccall("setMoveBehaviour", e,"IDLE")
            local p=e.pos
            ccall("animate", 'mallowspin', p.x, p.y, p.z, 0.1*9, e,true)
        end,
        update=function(t,e)
            if not e.hidden and t:runtime(e)<5 then
                -- Repeat animation for 5 seconds.
                -- (last arg=true -> this will hide the entity. We can then 
                -- check if the anim is still running by checking whether ent is hidden)
                return "n"
            else
                if not e.hidden then
                    ccall("animate", 'mallowspin', p.x, p.y, p.z, 0.1, e, true)
                end
                return "r"
            end
        end
        }
}

Tree.angry = {
    "move::ORBIT",
    "wait::6"
}

Tree.idle = {
    "move::RAND",
    "wait::20"
}


Tree:on("damage",function(e)
    return "angry"
end)

local colour={0.7,1,0.7}

-- ctor
return function(x, y)

    local e = Cyan.Entity()
    EH.PV(e,x,y)

    e.hp={hp=300,max_hp=300}
        
    e.bobbing={magnitude=0.25}

    e.pushable=false

    EH.PHYS(e,5,"dynamic")
    EH.FR(e)

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
        move={type="IDLE", id=1};
        tree=Tree
    }

    return e
end

