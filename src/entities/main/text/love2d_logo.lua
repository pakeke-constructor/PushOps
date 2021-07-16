
return function(x,y)

    return EH.FR(EH.PHYS(EH.PV(Cyan.Entity(), x,y), 9),3)
    :add("name", "love2d logo")
    :add("image", {
        quad = EH.Quads.love2d_logo
    })
    :add("pushable", true)
end

