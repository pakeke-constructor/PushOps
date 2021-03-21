

--[[

Gives a short, temporary speed boost to the player.

-  The magnitude of the speed boost is given by ent.strength!  
-  The speed boost will last for `ent.bufftime` seconds 


]]

local BUFFTIME = 13 -- 13 seconds a good time?



local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call


local f={}
for iii=1,5 do
    table.insert(f,Quads["rotbug"..tostring(iii)])
end

local COLOUR = {
    0.4,0.4,1,1
}
local COLOUR_CHANGE = 0.3 -- adds 0.3 blue colour to player





local cam = require 'src.misc.unique.camera'





local collisions = {
    area = {
        player = function(e,ce,dt)
            ccall("kill",e)
            assert(ce.targetID=="player", "??")

            -- speed increase is equal to `speedboost` ent's strength
            ccall("buff", ce, "speed", e.bufftime, e.strength)
            ccall("buff", ce, "tint", e.bufftime,  {1-COLOUR_CHANGE,1-COLOUR_CHANGE,1+COLOUR_CHANGE})
            -- TODO: play a sound here or somethin

            local p=e.pos
            ccall("shockwave", p.x, p.y, 10, 200, 8, 0.35,
                    {COLOUR[1],COLOUR[2],COLOUR[3]})
        end
    }
}


local SPD = {
    speed=300,max_speed=300
}


return function(x, y)
    local e = Cyan.Entity()
    EH.PV(e,x,y)
    e:add("animation",{
        frames=f;
        interval=0.1;
        current=0
    })
    :add("colour",COLOUR)

    :add("behaviour",{
        move={
            id="player";
            type="CLOCKON"
        }
    })

    :add("strength", 60)
    :add("bufftime", BUFFTIME)

    :add("collisions", collisions)
    :add("speed",SPD)
end

