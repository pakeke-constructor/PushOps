


local atlas = require( "assets.atlas" )

local Quads = atlas.Quads

local wall = Quads.base_wall

local _,_,w,h = wall:getViewport()
local shape = love.physics.newRectangleShape(w/1.3,h/2)



return function(x,y)
    return Cyan.Entity( )
    :add("pos", math.vec3(x,y,20))
    :add("image", {quad = wall})
    :add("physics", {
        body = "static";
        shape = shape
    })

    :add("bobbing",{
        magnitude = 0.1;
        value = 0
    })
end




