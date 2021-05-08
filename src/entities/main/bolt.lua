
--[[

Magic bolt

(Same as bullet, but different
colour, and ignores player armour)



]]
local shape = love.physics.newCircleShape(1)



local atlas = require "assets.atlas"
local Quads = atlas.Quads

local fpsys = love.graphics.newParticleSystem(atlas.image)
--fpsys:setQuads(Quads.beet, Quads.bot, Quads.bit)
fpsys:setQuads(Quads.circ4,Quads.circ4,Quads.circ3,Quads.circ3,Quads.circ2,Quads.circ1)
fpsys:setParticleLifetime(0.2, 0.3)
--fpsys:setLinearAcceleration(0,0,200,200)
fpsys:setDirection(180)
fpsys:setSpeed(0,0)
fpsys:setEmissionRate(90)
fpsys:setSpread(math.pi/2)
fpsys:setEmissionArea("uniform", 1,1)
fpsys:setColors({0.6,0.1,0.8,1}, {0.3,0,0.4,0.8})
fpsys:setSpin(-40)
fpsys:setRotation(0, 2*math.pi)
fpsys:setRelativeRotation(false)
local _,_, pW, pH = fpsys:getQuads()[1]:getViewport( )
fpsys:setOffset(pW/2, pH/2)


local ccall = Cyan.call


local r = love.math.random


local function onDeath(e)
    -- TODO sound here
    ccall("animate", "tp_up", e.pos.x, e.pos.y, e.pos.z+40, 0.01,1,{0.3,0.02,0.4})
end


local collisionsComp = {
    physics = function(self, e, speed)
        if e.targetID=="player" then
            assert(self.strength, "not given strength")
            ccall("damage",e,self.strength)
        end
        ccall("kill",self)
    end
}

local friction_comp = {
    emitter = fpsys;
    required_vel = 0;
    amount=0
}


return function(x,y)
    local e = Cyan.Entity()

    :add("pos", math.vec3(x,y,0))
    :add("vel", math.vec3(0,0,0))
    
    :add("hp", {hp = 100, max_hp = 100, regen=-100/4})
    
    :add("size",16)

    :add("strength", 35)

    :add("friction", {
        emitter = fpsys:clone();
        required_vel = 0;
        amount=0
    })
    EH.PHYS(e,5)
    :add("draw",{oy=0})
    :add("collisions", collisionsComp)
    :add("onDeath",onDeath)
    return e
end





