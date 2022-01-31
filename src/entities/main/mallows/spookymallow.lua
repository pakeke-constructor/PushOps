

--[[

Same as Mallow, but is "spooky" and drops spooky blocks on death.



]]


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

local COLOUR = {0.43,0,0.52,1}


local atlas = EH.Atlas
local Quads= atlas.Quads

local psys = love.graphics.newParticleSystem(atlas.image)
psys:setQuads(Quads.beet, Quads.bat, Quads.bot)
psys:setParticleLifetime(0.4, 0.8)
--psys:setLinearAcceleration(0,0,200,200)
psys:setDirection(180)
psys:setSpeed(5,15)
psys:setEmissionRate(50)
psys:setSpread(math.pi/2)
psys:setEmissionArea("uniform", 6,0)
psys:setColors({0.5,0.5,0.5})
psys:setSpin(-40,40)
psys:setRotation(0, 2*math.pi)
psys:setRelativeRotation(false)
local _,_, pW, pH = psys:getQuads()[1]:getViewport( )
psys:setOffset(pW/2, pH/2)






local Tree = EH.Node("_mallow behaviour tree")


local Camera = require("src.misc.unique.camera")

function Tree.choose(tree, e)
    if (e.hp.hp < e.hp.max_hp) or (Tools.distToPlayer(e, Camera) < 350) then
        -- No real point in this, it will be faded.
        if rand() < 0.5 then
            return "angry"
        else
            return "spin"
        end
    else
        return "idle"
    end
end



local mallow_spin_task = EH.Task("_mallow spin task")

mallow_spin_task.start = function(t,e)
    ccall("setMoveBehaviour", e,"IDLE")
    ccall("setVel", e, 0,0)
    ccall("animate", 'mallowspin', 
            0,0,0, 0.1, 3, 
            e.colour,  -- must take current instance of colour due to fade.
            e, true
    )
end

mallow_spin_task.update=function(t,e)
    ccall("setVel",e,0,0)
    if e.hidden then
        -- Repeat until the entity is no longer hidden.
        return "r"
    else
        return "n"
    end
end


Tree.spin = {
    mallow_spin_task,
    "move::LOCKON",
    "wait::3"
}

Tree.angry = {
    "move::ORBIT",
    "wait::4"
}

Tree.idle = {
    "move::RAND",
    "wait::3"
}



local physColFunc = function(e1, e2, speed)
    if EH.PC(e1,e2,speed) then
        ccall("sound","hit")
    end
end




local r = love.math.random

local cexists = Cyan.exists
local sin, cos = math.sin, math.cos


local BLOCK_NUM = 2
local MAX_BLOCK_ORBIT = 45
local MIN_BLOCK_ORBIT = 35
local ORBIT_SPEED = 4.5


local function update(e,dt)
    -- percentage of full HP
    local hp_ratio = e.hp.hp / e.hp.max_hp
    
    -- orbit distance
    local od = MIN_BLOCK_ORBIT + (MAX_BLOCK_ORBIT - MIN_BLOCK_ORBIT) * hp_ratio 

    local ex = e.pos.x
    local ey = e.pos.y

    e._t = (e._t + dt*ORBIT_SPEED)%(2*math.pi)

    for i=e._block_num, 1, -1 do
        if not cexists(e.orbiting_blocks[i]) then
            table.remove(e.orbiting_blocks, i)
            e._block_num = e._block_num - 1  
        end
    end

    for i,bl in ipairs(e.orbiting_blocks) do
        local offset = (i*2*math.pi)/e._block_num
        local tick = e._t + offset
        local xx = ex+od*sin(tick)
        local yy = ey+od*cos(tick)
        assert(xx==xx and yy==yy, "nan spotted in boxbully")
        ccall("setPos", bl, xx, yy)
    end
end


local function onDeath(e)
    for _,bl in ipairs(e.orbiting_blocks) do
        bl.pushable = true
        bl.physicsImmune = false -- wont get splatted
    end

    local p = e.pos
    ccall("emit", "guts", p.x, p.y, p.z, r(6,10))
    ccall("sound","glassbreak",0.25,0.5,0,0.3)
    EH.TOK(e,r(2,4))
end



-- ctor
return function(x, y)
    local e = Cyan.Entity()
    EH.PV(e,x,y)

    e._block_num = BLOCK_NUM
    e.orbiting_blocks = {}

    e.hp={
        hp=1700,
        max_hp=1700
    }

    for i=1, e._block_num do
        local bl = EH.Ents.spookyblock(x,y)
        bl.pushable = false
        bl.physicsImmune = true -- Immune to splats
        table.insert(e.orbiting_blocks, bl)
    end
    e._t = r()*2*math.pi -- ticker

    e.onUpdate = update
    e.hybrid = true

    e.bobbing={magnitude=0.25}

    e.speed = {speed = 90, max_speed = 100}

    e.pushable=false

    e.targetID = "enemy"

    EH.PHYS(e,7,"dynamic")

    e:add("friction", {
        amount = 6;
        emitter = psys:clone();
        required_vel = 10;
    })

    e.collisions = {
        physics = physColFunc
    }

    e.motion = {
        up=up;
        down=down;
        left=left;
        right=right;

        current=0;
        interval=0.3;
        required_vel=1
    }

    e.onDeath = onDeath

    e.colour = table.copy(COLOUR)

    e.fade = 220

    e.behaviour = {
        move={
            type="IDLE",
            id="player",
            
            orbit_tick = 0,
            orbit_speed = 1.2
        };
        tree=Tree
    }

    return e
end

