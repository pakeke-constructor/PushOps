--[[

Lifesteal token

]]

local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call
local r = love.math.random


local function playerColFunc(ent, player, dt)
    ccall("animate", "blit", ent.pos.x,ent.pos.y,ent.pos.z, 0.01, 1, {0.6,0,0})
    ccall("sound", "beep", 0.35, 0.35+r()/20)
    if player.hp then
        player.hp.hp = player.hp.hp + 2
    end
    ccall("kill",ent)
end


local f={1,2,3,2}
for i,v in ipairs(f) do
    f[i] = Quads["tok"..tostring(v)]
end
local f_rv = f



local ANIM_INTERVAL = 0.1

local COLOUR = {0.6,0,0}

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

