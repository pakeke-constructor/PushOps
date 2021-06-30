

local atlas = require("assets.atlas")

local grasses = {}

for i=1, 5 do
    local q = atlas.Quads["blue_grass_"..tostring(i)]
    table.insert(grasses, q)
end


local rand_choice = Tools.rand_choice

return function(x, y)
    return Cyan.Entity()
    :add("pos", math.vec3(x,y,0))
    :add("draw",true)
    :add("image", {quad=rand_choice(grasses)})
    :add("swaying", {value=0, magnitude=0.2})
    :add("trivial", true ) -- for drawing
    :add("colour",{1,1,1})
end

