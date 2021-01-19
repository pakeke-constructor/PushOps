

local shape = love.physics.newCircleShape(1)


local atlas = require "assets.atlas"
local Quads = atlas.Quads

local fpsys = love.graphics.newParticleSystem(atlas.image)
fpsys:setQuads(Quads.beet, Quads.bot, Quads.bit)
fpsys:setParticleLifetime(0.4, 0.6)
--fpsys:setLinearAcceleration(0,0,200,200)
fpsys:setDirection(180)
fpsys:setSpeed(0,0)
fpsys:setEmissionRate(90)
fpsys:setSpread(math.pi/2)
fpsys:setEmissionArea("uniform", 6,0)
fpsys:setColors({1,0,0}, {0.5,0,0,0.8})
fpsys:setSpin(-40)
fpsys:setRotation(0, 2*math.pi)
fpsys:setRelativeRotation(false)
local _,_, pW, pH = fpsys:getQuads()[1]:getViewport( )
fpsys:setOffset(pW/2, pH/2)


local ccall = Cyan.call


local r = love.math.random


local function colFunc(self, player)
    local pos = player.pos

    if player.armour == 0 then
        error("Player armour 0?? wat")
    end
    self:delete()
    ccall("damage", player, 10 / (player.armour or 1))
end


local collisionsComp = {
    area = {player = colFunc}
}


return function(x,y)
    return Cyan.Entity()

    :add("pos", math.vec3(x,y,0))
    :add("vel", math.vec3(0,0,0))
    
    :add("hp", {hp = 100, max_hp = 100})
    
    :add("size",0) -- Smol bullet! trust me this is a good size

    --[[
    :add("physics", {
        shape = shape;
        body  = "dynamic"
    })
    ]]

    :add("image", Quads.bullet)

    :add("size", 0)

    :add("collisions", collisionsComp)
end





