

local atlas = require("assets.atlas")

local Quads = atlas.Quads

local Psys = love.graphics.newParticleSystem(atlas.image,2000)


Psys:setColors({0,0,0.3}, {0,0,0.5}, {0.1,0.1,0.5})

Psys:setQuads{ Quads.bat, Quads.bot, Quads.bit }

local _,_, pW, pH = (Psys:getQuads()[1]):getViewport( )
Psys:setOffset(pW/2, pH/2)

Psys:setEmissionRate(150)
Psys:setParticleLifetime(0.1, 0.5)
Psys:setDirection(-math.pi/2)
Psys:setRotation(0, 2*math.pi)
Psys:setRelativeRotation(false)
Psys:setSpeed(30,45)
Psys:setEmissionArea("uniform", 2,0)

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

