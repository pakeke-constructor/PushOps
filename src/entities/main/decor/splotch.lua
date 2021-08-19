

-- TODO make better art for this
-- ==> the splats need to be bigger




local quads = {}
for i=1,4 do
    table.insert(quads, EH.Quads["splat"..tostring(i)])
end



return function(x,y)
    return Cyan.Entity()
    :add("pos", math.vec3(x,y,-18))
    :add("image", {
        quad=Tools.rand_choice(quads)
    })
    :add("colour",CONSTANTS.SPLAT_COLOUR)
    :add("hp", {
        hp = 100;
        max_hp = 100;
        regen = -3
    })
end



