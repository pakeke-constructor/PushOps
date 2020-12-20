


local atlas = require "assets.atlas"
local Quads = atlas.Quads




local psys = love.graphics.newParticleSystem(atlas.image)
do
    psys:setQuads(Quads.bot, Quads.bit)
    psys:setParticleLifetime(0.8, 1)
    --psys:setLinearAcceleration(0,0,200,200)
    psys:setDirection(180)
    psys:setSpeed(5,15)
    psys:setEmissionRate(140)
    psys:setRotation(0,math.pi*2)
    psys:setSpread(math.pi/2)
    psys:setEmissionArea("uniform", 6,2)
    psys:setColors({0.8,0.3,0,3}, {0.9,0.4,0.4,0.7})
    --psys:setSpin(-40,40)
    --psys:setRotation(0, 2*math.pi)
    --psys:setRelativeRotation(false)
    local _,_, pW, pH = psys:getQuads()[1]:getViewport( )
    psys:setOffset(pW/2, pH/2)
end



local sprites = {}
for i = 1,2 do
    table.insert(sprites, Quads["capital"..tostring(i)])
end

local shape = love.physics.newCircleShape(8)



return function(x,y)

    return Cyan.Entity()

    :add("pos", math.vec3(x,y,0))
    :add("vel", math.vec3(0,0,0))
    :add("acc", math.vec3(0,0,0))

    :add("physics", {
        shape = shape;
        body  = "dynamic"
    })

    :add("friction", {
        emitter = psys:clone();
        required_vel = 1.5;
        amount = 1;
    })

    :add("speed", {
        max_speed = 300
    })

    :add("pushable", true)

    :add("bobbing", {magnitude = 0.2, value = 0})

    :add("image", {quad = Tools.rand_choice(sprites)})

    :add("sigils", {"capital"})
end






