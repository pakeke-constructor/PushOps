

local _,_,w,h=EH.Quads.wall1_1:getViewport()
local shape = love.physics.newRectangleShape(w/1.3,h/2)

return function(x,y)
    return Cyan.Entity( )
    :add("pos", math.vec3(x,y,20))
    :add("physics", {
        body = "static";
        shape = shape
    })
end




