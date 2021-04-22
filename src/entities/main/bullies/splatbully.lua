
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


local collisions = {
    physics = function(e,ot,s)
        if EH.PC(e,ot,s) then
            -- add noise or something here
            local col = e.colour
            ccall("shockwave", e.pos.x, e.pos.y, 20, 50, 6, 0.2,
                {col[1]-0.1,col[2]-0.1,col[3]-0.1})
            ccall("splat", e.pos.x, e.pos.y)
        end
    end
}




local function spawnLittles(ent)
    for i=1, math.floor(2.5 + r()) do
        EH.Ents.splatenemy(ent.pos.x + (r()-.5)*10, ent.pos.y + (r()-.5)*10)
    end
end

local function onDeath(e)
    -- rand between 2 and 3
    ccall("await", spawnLittles, 0.2, e)
end


local COLOUR = {
    0.65,0.9,0.65
}


return function(x, y)

    local e = Cyan.Entity()
    EH.PV(e,x,y)
    
    e.motion = {
        up=up;
        down=down;
        left=left;
        right=right;
        current=0;
        interval=0.11;
        required_vel=1
    }

    e.strength = 25
    e.colour = COLOUR    
    e.speed={
        speed=120;
        max_speed=130
    }

    e.behaviour={
        move={
            id="player";
            type="CLOCKON"
        }
    }

    e.onDeath=onDeath

    e.sigils = {"crown"}

    e.hp = {
        hp=2000;
        max_hp=2000
    }

    e.bobbing = {
        magnitude=0.3 + r()/10;
        value=0
    }
    e.colour = CONSTANTS.SPLAT_COLOUR
    e.targetID="enemy"

    e.collisions=collisions

    EH.FR(e)
    EH.PHYS(e,15)
    return e
end

