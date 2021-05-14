


local ccall = Cyan.call
local EH=_G.EH

local function onUpdate( e,dt )
    local ratio = e.hp.hp / e.hp.max_hp
    e.light.distance = e.original_distance * ratio
end


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
