
--[[

Mushroom blocks explode on impact with enemy


]]
local atlas = require "assets.atlas"
local Quads = atlas.Quads

local psys = love.graphics.newParticleSystem(atlas.image)

do
    psys:setQuads(Quads.circ3, Quads.circ2, Quads.circ1)
    psys:setParticleLifetime(0.4, 0.5)
    --psys:setLinearAcceleration(0,0,200,200)
    psys:setDirection(180)
    psys:setSpeed(5,15)
    psys:setEmissionRate(120)
    psys:setRotation(0,math.pi*2)
    psys:setSpread(math.pi/2)
    psys:setEmissionArea("uniform", 10,0)
    psys:setColors({0.8,0.1,0.1}, {0.8,0.1,0.1,0.5})
    --psys:setSpin(-40,40)
    --psys:setRotation(0, 2*math.pi)
    --psys:setRelativeRotation(false)
    local _,_, pW, pH = psys:getQuads()[1]:getViewport( )
    psys:setOffset(pW/2, pH/2)
end


local _,_, w,h = Quads.block:getViewport( )
local block_shape = love.physics.newRectangleShape(w/2,h/2)


local sprites = {
    Quads.mushroom_block
}

local function dmgEnemies(ent, x, y)
    local eX, eY = ent.pos.x, ent.pos.y
    if Tools.dist(x-eX, y-eY) < 90 then
        ccall("damage", ent, 100)
    end
end


local ccall = Cyan.call
local rand = love.math.random
local cam = require("src.misc.unique.camera")
local collisions = {
    physics = function(self, col, speed)
        if speed > CONSTANTS.ENT_DMG_SPEED and col.targetID=="enemy" then
            local x, y, z = self.pos.x, self.pos.y, self.pos.z
            ccall("boom", x, y, 100, 100)
            ccall("animate", "push", x,y+25,z, 0.06, nil, {0.8,0.1,0.1}) 
            ccall("shockwave", x, y, 14, 200, 10, 0.4)
            ccall("sound", "boom")
            ccall("apply", dmgEnemies, x, y, "enemy")
            ccall("kill", self)
        end
    end
}


local colours = {}
for i=120,0,-5 do
    local u = (300 - i)/300
    table.insert(colours, {u,u,u})
end


local function onDeath(e)
    ccall("emit", "mushroom", e.pos.x, e.pos.y, e.pos.z, 3)
end


return function(x,y)
    if (not x) or (not y) then error("hey! stop it") end
    local abs = math.abs
    return Cyan.Entity()
    :add("pos", math.vec3(x,y,0))
    :add("vel", math.vec3(0,0,0))
    :add("acc", math.vec3(0,0,0))
    :add("physics", {
        shape = block_shape;
        body  = "dynamic"
    })
    :add("onDeath",onDeath)
    :add("pushable",true)
    :add("bobbing", {magnitude = 0.15, value = 0})
    :add("friction", {
        emitter = psys:clone();
        required_vel = 2;
        amount = 0.9
    })
    :add("collisions",collisions)
    :add("targetID", "physics")
    :add("image", {quad = Tools.rand_choice(sprites), oy = 20})
end




