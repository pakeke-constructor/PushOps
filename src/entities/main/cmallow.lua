
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call
local rand = love.math.random





local DEFAULT_SPEED = 80
local DEFAULT_MAX_SPEED = 90

local CHARGE_SPEED = 400
local CHARGE_MAX_SPEED = 600


local COLOUR={0.7,0.7,1}

local CHARGE_COLOUR = {0.4,0.4,0.8}




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




local Tree = EH.Node("cmallow behaviour tree")


local Camera = require("src.misc.unique.camera")

function Tree.choose(tree, e)
    if (e.hp.hp < e.hp.max_hp) or (Tools.distToPlayer(e, Camera) < 250) then
        if rand() < 0.5 then
            return "charge"
        else
            return "angry"
        end
    else
        return "idle"
    end
end



local cmallow_spin_task = EH.Task("_cmallow spin task")

cmallow_spin_task.start = function(t,e)
    ccall("setMoveBehaviour", e, "IDLE")
    ccall("setVel", e, 0,0)
    ccall("animate", 'mallowspin', 0,0,0, 0.04, 2, COLOUR, e, true)
end

cmallow_spin_task.update=function(t,e)
    ccall("setVel",e,0,0)
    if e.hidden then
        -- Repeat until the entity is no longer hidden.
        return "r"
    else
        return "n"
    end
end


local cmallow_charge_task = EH.Task("_cmallow charge task")

function cmallow_charge_task:start(e)
    --[[
        emits an explosion and starts charging!
    ]]
    local p = e.pos
    local x,y,z = p.x, p.y, p.z
    ccall("boom", x, y, 40, 100, 0,0, "player", 1.2)
    ccall("animate", "push", x,y+25,z, 0.03, nil, CHARGE_COLOUR) 
    ccall("shockwave", x, y, 4, 130, 7, 0.3)
    e.speed.max_speed = CHARGE_MAX_SPEED
    e.speed.speed = CHARGE_SPEED
    ccall("setMoveBehaviour", e, "LOCKON", "player")
end

function cmallow_charge_task:update(e,dt)
    if self:runtime(e)>2 then
        return "n"
    end
    return "r"
end


function cmallow_charge_task:finish(e)
    ccall("shockwave", e.pos.x, e.pos.y, 180, 40, 6, 0.5, CHARGE_COLOUR)
    e.speed.max_speed = DEFAULT_MAX_SPEED
    e.speed.speed = DEFAULT_SPEED
end


Tree.charge = {
    cmallow_spin_task,
    cmallow_charge_task,
    cmallow_spin_task
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
        ccall("sound","thud")
    end
end


local r = love.math.random
local function onDeath(e)
    local p = e.pos
    ccall("emit", "guts", p.x, p.y, p.z, r(6,10))
    EH.Ents.speedboost(p.x,p.y)
    EH.TOK(e,r(2,3))
end


-- ctor
return function(x, y)

    local e = Cyan.Entity()
    EH.PV(e,x,y)

    e.hp={
        hp=1700,
        max_hp=1700
    }

    e.bobbing={magnitude=0.25}

    e.speed = {
            speed = DEFAULT_SPEED,
            max_speed = DEFAULT_MAX_SPEED}

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

    e.colour = COLOUR

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


