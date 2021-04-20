


local atlas = require( "assets.atlas" )

local Quads = atlas.Quads

local walls = {Quads.wall1,Quads.wall2}

local _,_,w,h = walls[1]:getViewport()
local shape = love.physics.newRectangleShape(w/1.3,h/2)

local ccall = Cyan.call

local COLOUR = {0.87, 0.87, 0.87}

local WALL_DMG_RANGE = 80


local dist = Tools.dist

local function onBoom(e, x,y, strength)
    local p=e.pos
    if strength > 0 and dist(x-p.x, y-p.y)<WALL_DMG_RANGE then
        ccall("emit", "wallbreak", e.pos.x, e.pos.y, e.pos.z, 1)
    end
end




return function(x,y)
    return Cyan.Entity( )
    :add("pos", math.vec3(x,y,20))
    :add("image", {quad = Tools.rand_choice(walls)})
    :add("physics", {
        body = "static";
        shape = shape
    })
    :add("colour", COLOUR)
    :add("hp",{
        hp=math.huge;
        max_hp=math.huge
    })
    :add("onBoom",onBoom)
    :add("bobbing",{
        magnitude = 0.1;
        value = 0
    })
end




