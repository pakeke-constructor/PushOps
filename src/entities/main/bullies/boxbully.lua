--[[

Big, BIG lad.

Make a version of this ent who is constantly
*having 3 physics objects rotating around it.
(As a defence mechanism)

]]



local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call
local cexists = Cyan.exists


local BLOCK_NUM = 5

local MAX_BLOCK_ORBIT = 60
local MIN_BLOCK_ORBIT = 50

local ORBIT_SPEED = 3



local r = love.math.random

local ii = {1,2,1,3}
local up = {}
local down = {}
local right = {}
local left = {}


local ti = table.insert
local ts = tostring


for _,i in ipairs(ii) do
    ti(up, Quads['bully_up_'..ts(i)])
    ti(down, Quads['bully_down_'..ts(i)])
    ti(right, Quads['bully_right_'..ts(i)])
    ti(left, Quads['bully_left_'..ts(i)])
end


local floor = math.floor
local spawnF = function(p)
    for i=1, floor(r()*4) do
        local x,y = r()-0.5, r()-0.5
        EH.Ents.block(p.x + x*45, p.x + y*45)
    end
end


local collisions = {
    physics = function(e,ot,s)
        if EH.PC(e,ot,s) then
            -- add noise or something here
            local p = e.pos
            ccall("shockwave", e.pos.x, e.pos.y, 20, 50, 6, 0.2)
        end
    end
}




local sin = math.sin
local cos = math.cos


local function update(e,dt)
    -- percentage of full HP
    local hp_ratio = e.hp.hp / e.hp.max_hp
    
    -- orbit distance
    local od = MIN_BLOCK_ORBIT + (MAX_BLOCK_ORBIT - MIN_BLOCK_ORBIT) * hp_ratio 

    local ex = e.pos.x
    local ey = e.pos.y

    e._t = (e._t + dt*ORBIT_SPEED)%(2*math.pi)

    for i=e._block_num, 1 do
        if not cexists(e.orbiting_blocks[i]) then
            e.orbiting_blocks[i] = nil
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
end


return function(x, y)

    local e = Cyan.Entity()
    EH.PV(e,x,y)

    e.orbiting_blocks = {}

    e._block_num = math.floor(BLOCK_NUM + r()*2)

    for i=1, e._block_num do
        local bl = EH.Ents.block(x,y)
        bl.pushable = false
        bl.physicsImmune = true -- Immune to splats

        table.insert(e.orbiting_blocks, bl)
    end

    e._t = r()*2*math.pi -- ticker
    
    e.motion = {
        up=up;
        down=down;
        left=left;
        right=right;
        current=0;
        interval=0.11;
        required_vel=1
    }

    e.onDeath = onDeath

    e.hp={
        hp=2000;
        max_hp=2000
    }
    
    e.speed={
        speed=75;
        max_speed=85
    }

    e.strength = 20

    e.behaviour={
        move={
            id="player";
            type="CLOCKON"
        }
    }

    e.bobbing = {
        magnitude=0.3 + r()/10;
        value=0
    }
    e.sigils ={"crown"}-- {"strength"}
    e.targetID="enemy"

    e.hybrid=true
    e.onUpdate=update

    e.collisions=collisions

    local col = (r()/2) + 0.2

    e.colour = {col,col,col}

    EH.FR(e)
    EH.PHYS(e,12)
    return e
end

