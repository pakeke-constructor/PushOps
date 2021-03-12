--[[

Big, BIG lad.

Make a version of this ent who is constantly
carrying a shield

]]



local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call

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
        EH.Ents.block(x*15, y*15)
    end
end


local collisions = {
    physics = function(e,ot,s)
        if EH.PC(e,ot,s) then
            -- add noise or something here
            local p = e.pos
            ccall("await", spawnF, 0, p)
            ccall("shockwave", e.pos.x, e.pos.y, 20, 50, 6, 0.2)
        end
    end
}


return function(x, y)

    local e = Cyan.Entity()
    EH.PV(e,x,y)
    
    e.motion = {
        up=up;
        down=down;
        left=left;
        right=right;
        curret=0;
        interval=0.11;
        required_vel=1
    }

    e.hp={
        hp=1000;
        max_hp=1000
    }
    
    e.speed={
        speed=115;
        max_speed=125
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
    e.sigils = {"strength"}
    e.targetID="enemy"

    e.collisions=collisions

    local col = (r()/2) + 0.3

    e.colour = {col,col,col}

    EH.FR(e)
    EH.PHYS(e,15)
    return e
end

