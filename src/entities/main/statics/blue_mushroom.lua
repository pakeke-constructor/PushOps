



local atlas = require( "assets.atlas" )

local Quads = atlas.Quads

local mushes = {Quads.blue_mushroom_1, Quads.blue_mushroom_2}
local mush = mushes[1]

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
        ccall("emit","blue_mushroom",p.x, p.y - 20, p.z, 2)
    end
end


local function spawnMidgets(p)
    for i=1, rand(2,5)do
        local e = EH.Ents.ghost(p.x + (rand()-0.5)*30, p.y + (rand()-0.5)*30)
        e.colour = {0.4,0.4,0.8}
        e.fade = 200
    end
end

local function onDeath(e)
    local p = e.pos
    ccall("emit","blue_mushroom",p.x, p.y - 20, p.z, 4)
    ccall("await", spawnMidgets, 0, p)
end

local BLU = {0.1,0.1,1,1}

return function(x,y)
    return Cyan.Entity( )
    :add("pos", math.vec3(x,y,0))
    :add("image", {quad = Tools.rand_choice(mushes), oy=90})
    :add("physics", {
        body = "static";
        shape = shape
    })

    :add("light", {
        colour = BLU;
        distance = 4
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




