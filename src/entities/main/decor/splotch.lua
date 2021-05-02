

-- TODO make better art for this




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
end


