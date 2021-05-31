


local ccall = Cyan.call
local EH=_G.EH


return function ( x, y )
    local e = Cyan.Entity()
    --[[
    There will be 2 extra fields given here:
    ]]
    e:add("pos", math.vec3(x,y,0))
    e:add("light",{
        distance = 4;
        colour = {1,1,1,1}
    })

    return e
end
