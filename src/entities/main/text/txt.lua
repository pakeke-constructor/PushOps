



return function(x,y,text)
    assert(text,"expected text for ctor of txt ent")
    Cyan.Entity()
    :add("pos",math.vec3(x,y+25,-50)) -- default z pos -50
    :add("text", text)
end

