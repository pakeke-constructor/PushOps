
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call

local emitter=love.graphics.newParticleSystem(Atlas.image,400)
emitter:setQuads(Quads.circ4, Quads.circ3, Quads.circ3, Quads.circ2)
emitter:setParticleLifetime(0.7, 1.2)
--emitter:setLinearAcceleration(0,0,200,200)
emitter:setDirection(180)
emitter:setSpeed(0.5,1)
emitter:setEmissionRate(200)
emitter:setSpread(math.pi/2)
emitter:setEmissionArea("uniform", 6,0)
emitter:setColors({0.6,0.6,0.6}, {0.3,0.3,0.3,0.3})
emitter:setSpin(0,0)
emitter:setEmissionArea("uniform", 22,12)
emitter:setRotation(0, 2*math.pi)
emitter:setRelativeRotation(false)
local _,_, pW, pH = emitter:getQuads()[1]:getViewport( )
emitter:setOffset(pW/2, pH/2)


local f={1,2,3,2,1,4,5,4}
for i,v in ipairs(f) do
    f[i] = Quads["bigwall"..tostring(v)]
end

local _,_,w,h=Quads.bigwall1:getViewport()
local shape = love.physics.newRectangleShape(w/1.3,h/2)

return function(x, y)
    local e = Cyan.Entity()
    EH.PV(e,x,y)
    e:add("friction",{
        emitter=emitter:clone()
    })
    e:add("animation",{
        frames=f;
        interval=0.2;
        oy=w
    })
    e.bobbing={magnitude=0.25}
    e.swaying={magnitude=0.01}
    e.physics = {
        body="dynamic";
        shape=shape
    }
    local spd=love.math.random(100,200)
    e.speed={speed=spd,spd}
    e.behaviour={
        move={
            type="RAND"
        }
    }
end


