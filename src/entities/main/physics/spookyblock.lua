

local atlas = require "assets.atlas"
local Quads = atlas.Quads

local psys = love.graphics.newParticleSystem(atlas.image)

do
    psys:setQuads(Quads.circ3, Quads.circ3, Quads.circ2)
    psys:setParticleLifetime(0.5, 0.6)
    --psys:setLinearAcceleration(0,0,200,200)
    psys:setDirection(180)
    psys:setSpeed(5,15)
    psys:setEmissionRate(120)
    psys:setRotation(0,math.pi*2)
    psys:setSpread(math.pi/2)
    psys:setEmissionArea("uniform", 10,0)
    psys:setColors({0.43,0,0.52,0.6}, {0.43,0,0.52,0})
    local _,_, pW, pH = psys:getQuads()[1]:getViewport( )
    psys:setOffset(pW/2, pH/2)
end


local _,_, w,h = Quads.block:getViewport( )
local block_shape = love.physics.newRectangleShape(w/2,h/2)


local sprites = {
    Quads.slant_block, Quads.slant_block2
}


local ccall = Cyan.call
local rand = love.math.random

local collisions = {
    physics = function(ent,col, speed)

    end
}

local COLOUR = {0.43,0,0.52}


return function(x,y)
    if (not x) or (not y) then error("hey! stop it") end
    local abs = math.abs
    return Cyan.Entity()
    :add("pos", math.vec3(x,y,0))
    :add("vel", math.vec3(0,0,0))
    :add("acc", math.vec3(0,0,0))
    :add("colour", table.copy(COLOUR))
    :add("physics", {
        shape = block_shape;
        body  = "dynamic"
    })
    :add("pushable",true)
    :add("fade",200)
    :add("bobbing", {magnitude = 0.15, value = 0})
    :add("friction", {
        emitter = psys:clone();
        required_vel = 2;
        amount = 0.9
    })
    --:add("collisions",collisions)   Turned these off for now
    :add("targetID", "physics")
    :add("image", {quad = Tools.rand_choice(sprites), oy = 20})
end




