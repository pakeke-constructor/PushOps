

local Quads = require("assets.atlas").Quads


local q = {Quads.pine3, Quads.pine6}

return function(x,y)

    Cyan.Entity()

    :add("pos", math.vec3(x,y,0))

    :add("image", {quad= Tools.rand_choice(q), oy=230})
    :add("swaying", {magnitude=0.03} )
end


