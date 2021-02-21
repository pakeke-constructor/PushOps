
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call

local tree = EH.Node("_tok ent behaviour")

local function playerColFunc(ent, player, dt)
    ccall("animate", "blit", ent.pos.x,ent.pos.y,ent.pos.z, 0.01, 1)
    ccall("sound", "beep")
    ccall("kill",ent)
end


local f={1,2,3,4}
for i,v in ipairs(f) do
    f[i]=Quads["tok"..tostring(v)]
end


return function(x, y)
    local e = Cyan.Entity()
    EH.PV(e,x,y)
    e.animation = {
        frames=f,
        interval=0.2
    }
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

