

--[[

Gives a short, temporary speed boost to the player.

-  The magnitude of the speed boost is given by ent.strength!  
-  The speed boost will last for `ent.bufftime` seconds 


]]



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
    0.4,0.4,1,0.6
}
local LIGHT_COLOUR = {
    0.2,0.2,1,1
}

local COLOUR_CHANGE = 0.3 -- adds 0.3 blue colour to player



local L={
    colour=LIGHT_COLOUR;
    distance=30
}


local cam = require 'src.misc.unique.camera'



local cexists = Cyan.exists
local function reduceSpeed(e, amount, d_col)
    -- d_col  ::   change in colour blue
    -- amount ::   change in speed
    if cexists(e) then
        e.speed = {
            max_speed = e.max_speed - amount;
            speed     = e.speed     - amount
        }
        e.colour = {
            e.colour[1],
            e.colour[2],
            e.colour[3] - d_col
        }
    end
end



local collisions = {
    area = {
        player = function(e,ce,dt)
            ccall("kill",e)
            assert(ce.targetID=="player", "??")

            -- speed increase is equal to `speedboost` ent's strength
            local amount = e.strength

            ce.speed = {
                max_speed = e.max_speed + amount;
                speed     = e.speed     + amount
            }
            ce.colour = {ce.colour[1], ce.colour[2], ce.colour[3]}
            local orig_blue = ce.colour[3]
            
            ce.colour[3] = ce.colour[3] + COLOUR_CHANGE

            ccall("await", reduceSpeed, ce.bufftime, ce, amount, COLOUR_CHANGE)
        end
    }
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
    :add("light",L)

    :add("behaviour",{
        move={
            id="player";
            type="SOLO"
        }
    })

    :add("strength", 10)

    :add("collisions", collisions)
    :add("speed",{speed=70,max_speed=70})
end

