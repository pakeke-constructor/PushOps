


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
        original_light_colour = {<original colour>}
        light_fade -- whether it fades or not
    ]]
    e:add("pos", math.vec3(x,y,0))
    e:add("light",{
        distance = 10;
        colour = {1,1,1,1}
    })
    e.onUpdate = onUpdate
    e:add("hp",{
        hp = 0XD; -- doesnt matter will be overridden
        max_hp = 0XD
    })
    return e
end
