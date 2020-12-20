

--[[

Terrible Sprite :/


]]
local Quads = require("assets.atlas").Quads


local shape = love.physics.newCircleShape(3)

return function(x,y)

    Cyan.Entity()

    :add("pos", math.vec3(x,y,0))

    :add("image", {quad= Quads.pine1})

    :add("physics",{
        body = "static";
        shape = shape
    })

    :add("bobbing",{
        magnitude = 0.1;
        value = 0
    })

end


