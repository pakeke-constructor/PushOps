



local atlas = require("assets.atlas")

local Quads = atlas.Quads

local Psys = love.graphics.newParticleSystem(atlas.image,2000)


Psys:setColors({1,0,0}, {0.7,0,0}, {0.7,0,0.4})

Psys:setQuads{ Quads.capital }

local _,_, pW, pH = (Psys:getQuads()[1]):getViewport( )
Psys:setOffset(pW/2, pH/2)

Psys:setColors(
   {0,0.2,0},
   {0,0.6,0},
   {0,1,0,0.5},
   {1,1,1,0}
)


Psys:setEmissionRate(8)
Psys:setParticleLifetime(0.9, 1)
Psys:setDirection(-math.pi/2)
Psys:setRotation(0, 0)
Psys:setRelativeRotation(false)
Psys:setSpeed(20,30)
Psys:setEmissionArea("normal", 4,0)

local lg=love.graphics

return {

    staticUpdate = function(dt)
        Psys:update(dt)
    end,

    draw = function(ent)
        local h
        if ent.draw then
            h = ent.draw.h/1.3
        else
            h = 0
        end
        lg.draw(Psys, ent.pos.x, (ent.pos.y - h) - ent.pos.z / 2)
    end

}


