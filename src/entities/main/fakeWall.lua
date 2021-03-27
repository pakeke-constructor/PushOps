

local Quads = require("assets.atlas").Quads

return function(x,y)
    local w = Cyan.Entity()
    :add("pos", math.vec3(x,y,0))
    :add("image", {quad = Quads.wall1})
    EH.BOB(w)
    return w
end

