



local atlas = require( "assets.atlas" )

local Quads = atlas.Quads

local mush = Quads.mushroom

local _,_,w,h = mush:getViewport()
local shape = love.physics.newCircleShape(4)



return function(x,y)
    return Cyan.Entity( )
    :add("pos", math.vec3(x,y,0))
    :add("image", {quad = mush, oy=60})
    :add("physics", {
        body = "static";
        shape = shape
    })

    :add("bobbing",{
        magnitude = 0.15;
        value = 0
    })
end




