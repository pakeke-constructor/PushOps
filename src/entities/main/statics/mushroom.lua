



local atlas = require( "assets.atlas" )

local Quads = atlas.Quads

local mush = Quads.mushroom

local _,_,w,h = mush:getViewport()
local shape = love.physics.newCircleShape(4)

local rand = love.math.random

--[[

Spawns mushroom on death

]]

local function onBoom(e,x,y, strength)
    if Tools.dist(e.pos.x-x, e.pos.y-y) < 60 and strength>1 then
        ccall("damage",e,100)
        local p = e.pos
        ccall("emit","smoke",p.x, p.y, p.z, 18)
    end
end


local function spawnMidgets(p)
    for i=1, rand(2,5)do
        EH.Ents.shroom(p.x + (rand()-0.5)*30, p.y + (rand()-0.5)*30)
    end
end

local function onDeath(e)
    local p = e.pos
    ccall("emit","smoke",p.x, p.y, p.z, 18)
    ccall("await", spawnMidgets, 0, p)
end

return function(x,y)
    return Cyan.Entity( )
    :add("pos", math.vec3(x,y,0))
    :add("image", {quad = mush, oy=60})
    :add("physics", {
        body = "static";
        shape = shape
    })
    
    :add("onDeath", onDeath)

    :add("hp",{
        hp=160;
        max_hp = 160
    })

    :add("onBoom", onBoom)

    :add("bobbing",{
        magnitude = 0.15;
        value = 0
    })
end




