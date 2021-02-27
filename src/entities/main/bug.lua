

--[[

I dont know what this will be,
Make it something creative and fun

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
    0.3,0.3,1,1
}


local L={
    colour=LIGHT_COLOUR;
    distance=70
}


local cam = require 'src.misc.unique.camera'

local function ufunc(e,dt)
    local d = Tools.distToPlayer(e,cam) 
    if d > 300 and e.behaviour.move ~= "IDLE" then
        ccall("setMoveBehaviour", e, "IDLE")
    elseif d < 300 and e.behaviour.move ~= "SOLO" then
        ccall("setMoveBehaviour",e,"SOLO")  
    end
end



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

    :add("speed",{speed=70,max_speed=70})
    
    :add("hybrid", true)
    :add("onHeavyUpdate", ufunc)

end

