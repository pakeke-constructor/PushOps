


local quads = require("assets.atlas").quads


assert(quads.NYI)


return function(x,y)

    return Cyan.Entity()
    :add("pos", math.vec3(x,y,0))


    :add("image", { quad = quads.NYI } )

    :add("size", 30)

    :add("collisions", {
        area = {
            [1] = function()
                -- This works!
            end
        }
    })
end

