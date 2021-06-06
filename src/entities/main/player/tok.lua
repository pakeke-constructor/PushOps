
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call
local r = love.math.random


local savedata = require("src.misc.unique.savedata")

local function playerColFunc(ent, player, dt)
    ccall("animate", "blit", ent.pos.x,ent.pos.y,ent.pos.z, 0.01, 1)
    ccall("sound", "beep", 0.35, 0.95+r()/10)
    savedata.tokens = savedata.tokens + 1
    ccall("kill",ent)
end

--[[
local f={1,2,3,4}
for i,v in ipairs(f) do
    f[i]=Quads["bigtok"..tostring(v)]
end
local f_rv = {4,3,2,1}
for ii,vv in ipairs(f_rv) do
    f_rv[ii]=Quads["bigtok"..tostring(vv)]
end
]]


local f={1,2,3,2}
for i,v in ipairs(f) do
    f[i] = Quads["coin"..tostring(v)]
end
local f_rv = f



local ANIM_INTERVAL = 0.1

local COLOUR = {255/255, 215/255, 0}

return function(x, y)
    local e = Cyan.Entity()
    EH.PV(e,x,y)
    e.animation = {
        frames=f,
        interval = ANIM_INTERVAL
    }
    
    if r()<0.5 then
        -- 50% chance for animation to run backwards
        -- (gives nice variation)
        e.animation.frames = f_rv
    end

    e.colour = COLOUR
    
    e.speed={
        speed=300;
        max_speed=300
    }
    e.size = 2
    e.behaviour = {
        move={
            type="CLOCKON";
            id="player"
        }
    }
    e.collisions = {
        area = {
            player = playerColFunc
        }
    }
end

