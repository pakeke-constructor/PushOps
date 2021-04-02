
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call
local r = love.math.random



local function playerColFunc(ent, player, dt)
    ccall("animate", "blit", ent.pos.x,ent.pos.y,ent.pos.z, 0.01, 1)
    ccall("sound", "beep", 0.35, 0.95+r()/10)
    ccall("kill",ent)
end


local f={1,2,3,4}
for i,v in ipairs(f) do
    f[i]=Quads["tok"..tostring(v)]
end
local f_rv = {4,3,2,1}
for ii,vv in ipairs(f_rv) do
    f_rv[ii]=Quads["tok"..tostring(vv)]
end




local ANIM_INTERVAL = 0.1



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
    
    e.speed={
        speed=250;
        max_speed=250
    }
    e.size = 10
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

