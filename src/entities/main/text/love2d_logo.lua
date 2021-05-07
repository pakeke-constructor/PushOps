
return function(x,y)

    return Cyan.Entity()
    :add("name", "love2d logo")
    :add("image", {
        quad = EH.Quads.love2d_logo
    })
    :add("pos", math.vec3(x,y,-50))
end

