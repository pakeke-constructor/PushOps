


local atlas = require( "assets.atlas" )

local Quads = atlas.Quads

local wall = Quads.base_wall

local _,_,w,h = wall:getViewport()
local shape = love.physics.newRectangleShape(w/1.3,h/2)

local ccall = Cyan.call


local WALL_HP = 200;
local WALL_DMG_RANGE = 80


local dist = Tools.dist

local function onBoom(e, x,y, strength)
    local p=e.pos
    if strength > 0 and dist(x-p.x, y-p.y)<WALL_DMG_RANGE then
        ccall("damage",e,101)
    end
end

local function onDeath(e)
    ccall("emit", "wallbreak", e.pos.x, e.pos.y, e.pos.z, 10)
end




return function(x,y)
    return Cyan.Entity( )
    :add("pos", math.vec3(x,y,20))
    :add("image", {quad = wall})
    :add("physics", {
        body = "static";
        shape = shape
    })
    :add("hp",{
        hp=WALL_HP;
        max_hp=WALL_HP
    })
    :add("onBoom",onBoom)
    :add("onDeath",onDeath)

    :add("bobbing",{
        magnitude = 0.1;
        value = 0
    })
end




