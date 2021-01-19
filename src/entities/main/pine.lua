

--[[



]]
local Quads = require("assets.atlas").Quads


local shape = love.physics.newCircleShape(3)

return function(x,y)

    Cyan.Entity()

    :add("pos", math.vec3(x,y,0))

    :add("image", {quad= Quads.pine3, oy=230})
    :add("swaying", {magnitude=0.03} )

    :add("physics",{
        body = "static";
        shape = shape
    })

    :add("bobbing",{
        magnitude = 0.01;
        value = 0
    })

end


