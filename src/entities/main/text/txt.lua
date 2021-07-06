

return function(x,y,text, Z)
    -- HAD TO DO A SHITTY Z POSITION HACK.  (in playerpillar.lua)
    -- (screw you gravitySys and indexsys :( 
    assert(text,"expected text for ctor of txt ent")
    return Cyan.Entity()
    :add("pos",math.vec3(x,y+25,Z or -50)) -- default z pos -50
    :add("text", text)
end

