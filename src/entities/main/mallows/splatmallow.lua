
--[[

This is unused, because these guys
are SOOOOOO OP!!!!!!

They pull in your blocks and delete them.

I'm sorry, but these guys weren't fun to verse,
they were too strong lol!

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

local COLOUR = table.copy(CONSTANTS.SPLAT_COLOUR)
for i=1,3 do -- Darken splat colour
    COLOUR[i] = COLOUR[i] * 0.85
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






local Tree = EH.Node("splat mallow behaviour tree")


local Camera = require("src.misc.unique.camera")

function Tree.choose(tree, e)
    if (e.hp.hp < e.hp.max_hp) or (Tools.distToPlayer(e, Camera) < 250) then
        if rand() < 0.5 then
            --print("mallow tree: angry")
            return "angry"
        else
            return "spin"
        end
    else
        return "angry"
    end
end



local splat_spin_task = EH.Task("_splat mallow spin task")

splat_spin_task.start = function(t,e)
    e._previous_splatmallow_armour = e.armour
    e.armour = math.huge -- make invincible
    local p = e.pos
    ccall("moob", p.x, p.y, 70, 150)
    ccall("setMoveBehaviour", e,"IDLE")
    ccall("shockwave", p.x, p.y, 100, 30, 10, 0.25, table.copy(CONSTANTS.SPLAT_COLOUR))
    ccall("setVel", e, 0,0)
    ccall("animate", 'mallowspin', 0,0,0, 0.06, 1, e.colour, e, true)
    ccall("emit", 'splat', e.pos.x,e.pos.y,e.pos.z, 14)
end

splat_spin_task.update=function(t,e,dt)
    ccall("setVel",e,0,0)
    if e.hidden then
        -- Repeat until the entity is no longer hidden.
        return "r"
    else
        return "n"
    end
end

splat_spin_task.finish = function(t,e)
    if Cyan.exists(e) then
        local x, y = e.pos.x, e.pos.y
        ccall("shockwave",  x, y, 30, 100, 10, 0.25, table.copy(CONSTANTS.SPLAT_COLOUR))
        ccall("splat",  x, y, 70)
        ccall("emit", 'splat', e.pos.x,e.pos.y,e.pos.z, 10)
        e.armour = e._previous_splatmallow_armour
    end
end


Tree.spin = {
    splat_spin_task,
    splat_spin_task,
    splat_spin_task,
    "move::LOCKON",
    "wait::7",
    "wait::r"
}

Tree.angry = {
    "move::ORBIT",
    "wait::2",
    "wait::r"
}



local physColFunc = function(e1, e2, speed)
    if EH.PC(e1,e2,speed) then
        ccall("sound","hit")
    end
end


local r = love.math.random
local function onDeath(e)
    local p = e.pos
    ccall("emit", "guts", p.x, p.y, p.z, r(6,10))
    ccall("emit", 'splat', e.pos.x,e.pos.y,e.pos.z, 25)
    ccall("sound","glassbreak",0.25,0.5,0,0.3)
    EH.TOK(e,r(2,4))
end


-- ctor
return function(x, y)

    local e = Cyan.Entity()
    EH.PV(e,x,y)

    e.hp={
        hp=700,
        max_hp=700
    }

    e.bobbing={magnitude=0.25}

    e.speed = {speed = 160, max_speed = 170}

    e.pushable=false

    e.targetID = "enemy"

    EH.PHYS(e,14)

    e:add("friction", {
        amount = 2;
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

    e.behaviour = {
        move={
            type="RAND",
            id="player",
            
            orbit_tick = 0,
            orbit_speed = 1.2
        };
        tree=Tree
    }

    return e
end

