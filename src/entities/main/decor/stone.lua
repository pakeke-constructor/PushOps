


local atlas = require("assets.atlas")

local stones = {}

for i=1, 4 do
    local q = atlas.Quads["stone"..tostring(i)]
    table.insert(stones, q)
end


local rand_choice = Tools.rand_choice

return function(x, y)
    return Cyan.Entity()
    :add("pos", math.vec3(x,y,0))
    :add("draw",true)
    :add("image", {quad=rand_choice(stones)})
    :add("bobbing", {magnitude = 0.2, value=0})
    :add("trivial", true ) -- for drawing
    :add("colour",{1,1,1})
end



