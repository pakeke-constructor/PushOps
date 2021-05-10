

--[[

]]
local Quads = require("assets.atlas").Quads


local shape = love.physics.newRectangleShape(16,16)

local q = {Quads.pillar2}

return function(x,y)

    local e = Cyan.Entity()

    :add("pos", math.vec3(x,y,0))

    :add("image", {quad= Tools.rand_choice(q), oy=40})
    :add("physics",{
        body = "static";
        shape = shape
    })
    :add("colour", {0.5,0.5,0.5})

    :add("bobbing",{
        magnitude = 0.03;
        value = 0
    })

    return e
end


